import sys
import shutil
import os
import json
import glob
import re

class TrimmingData:
    def __init__(self, input_dir, first_num, last_num, output_dir):
        self.first_num = first_num
        self.last_num = last_num

        ### INPUT FILES
        self.input_dir = input_dir
        self.input_catalog_file = input_dir + "/catalog_{}.catalog"
        self.input_catalog_manifest = input_dir + "/catalog_{}.catalog_manifest"
        self.input_manifest = input_dir + "/manifest.json"

        ### OUTPUT FILES
        self.output_dir = output_dir
        self.output_catalog_file = output_dir + "/catalog_0.catalog"
        self.output_catalog_manifest = output_dir + "/catalog_0.catalog_manifest"
        self.output_manifest = output_dir + "/manifest.json"

    def append_catalog(self):## 元のディレクトリにあるcatalogfileを1つに結合する。１つのファイルを出力する
        read_catalogs = \
            sorted(glob.glob(self.input_catalog_file.format("*")), key=lambda s: int(re.search(r'\d+', s).group()))
        with open(self.output_catalog_file, "w") as outfile:
            for f in read_catalogs:
                with open(f, "r") as infile:
                    outfile.write(infile.read())

    def append_manifest(self):# manifestのline_lengthsを結合し、１つのファイルを出力する。
        store = []
        read_manifests = \
            sorted(glob.glob(self.input_catalog_manifest.format("*")), key=lambda s: int(re.search(r'\d+', s).group()))
        for manifest in read_manifests:
            with open(manifest, "r") as infile:
                j = json.load(infile)
                store.extend(j["line_lengths"])
        with open(read_manifests[0], "r") as infile:
            j = json.load(infile)
            j["line_lengths"] = store[self.first_num:self.last_num+1]
            with open(self.output_catalog_manifest, "w") as outfile:
                json.dump(j, outfile)

    def extract(self):# .catalogの中から指定された分を抽出すると番号を再度振り直し
        store = []
        with open(self.output_catalog_file, "r") as infile:
            lines = infile.readlines()
            for i, line in enumerate(lines[self.first_num : self.last_num + 1]):
                j = json.loads(line)
                j["_index"] = i
                j["cam/image_array"] = '{}_cam_image_array_.jpg'.format(i)
                store.append(json.dumps(j) + '\n')
        with open(self.output_catalog_file, "w") as outfile:
            outfile.writelines(store)

    def copy_image(self):# 画像をコピーし、番号を振り直す。
        input_img_path = self.input_dir + "/images/{}_cam_image_array_.jpg"
        output_img_path = self.output_dir + "/images/{}_cam_image_array_.jpg"
        for out_index, in_index in enumerate(range(self.first_num, self.last_num + 1)):
            in_image = input_img_path.format(in_index)
            out_image = output_img_path.format(out_index)
            shutil.copy(in_image, out_image)

    def modify_manifest(self):# manifest内のpathsとcurrent_indexを書き換える。
        with open(self.input_manifest,"r") as infile:
            lines = infile.readlines()
            j = json.loads(lines[4])
            j["paths"] = ["catalog_0.catalog"]
            j["current_index"] = self.last_num - self.first_num + 1
            with open(self.output_manifest, "w") as outfile:
                outfile.writelines(lines[0:4])
                outfile.write(json.dumps(j))

def verification_data(path):# manifest.jsonの存在を確認
    print("Checking" + path + " ... ", end="")
    if os.path.exists(path + "/manifest.json"):
        print("OK")
    else:
        print("\n" + path + " doesn't exist donkey data.")
        exit(1)

def verification_target_dir(path):# ディレクトリの確認。なければ、imagesディレクトリまで作成する。
    print("Checking destination data path ... ", end="")
    if os.path.exists(path):
        print("OK")
    else:
        os.makedirs(os.path.join(path, 'images'))
        print("doesn't exist destination directory, making dir: " + '{}'.format(path) + '/images')

def main(input_dir, first_num, last_num, output_dir):
    print("source data path: " + input_dir)
    print("first record number: " + str(first_num))
    print("last record number: " + str(last_num))
    print("destination data path: " + output_dir)
    verification_data(input_dir)
    verification_target_dir(output_dir)
    trim = TrimmingData(input_dir, first_num, last_num, output_dir)
    trim.append_catalog()
    trim.append_manifest()
    trim.extract()
    trim.copy_image()
    trim.modify_manifest()

if __name__ == '__main__':
    args = sys.argv
    input_path = args[1]
    first = int(args[2])
    last = int(args[3])
    output_path = args[4]
    main(input_path, first, last, output_path)