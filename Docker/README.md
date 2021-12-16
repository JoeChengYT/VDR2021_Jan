# Docker Directory Description
This directory is an example of what our team used for the Virtual Donkey Car Race in November 2021.  
The following describes how we used it.  
Using a Docker container on a server close to the race server allows race participants to interact with the race server over a low-latency network connection.  
This method was established by [@Heavy02011](https://github.com/Heavy02011), [@altexdim](https://github.com/altexdim) and other DonkeyCar organizers. Thank you!  
For more information, please visit https://github.com/connected-autonomous-mobility/diyrobocar_docker_agent_pln
and
https://github.com/altexdim/donkeycar-race
and the Donkeycar Discord for more details.  
## Step 1. copy the necessary files to Team_ahoy_racer
The _Team_ahoy_racer_ directory is a directory that is required when creating a DockerImage.  
The files that need to be copied are as follows.  
- `cfgs`: Our original config file  
- `save_model`: Our trained models  
- Empty `models`: Needed when starting the automatic driving  
- Empty `data`: Needed when starting the automatic driving  
- `config.py`  
- `manage.py`  
- `Makefile`: Use the *make* command to start automatic driving  

##Step 2. Start image build.
``` sh . /img_build.sh ```  
to start Docker's Image build.  
It will take 1.5 hours to build.

## Step 3. Check the built image.
Check if the contents of Step 1 are included in the built image.  
``` docker run --name "TEAM_ahoy_racer" -it yourname/race2021_nov:0.1 /bin/bash ```    
to start the container and check the items.

## Step 4. Upload the image to DockerHub
Upload the image to DockerHub to be downloaded by the server where the Docker container will be deployed.  
To use DockerHub, you need to register as a member.  
Please register at https://hub.docker.com/

Upload the file to DockerHub.  
``` docker tag yourname/race2021_nov:0.1 <NEED MODIFY!> DockerHub_UserName/RipositoryName:tagname  ```

``` docker push <NEED MODIFY!> DockerHub_UserName/RipositoryName:tagname ```

## Step 5. create sshkey
Create the sshkey.  
Creating sshkey is specified in the following instruction. 
[see here](https://github.com/altexdim/donkeycar-race#step-by-step-guide-for-a-participant-to-set-everything-up-before-the-race)  
``` ssh-keygen -t ed25519 -C "your_email@example.com" -f ~/.ssh/donkeysim_race ```

## Step 6. Contact the DonkeyCar organizer
Make a request to the DonkeyCar organizer to create a Docker container.  
It is a good to prepare your ssh public key and the name of the repository you uploaded to DockerHub ready when you make the request.  
Also, to understand how it works, we recommend reading [README here](https://github.com/altexdim/donkeycar-race)
to know how it works.


# Dockerディレクトリの説明
このディレクトリは私達のチームが2021年11月のVirtual Donkey Car Raceで使った一例です。  
以下は私達が使った方法を説明します。  
レースサーバに近いサーバにてDockerコンテナを利用することで、レース参加者は低遅延なネットワーク接続でレースサーバとやり取りできます。
この方法は[@Heavy02011さん](https://github.com/Heavy02011) と[@altexdimさん](https://github.com/altexdim) を初め、DonkeyCarの主催者が確立しました。ありがとうございます!  
詳しい説明はhttps://github.com/connected-autonomous-mobility/diyrobocar_docker_agent_pln
と
https://github.com/altexdim/donkeycar-race
及び、DonkeycarのDiscordを是非ご覧ください。
## Step 1. Team_ahoy_racerに必要なファイルをコピーする
Team_ahoy_racerディレクトリはDockerImage作成時に必要なディレクトリです。  
コピーが必要なファイルは以下の通りです。  
- `cfgs`ディレクトリ: 私達のオリジナルのconfigファイルです
- `save_model`ディレクトリ: 学習済みモデルです
- 空の`models`ディレクトリ: 自動運転開始時に必要とされています
- 空の`data`ディレクトリ: 自動運転開始時に必要とされています
- `config.py`
- `manage.py`
- `Makefile`: makeコマンドを使って自動運転を開始します

##Step 2. イメージビルドを開始する
``` sh ./img_build.sh ```  
を実行することで、DockerのImageビルドが始まります。  
ビルドには1.5時間掛かります。

## Step 3. ビルドしたイメージをチェックする
ビルドしたイメージ内にStep 1の内容物が入っているか確認します。  
``` docker run --name "TEAM_ahoy_racer" -it  yourname/race2021_nov:0.1 /bin/bash ```  
でコンテナを起動し、内容物を確認します。

## Step 4. DockerHubにイメージをアップロード
イメージをDockerHubにアップロードし、Dockerコンテナを展開するサーバでダウンロードをできるようにします。  
DockerHubの利用には会員登録が必要です。  
https://hub.docker.com/  
で会員登録を行ってください。

DockerHubへアップロードします。  
``` docker tag yourname/race2021_nov:0.1 <NEED MODIFY!> DockerHub_UserName/RipositoryName:tagname ```  

``` docker push <NEED MODIFY!> DockerHub_UserName/RipositoryName:tagname ```

## Step 5. sshkeyを作成する
sshkeyの作成を行います。  
sshkeyの作成は以下のインストラクションで指定されています。 
[こちらをご覧ください。](https://github.com/altexdim/donkeycar-race#step-by-step-guide-for-a-participant-to-set-everything-up-before-the-race)  
``` ssh-keygen -t ed25519 -C "your_email@example.com" -f ~/.ssh/donkeysim_race ```

## Step 6. DonkeyCar主催者に連絡する
DonkeyCar主催者へDockerコンテナ作成の依頼をしてください。  
依頼する時に、あなたのsshkeyの公開鍵とDockerHubにアップロードしたリポジトリ名を準備するといいでしょう。  
また、仕組みを理解するために、[こちらのREADME](https://github.com/altexdim/donkeycar-race)
を読むことをおすすめします。


# Docker目录说明
此目录是我们团队用于 2021 年 11 月虚拟DonkeyCar比赛的示例。  
下面介绍我们如何使用它。   
在靠近比赛服务器的服务器上使用 Docker 容器允许比赛参与者通过低延迟网络与比赛服务器进行连接。   
该方法由[@Heavy02011](https://github.com/Heavy02011)、[@altexdim](https://github.com/altexdim)等DonkeyCar组织者建立。 谢谢！   
更多信息请访问  
https://github.com/connected-autonomous-mobility/diyrobocar_docker_agent_pln
,  
https://github.com/altexdim/donkeycar-race
和 Donkeycar Discord 了解更多详情。  

## Step 1. 复制必要的文件到Team_ahoy_racer
Team_ahoy_racer 目录是创建 Docker Image 时需要的目录。 
需要复制的文件如下。 　　
- `cfgs` 目录：我们的原始配置文件　　
- `save_model`目录：训练好的模型　　
- 空的`models`目录：自动驾驶开始时需要　　
- 空的`data`目录：自动驾驶开始时需要　　
- `config.py`  
- `manage.py`  
- `Makefile`：使用make命令启动自动驾驶运行 

## Step 2. 开始镜像构建
``` sh . /img_build.sh ```  
开始Docker的镜像构建。  
构建需要1.5个小时。

## Step 3. 检查构建的镜像
检查步骤 1 的内容是否包含在构建的镜像中。  
``` docker run --name "TEAM_ahoy_racer" -it yourname/race2021_nov:0.1 /bin/bash ```  
启动Docker容器并检查内容。  

## Step 4. 上传镜像到DockerHub
将映像上传到 DockerHub，并使其可在部署 Docker 容器的服务器上下载。  
使用 Docker Hub 需要注册会员。  
https://hub.docker.com/  
请注册成为会员。  

上传到 DockerHub  
``` docker tag yourname/race2021_nov:0.1 <NEED MODIFY!> DockerHub_UserName/RipositoryName:tagname ```  
``` docker push <NEED MODIFY!> DockerHub_UserName/RipositoryName:tagname ```  

## Step 5. 创建 ssh 密钥 
创建一个ssh密钥。  
ssh 密钥的创建请看以下的说明。  

[请看这里](https://github.com/altexdim/donkeycar-race#step-by-step-guide-for-a-participant-to-set-everything-up-before-the-race)  

``` ssh-keygen -t ed25519 -C "your_email@example.com" -f ~/.ssh/donkeysim_race ```  

## Step 6. 联系 DonkeyCar 组织者  
请 DonkeyCar 组织者创建一个 Docker 容器。  
最好在发出请求时准备好 ssh 公钥和上传到 DockerHub 的存储库名称。  
另外，要了解它是如何工作的，请读一下 [README](https://github.com/altexdim/donkeycar-race)  
