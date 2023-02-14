from flask import jsonify

class ModelOperate():
    def inputCheck(input):
        # ここではフロントから帰ってくるデータは一次元hashmapだとして考えている．
        if not input['content'] or not input['setDateTime']:
            return False
        

        return input


    def codeJson():

        return jsonfile

    def updateTime(task_id):
        if task_id is None:
            return 'a'
