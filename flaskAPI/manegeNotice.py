from init import notion
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from datetime import datetime
from flask_restful import Resource

engine = create_engine("sqlite:///sqldata/user.sqlite3", echo=True)

Session = sessionmaker(bind=engine)
session = Session()

# 試験的にデータを追加します

test = notion()
test.user_id = 1
test.notion = 'apple'
test.description= 'tabetainaaa'
test.updateDate = datetime(2002, 12, 4, 20, 30, 40)
session.add(instance=test)
session.commit()

class notion(Resource):
    def get(self):
        return { 'message': 'Hello World' }
