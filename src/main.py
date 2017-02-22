import os.path
import numpy as np
from scipy import ndimage
from sklearn import cluster
import skimage
from skimage import io, filters, feature, morphology, color#restoration
from skimage.morphology import disk
import matplotlib.pyplot as plt
import warnings
import time
from PIL import Image

import glob

# %pylab
im_list = glob.glob('../images/train*.jpg')
def myimread(filepaths):
    """
    filepaths is a list of paths to image files.
    Images are loaded using the im
    """
    if any(filepaths):
        train_imgs = [io.imread(fpath) for fpath in filepaths]


train_grey = [color.rgb2gray(im) for im in train_imgs]

# Empty list for center coordinates(need to optimize this)
train_centers = []

start = time.time() # start a timer
for imgray in train_grey:
    # smooth the image using a rank median filter
    denoised = filters.rank.median(imgray, disk(2))

    # detect contrast differences using Canny edge filtering
    edges = feature.canny(denoised, sigma=1)

    # binary-dilation algorithm to fill groups
    segmented = ndimage.binary_fill_holes(edges)

    label_objects, nb_labels = ndimage.label(segmented)
    sizes = np.bincount(label_objects.ravel()) # threshold size, then perform essentially an 
    mask_sizes = sizes > 40
    mask_sizes[0] = 0

    # logically AND operation with the surviving labels
    cleaned = mask_sizes[label_objects]
    labels, _ = ndimage.label(cleaned)
    labels.min(), labels.max()
    centers = ndimage.measurements.center_of_mass(denoised,labels=labels, index=np.arange(labels.min(),labels.max()))
    train_centers.append(centers)

end = time.time()

print('Took {} seconds'.format(end -start))
(end-start)/len(centers)



for fpath, img, centers in zip(im_list, train_imgs, train_centers):

    # split the directory path from the file name
    dirname, fname = os.path.split(fpath)

    # split the file name from the file extention
    fname, _ = os.path.splitext(fname)

    # make a directiory to store the centers
    if not os.path.exists(dirname+'/centers'):
        os.mkdir(dirname+'/centers')
    else:
        print('Over-writing images in centers directory!')

    newf = '{}/centers/{}_centers.jpg'.format(dirname,fname)
    print('Saving "{}"'.format(newf))

    fig = plt.figure()
    plt.imshow(img)
    for c in centers:
        y,x = c
        plt.plot(x,y, 'r.', markersize=14)
    fig.savefig(newf)
