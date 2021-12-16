# Virtual Donkey Racing2022_January

# Repository Introduction
This repository includes Donkey v4.2 driving data, trained models, and Donkey configuration data for participation in the Virtual DonkeyCar Race racing in January 2022.  
This repository refers to [hogenimushi/vdc2020_race03](https://github.com/hogenimushi/vdc2020_race03).

## Preparation
### Install Donkeycar
1. [Please follow instruction from "Install Donkeycar on Linux"](https://docs.donkeycar.com/guide/host_pc/setup_ubuntu/)
1. [Please follow instruction from "Donkey Simulator"](https://docs.donkeycar.com/guide/simulator/)  

### Attention
**Please upgrade your TensorFlow version to 2.4.0 to use the automated driving models in this repository.**  
How to check the version of TensorFlow in conda
```shell
conda list | grep tensor
```  
If your installed tensorflow == 2.2.0, please type below commands
```shell
conda uninstall tensorflow
pip install tensorflow==2.4.0
If you have GPU
pip install tensorflow-gpu==2.4.0
```
### Installing the simulator.
```shell
make install_sim
```

### Recording driving data
```shell
make record
````

### Creating a model with the example data.
models/test.h5 will be created.  
```shell
make test_train
```

### Running the test.h5 autonomous driving model.
```shell
cp save_model/test.h5 models/
make test_run
```

### Miscellaneous.
See the Makefile.

## Description of each directory and file.
- ```Docker```: It is used to build Docker images, which help deploy containers near a race server. Please see the README in the _Docker_ directory for more information.
- ```cfgs```: Contains the configuration data files for Donkey. Donkey's configuration data includes car body settings and machine learning settings.
- ```data```: This directory contains the simulator's recorded driving data. If you want to share your data, move it to _save_data_.
- ```models```: The directory where models will be output after training. Move models to _save_model_ if you want to share them.
- ```save_data```: Share Donkey's running data with others.
- ```save_model```: Share Donkey's trained model with others.
- ```Makefile```: We use this mainly for reproducibility of the trained model. Specifically, it describes the data used in the trained model. It also allows you to invoke long commands with your own commands.
- ```config.py```: Contains Donkey's configuration data, which can be overwritten from _cfgs_, so there is no need to edit config.py.
- ```manage.py```: Manages Donkey's train and drive modes.
- ```train.py```: Takes arguments specified during training.
- ```.gitignore```: This allows you to specify files and directories not to be pushed to the repository.　　

# リポジトリ紹介
このリポジトリは2021年11月のVirtual DonkeyCar Race racingに参加するためにDonkey v4.2 の走行データ、学習済みモデル、Donkeyのコンフィグデータを共有します。
このリポジトリは[hogenimushi/vdc2020_race03](https://github.com/hogenimushi/vdc2020_race03) を参考にして作っています。

## 準備
### Donkeycarをインストールする
1. [Install Donkeycar on Linux に沿ってインストールしてください](https://docs.donkeycar.com/guide/host_pc/setup_ubuntu/)
1. [Donkey Simulator に沿ってインストールしてください](https://docs.donkeycar.com/guide/simulator/)  

### 注意
**このリポジトリの自動運転モデルを利用するにはtensorflowのバージョンは2.4.0へアップグレードしてください。**  
conda内のtensorflowのバージョン確認方法
```shell
conda list | grep tensor
```  
もし、tensorflow == 2.2.0の場合
```shell
conda uninstall tensorflow
pip install tensorflow==2.4.0
GPUがある場合は
pip install tensorflow-gpu==2.4.0
```

### シミュレータをインストールする
```shell
make install_sim
```

### 走行データを得る
```shell
make record
```

### Exampleデータを使ってモデルを作る
models/test.h5を作ります  
```shell
make test_train
```

### test.h5を使って自動運転
```shell
cp save_model/test.h5 models/
make test_run
```

### その他
Makefileをご覧ください。

## 各ディレクトリとファイルの説明
- ```Docker```: Dockerイメージをビルドするために使われます。Dockerイメージはレースサーバ近くでコンテナを展開するときに役立ちます。詳しくは_Docker_ディレクトリ内のREADMEをご覧ください。
- ```cfgs```: Donkeyのコンフィグデータが入っています。コンフィグデータとは、車体設定や、機械学習時の設定などが書いてあります。
- ```data```: シミュレータでの走行データが書き込まれます。共有したい走行データは*save_data*へ移動しましょう。
- ```models```: 学習後にモデルが出力されるディレクトリです。共有したいモデルは*save_model*へ移動しましょう。
- ```save_data```: Donkeyの走行データをみんなと共有します。
- ```save_model```: Donkeyの学習済モデルをみんなと共有します。
- ```Makefile```: 学習済みモデルの再現性を主な目的として使っています。具体的には、学習済みモデルに使ったデータを記述します。また、長いコマンドを独自のコマンドで呼び出すことができます。
- ```config.py```: Donkeyのコンフィグデータが記されています。*cfgs*から上書きできるため、config.pyを編集する必要はありません。
- ```manage.py```: Donkeyのtrainやdriveモードを管理しています。
- ```train.py```: 学習時に指定した引数を受け取ります。
- ```.gitignore```: リポジトリにpushしないファイルやディレクトリを指定できます。

# 存储库介绍
该存储库共享Donkey v4.2驾驶数据、训练模型和Donkey配置数据，以参加2021年11月的Virtual DonkeyCar Race比赛。  
这个存储库是通过参考[hogenimushi/vdc2020_race03](https://github.com/hogenimushi/vdc2020_race03)创建的。  

## 准备
### 安装DonkeyCar
1. [请根据在 Linux 上安装 Donkeycar 的方法进行安装。](https://docs.donkeycar.com/guide/host_pc/setup_ubuntu/)  
1. [请根据Donkey Simulator 进行安装。](https://docs.donkeycar.com/guide/simulator/)  

### 注意
请将您的 tensorflow 版本升级到 2.4.0 以利用此存储库中的自动驾驶模型。  
检查conda中tensorflow的版本  
```shell
conda list | grep tensor
```

如果 tensorflow == 2.2.0 的情况  
```shell
conda uninstall tensorflow
pip install tensorflow==2.4.0
如果有GPU
pip install tensorflow-gpu==2.4.0
```

### 安装模拟器  
```shell
make install_sim
```

### 获取驾驶数据
```shell
make record
```

### 使用示例数据创建模型
创建models/test.h5
```shell
make test_train
```

### 使用test.h5自动驾驶
```shell
cp save_model/test.h5 models/
make test_run
```

### 其他
请看Makefile

## 每个目录和文件的说明
- ```Docker```: 它被用来构建Docker镜像，这有助于在竞赛服务器附近部署容器。请参阅 _Docker_ 目录中的README以了解更多信息。
- ```cfgs```： 包含 Donkey 配置数据。配置数据描述了车身设置和机器学习设置。  
- ```data```： 写入模拟器中的驾驶数据。将要共享的驾驶数据移动到 *save_data*。  
- ```models```： 训练后模型输出的目录。将要共享的模型移动到 *save_model*。  
- ```save_data```： 与大家分享Donkey的驾驶数据。  
- ```save_model```： 与大家分享 Donkey 训练好的模型。  
- ```Makefile```： 主要目的是重现训练好的模型。具体来说，描述用于训练模型的数据。您还可以使用自己的命令调用长命令。  
- ```config.py```： 包含 Donkey 的配置数据。您不需要编辑 config.py，因为您可以从 *cfgs* 覆盖它。  
- ```manage.py```： 管理 Donkey 的训练和驾驶模型。  
- ```train.py```： 接收训练期间指定的参数。  
- ```.gitignore```： 您可以指定将不会推送到存储库的文件和目录。  
