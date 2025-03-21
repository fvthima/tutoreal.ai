# config.py
from urllib.parse import quote_plus

DB_USERNAME = ''
DB_PASSWORD = ''
DB_HOST = ''
DB_NAME = ''  # must match the database name

SQLALCHEMY_DATABASE_URI = (
    f"mysql+mysqlconnector://{DB_USERNAME}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}?charset=utf8"
)
