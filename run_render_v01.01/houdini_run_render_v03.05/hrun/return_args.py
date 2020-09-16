#!/usr/bin/env python
# encoding=utf-8

# created date: 2020.09.16
# author: seongcheol jeon
# email: saelly55@gmail.com

# description       : get arguments
#                   : no history option added
#                   : no sql option added
#                   : only set envrionment variables

import importlib

import hrun_args.hrun_args as hargs
from modules.default import default

importlib.reload(hargs)
importlib.reload(default)


class ReturnArgs(hargs.GetArgs):
    def __init__(self):
        super(ReturnArgs, self).__init__()

    @staticmethod
    def get_fxhome():
        return default.Default.get_fxhome()

    @staticmethod
    def get_fxhome_bridge():
        return default.Default.get_fxhome_user_brg()

    @staticmethod
    def get_common_bridge():
        return default.Default.get_common_brg()

    def get_never_option(self):
        if self.chk_opt_never:
            return "1"
        return "0"

    def get_hipfiles(self):
        hipfiles = self.get_hipfile()
        if hipfiles is None:
            return ""
        return hipfiles

    def get_show_option(self):
        if self.chk_opt_show:
            return "1"
        return "0"

    def get_nohistory_option(self):
        if self.chk_opt_no_hist:
            return "1"
        return "0"

    def get_nosql_option(self):
        if self.chk_opt_nosql:
            return "1"
        return "0"

    def get_only_env_option(self):
        if self.chk_opt_only_env:
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
            rtnargs.get_never_option(),
            rtnargs.get_show_option(),
            rtnargs.get_nohistory_option(),
            rtnargs.get_nosql_option(),
            rtnargs.get_only_env_option(),
            rtnargs.get_hipfiles()
        ]
    ))

