#####################################################################################
#スクリーンショットからの文字列をOCRで複数行のデータを登録する場合はこのファイルから行う#
#####################################################################################

#データベース追加機能実装済

from PIL import Image
import pyocr
import cv2
import datetime
from sqlalchemy import create_engine
from sqldata.init import notion
from sqlalchemy.orm import sessionmaker, scoped_session

#環境変数「PATH」にTesseract-OCRのパスを設定。
#Windowsの環境変数に設定している場合は不要。
#path='C:\\Program Files\\Tesseract-OCR\\'
#os.environ['PATH'] = os.environ['PATH'] + path

#pyocrにTesseractを指定する。
pyocr.tesseract.TESSERACT_CMD = r'C:\Program Files\Tesseract-OCR\tesseract.exe'
tools = pyocr.get_available_tools()
tool = tools[0]

#文字を抽出したい画像のパスを選ぶ
img = Image.open('memo_kurozi.png')


#画像の文字を抽出
builder = pyocr.builders.TextBuilder(tesseract_layout=6)
text = tool.image_to_string(img, lang="jpn", builder=builder)

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


###データベース###

#エンジン データベースに接続するために必要なオブジェクト
engine = create_engine("sqlite:///sqldata/user.sqlite3", echo=True)

#セッション
Session = scoped_session(
    sessionmaker(
        autocommit=False,
        autoflush=False,
        bind=engine
    )
)
session = Session()



#データの高速追加方法
#ミナピピンの研究室, 【Python】SqlalchemyでのINSERT処理を高速化する方法まとめ
#https://tkstock.site/2022/12/25/python-sqlalchemy-db-insert-speedup/, 2023年2月18日.

#データベースに中身を追加する。
for i in range(len(yotei_list)):
    data = notion()
    data.effectiveDate = yotei_list[i][0]
    data.notion = yotei_list[i][1]
    
    session.add(data)
    session.commit()



#中身の表示方法
#しげっちBlog, 【Python】SQLAlchemy データを取得する方法
#https://shigeblog221.com/python-sqlalchemy1/ 2023年2月18日.

#データベースの中身を表示する。
for r in session.query(notion).order_by(notion.id):
    print(r.id, r.effectiveDate, r.notion)


#対象レコードをすべてリストで取得
list_a = session.query(notion).order_by(notion.id).all()
for r in list_a:
    print(r.id, r.effectiveDate, r.notion)


