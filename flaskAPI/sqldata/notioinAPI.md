# Notion API
kc3hack2023においてチームGの作成物であり，**本イベント用の使用に限って**開発している．

### ざっくりと説明
`flask_restful`を使用したAPIである．
これはHTTPリクエストに従ってAPIをし，主に次の三つが定義されている 参照`manegeNotice.py`
* `Notion`クラス<br>
    * post :通知を設定する．通知内容・期限日時が指定されていない時，書式に沿ったデータが入らない時エラーメッセージを返す．<br>
    * get :通知の一覧をJsonで返している．期限の日時をすぎているものはDBから削除される．<br>
    
| POST | GET | 
| --- | --- |
| 通知の設定 | 通知一覧の取得 |

ホスト/パスー> <p>"http://localhost/5000/notion"</p>

* `EditNotion`クラス<br>
     * delete :通知の削除を行う．パスから通知のidを指定して特定の通知を消去する．<br>
     
| DELETE |
| --- |
| 通知の削除 |

ホスト/パスー> <p>"http://localhost/5000/notion/{id}"</p>

* `ReceiveBase64`クラス<br>
     * post :OCRに使う画像データの受け取りをします．responseは通知内容と読み取った日時をJson形式で返す．詳しくは<a href=https://hackmd.io/2KeBMmdaR-iXKwfRKKuCbQ>本持さんのまとめたやつ</a><br>
     
| POST |
| --- |
| OCR読み取り |

ホスト/パスー> <p>"http://localhost/5000/notion/ocr"</p>


### テーブル設計について
今回は一個だけのテーブルnotionを実装している（init.py）
`notion`

| カラム名 | 制約・備考 | 型 |
| - | - | - |
| id | primary key | integer |
| notion | 通知タイトル | string |
| description | 通知詳細 | string |
| created | 通知の作成日時（default UTC+9:00） | datetime |
| effectiveDate | 通知の期限日時 （default UTC+9:00） | datetime |
| informed | （今は使われていない） | integer |    