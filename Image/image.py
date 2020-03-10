import cv2
import numpy as np
from PIL import Image

filename = './Resolution.png'

img = cv2.imread(filename)

img_gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

cv2.imwrite('test_image_1.tif', img_gray)
