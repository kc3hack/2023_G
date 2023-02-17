########################################################################
#画像処理が必要になるOCRで現実世界の文字を読取る場合はこのファイルから行う#
########################################################################

#データベース追加機能未実装

import os
from PIL import Image
import pyocr
import cv2
import numpy as np


#環境変数「PATH」にTesseract-OCRのパスを設定。
#Windowsの環境変数に設定している場合は不要。
#path='C:\\Program Files\\Tesseract-OCR\\'
#os.environ['PATH'] = os.environ['PATH'] + path

def cv2pil(image):
    ''' OpenCV型 -> PIL型 '''
    new_image = image.copy()
    if new_image.ndim == 2:  # モノクロ
        pass
    elif new_image.shape[2] == 3:  # カラー
        new_image = cv2.cvtColor(new_image, cv2.COLOR_BGR2RGB)
    elif new_image.shape[2] == 4:  # 透過
        new_image = cv2.cvtColor(new_image, cv2.COLOR_BGRA2RGBA)
    new_image = Image.fromarray(new_image)
    return new_image

def scale_to_width(img, width):
    """幅が指定した値になるように、アスペクト比を固定して、リサイズする。
    """
    h, w = img.shape[:2]
    height = round(h * (width / w))
    dst = cv2.resize(img, dsize=(width, height))

    return dst

#pyocrにTesseractを指定する。
pyocr.tesseract.TESSERACT_CMD = r'C:\Program Files\Tesseract-OCR\tesseract.exe'
tools = pyocr.get_available_tools()
tool = tools[0]

#文字を抽出したい画像のパスを選ぶ
#img = cv2.imread("yotei.jpg")
#img = cv2.imread("yotei_1row.jpg")
#img = cv2.imread("yotei_high.png")
#img = cv2.imread("yotei_print.JPG")
img = cv2.imread("syouhikigen.png")

#print(type(img[0][0][0])) 画素の型は、uint8(符号なし8bit整数型)


dst_img = scale_to_width(img, 600)

cv2.imshow("img", dst_img)
cv2.waitKey()
cv2.destroyAllWindows()



#「凹凸係数」を利用して影を除去する
# Qiita, pythonで画像の陰の除去, https://qiita.com/fallaf/items/1c5387a79027b2ec64b0
#2023年2月17日.

ksize = 51
blur = cv2.blur(img, (ksize, ksize))
rij = img/blur
index_1 = np.where(rij >= 0.98)
index_0 = np.where(rij < 0.98)
rij[index_0] = 0
rij[index_1] = 1

rij_img = rij*255
#cv2.imwrite("rij_image.png", rij*255) # rijの値は0～1になるはずなので255倍

#画素の値の型を float --> np.uint8 にする
rij_img_int = rij_img.astype(np.uint8)
#print(rij_img_int)



#中央値フィルタでゴマ塩ノイズを除去
ksize=9
#中央値フィルタ
img_mask = cv2.medianBlur(rij_img_int, ksize)
dst_img_mask = scale_to_width(img_mask, 600)

# フィルタ後の画像の表示
#cv2.imshow("gomashio", dst_img_mask)
#cv2.waitKey()
#cv2.destroyAllWindows()


# 閾値の設定
threshold = 150

# 二値化(閾値100を超えた画素を255にする。)
ret, img_thresh = cv2.threshold(img_mask, threshold, 255, cv2.THRESH_BINARY)
dst_img_thresh = scale_to_width(img_thresh, 600)

# 二値化画像の表示
#cv2.imshow("binary", dst_img_thresh)
#cv2.waitKey()
#cv2.destroyAllWindows()


# ---グレースケール---

img_gray = cv2.cvtColor(img_thresh, cv2.COLOR_BGR2GRAY)
dst_img_gray = scale_to_width(img_gray, 600)

# 二値化画像の表示
cv2.imshow("gray_scale", dst_img_gray)
cv2.waitKey()
cv2.destroyAllWindows()

#cv2.imwrite("gray_image_row.png", img_gray)



#print(img_thresh)




#1文字ずつ認識
#プログラミングのメモ帳,【Python応用】OpenCVを用いた文字認識を行ってみた
#https://www.hobby-happymylife.com/%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0/python_opencv_ocr/
#2023年2月17日.

"""
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
blur = cv2.GaussianBlur(gray, (5, 5), 0)
thresh = cv2.adaptiveThreshold(blur, 255, 1, 1, 11, 2)
#3---輪郭抽出
#contours = cv2.findContours(thresh, cv2.RETR_LIST, cv2.CHAIN_APPROX_SIMPLE)[0]
contours = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[0]
#4---抽出した数分処理
for moji in contours:
    x, y, w, h = cv2.boundingRect(moji)
    if h < 20: continue
    red = (0, 0, 255)
    cv2.rectangle(img, (x, y), (x+w, y+h), red, 2)
#5---保存
cv2.imwrite('re-moji.png', img)
"""


#img = Image.open('Konofan.png')

PIL_img = cv2pil(img)

#画像の文字を抽出
builder = pyocr.builders.TextBuilder(tesseract_layout=6)
text = tool.image_to_string(PIL_img, lang="jpn", builder=builder)


print(text)