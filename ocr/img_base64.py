import cv2
import base64
import numpy as np
import io

# Qiita, [Python]Base64でエンコードされた画像データをデコードする。
# https://qiita.com/TsubasaSato/items/908d4f5c241091ecbf9b, 2023年2月16日

# Qiita, base64ってなんぞ？？理解のために実装してみた
# https://qiita.com/PlanetMeron/items/2905e2d0aa7fe46a36d4

#r"" raw文字列では//や/nがそのまま認識されるため、改行文字などのエスケープ文字にならない。

#画像をbase64にする
#引数 target_file:Base64でエンコードする画像のパス, encode_file:エンコードした画像の保存先パス
def img_to_base64(img_path, base64_path):

    #Base64でエンコードする画像のパス
    img_path=r"Konofan.png"
    #エンコードした画像の保存先パス
    base64_path=r"encode.txt"

    with open(img_path, 'rb') as f:
        data = f.read()
    #Base64で画像をエンコード
    encode=base64.b64encode(data)
    with open(base64_path,"wb") as f:
        f.write(encode)


def base64_to_img(base64_path, img_path):

    #Base64でエンコードされたファイルのパス
    base64_path=r"encode.txt"
    #デコードされた画像の保存先パス
    img_path=r"decode.jpg"

    with open(base64_path, 'rb') as f:
        img_base64 = f.read()

    #バイナリデータ <- base64でエンコードされたデータ  
    img_binary = base64.b64decode(img_base64)
    img_ndry=np.frombuffer(img_binary,dtype=np.uint8) #バッファ―をnumpy配列に高速変換している

    #raw image <- img_ndry
    img = cv2.imdecode(img_ndry, cv2.IMREAD_COLOR)


    #画像を保存する場合
    cv2.imwrite(img_path, img)

    #表示確認
    #cv2.imshow('window title', img)
    #cv2.waitKey(0)
    #cv2.destroyAllWindows()


#メインルーチン
def main():

    #Base64でエンコードする画像のパス
    img_path=r"Konofan.png"
    #エンコードした画像の保存先パス
    base64_path=r"encode.txt"
    img_to_base64(img_path, base64_path)


    #Base64でエンコードされたファイルのパス
    base64_path=r"encode.txt"
    #デコードされた画像の保存先パス
    img_path=r"decode.jpg"
    base64_to_img(base64_path, img_path)

if __name__ == '__main__':
    main()