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

# 試験的にデータを追加します

# test = notion()
# # test.user_id = 1
# test.notion = 'apple'
# test.description= 'tabetainaaa'
# now = datetime.now(JST)
# test.updateDate = now + timedelta(minutes=30)
# session.add(instance=test)
# session.commit()
def json_serial(obj):

    if isinstance(obj, (datetime)):
        return obj.isoformat()
    raise TypeError (f'Type {obj} not serializable')

data = notion()

class Notion(Resource):
    session.begin()

    def get(self):
        list = session.query(notion).order_by(notion.updateDate).all()
        response = []
        for task in list:
            task.iosformat()
            hash = {
                "content":task.notion,
                "setDateTime":"jikann",
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
        data.notion = input['content']
        # data.description= input['']
        now = datetime.now(JST)
        data.updateDate = now + timedelta(minutes=30)
        session.add(instance=data)
        session.commit()
        return { 'message': 'Complete Data settimg' }

    def delete(self):
        raise 'delete is here'
        input = request.json
        if input["id"].isdigit():
            taskDel = session.query(notion).filter_by(id=int(input['id']))
            if not len(taskDel) == 0:
                session.delete(taskDel[0])
                return {'message':'complete delete'}
        return {'message':'cannot be deleted'}

    session.close()
