from init import notion
from sqldata.checkModel import ModelOperate
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, scoped_session
from datetime import datetime, timedelta, timezone
from flask_restful import Resource
from flask import jsonify, request

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

test = notion()
# test.user_id = 1
test.notion = 'apple'
test.description= 'tabetainaaa'
now = datetime.now(JST)
test.updateDate = now + timedelta(minutes=30)
session.add(instance=test)
session.commit()

data = notion()

class Notion(Resource):
    session.begin()

    def get(self):
        test = {
            "test":"testing data",
            "code":123
        }
        return test

    def post(self):
        # なんらでデータ受け取ります
        input = request.json
        
        # データ検査する
        if not ModelOperate.inputCheck(input):
            return 'invalid status', 400
        
        # データ入れる
        data.notion = input['content']
        # data.description= input['']
        data.updateDate = datetime(2002, 12, 4, 20, 30, 40)
        session.add(instance=test)
        session.commit()
        session.close()
        return { 'message': 'Complete Data settimg' }

    def delete(self):

        return 'complete delete'


    session.close()
