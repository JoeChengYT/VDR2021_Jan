# Useful code introduction
## image_mask.py
**purpose** : Add noise masks to images to increase the generality of the model during training.  
**How to use** : ```python scripts/image_mask.py ../save_data/Example_data ../data/Example_data_trimmed```

## trim.py
**Purpose** : Trim and save a portion of running data.  
**How to use** : ```python trim.py ../save_data/Example_data 10 20 ../data/Destination_DIR```  
**Algorithm** :  
1. Check for the existence of manifest.json in Example_data
2. Check if there is a ```Destination_DIR``` in ```data```. If not, it will be created automatically
3. Integrate the contents of the ```.catalog``` file in ```Example_data```
4. Integrate the contents of the ```.catalog_manifest``` file in ```Example_data``` and get the "Line_length" values from 10~20
5. Cut out the values from 10 to 20 in the merged ```.catalog``` file and renumber them
6. Cut out the images in the images directory and renumber them.
7. Rewrite the inside of ```manifest.json``` and output it.

## multi_trim.py ##  
**Purpose** : Reads and cuts the running data from the file containing the clipping points.  
**Use** : ```python multi_trim.py --input=../save_data/Example_data --output=../data/Destination_DIR --file=../save_data/multi_trim.trim --onefile```    
_multi_trim.trim_ : Crop and save images from 10 to 20, 110 to 130, and 200 to 300.  
10 20  
110 130  
200 300  
**Algorithm** :  
1. Import ```trim.py```
2. Read the file one line at a time
3. Pass the arguments to ```trim.py```
4. Repeat steps 2 and 3 until the content of the file becomes EOF.

# 便利なコードの紹介
## image_mask.py
**目的** : 画像にノイズマスクをいれて学習時にモデルの汎用性を高める
**使い方** : ```python scripts/image_mask.py ../save_data/Example_data ../data/Example_data_trimmed```

## trim.py
**目的** : 走行データの一部分を切り抜いて保存します。  
**使い方** : ```python trim.py ../save_data/Example_data 10 20 ../data/Destination_DIR```  
**アルゴリズム** :  
1. ```Example_data```内に```manifest.json```の存在を確認します。
2. ```../dataにDestination_DIR```があるか確認します。ない場合は自動で作ります。
3. ```Example_data```内の```.catalog```ファイルの内容を統合します。
4. ```Example_data```内の```.catalog_manifest```ファイルの内容を統合し、10~20までの"Line_length"の値を取得します。
5. 統合された```.catalog```ファイル内から10~20までの値を切り出しと番号を振りなおします。
6. ```images```ディレクトリ内で画像を切り出し、番号を振りなおします。
7. ```manifest.json```の中を書き換えて出力します。

## multi_trim.py
**目的** : 走行データの切り抜き箇所が書かれたファイルから読み出して切り取ります。  
**使い方** : ```python multi_trim.py --input=../save_data/Example_data --output=../data/Destination_DIR --file=../save_data/multi_trim.trim --onefile```    
_multi_trim.trim_ : 10から20まで、110から130まで、200から300までの画像を切り抜いて保存します。  
10 20  
110 130  
200 300  
**アルゴリズム** :  
1. ```trim.py```をインポートします。
2. fileを１行ずつ読み取ります。
3. ```trim.py```に引数を渡します。
4. fileの内容がEOFになるまで2と3を繰り返します。