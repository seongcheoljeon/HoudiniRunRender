#!/usr/bin/env python
# encoding=utf-8

# created date: 2020.09.16
# author: seongcheol jeon
# email: saelly55@gmail.com
# description       : get arguments
#                   : history enable/disable added
#                   : nosql option 추가 (fx database사용하지 않는 옵션)
#                   : onlyenv option 추가 (houdini를 실행하지 않고 env만 적용하는 옵션)

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
        self.parser = argparse.ArgumentParser(
            add_help=True, description="This is the help page for running Houdini")
        self.parser.add_argument('-fxu', '--fxuser', type=str, help='User Name', required=False)
        self.parser.add_argument('-fxv', '--fxversion', type=str, help='Houdini Version', required=False)
        self.parser.add_argument('-n', help='Houdini Mode: Manual', action="store_true", default=False, required=False)
        self.parser.add_argument(
            '-fxs', help='Show All Envrionment Variables', action="store_true", default=False, required=False)
        self.parser.add_argument('hfile', nargs='*')
        self.parser.add_argument(
            '-nohistory', help='Not Write History', action="store_true", default=False, required=False)
        self.parser.add_argument(
            '-nosql', help='Not Use FX Database', action='store_true', default=False, required=False)
        self.parser.add_argument(
            '-onlyenv', help='Only Set Environment Variables', action='store_true', default=False, required=False)
        # array for all arguments passed to script
        self.args = self.parser.parse_args()
        # -fxu 를 설정하지 않았다면 디폴트 셋팅값을 설정한다.
        self.fxuser = self.args.fxuser if self.args.fxuser is not None else default.Default.get_default_uname()
        # -fxv 를 설정하지 않았다면 디폴트 셋팅값을 설정한다.
        self.fxversion = [self.args.fxversion] if self.args.fxversion is not None else default.Default.get_default_hou_ver()
        self.never = self.args.n
        self.show = self.args.fxs
        self.hfile = self.args.hfile
        self.nohistory = self.args.nohistory
        self.nosql = self.args.nosql
        self.onlyenv = self.args.onlyenv

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
    def chk_opt_never(self):
        if self.never:
            return True
        return False

    @property
    def chk_opt_show(self):
        if self.show:
            return True
        return False

    @property
    def chk_opt_no_hist(self):
        if self.nohistory:
            return True
        return False

    @property
    def chk_opt_nosql(self):
        return self.nosql

    @property
    def chk_opt_only_env(self):
        return self.onlyenv

    def get_fxuser(self):
        if self.chk_opt_fxuser:
            user_root_dir = default.Default.merge_path(
                default.Default.get_fxhome(), default.Default.get_fxhome_user_brg())
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
                    print("The installed Houdini version: {0}".format(hd))
                print()
                sys.exit(1)
            else:
                pass
            return self.fxversion
        return None

    def get_never(self):
        if self.chk_opt_never:
            return self.never
        return None

    def get_show(self):
        if self.chk_opt_show:
            return self.show
        return None

    def get_no_hist(self):
        if self.chk_opt_no_hist:
            return self.nohistory
        return None

    def get_nosql(self):
        return self.nosql

    def get_only_env(self):
        return self.onlyenv

    def get_hipfile(self):
        hipfiles = []
        for f in self.hfile:
            if "." in f and f.split(".")[-1] in ("hip", "hipnc", "hiplc"):
                hipfiles.append(f)

        if len(hipfiles) > 0:
            if not hipfiles:
                default.Default.error_message("Missing .hip motion file name", _exit=True)
            if len(hipfiles) > 1:
                default.Default.error_message(
                    "Too many .hip motion file names: {0}".format(" ".join(hipfiles)), _exit=True)
            return hipfiles[0]
        else:
            return None

    @staticmethod
    def chk_installed_houdini(pdir):
        hlist = glob(default.Default.merge_path(pdir, default.Default.get_hou_brg() + "*"))
        if len(hlist) == 0:
            _file, _line, _func = inspect.getframeinfo(inspect.currentframe())[:3]
            default.Default.error_message(
                "No Houdini version is installed.", _exit=True, _file=_file, _line=_line, _func=_func)
        else:
            pass


if __name__ == "__main__":
    ga = GetArgs()
    print("username:        ", ga.get_fxuser())
    print("version:         ", ga.get_fxversion())
    print("never:           ", ga.get_never())
    print("show:            ", ga.get_show())
    print("hipfile:         ", ga.get_hipfile())
    print("fxuser check:    ", ga.chk_opt_fxuser)
    print("fxversion check: ", ga.chk_opt_fxversion)
    print("no-history:      ", ga.chk_opt_no_hist)
    print("only env:        ", ga.chk_opt_only_env)

