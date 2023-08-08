from datetime import datetime
from enum import Enum
from typing import Optional
from beanie import Document, PydanticObjectId
from pydantic import BaseModel, BaseSettings

class Settings(BaseSettings):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    MONGODB_CONNECTION_STRING: str = ""
    MONGODB_DATABASE_NAME: str = "Todo"

class TodoList(Document):
    name: str
    description: Optional[str] = None
    createdDate: Optional[datetime] = None
    updatedDate: Optional[datetime] = None


class CreateUpdateTodoList(BaseModel):
    name: str
    description: Optional[str] = None


class TodoState(Enum):
    TODO = "todo"
    INPROGRESS = "inprogress"
    DONE = "done"


class TodoItem(Document):
    listId: PydanticObjectId
    name: str
    description: Optional[str] = None
    state: Optional[TodoState] = None
    dueDate: Optional[datetime] = None
    completedDate: Optional[datetime] = None
    createdDate: Optional[datetime] = None
    updatedDate: Optional[datetime] = None


class CreateUpdateTodoItem(BaseModel):
    name: str
    description: Optional[str] = None
    state: Optional[TodoState] = None
    dueDate: Optional[datetime] = None
    completedDate: Optional[datetime] = None


__beanie_models__ = [TodoList, TodoItem]
