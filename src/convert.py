import sys, os.path
from PIL import Image
from tqdm import tqdm

im_list = sys.argv[1:]
with tqdm(total=100) as pbar:
    step = 100/len(im_list)
    print('Converting Images...')
    for ix, im,  in enumerate(im_list):
        im_resized = Image.open(im).resize((640,480), Image.ANTIALIAS)
        fname, ext = os.path.splitext(im)
        d = os.path.dirname(fname)
        newf = '{}/train{}{}'.format(d,ix,ext)
        im_resized.save(newf)
        pbar.update(step)
print(f'Images saved to {d}')
