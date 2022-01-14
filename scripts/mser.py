## https://qa.try2explore.com/questions/jp/10701825

import cv2
import matplotlib.pyplot as plt
import numpy as np
import os
import glob
import sys

def display(img, output_file_path):
    cv2.imwrite(output_file_path, img)
    # plt.imshow(plt.imread(output_file_path))
    # plt.axis('off')
    # plt.show()

def execution(cv2_read_img, get_image, vis, basename_without_ext):
    mser = cv2.MSER_create()
    kp = mser.detect(get_image, None)
    #print("{} detect feature number is {}".format(basename_without_ext, len(kp)))
    regions, _ = mser.detectRegions(get_image)
    hulls = [cv2.convexHull(p.reshape(-1, 1, 2)) for p in regions]
    vis = cv2.polylines(vis, hulls, 1, (0, 255, 255))

##########################################################################################
    mask = np.zeros((cv2_read_img.shape[0], cv2_read_img.shape[1], 1), dtype=np.uint8)
    for countour in hulls:
        cv2.drawContours(mask, [countour], -1, (255, 255, 255), -1)
    text_only = cv2.bitwise_and(cv2_read_img, cv2_read_img, mask=mask)

    return vis, text_only

def main(input_dir, output_dir):
    from_dir = input_dir
    to_dir = output_dir
    show_vis = True
    show_text_only = False
    os.makedirs(to_dir, exist_ok=True)

    for path in glob.glob(os.path.join(from_dir, '*')):
        ## Prepare new file NAME
        basename_without_ext = os.path.splitext(os.path.basename(path))[0] ## get file name

        cv2_read_img = cv2.imread(path)
        gray_img = cv2.cvtColor(cv2_read_img, cv2.COLOR_RGB2GRAY)  ## grayscale
        vis = cv2_read_img.copy()

        vis, text_only = execution(cv2_read_img, gray_img, vis, basename_without_ext)

        if(show_vis):
            rename = basename_without_ext + '.jpg'
            output_file_name = os.path.join(to_dir, rename)
            display(vis, output_file_name)
        if(show_text_only):
            rename = basename_without_ext + '.jpg'
            output_file_name = os.path.join(to_dir, rename)
            display(text_only, output_file_name)

if __name__ == '__main__':
    #main()
    args = sys.argv
    input_dir = args[1]
    output_dir = args[2]
    main(input_dir, output_dir)
