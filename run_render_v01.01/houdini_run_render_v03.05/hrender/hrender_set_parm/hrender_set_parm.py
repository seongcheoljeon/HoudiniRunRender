#!/usr/bin/env hython
#encoding=utf-8

# created date: 2020.09.16
# author: seongcheol jeon
# email: saelly55@gmail.com

import hou
import sys
from copy import deepcopy


class RenderSetParm(object):
    def __init__(self, args):
        self.args = deepcopy(args)

        try:
            hou.hipFile.load(self.args.file)
        except hou.LoadWarning as err:
            sys.stderr.write(err)

        # returns the output node to use (driver | cop)
        if self.args.c_option:
            comp = hou.node('/out').createNode('comp')
            comp.parm("coppath").set(self.args.c_option)
            rop = '/out/{0}'.format(comp.name())
        else:
            # if a leading slash was provided, it's an absolute path.
            if self.args.d_option[0] == '/':
                rop = self.args.d_option
            else:
                rop = '/out/{0}'.format(self.args.d_option)

        self.ropNode = hou.node(rop)

    def set_aspect_ratio(self):
        # sets the appropriate width and height based on the current aspect ratio
        # if a width or height is provided.

        # maintain aspect ratio if the width or height is given, but not both.
        keep_aspect = bool(self.args.w_option) ^ bool(self.args.h_option)

        xres = self.ropNode.parm('res1').eval()
        yres = self.ropNode.parm('res2').eval()
        if keep_aspect:
            if self.args.d_option:
                xres = self.ropNode.parm('res_overridex').eval()
                yres = self.ropNode.parm('res_overridey').eval()

        if self.args.w_option:
            self.args.h_option = int((float(self.args.w_option) / xres) * yres)
        elif self.args.h_option:
            self.args.w_option = int((float(self.args.h_option) / yres) * xres)
        #else:
        #    self.args.w_option = int((float(self.args.h_option) / yres) * xres)

    def set_overrides(self):
        # if a width or height is specified, we should override the resolution.
        if self.args.w_option or self.args.h_option:
            if self.args.d_option:
                self.ropNode.parm('override_camerares').set(True)
                self.ropNode.parm('res_fraction').set('specific')
                self.ropNode.parm('res_overridex').set(self.args.w_option)
                self.ropNode.parm('res_overridey').set(self.args.h_option)
            else:
                self.ropNode.parm('tres').set('specify')
                self.ropNode.parm('res1').set(self.args.w_option)
                self.ropNode.parm('res2').set(self.args.h_option)

        # override the output file name.
        if self.args.o_option:
            if self.args.c_option:
                self.ropNode.parm('copoutput').set(self.args.o_option)
            else:
                self.ropNode.parm('vm_picture').set(self.args.o_option)

        # add image processing fraction.
        if self.args.b_option:
            self.ropNode.parm('fraction').set(self.args.b_option)

        if self.args.t_option:
            self.ropNode.parm('take').set(self.args.t_option)

    def set_framerange(self):
        # sets frame range information on the output node.
        increment = self.args.i_option or 1

        framerange = ()
        if self.args.frame_range:
            # render the given frame range.
            self.ropNode.parm('trange').set(1)
            framerange = (self.args.frame_range[0], self.args.frame_range[1], increment)
        elif self.args.frame:
            # render single frame (start and end frames are the same)
            self.ropNode.parm('trange').set(1)
            framerange = (self.args.frame, self.args.frame, increment)
        else:
            # render current frame.
            self.ropNode.parm('trange').set(0)
        return framerange

    def render(self):
        nodes = ['geometry', 'ifd']
        if self.ropNode.type().name() in nodes:
            self.set_aspect_ratio()
            self.set_overrides()
            framerange = self.set_framerange()
            interleave = hou.renderMethod.FrameByFrame if self.args.I_option else hou.renderMethod.RopByRop
        else:
            framerange = self.set_framerange()
            interleave = hou.renderMethod.FrameByFrame if self.args.I_option else hou.renderMethod.RopByRop
        print()
        print("- Render Information -")
        print("User: {0}".format(self.args.fxuser))
        print("Version: {0}".format(self.args.fxversion[0]))
        print()
        self.ropNode.render(
            verbose=bool(self.args.v_option), frame_range=framerange, method=interleave)

    def hou_test(self):
        import hou
        print()
        print("'hou' module import test:", hou.__file__)
        print()


if __name__ == '__main__':
    rsp = RenderSetParm()
    #rsp.hou_test()

