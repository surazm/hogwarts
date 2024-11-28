from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base

SQLALCHEMY_DATABASE_URL="mysql+pymysql://admin:admin@127.0.0.1:3306/hogwarts"

engine=create_engine(
    SQLALCHEMY_DATABASE_URL
)

SessionLocal=sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base=declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()