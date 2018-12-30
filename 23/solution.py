#!/usr/bin/python2.7

from __future__ import print_function

import matplotlib.pyplot as plt
import matplotlib.cm as cm
from mpl_toolkits.mplot3d.axes3d import Axes3D

import sys
#import os
import re
import numpy as np
#import cv2

#points = np.asarray( points )
fig = plt.figure(figsize=(24,18))
ax = fig.add_subplot(1, 1, 1, projection='3d')

#points = []
for line in sys.stdin:
    x,y,z,r = re.findall( r'(-?[0-9.]+),(-?[0-9.]+),(-?[0-9.]+),([0-9.]+)' , line )[0]
    print( x,y,z,r )
    #ax.scatter([int(x)], [int(y)], [int(z)], s=np.pi*int(r)*int(r), alpha=0.8, c='k')
    ax.scatter([int(x)], [int(y)], [int(z)], alpha=0.2, c='k')
    #points.append( [x,y,z,r] )

plt.show()
