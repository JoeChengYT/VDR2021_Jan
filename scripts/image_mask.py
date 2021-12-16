import sys
import os
import numpy
from PIL import Image, ImageDraw
import random
import glob
import shutil
from argparse import ArgumentParser

def get_option():
    argparser = ArgumentParser()
    argparser.add_argument('--input', type=str, help="input data path")
    argparser.add_argument('--output', type=str, help="output data path")
    return argparser.parse_args()

# img自体にノイズをのせる
class ImageMask1:
    def __init__(self, target_path):
        self.target_path = target_path
        self.target_img_path = os.path.join(target_path, "images")

    def make_noise_image(self):
        # 正方形のノイズでmaskする
        self.noise_image_size = 20 #random.randint(20, 50)
        imagesize = (self.noise_image_size, self.noise_image_size,3)  # ノイズ画像サイズ
        randomByteArray = bytearray(os.urandom(
            imagesize[0] * imagesize[1]* imagesize[2]))  # 画素数文の乱数発生
        flatNumpyArray = numpy.array(randomByteArray)  # 1D 乱数
        grayImage = flatNumpyArray.reshape(imagesize)  # 1D から画像 (2D) に変換
        self.noise_image = Image.fromarray(numpy.uint8(grayImage))  # 画像

    def main(self):
        files = os.listdir(self.target_img_path)
        # print(self.target_img_path)
        # print(files)
        for i in files:
            img = Image.open(os.path.join(self.target_img_path, i))
            masked_img = img.copy()
            #for __ in range(3):
            self.make_noise_image()
            x = random.randint(0, img.size[0] - self.noise_image_size)
            y = random.randint(0, img.size[1] - self.noise_image_size)
            masked_img.paste(self.noise_image, (x, y))
            masked_img.save(os.path.join(self.target_img_path, i))

      
# ノイズをのせたimgを作る
class ImageMask2(ImageMask1):
    def __init__(self, target_path, destination_path):
        super().__init__(target_path)
        self.destination_path = destination_path
        self.destination_img_path = os.path.join(destination_path, "images")

    def main(self):
        files = os.listdir(self.target_img_path)
        # print(self.target_img_path)
        # print(files)
        for i in files:
            img = Image.open(os.path.join(self.target_img_path, i))
            masked_img = img.copy()
            #for __ in range(3):
            self.make_noise_image()
            x = random.randint(0, img.size[0] - self.noise_image_size)
            y = random.randint(0, img.size[1] - self.noise_image_size)
            masked_img.paste(self.noise_image, (x, y))
            masked_img.save(os.path.join(self.destination_img_path, i))

        shutil.copy(os.path.join(target_path, "catalog_0.catalog"), os.path.join(self.destination_path, "catalog_0.catalog"))
        shutil.copy(os.path.join(target_path, "catalog_0.catalog_manifest"), os.path.join(self.destination_path, "catalog_0.catalog_manifest"))
        shutil.copy(os.path.join(target_path, "manifest.json"), os.path.join(self.destination_path, "manifest.json"))




def verification_data(path):
    print("checking " + path + " ... ", end="")
    if os.path.exists(os.path.join(path, "manifest.json")):
        print("ok")
    else:
        print("\n" + path + " doesn't exist donkey data.")
        exit(1)


def verification_target_dir(path):
    print("checking destination data path ... ", end="")
    if os.path.exists(os.path.join(path, "images")):
        print("ok")
    else:
        os.mkdir(path)
        os.mkdir(os.path.join(path, "images"))
        print("doesn't exist destination directory, making dir: " + path)


def main(target_path, destination_path=None):
    verification_data(target_path)
    if destination_path is None:
        mask = ImageMask1(target_path)
    else:
        verification_target_dir(destination_path)
        mask = ImageMask2(target_path, destination_path)
    mask.main()


if __name__ == '__main__':
    count_args = sys.argv
    args = get_option()
    target_path = args.input
    destination_path = args.output
    #target_path = args[1]
    destination_path = None if len(count_args) == 2 else destination_path
    main(target_path, destination_path)
