import numpy as np
from scipy import ndimage
import matplotlib.pyplot as plt

import skimage
from skimage import io, filters, feature, morphology, color
from skimage.morphology import disk

from PIL import Image
import warnings
import time
import os.path
import glob
import re

# find all the training images with a filename 
# of which matches the pattern train*.jpg, where
# the '*' symbols could represent any character
im_list = glob.glob('../images/train*.jpg')

# sort the filenames which matched the specified path
# this is used for saving the center of ojbects.mat files 
im_list.sort(key=lambda f: int(re.findall('([0-9]+)', os.path.basename(f))[0]))

# Read each image file and store them in a list 
train_imgs = [io.imread(fpath) for fpath in im_list]

# use the skimage.color.rgb2gray() function to 
# convert the multichannel color images to 
# single channel grayscale image
train_grey = [color.rgb2gray(im) for im in train_imgs]

# imgray = train_grey[-1]


# Empty list for center coordinates 
train_centers = []

# start a timer
start = time.time()


for imgray in train_grey:
    # smooth the image using a rank median filter
    denoised = filters.rank.median(imgray, disk(2))

    # detect contrast differences using Canny edge filtering
    edges = feature.canny(denoised, sigma=1)

    # binary-dilation algorithm to fill groups
    segmented = ndimage.binary_fill_holes(edges)

    label_objects, nb_labels = ndimage.label(segmented)


    # threshold size, then perform essentially an 
    sizes = np.bincount(label_objects.ravel())
    mask_sizes = sizes > 40
    mask_sizes[0] = 0

    # logically AND operation with the surviving labels
    cleaned = mask_sizes[label_objects]
    labels, _ = ndimage.label(cleaned)
    labels.min(), labels.max()
    centers = ndimage.measurements.center_of_mass(denoised,labels=labels, index=np.arange(labels.min(),labels.max()))
    train_centers.append(centers)

end = time.time()


# imrgb = train_imgs[-1]
# imrgb[np.logical_not(cleaned),0] = 0
# imrgb[np.logical_not(cleaned),1] = 0
# imrgb[np.logical_not(cleaned),2] = 0
# io.imshow(imrgb)



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



