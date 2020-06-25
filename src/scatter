#!/usr/bin/env python3
# -*- coding: utf-8-sig -*-

from matplotlib import pyplot as plt
from matplotlib import style
import numpy as np
from sys import argv

script, data_file, save_fig = argv

plt.style.use('ggplot')

x,y = np.loadtxt(data_file, unpack = True, delimiter = ';')
fig = plt.scatter(x, y, color='cornflowerblue')

plt.title('Blood Glucose Scatter Plot')
plt.xlabel('Time of day (24H)')
plt.ylabel('Readings (mmo/l)')

plt.savefig(save_fig, bbox_inches='tight', dpi='figure')
