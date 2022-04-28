import argparse
import multiprocessing as mp
import warnings
from PIL import Image

warnings.filterwarnings("ignore", "(Possibly )?corrupt EXIF data", UserWarning)


def validate(fn):
    try:
        im = Image.open(fn).convert('RGB')
        # remove images with too small or too large size
        if im.size[0] < 10 or im.size[1] < 10 or im.size[0] > 10000 or im.size[1] > 10000:
            return fn
    except:
        return fn


parser = argparse.ArgumentParser()
parser.add_argument("files", nargs="?", type=argparse.FileType("r"))
args = parser.parse_args()

with mp.Pool(64) as p:
    for fn in p.map(validate, (line.strip() for line in args.files)):
        if fn is not None:
            print(fn)
