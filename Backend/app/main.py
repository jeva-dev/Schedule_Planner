from fastapi import FastAPI
import psycopg2
from psycopg2.extras import RealDictCursor
import time
from . import models, database
from .router import posts
from fastapi.middleware.cors import CORSMiddleware

models.Base.metadata.create_all(bind = database.engine)


app = FastAPI()


# CORS middleware config
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # allows these origins
    allow_credentials=True,
    allow_methods=["*"],    # allows all methods (GET, POST, etc.)
    allow_headers=["*"],    # allows all headers
)

MAX_RETRIES = 5
RETRY_DELAY = 3

for attempt in range(1, MAX_RETRIES + 1):
    try:
        conn = psycopg2.connect(
            host = '*',
            database = '*',
            user = '*',
            password = '*!',
            cursor_factory = RealDictCursor
        )
        cursor = conn.cursor()
        print("Database connected.")
        break
    except Exception as error:
        print(f"Attempt {attempt} failed: {error}")
        if attempt == MAX_RETRIES:
            print("Could not able to connect to database after multiple attempts. Exiting")
            raise
        print(f"Retrying in {RETRY_DELAY} seconds...")
        time.sleep(RETRY_DELAY)

app.include_router(posts.router)