#!/usr/bin/env python
#encoding=utf-8

# created date: 2020.09.16
# author: seongcheol jeon
# email: saelly55@gmail.com

import os
import sys
import importlib

import hrender_args.hrender_args as hrender_args

try:
    import hou
except ImportError as err:
    sys.stderr.write(err)

importlib.reload(hrender_args)


class HRender(hrender_args.GetArgs):
    def __init__(self):
        super(self.__class__, self).__init__()

    @property
    def framerange(self):
        increment = self.get_increment or 1
        if self.get_integer_frame is not None:
            return [self.get_integer_frame[0], self.get_integer_frame[1], increment]
        return None

    def set_hip_env_vars(self):
        hip_var = 'HIP'
        hipname_var = 'HIPNAME'
        hipfile_var = 'HIPFILE'

        print('--------------------------------------------------------')
        print('사본 HIP: {0}'.format(hou.getenv(hip_var)))
        print('사본 HIPNAME: {0}'.format(hou.getenv(hipname_var)))
        print('사본 HIPFILE: {0}'.format(hou.getenv(hipfile_var)))

        hou.hscript('set -g %s = %s' % (hip_var, self.get_hip))
        hou.hscript('varchange %s' % hip_var)
        hou.hscript('set -g %s = %s' % (hipname_var, self.get_hipname))
        hou.hscript('varchange %s' % hipname_var)
        hou.hscript('set -g %s = %s' % (hipfile_var, self.get_hipfile))
        hou.hscript('varchange %s' % hipfile_var)

        print('--------------------------------------------------------')
        print('원본 HIP: {0}'.format(hou.getenv(hip_var)))
        print('원본 HIPNAME: {0}'.format(hou.getenv(hipname_var)))
        print('원본 HIPFILE: {0}'.format(hou.getenv(hipfile_var)))
        print('--------------------------------------------------------')

    def render(self):
        if not os.path.exists(self.get_hipfile):
            sys.stderr.write('ERROR(Cannot Find HIP File)')
            sys.exit(55)
        try:
            hou.hipFile.load(self.get_hipfile)
        except hou.LoadWarning as err:
            sys.stderr.write('ERROR(HIP File Loading): {0}'.format(err))
            sys.exit(55)
        interleave = hou.renderMethod.FrameByFrame if self.get_interleave \
            else hou.renderMethod.RopByRop
        self.set_hip_env_vars()
        rnode = hou.node(self.get_driver)
        if self.framerange is None:
            rnode.render(
                verbose=self.get_verbose, method=interleave, ignore_inputs=self.get_nodeps)
        else:
            rnode.render(
                verbose=self.get_verbose, frame_range=self.framerange,
                method=interleave, ignore_inputs=self.get_nodeps)


if __name__ == '__main__':
    hr = HRender()
    hr.render()




