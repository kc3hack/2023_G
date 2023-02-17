from sqldata.init import notion
from sqldata.checkModel import ModelOperate
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, scoped_session
from datetime import datetime, timedelta, timezone
from flask_restful import Resource
from flask import json, request

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
        # data.description= input['description']
        now = datetime.now(JST)
        try:
            data.effectiveDate = datetime.strptime(input['setDateTime'], '%Y-%m-%d %H:%M:%S')
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
        # どんな感じで来るかわからんからとりあえずJson形式で受け取る？
        base64data = request.json

        response ={}#仮置き
        """ここにOCRの操作が来る
        読み取ったデータは以下の形になる
        response = {
            'contet':'',
            'limitDateTime':DATETIME.strftime('%Y-%m-%d %H:%M:%S')
        }
        """

        return response


