#!/usr/bin/env python3
#-*-coding: utf-8-*-

import os
import sys

sys.path.append(os.path.abspath(os.path.dirname(__file__)))
import pic_utils as picu

SCRIPT_NAME = os.path.basename(__file__)

if len(sys.argv) < 3:
    print("%s - Rotates pictures" % SCRIPT_NAME, file = sys.stderr)
    print("Usage: %s <N degrees> <directory or file 1> [<directory or file 2> ...]" % SCRIPT_NAME, file = sys.stderr)
    print("Example 1: %s 90 dir1" % SCRIPT_NAME, file = sys.stderr)
    print("Example 2: %s -90.0 dir1 file1.jpg" % SCRIPT_NAME, file = sys.stderr)
    sys.exit(1)

degrees = float(sys.argv[1])

for i in range(2, len(sys.argv)):
    path = sys.argv[i]
    if not os.path.exists(path):
        print("Path does not exist: %s" % path, file = sys.stderr)
        continue

    if os.path.isfile(path):
        try:
            _, _, _, mat = picu.load(path, channels = -1)
            h, w, _ = mat.shape
            picu.save(path, picu.rotate(mat, degrees)) # TODO: compress params for jpeg and png
            print("Rotated: %s" % path)
        except Exception as ex:
            print("%s: %s: %s" % (path, type(ex), ex), file = sys.stderr)

        continue

    for f in os.listdir(path):
        p = os.path.join(path, f)
        try:
            _, _, _, mat = picu.load(p, channels = -1)
            h, w, _ = mat.shape
            picu.save(p, picu.rotate(mat, degrees)) # TODO: compress params for jpeg and png
            print("Rotated: %s" % p)
        except Exception as ex:
            print("%s: %s: %s" % (p, type(ex), ex), file = sys.stderr)

