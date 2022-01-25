import sys
import shutil
import json

class Pilot2User:
    def __init__(self, input_path, output_path):
        ## Input files
        self.input_path = input_path
        self.input_catalog_file = input_path + "/catalog_{}.catalog"
        self.input_catalog_manifest = input_path + "/catalog_{}.catalog_manifest"
        self.input_manifest = input_path + "/manifest.json"

        ## Output files
        self.output_path = output_path
        self.output_catalog_file = output_path + "/catalog_0.catalog"
        self.output_catalog_manifest = output_path + "/catalog_0.catalog_manifest"
        self.output_manifest = output_path + "/manifest.json"

    def files_copy(self):
        shutil.copytree(self.input_path, self.output_path)

    def extract(self):
        store = []
        with open(self.output_catalog_file, "r") as infile:
            lines = infile.readlines()
            for i, line in enumerate(lines[:len(lines)]):
                j = json.loads(line)
                j["user/angle"] = j["pilot/angle"]
                j["user/throttle"] = j["pilot/throttle"]
                j["user/mode"] = 'user'
                del j["pilot/throttle"]
                del j["pilot/angle"]
                store.append(json.dumps(j) + '\n')
        with open(self.output_catalog_file, "w") as outfile:
            outfile.writelines(store)


def main(input_path, output_path):
    print("source data path is " + input_path)
    print("destination data path is " + output_path)
    convert_class = Pilot2User(input_path, output_path)
    convert_class.files_copy()
    convert_class.extract()


if __name__ == '__main__':
    args = sys.argv
    input_dir = args[1]
    output_dir = args[2]
    main(input_dir, output_dir)