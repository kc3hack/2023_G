import base64
from distutils.log import debug
from torch import import_ir_module
#from sqldata.init import notion
#from sqldata.checkModel import ModelOperate
from init import notion
from checkModel import ModelOperate

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, scoped_session
from datetime import datetime, timedelta, timezone
from flask_restful import Resource
from flask import json, request

#追加
from img_base64 import base64_to_img, Base64ToNdarry
from ocr_test_data import ocr_process


JST = timezone(timedelta(hours=+9), 'JST')
datetime.now(JST)
engine = create_engine("sqlite:///sqldata/user.sqlite3", echo=True)

Session = scoped_session(
    sessionmaker(
        autocommit=False,
        autoflush=False,
        bind=engine
    )
)
session = Session()

class Notion(Resource):
# 通知を表示する
    def get(self):
        # 期限切れは削除（一応）
        taskDel = session.query(notion).filter(notion.effectiveDate<datetime.now(JST))
        if taskDel:
            taskDel.delete()
            session.commit()
        # 一覧を持ってくる
        list = session.query(notion).order_by(notion.effectiveDate).all()
        response = []
        for task in list:
            hash = {
                "content":task.notion,
                "description":task.description,
                "createDateTime":task.created.strftime('%Y-%m-%d %H:%M:%S'),
                "limitDateTime":task.effectiveDate.strftime('%Y-%m-%d %H:%M:%S'),
                "channelId":task.id
            }
            response.append(hash)
        # response = json.dump(response)
        return response
# 通知を追加する
    def post(self):
        # なんらでデータ受け取ります
        input = request.json
        
        # データ検査する
        if not ModelOperate.inputCheck(input):
            return {'message':'invalid status'}
        
        # データ入れる
        data = notion()
        data.notion = input['content']
        data.description= input['description']
        now = datetime.now(JST)
        try:
            data.effectiveDate = datetime.strptime(input['limitDateTime'], '%Y-%m-%d %H:%M:%S')
        except ValueError:
            return {'message':'invalid date or time'}
        session.add(instance=data)
        session.commit()
        return { 'message': 'Complete Data settimg',
            'id':data.id}

class EditNotion(Resource):
# 通知を削除する
    def delete(self, id):
        taskDel = session.query(notion).filter_by(id=id)
        if len(taskDel.all()) == 0:
            return {'message':'none data'}
        else:
            taskDel.delete()
            session.commit()
            return {'message':'complete delete'}
    

class ReceiveBase64(Resource):
# OCR用の画像データ取得をする
    def post(self):
        input = request.json

        base64data = input['base64Image']#ここにbase64のデータが入ってます．
        
        """
        #以下、テスト用
        img_path = "memo_kurozi.png"
        with open(img_path, 'rb') as f:
            imgdata = f.read()

        #Base64で画像をエンコード
        base64data=base64.b64encode(imgdata)
        """

        #画像をnp配列に変換する。
        img = Base64ToNdarry(base64data)

        #OCRのPATHを指定してから、光学文字認識をする。
        OCR_path=r'C:\Program Files\Tesseract-OCR\tesseract.exe'
        yotei_list = ocr_process(OCR_path, img)
        
        
        #print(yotei_list) 確認用

        """
        ここにOCRの操作が来る
        読み取ったデータは以下の形になる
        """

        #要素数が1のとき、1つのデータしか入っていないためそのまま追加
        if len(yotei_list[0]) == 1:
            response = {
                'contet':yotei_list[0],
                'limitDateTime':yotei_list[1].strftime('%Y-%m-%d %H:%M:%S')

                #'contet':'通知タイトル',
                #'limitDateTime':DATETIME.strftime('%Y-%m-%d %H:%M:%S')
                #'test':'aaaaaaaaaaa'
            }

        #2のとき、複数のデータが入力されているため、1つ目のデータのみ入力
        elif len(yotei_list[0]) == 2:
            response = {
                'contet':yotei_list[0][0],
                'limitDateTime':yotei_list[0][1]

                #'contet':'通知タイトル',
                #'limitDateTime':DATETIME.strftime('%Y-%m-%d %H:%M:%S')
                #'test':'aaaaaaaaaaa'
            }

    
        return response