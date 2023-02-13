from flask import Flask
from flask_restful import Resource


class HelloWorld(Resource):
    def get(self):
        return { 'message': 'Hello World' }

class VariableRouting(Resource):
    def get(self, id):
        return { 'id': id }

class userSession(Resource):
    def get(self, id):
        return { 'id': id }

# class VariableRouting(Resource):
#     def get(self, id):
#         return { 'id': id }

