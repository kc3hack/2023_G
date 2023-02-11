from flask import Flask
from flask_restful import Api
from flask_session import Session
from flaskAPI.setAPI import *

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

if __name__ == '__main__':
    app.run(debug = True)