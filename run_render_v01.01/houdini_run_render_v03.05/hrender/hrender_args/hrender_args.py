#!/usr/bin/env hython
# encoding=utf-8

# created date: 2020.09.16
# author: seongcheol jeon
# email: saelly55@gmail.com

import os
import sys
import inspect
import argparse
import importlib
from glob import glob

from modules.default import default
importlib.reload(default)


class GetArgs(object):
    def __init__(self):
        """
        인자들을 불러와 검사한 후, 만약 하나라도
        검사에 걸리면 에러를 발생. 그리고 usage함수를
        호출하여 메세지를 출력하고 프로세스를 강제종료한다.
        """

        self.parser = argparse.ArgumentParser(
            add_help=False,
            description="This script is parsed script associated with rendering"
        )

        # custom arguments
        self.parser.add_argument('-fxu', '--fxuser', dest='fxuser', type=str, required=False)
        self.parser.add_argument('-fxv', '--fxversion', dest='fxversion', type=str, required=False)
        self.parser.add_argument('-fxs', dest='show', action='store_true', default=False, required=False)
        self.parser.add_argument('-fxnodeps', dest='nodeps', action='store_true', default=False, required=False)
        self.parser.add_argument('-fxrenderdir', '--fxrenderdir', dest='renderdir', type=str, required=False)
        self.parser.add_argument('-hip', '--envhip', dest='hip', type=str, required=True)
        self.parser.add_argument('-hipname', '--envhipname', dest='hipname', type=str, required=True)
        self.parser.add_argument('-hipfile', '--envhipfile', dest='hipfile', type=str, required=True)
        self.parser.add_argument(
            '-nosql', help='Not Use FX Database', action='store_true', default=False, required=False
        )
        self.parser.add_argument(
            '-onlyenv', help='Only Set Environment Variables', action='store_true', default=False, required=False
        )

        # option arguments
        self.parser.add_argument('-c', dest='c_option')
        self.parser.add_argument('-d', dest='d_option')

        self.parser.add_argument('-w', dest='w_option', type=int)
        self.parser.add_argument('-h', dest='h_option', type=int)

        self.parser.add_argument('-i', dest='i_option', type=int)

        self.parser.add_argument('-t', dest='t_option')
        self.parser.add_argument('-o', dest='o_option')

        self.parser.add_argument('-b', dest='b_option', type=float)
        self.parser.add_argument('-j', dest='threads', type=int)

        self.parser.add_argument('-F', dest='frame', type=float, required=False)
        self.parser.add_argument('-f', dest='frame_range', nargs=2, type=float, required=False)

        # .hip | .hiplc | .hipnc file
        self.parser.add_argument('file', nargs='*')

        # boolean flags
        self.parser.add_argument('-e', dest='e_option', action='store_true')
        self.parser.add_argument('-R', dest='renderonly', action='store_true')
        self.parser.add_argument('-v', dest='v_option', action='store_true')
        self.parser.add_argument('-I', dest='I_option', action='store_true')

        self.args, unknown = self.parser.parse_known_args()

        self.fxuser = self.args.fxuser if self.args.fxuser is not None else default.Default.get_default_uname()
        self.fxversion = [self.args.fxversion] if self.args.fxversion is not None else default.Default.get_default_hou_ver()
        self.args.fxuser = self.fxuser
        self.args.fxversion = self.fxversion

        self.show = self.args.show

        self.__verbose = self.args.v_option
        self.__interleave = self.args.I_option
        self.__increment = self.args.i_option

        # environments #
        self.hip = self.args.hip
        self.hipname = self.args.hipname
        self.hipfile = self.args.hipfile
        ################

        # handle unknown arguments (show usage text and exit)
        if unknown:
            GetArgs.usage('Unknown argument(s): {0}'.format(' '.join(unknown)))

        # If there's something wrong with the arguments, show usage and exit.
        err = self.validate_args()
        if err != '':
            GetArgs.usage(err)

        self.hfile = self.args.file
        self.frame = self.args.frame_range
        self.driver = self.args.d_option

        self.nodeps = self.args.nodeps
        self.renderdir = self.args.renderdir

        self.nosql = self.args.nosql

        self.onlyenv = self.args.onlyenv

    @staticmethod
    def chk_arguments():
        args = sys.argv[1:]
        if len(args) < 1 or args[0] == '-':
            GetArgs.usage()

    def rtn_args(self):
        return self.args

    @property
    def get_hip(self):
        return self.hip

    @property
    def get_hipname(self):
        return self.hipname

    @property
    def get_hipfile(self):
        return self.hipfile

    @property
    def get_verbose(self):
        return self.__verbose

    @property
    def get_interleave(self):
        return self.__interleave

    @property
    def get_increment(self):
        return self.__increment

    def get_fxuser(self):
        if self.chk_opt_fxuser:
            user_root_dir = default.Default.merge_path(default.Default.get_fxhome(), default.Default.get_fxhome_user_brg())
            udirlist = os.listdir(user_root_dir)
            if self.fxuser not in udirlist:
                _file, _line, _func = inspect.getframeinfo(inspect.currentframe())[:3]
                default.Default.error_message(
                    "The entered -fxu or --fxuser option {0} does not exist in the {1} directory".format(
                        self.fxuser, user_root_dir), _exit=True, _file=_file, _line=_line, _func=_func)
            return self.fxuser
        return None

    def get_fxversion(self):
        if self.chk_opt_fxversion:
            hdir_root_dir = default.Default.merge_path(default.Default.get_opt_dir())
            hdir = default.Default.merge_path(hdir_root_dir, default.Default.get_hou_brg()+self.fxversion[0])
            if not os.path.exists(hdir):
                _file, _line, _func = inspect.getframeinfo(inspect.currentframe())[:3]
                default.Default.error_message(
                    "The directory path does not exist -> {0}".format(hdir),
                    _exit=False, _file=_file, _line=_line, _func=_func)
                GetArgs.chk_installed_houdini(hdir_root_dir)
                for hd in glob(default.Default.merge_path(hdir_root_dir, default.Default.get_hou_brg() + "*")):
                    print("The installed Houdini Version: {0}".format(hd))
                print()
                exit(1)
            else:
                pass
            return self.fxversion
        return None

    @staticmethod
    def chk_installed_houdini(pdir):
        hlist = glob(default.Default.merge_path(pdir, default.Default.get_hou_brg() + "*"))
        if len(hlist) == 0:
            _file, _line, _func = inspect.getframeinfo(inspect.currentframe())[:3]
            default.Default.error_message(
                "Houdini is not installed.", _exit=True, _file=_file, _line=_line, _func=_func)
        else:
            pass

    @property
    def get_file(self):
        return self.hfile

    @property
    def get_integer_frame(self):
        if self.frame is not None:
            return [int(self.frame[0]), int(self.frame[1])]
        return None

    @property
    def get_frame(self):
        if self.frame is not None:
            return "{0} {1}".format(int(self.frame[0]), int(self.frame[1]))
        return "{0} {1}".format(int(-1), int(-1))

    @property
    def get_driver(self):
        return self.driver

    @property
    def get_nodeps(self):
        return self.nodeps

    @property
    def get_nosql(self):
        return self.nosql

    @property
    def get_only_env(self):
        return self.onlyenv

    @property
    def get_render_dir(self):
        return self.renderdir

    @property
    def chk_opt_file(self):
        if self.hfile is not None:
            return True
        return False

    @property
    def chk_opt_fxuser(self):
        if self.fxuser is not None:
            return True
        return False

    @property
    def chk_opt_fxversion(self):
        if self.fxversion is not None:
            return True
        return False

    @property
    def chk_opt_show(self):
        if self.show:
            return True
        return False

    @staticmethod
    def usage(msg=''):
        print(
"""
        Houdini Render Script
        Author: Seongcheol Jeon

Usage:

Single frame:   hrender    [options] driver|cop file.hip [imagefile]
Frame range:    hrender -e [options] driver|cop file.hip

example) hrender -e -f 1 120 -v -d /out/geo /home/user/hr/hrender_test.hip

driver|cop:     -c /img/imgnet
                -c /img/imgnet/cop_name
                -d output_driver

options:        -w pixels           Output width
                -h pixels           Output height
                -F frame            Single frame
                -b fraction         Image processing fraction (0.01 to 1.0)
                -t take             Render a specified take
                -o output           Output name specification
                -v                  Run in verbose mode
                -I                  Interleaved, hscript render -I

with \"-e\":    -f start end        Frame range start and end
                -i increment        Frame increment

custom option:  -fxu, --fxuser          User name
                -fxv, --fxversion       Houdini version
                -fxs                    Show All Environment Variables
                -hip, --envhip          HIP Environment Variables
                -hipname, --envhipname  HIPNAME Environment Variables
                -hipfile, --envhipfile  HIPFILE Environment Variables
                -nosql                  Not Use FX Database
                -onlyenv                Only Set Environment Variables

Notes:  1)  For output name use $F to specify frame number (e.g. -o $F.pic).
        2)  If only one of width (-w) or height (-h) is specified, aspect ratio
            will be maintained based upon aspect ratio of output driver.
""")
        GetArgs.error(msg)

    @staticmethod
    def error(msg, _exit=True):
        if msg:
            sys.stderr.write('\n')
            sys.stderr.write('[ERROR]: %s\n' % msg)
            sys.stderr.write('*****')
        sys.stderr.write('\n')
        if _exit:
            sys.exit(1)

    def validate_args(self):
        hipfiles = []
        for f in self.args.file:
            if ('.' in f) and (f.split('.')[-1] in ('hip', 'hipnc', 'hiplc')):
                hipfiles.append(f)

        if not hipfiles:
            return 'Missing .hip motion file name.'
        if len(hipfiles) > 1:
            return 'Too many .hip motion file names: {0}'.format(' '.join(hipfiles))
        if not os.path.isfile(hipfiles[0]):
            return 'Cannot find file {0}'.format(hipfiles[0])

        self.args.file = hipfiles[0]

        if self.args.frame_range:
            if not self.args.e_option:
                return 'Cannot specify frame range without -e.'
            if self.args.frame_range[0] > self.args.frame_range[1]:
                return 'Start frame cannot be greater than end frame.'

        if self.args.i_option:
            if not self.args.e_option:
                return 'Cannot use -i option without -e.'

        if not self.args.c_option and not self.args.d_option:
            return 'Must specify one of -c or -d.'

        if self.args.c_option and self.args.d_option:
            return 'Cannot specify both -c and -d.'

        if self.args.w_option and self.args.w_option < 1:
            return 'Width must be greater than zero.'

        if self.args.h_option and self.args.h_option < 1:
            return 'Height must be greater than zero.'

        if self.args.i_option and self.args.i_option < 1:
            return 'Frame increment must be greater than zero.'

        if self.args.c_option:
            if self.args.c_option[-1] == '/':
                return 'Invalid parameter for -c option (trailing \'/\')'

        return ''


if __name__ == '__main__':
    ga = GetArgs()

