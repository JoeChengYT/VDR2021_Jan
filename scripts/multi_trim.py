## This is a script that trims the data you want exactly the way you want it.
# Reference to
# https://github.com/hogenimushi/vdc2020_race03/blob/4c0327bae28db8b02400094f757b4bed7d63a3dd/scripts/trimming.py
#
import trim
import merge_data
import shutil
from argparse import ArgumentParser

def get_option():
    argparser = ArgumentParser()
    argparser.add_argument('--input', type=str, help="input data path")
    argparser.add_argument('--num', nargs='+', type=int, help="input number directory")
    argparser.add_argument('--output', type=str, help="output data path")
    argparser.add_argument('--file', type=str, default="", help="if number describing in file, please use --file option")
    argparser.add_argument('--onefile', action='store_true', default=False, help="convert")
    return argparser.parse_args()

def file_mode(file_dir, current_dir, target_dir):
    with open(file_dir) as f:
        line = [s.strip() for s in f.readlines()]
    num = [i.split() for i in line]
    fileNames = []
    for i in range(len(num)):
        trim.main(current_dir, int(num[i][0]), int(num[i][1]), target_dir + '_{}'.format(i))
        fileNames.append(target_dir + "_{}".format(i))

    return fileNames

def arg_mode(num, current_dir, target_dir):
    fileNames = []
    for i in range(0, len(num), 2):
        trim.main(current_dir, int(num[i]), int(num[i+1]), target_dir + '_{}'.format(i))
        fileNames.append(target_dir + "_{}".format(i))

    return fileNames

if __name__ == '__main__':
    args = get_option()
    input_path = args.input
    output_path = args.output
    file_path = args.file
    number_list = args.num
    one_file = args.onefile

    if len(args.file) != 0:
        fileNames = file_mode(file_path, input_path, output_path)
    else:
        fileNames = arg_mode(number_list, input_path, output_path)

    # ファイルの結合
    if one_file == True:
        # ファイルの作成
        merge_data.main(fileNames, output_path)
        # ファイルの削除
        for file in fileNames:
            shutil.rmtree(file)
