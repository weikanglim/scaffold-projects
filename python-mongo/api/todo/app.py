import motor
import certifi
from beanie import init_beanie
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .models import Settings, __beanie_models__

settings = Settings()
app = FastAPI(
    description="Simple Todo API",
    version="2.0.0",
    title="Simple Todo API",
    docs_url="/",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

from . import routes  # NOQA

@app.on_event("startup")
async def startup_event():
    client = motor.motor_asyncio.AsyncIOMotorClient(
        settings.MONGODB_CONNECTION_STRING,
        tlsCAFile=certifi.where(),
    )
    await init_beanie(
        database=client[settings.MONGODB_DATABASE_NAME],
        document_models=__beanie_models__,
    )
