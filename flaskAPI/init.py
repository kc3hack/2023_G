import sqlalchemy
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, DATETIME
from datetime import datetime, timedelta, timezone

JST = timezone(timedelta(hours=+9), 'JST')
datetime.now(JST)

engine = sqlalchemy.create_engine('sqlite:///sqldata/user.sqlite3', echo=True)
Base = declarative_base()

class notion(Base):

    user_id = Column(Integer)
    notion = Column(String(length=255), nullable = False)
    description = Column(String(length=255))
    created = Column(DATETIME, default=datetime.now(JST))
    updateDate = Column(String(length=255))
    informed = Column(Integer, default=0)

    __tablename__ = 'notion'

# class user(Base):
# ログイン機能実装時に使うけど
#     user_id = Column(Integer, primary_key=True)
#     name = Column(String(length=255), nullable = False, unique=True)
#     hash = Column(String(length=255), nullable=False)

#     __tablename__ = 'users'

Base.metadata.create_all(bind=engine)