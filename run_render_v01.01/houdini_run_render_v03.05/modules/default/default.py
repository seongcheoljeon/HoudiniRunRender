#!/usr/bin/env python
# encoding=utf-8

# created date: 2020.09.16
# author: seongcheol jeon
# email: saelly55@gmail.com

import os
import sys
import inspect
import traceback


class Default(object):
    def __init__(self):
        pass

    # path parameters join
    @staticmethod
    def set_path_sep(*args):
        return os.pathsep.join(args)

    @staticmethod
    def chk_uid():
        if os.getuid() == 0:
            return True
        return False

    @staticmethod
    def get_common_brg():
        return os.getenv("DEF_FXHOME_COMMON_BRIDGE_DIR")

    @staticmethod
    def get_opt_dir():
        return os.getenv("DEF_OPT_DIR")

    @staticmethod
    def get_hou_brg():
        return os.getenv("DEF_HOU_BRG")

    @staticmethod
    def get_default_hou_ver():
        return [os.getenv("DEF_HOUDINI_VERSION")]

    @staticmethod
    def get_default_uname():
        default_uname = os.getenv("DEF_FXUSER")
        if default_uname is None:
            Default.error_message("FXUSER variable is not set.", _exit=True)
        return default_uname

    @staticmethod
    def exists_dir(_dir):
        if not os.path.isdir(_dir):
            _file, _line, _func = inspect.getframeinfo(inspect.currentframe())[:3]
            Default.error_message(
                "{0} is not a directory.".format(_dir),
                _exit=True, _file=_file, _line=_line, _func=_func)
        if not os.path.exists(_dir):
            _file, _line, _func = inspect.getframeinfo(inspect.currentframe())[:3]
            Default.error_message(
                "{0} is a nonexistent directory.".format(_dir),
                _exit=True, _file=_file, _line=_line, _func=_func)
        return True

    @staticmethod
    def get_fxhome():
        fxhome = os.getenv("DEF_FXHOME")
        Default.exists_dir(fxhome)
        return fxhome

    @staticmethod
    def get_fxhome_user_brg():
        return os.getenv("DEF_FXHOME_USER_BRIDGE_DIR")

    @staticmethod
    def merge_path(*args):
        ss = ""
        if args[0][0] != os.sep:
            ss = os.sep
        for arg in args:
            ss = os.path.join(ss, arg)
        if ss[0] != os.sep:
            return ss
        return os.path.normpath(ss)

    @staticmethod
    def get_file_info():
        _file, _line, _func = inspect.getframeinfo(inspect.currentframe())[:3]
        d = dict()
        d.setdefault("file", _file)
        d.setdefault("line", _line)
        d.setdefault("func", _func)
        return d

    @staticmethod
    def confirm_message(msg):
        print()
        print("-" * 88)
        print("[CONFIRM]: {0}".format(msg))
        print("-" * 88)

    @staticmethod
    def warning_message(msg, _file="", _func="", _line=""):
        print()
        print("*" * 100)
        print("[WARNING]: {0}".format(msg))
        print("File: {0}".format(_file))
        print("Function: {0}".format(_func))
        print("Line: {0}".format(_line))
        print("*" * 100)
        print()

    @staticmethod
    def error_message(msg, _exit=False, _file="", _func="", _line=""):
        sys.stderr.write("\n")
        sys.stderr.write("*" * 88)
        sys.stderr.write("\n")
        sys.stderr.write("[ERROR]: {0}".format(msg))
        sys.stderr.write("\n")
        sys.stderr.write("File: {0}".format(_file))
        sys.stderr.write("\n")
        sys.stderr.write("Function: {0}".format(_func))
        sys.stderr.write("\n")
        sys.stderr.write("Line: {0}".format(_line))
        sys.stderr.write("\n")
        sys.stderr.write("*" * 88)
        sys.stderr.write("\n")
        traceback.print_exc()
        if _exit:
            sys.exit(1)


if __name__ == "__main__":
    dft = Default()
    print("fxhome:", dft.get_fxhome())
    print("user default:", dft.get_default_uname())
    print("houdini version default:", dft.get_default_hou_ver())
    print("fxhome user bridge:", dft.get_fxhome_user_brg())
