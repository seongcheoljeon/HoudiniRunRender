#!/usr/bin/env python
# encoding=utf-8

# created date: 2020.09.16
# author: seongcheol jeon
# email: saelly55@gmail.com
# description: 인자로 들어오는 것의 하위 디렉토리들을 패스로 가공.

import os
import sys
import glob


# 1번째: 후디니 버전
# 2번째: 디렉토리에 추가할 부모 디렉토리
# 3번째: 어떤 디렉토리를 추가할 것인지 디렉토리 이름.

def init_set():
    args = sys.argv[1:]
    if len(args) != 3:
        print("인자값이 3개가 아닙니다.")
        sys.exit(1)
    return args


def make_path():
    hou_version, dir_path, target_dir = init_set()
    users = glob.glob(os.path.join(dir_path, "*"))
    ll = []
    for user in users:
        ll.append(os.path.join(user, "houdini" + hou_version, target_dir))
    return os.pathsep.join(ll)


if __name__ == "__main__":
    print(make_path())
