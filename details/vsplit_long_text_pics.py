#!/usr/bin/env python3
#-*-coding: utf-8-*-

import os
import sys
import time
import argparse
import shutil
import re

#sys.path.append(os.path.abspath(os.path.dirname(__file__)))
import pic_utils as picu

def parse_cmdline():

    cmdline_parser = argparse.ArgumentParser(description = "Vertically split longer pictures containing large amounts of texts into several shorter ones.")

    cmdline_parser.add_argument("--input", "-i", nargs = "+", help = "Input files and/or directories.")
    cmdline_parser.add_argument("--output", "-o", default = "vsplit", help = "Output root directory.")
    cmdline_parser.add_argument("--height_base", "-H", type = int, default = 1080, help = "Height base in pixels for each split part. The final height may be greater than this.")
    cmdline_parser.add_argument("--step", "-S", type = int, default = 4, help = "Step value in pixels for each move to check whether current row can be the boundary line.")
    cmdline_parser.add_argument("--keep_dir_hierarchy", action = "store_true", help = "Specify whether or not to keep the directory hierarchy for outputs.")

    return cmdline_parser.parse_args()

def generate_input_file_list(input_args):

    list_file = os.path.join("/tmp", os.path.basename(sys.argv[0]) + (".%d" % time.time()))

    with open(list_file, "w") as fp:
        for i in input_args:
            if not os.path.exists(i):
                continue

            if os.path.isfile(i):
                fp.write(i + "\n")
                continue

            for root, dirs, files in os.walk(i, followlinks = True):
                for name in files:
                    fp.write(os.path.join(root, name) + "\n")

    return list_file

def copy_fragment(result_path, mat, height_start, height_end):
    _total_height, _total_width = mat.shape[:2]
    height_stop = height_end if height_end <= _total_height else _total_height
    result_dir = os.path.dirname(result_path)
    if not os.path.exists(result_dir):
        os.makedirs(result_dir)
    picu.save(result_path, mat[height_start:height_stop+1,])
    print(result_path)

def do_splitting(list_file, cmd_args):

    output_root = cmd_args.output
    if "" != output_root:
        if os.path.exists(output_root):
            shutil.rmtree(output_root)

        if not os.path.exists(output_root):
            os.makedirs(output_root)

    for line in open(list_file):

        path = line.strip("\n")
        type_num, _, _, mat = picu.load(path, channels = 3) # TODO: channels = -1
        if mat is None:
            print("*** Not an image file: %s" % path, file = sys.stderr)
            continue

        basename = os.path.splitext(re.sub(r"^/*", "", path) if cmd_args.keep_dir_hierarchy else os.path.basename(path))[0]
        suffix = picu.get_image_suffix(type_num)
        TOTAL_HEIGHT, TOTAL_WIDTH = mat.shape[:2]
        fragment_count = 0
        h_start = 0
        h_end = h_start + cmd_args.height_base - 1

        while h_end < TOTAL_HEIGHT:
            can_be_boundary = True

            for i in range(1, TOTAL_WIDTH):
                if not (mat[h_end][0] == mat[h_end][i]).all():
                    can_be_boundary = False
                    break

            if not can_be_boundary:
                h_end += cmd_args.step
                continue

            fragment_count += 1
            result_path = "%s_%03d%s" % (os.path.join(output_root, basename), fragment_count, suffix)
            copy_fragment(result_path, mat, h_start, h_end)

            h_start = h_end + 1
            h_end = h_start + cmd_args.height_base - 1

        if h_start < TOTAL_HEIGHT:
            continue

        result_path = "%s_%03d%s" % (os.path.join(output_root, basename), fragment_count, suffix)
        copy_fragment(result_path, mat, h_start, h_end)

    os.remove(list_file)

def main():
    cmd_args = parse_cmdline()
    list_file = generate_input_file_list(cmd_args.input)
    do_splitting(list_file, cmd_args)

if __name__ == "__main__":
    main()

