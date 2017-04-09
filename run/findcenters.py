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

import sys

try:
    fname = sys.argv[1]
except IndexError as e:
    print('Please enter a valid image file path!')
    sys.exit()

try:
    imrgb = io.imread(fname)
except FileNotFoundError:
    print('Please enter a valid image file path!')
    sys.exit()


# use the skimage.color.rgb2gray() function to 
# convert the multichannel color images to 
# single channel grayscale image
imgray = color.rgb2gray(imrgb)

with warnings.catch_warnings():
    warnings.simplefilter("ignore")

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
centers = ndimage.measurements.center_of_mass(denoised,labels=labels, index=np.arange(labels.min(),labels.max()))

print(centers)
