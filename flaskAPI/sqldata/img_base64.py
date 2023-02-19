import cv2
import base64
import numpy as np
import io

# Qiita, [Python]Base64でエンコードされた画像データをデコードする。
# https://qiita.com/TsubasaSato/items/908d4f5c241091ecbf9b, 2023年2月16日

# Qiita, base64ってなんぞ？？理解のために実装してみた
# https://qiita.com/PlanetMeron/items/2905e2d0aa7fe46a36d4

#r"" raw文字列では//や/nがそのまま認識されるため、改行文字などのエスケープ文字にならない。


def Base64ToNdarry(img_base64):
    img_data = base64.b64decode(img_base64)
    img_np = np.fromstring(img_data, np.uint8)
    src = cv2.imdecode(img_np, cv2.IMREAD_ANYCOLOR)

    return src


def base64_to_img(img_binary, img_path):

    #バイナリデータ <- base64でエンコードされたデータ  
    img_ndry=np.frombuffer(img_binary,dtype=np.uint8) #バッファ―をnumpy配列に高速変換している

    #raw image <- img_ndry
    img = cv2.imdecode(img_ndry, cv2.IMREAD_COLOR)

    return img


    #画像を保存する場合
    #cv2.imwrite(img_path, img)

    #表示確認
    #cv2.imshow('window title', img)
    #cv2.waitKey(0)
    #cv2.destroyAllWindows()
