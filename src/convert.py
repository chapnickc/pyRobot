import glob
import os.path
from PIL import Image
import sys
# path_re = sys.argv[1] #path to images with regular expression
im_list = glob.glob('../images/mask_PinkGreen/*.jpg')

for ix, im in enumerate(im_list):
    im_resized = Image.open(im).resize((640,480), Image.ANTIALIAS)
    fname, ext = os.path.splitext(im)
    d = os.path.dirname(fname)
    newf = '{}/train{}{}'.format(d,ix,ext)
    im_resized.save(newf)
