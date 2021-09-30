import cv2                                         #importing cv2 library
import numpy as np                                 #importing numpy library

n1 = open('Output//SonuGawd_3.hex','r')                     #opening .hex file for kernel of 3x3 which is the output file of verilog code
n2 = open('Output//SonuGawd_5.hex','r')                     #opening .hex file for kernel of 5x5 which is the output file of verilog code
n3 = open('Output//SonuGawd_7.hex','r')                     #opening .hex file for kernel of 7x7 which is the output file of verilog code

img1 = np.zeros((183,275),np.uint8)                #creating image for storing output image processed by kernel of 3x3
img2 = np.zeros((183,275),np.uint8)                #creating image for storing output image processed by kernel of 5x5
img3 = np.zeros((183,275),np.uint8)                #creating image for storing output image processed by kernel of 7x7


#-----------------------------------------reading from opened hex files and storing new pixel values in images---------------------------------------

for i in range(183):
	for j in range(275):

		s1 = n1.readline()
		img1[i,j] = int(s1,16)

		s2 = n2.readline()
		img2[i,j] = int(s2,16)

		s3 = n3.readline()
		img3[i,j] = int(s3,16)

#----------------------------------------writing new images to corresponding jpg files which is the final output-----------------

cv2.imwrite('Output//SonuGawd_3.png',img1)
cv2.imwrite('Output//SonuGawd_5.png',img2)
cv2.imwrite('Output//SonuGawd_7.png',img3)

#---------------------------------------closing the files------------------------------------------------------

n1.close()
n2.close()
n3.close()

cv2.waitKey(0)
cv2.destroyAllWindows()
