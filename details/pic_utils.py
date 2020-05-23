#!/usr/bin/env python3
#-*-coding: utf-8-*-

import os
import sys
from enum import IntEnum, unique
import imghdr
from io import BytesIO

try:
    import magic
except Exception as ex:
    print("*** Failed to import magic: %s: %s" % (type(ex), ex), file = sys.stderr)
    if isinstance(ex, ModuleNotFoundError):
        print("Run \"pip3 install python-magic\" or some other command to install it first!", file = sys.stderr)
    raise ex

try:
    import numpy as np
except Exception as ex:
    print("*** Failed to import numpy: %s: %s" % (type(ex), ex), file = sys.stderr)
    if isinstance(ex, ModuleNotFoundError):
        print("Run \"pip3 install numpy\" or some other command to install NumPy first!", file = sys.stderr)
    raise ex

try:
    import cv2
    os.environ["OPENCV_IO_ENABLE_JASPER"] = "1" # Solves a bug relative to JPEG2000
except Exception as ex:
    print("*** Failed to import cv2: %s: %s" % (type(ex), ex), file = sys.stderr)
    if isinstance(ex, ModuleNotFoundError):
        print("Run \"pip3 install opencv-python\" or some other command to install OpenCV first!", file = sys.stderr)
    raise ex

try:
    from PIL import Image, ImageSequence, ImageFile
    ImageFile.LOAD_TRUNCATED_IMAGES = True # A workaround to: <class 'OSError'>：image file is truncated
except Exception as ex:
    print("*** Failed to import PIL components: %s: %s" % (type(ex), ex), file = sys.stderr)
    if isinstance(ex, ModuleNotFoundError):
        print("Run \"pip3 install pillow\" or some other command to install PIL first!", file = sys.stderr)
    raise ex

@unique
class ImageType(IntEnum):
    IMG_UNKNOWN = 0
    IMG_JPEG = 1
    IMG_BMP = 2
    IMG_PNG = 3
    IMG_TIFF = 4
    IMG_GIF = 5
    IMG_WEBP = 6

SUPPORTED_TYPE_STRINGS = [ i[0].split("_")[1] for i in ImageType.__members__.items() if "IMG_UNKNOWN" != i[0] ]
SUPPORTED_TYPE_NUMBERS = [ i[1] for i in ImageType.__members__.items() if ImageType.IMG_UNKNOWN != i[1] ]
TRANSPARENT_TYPE_NUMBERS = [ ImageType.IMG_PNG, ImageType.IMG_GIF, ImageType.IMG_WEBP ]

__IMG_TYPE_MAP = {
    "jpg": ImageType.IMG_JPEG
    , "jpeg": ImageType.IMG_JPEG
    , "jp2": ImageType.IMG_JPEG
    , "j2k": ImageType.IMG_JPEG
    , "bmp": ImageType.IMG_BMP
    , "x-ms-bmp": ImageType.IMG_BMP
    , "png": ImageType.IMG_PNG
    , "tiff": ImageType.IMG_TIFF
    , "gif": ImageType.IMG_GIF
    , "webp": ImageType.IMG_WEBP
}

def get_image_type(file):

    assert isinstance(file, str) or isinstance(file, bytes)

    type_str = "Unknown"
    try:
        if isinstance(file, str):
            if not os.path.exists(file):
                return (ImageType.IMG_UNKNOWN, "Non-existent file")

            type_str = magic.from_file(file, mime = True)
        else:
            type_str = magic.from_buffer(file, mime = True)

        return (__IMG_TYPE_MAP[type_str.replace("image/", "")], type_str)
    except Exception as ex:
        return (ImageType.IMG_UNKNOWN, type_str)

def get_image_suffix(type_num):
    try:
        return SUPPORTED_TYPE_STRINGS[SUPPORTED_TYPE_NUMBERS.index(type_num)]
    except Exception:
        raise TypeError("Value of type_num must be one of %s" % SUPPORTED_TYPE_NUMBERS)

SUPPORTED_CHANNELS = [ -1, 1, 3, 4 ]
SUPPORTED_CHANNEL_ORDERS = [ "RGB", "BGR" ]

__CV_READ_FLAGS = [
    -1
    , cv2.IMREAD_GRAYSCALE
    , -1
    , cv2.IMREAD_COLOR
    , cv2.IMREAD_UNCHANGED
]

__PIL_READ_FLAGS = [
    ""
    , "L"
    , ""
    , "RGB"
    , "RGBA"
]

def load(file, channels, channel_order = "BGR"):

    assert channels in SUPPORTED_CHANNELS
    assert channel_order in SUPPORTED_CHANNEL_ORDERS

    img_type, type_str = get_image_type(file)

    if img_type is ImageType.IMG_UNKNOWN:
        return (img_type, type_str, 0, None)

    if img_type in TRANSPARENT_TYPE_NUMBERS and -1 == channels:
        channels = 4

    is_path = isinstance(file, str)
    is_rgb_order = ("RGB" == channel_order)

    if img_type is not ImageType.IMG_GIF:
        mat = cv2.imread(file, __CV_READ_FLAGS[channels]) if is_path \
            else cv2.imdecode(np.asarray(bytearray(file), dtype = "uint8"), __CV_READ_FLAGS[channels])

        if mat is not None:
            if 1 == channels:
                return (img_type, type_str, mat.shape[2], mat)

            if 3 == channels:
                return (img_type, type_str, mat.shape[2], cv2.cvtColor(mat, cv2.COLOR_BGR2RGB) if is_rgb_order else mat)

            #
            # channels == 4
            #

            _, _, cur_channels = mat.shape
            assert cur_channels in [ 3, 4 ]

            if 3 == cur_channels:
                return (img_type, type_str, cur_channels, cv2.cvtColor(mat, cv2.COLOR_BGR2RGBA) if is_rgb_order else cv2.cvtColor(mat, cv2.COLOR_BGR2BGRA))
            else:
                return (img_type, type_str, cur_channels, cv2.cvtColor(mat, cv2.COLOR_BGRA2RGBA) if is_rgb_order else mat)

    #
    # It's a GIF, or not a GIF but failed to parse with OpenCV.
    #

    img = Image.open(file if is_path else BytesIO(file))
    src_channels = len(img.getbands())
    img_rgb = None

    for frame in ImageSequence.Iterator(img):
        img_rgb = frame.convert(__PIL_READ_FLAGS[channels])
        break

    assert img_rgb is not None
    mat = np.array(img_rgb)

    if 1 == channels:
        return (img_type, type_str, src_channels, mat)

    if 3 == channels:
        return (img_type, type_str, src_channels, mat if is_rgb_order else cv2.cvtColor(mat, cv2.COLOR_RGB2BGR))

    return (img_type, type_str, src_channels, mat if is_rgb_order else cv2.cvtColor(mat, cv2.COLOR_RGBA2BGRA))

def save(path, mat, *args):

    return cv2.imwrite(path, mat) # TODO: gif, webp with vp8x encoding

def rotate(mat, degrees):
    """
    https://stackoverflow.com/questions/43892506/opencv-python-rotate-image-without-cropping-sides/47248339
    """

    h, w = mat.shape[:2]
    mat_center = (w / 2, h / 2)
    rotated_mat = cv2.getRotationMatrix2D(mat_center, degrees, 1)

    abs_cos = abs(rotated_mat[0, 0])
    abs_sin = abs(rotated_mat[0, 1])

    bound_w = int(h * abs_sin + w * abs_cos)
    bound_h = int(h * abs_cos + w * abs_sin)

    rotated_mat[0, 2] += bound_w / 2 - mat_center[0]
    rotated_mat[1, 2] += bound_h / 2 - mat_center[1]

    return cv2.warpAffine(mat, rotated_mat, (bound_w, bound_h))

