from flask import Flask
from flask_restful import Api
from flask_session import Session
from sqldata.manegeNotice import Notion
from setAPI import *

app = Flask(__name__)
api = Api(app)

# Ensure templates are auto-reloaded
app.config["TEMPLATES_AUTO_RELOAD"] = True

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

api.add_resource(HelloWorld, '/')#接続テスト用のやつ
# api.add_resource(userSession, '/user')
api.add_resource(Notion, '/notion')


@app.errorhandler(404)
@app.errorhandler(403)
@app.errorhandler(400) #invalid テストよになるかm
def page_not_found(error):
    return  error.code

if __name__ == '__main__':
    app.run(debug = True)