## Notion API
kc3hack2023においてチームGの作成物であり，**本イベント用の使用に限って**開発している．

### ざっくりと説明
`flask_restful`を使用したAPIである．
これはHTTPリクエストに従ってAPIをし，主に次の三つが定義されている（"http://localhost/5000/notion"）．参照`manegeNotice.py`
| POST | GET | DELETE | 
| --- | --- | --- | 
| 通知の設定 | 通知一覧の取得 | 指定した通知の消去 | 
