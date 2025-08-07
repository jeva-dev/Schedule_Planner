from pydantic import BaseModel
from datetime import datetime

class PostBase(BaseModel):
#    user_id : int
    title: str
    content : str

class PostCreate(PostBase):
    pass

# Response Models

class Post(BaseModel):
#    user_id : int
    id : int
    title : str
    content : str
    created_at : datetime

    model_config = {
        "from_attributes" : True
    }