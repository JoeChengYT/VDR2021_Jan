import shutil
import sys
import json

# 複数のTabを結合して一つにする
class MergeData:
    # inputFileNames: 結合するファイル名一覧 
    # outputFileName: 出力するファイル名
    def __init__(self, inputFileNames, outputFileName):
        self.inputFileNames = inputFileNames
        self.outputFileName = outputFileName
        self.index = self.getSize()
        shutil.copytree(inputFileNames[0], outputFileName)

    # 各ファイルのインデックス数を取得
    def getSize(self):
        index = []
        for file in self.inputFileNames:
            with open(file+"/manifest.json", "r") as inputFile:
                lines = inputFile.readlines()
                j = json.loads(lines[4])
                index.append(j["current_index"])
        return index

    # manifest.jsonのcurrent_indexを書き換える
    def merge_manifest(self):
        # 読み込み
        with open(self.outputFileName+"/manifest.json", "r") as inputFile:
            lines = inputFile.readlines()
            j = json.loads(lines[4])
            j["current_index"] = sum(self.index)
            lines[4] = json.dumps(j)
        # 書き込み
        with open(self.outputFileName+"/manifest.json", "w") as outputFile:
            outputFile.writelines(lines)

    # catalog_0.catalogの結合
    def merge_catalog(self):
        outputFile = open(self.outputFileName+"/catalog_0.catalog", "w")
        indexCounter = 0
        for inputFileName in self.inputFileNames:
            inputFile = open(inputFileName+"/catalog_0.catalog", "r")
            for line in inputFile.readlines():
                j = json.loads(line)
                j["_index"] = indexCounter
                j["cam/image_array"] = '{}_cam_image_array_.jpg'.format(indexCounter)
                outputFile.writelines(json.dumps(j) + '\n')
                indexCounter += 1
            inputFile.close()
        outputFile.close()

    # catalog_manifestの結合 
    def merge_catalog_manifest(self):
        line_lengths = []
        # 結合
        for inputFileName in self.inputFileNames:
            with open(inputFileName+"/catalog_0.catalog_manifest", "r") as inputFile:
                j = json.load(inputFile)
                line_lengths.extend(j["line_lengths"])
        # jsonの作成
        with open(self.outputFileName+"/catalog_0.catalog_manifest", "r") as outputFile:
            j = json.load(outputFile)
            j["line_lengths"] = line_lengths
        # 書き込み
        with open(self.outputFileName+"/catalog_0.catalog_manifest", "w") as outputFile:
            json.dump(j, outputFile)

    # 画像の結合
    def merge_image(self):
        currentIndex = self.index[0]
        outputImageName = self.outputFileName + "/images/{}_cam_image_array_.jpg"
        for i in range(1, len(self.inputFileNames)):
            inputImageName = self.inputFileNames[i] + "/images/{}_cam_image_array_.jpg"
            for j in range(self.index[i]):
                shutil.copy(inputImageName.format(j), outputImageName.format(currentIndex))
                currentIndex += 1


def main(inputFileNames, outputFileName):
    if len(inputFileNames) <= 1:
        print('Error "Please input less than two files."')
        sys.exit()

    mergeData = MergeData(inputFileNames, outputFileName)
    mergeData.merge_manifest()
    mergeData.merge_catalog()
    mergeData.merge_catalog_manifest()
    mergeData.merge_image()

if __name__ == '__main__':
    args = sys.argv
    inputFileNames = args[1]
    outputFileName = args[2]
    main(inputFileNames, outputFileName)
