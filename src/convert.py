import glob
import os.path
from PIL import Image

im_list = glob.glob('./images/raw/*.jpg')

for ix, im in enumerate(im_list):
    im_resized = Image.open(im).resize((640,480), Image.ANTIALIAS)
    fname, ext = os.path.splitext(im)
    d = os.path.dirname(fname)
    newf = '{}/train{}{}'.format(d,ix,ext)
    im_resized.save(newf)
