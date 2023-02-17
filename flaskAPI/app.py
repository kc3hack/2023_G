from flask import Flask
from flask_restful import Api
from flask_session import Session
from sqldata.manegeNotice import Notion, EditNotion, ReceiveBase64
from setAPI import *

app = Flask(__name__)
api = Api(app)

# アプリ設定
# Ensure templates are auto-reloaded
app.config["TEMPLATES_AUTO_RELOAD"] = True

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

api.add_resource(HelloWorld, '/')#接続テスト用のやつ
api.add_resource(Notion, '/notion')#通知を表示・追加
api.add_resource(EditNotion, '/notion/<int:id>')#通知データをIDを指定して削除
api.add_resource(ReceiveBase64, 'notion/ocr')#OCR用画像データ受け取り

# エラーハンドラー
@app.errorhandler(404)
@app.errorhandler(403)
@app.errorhandler(400) #invalid テストよになるかm
def page_not_found(error):
    return  error.code

if __name__ == '__main__':
    app.run(debug = True)