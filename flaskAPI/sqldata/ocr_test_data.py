#####################################################################################
#スクリーンショットからの文字列をOCRで複数行のデータを登録する場合はこのファイルから行う#
#####################################################################################

#データベース追加機能実装済

from PIL import Image
import pyocr
import cv2
import datetime

#環境変数「PATH」にTesseract-OCRのパスを設定。
#Windowsの環境変数に設定している場合は不要。
#path='C:\\Program Files\\Tesseract-OCR\\'
#os.environ['PATH'] = os.environ['PATH'] + path

#pyocrにTesseractを指定する。

#OCR_path=r'C:\Program Files\Tesseract-OCR\tesseract.exe'


#Qiita, 【Python】Pillow ↔ OpenCV 変換
#https://qiita.com/derodero24/items/f22c22b22451609908ee, 2023年2月18日.
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


def ocr_process(OCR_path, image_data):

    pyocr.tesseract.TESSERACT_CMD = OCR_path
    tools = pyocr.get_available_tools()
    tool = tools[0]

    #文字を抽出したい画像のパスを選ぶ
    #img = Image.open('memo_kurozi.png')

    new_image = cv2pil(image_data)

    #画像の文字を抽出
    builder = pyocr.builders.TextBuilder(tesseract_layout=6)
    text = tool.image_to_string(new_image, lang="jpn", builder=builder)

    text_rows = text.split('\n') #改行文字で切断する。

    yotei_list = []

    #年日付だけ前の影響を受ける。
    year = 0
    month = 0
    day = 0

    for i in range(len(text_rows)):

        #時間は初期状態では全て0
        time = 0
        min = 0
        sec = 0

        content = ''
        baf = ''

        for j in range(len(text_rows[i])):

            #数値でありその文字を含める場合
            if text_rows[i][j] == '年' and str.isdigit(baf):
                year = int(baf)
                baf = ''
            elif text_rows[i][j] == '月' and str.isdigit(baf):
                month = int(baf)
                baf = ''
            elif text_rows[i][j] == '日' and str.isdigit(baf):
                day = int(baf)
                baf = ''

            elif text_rows[i][j] == '時' and str.isdigit(baf):
                time = int(baf)
                baf = ''
            elif text_rows[i][j] == '分' and str.isdigit(baf):
                min = int(baf)
                baf = ''
            elif text_rows[i][j] == '秒' and str.isdigit(baf):
                min = int(baf)
                baf = ''
            
            else: 
                baf += text_rows[i][j]

            content = baf

        #リストの中のリスト
        l = []
        l.append(datetime.datetime(year, month, day, hour=time, minute=min, second=sec))
        l.append(content)

        yotei_list.append(l)

        #print(yotei_list)


    return yotei_list