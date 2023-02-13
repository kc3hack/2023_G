from flask import Flask
from flask_restful import Api
from flask_session import Session
from manegeNotice import Notion
from setAPI import *

app = Flask(__name__)
api = Api(app)

# Ensure templates are auto-reloaded
app.config["TEMPLATES_AUTO_RELOAD"] = True

# Custom filter
# app.jinja_env.filters["usd"] = usd

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

api.add_resource(HelloWorld, '/')
api.add_resource(VariableRouting, '/var/<string:id>')
api.add_resource(userSession, '/user')
api.add_resource(Notion, '/set')


@app.errorhandler(404)
@app.errorhandler(403)
@app.errorhandler(400) #invalid テストよになるかm
def page_not_found(error):
    return  error

if __name__ == '__main__':
    app.run(debug = True)