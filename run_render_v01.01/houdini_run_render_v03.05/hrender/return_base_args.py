#!/usr/bin/env python
# encoding=utf-8

# created date: 2020.09.16
# author: seongcheol jeon
# email: saelly55@gmail.com

# - no sql option added
# - onlyenv option added

import importlib

from hrender_args import hrender_args as hrender_args
from modules.default import default

importlib.reload(hrender_args)
importlib.reload(default)


class ReturnArgs(hrender_args.GetArgs):
    def __init__(self):
        super(ReturnArgs, self).__init__()

    def get_fxhome(self):
        return default.Default.get_fxhome()

    def get_fxhome_bridge(self):
        return default.Default.get_fxhome_user_brg()

    def get_common_bridge(self):
        return default.Default.get_common_brg()

    def get_show_option(self):
        if self.chk_opt_show:
            return "1"
        return "0"

    def get_nodeps_option(self):
        if self.get_nodeps:
            return "1"
        return "0"

    def get_render_directory(self):
        if self.get_render_dir is not None:
            return self.get_render_dir
        return "0"

    def get_env_hip(self):
        return self.get_hip

    def get_env_hipname(self):
        return self.get_hipname

    def get_env_hipfile(self):
        return self.get_hipfile

    def get_nosql_option(self):
        if self.get_nosql:
            return "1"
        return "0"

    def get_only_env_option(self):
        if self.get_only_env:
            return "1"
        return "0"


if __name__ == "__main__":
    rtnargs = ReturnArgs()
    print(" ".join(
        [
            rtnargs.get_fxuser(),
            rtnargs.get_fxversion()[0],
            rtnargs.get_fxhome(),
            rtnargs.get_fxhome_bridge(),
            rtnargs.get_common_bridge(),
            rtnargs.get_show_option(),
            rtnargs.get_hipfile,
            rtnargs.get_driver,
            rtnargs.get_frame,
            rtnargs.get_nodeps_option(),
            rtnargs.get_render_directory(),
            rtnargs.get_env_hip(),
            rtnargs.get_env_hipname(),
            rtnargs.get_env_hipfile(),
            rtnargs.get_nosql_option(),
            rtnargs.get_only_env_option()
        ]
    ))
