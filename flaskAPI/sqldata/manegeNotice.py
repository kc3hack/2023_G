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
                "setDateTime":task.effectiveDate.strftime('%Y-%m-%d %H:%M:%S'),
                "remindList":[],
                "channelId":task.id
            }
            response.append(hash)
        # response = json.dump(response, default=json_serial)
        return response

    def post(self):
        # なんらでデータ受け取ります
        input = request.json
        
        # データ検査する
        if not ModelOperate.inputCheck(input):
            return {'message':'invalid status'}
        
        # データ入れる
        data = notion()
        data.notion = input['content']
        # data.description= input['']
        now = datetime.now(JST)
        try:
            data.effectiveDate = datetime.strptime(input['setDateTime'], '%Y-%m-%d %H:%M:%S')
        except ValueError:
            return {'message':'invalid date or time'}
        session.add(instance=data)
        session.commit()
        return { 'message': 'Complete Data settimg' }

class EditNotion(Resource):

    def delete(self, id):
        taskDel = session.query(notion).filter_by(id=id)
        if len(taskDel.all()) == 0:
            return {'message':'none data'}
        else:
            taskDel.delete()
            session.commit()
            return {'message':'complete delete'}
    
