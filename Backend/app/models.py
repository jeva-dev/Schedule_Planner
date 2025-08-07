from sqlalchemy import TIMESTAMP, Column, ForeignKey, String, Integer, text
from .database import Base

class Post(Base):
    __tablename__ = 'posts'

    id = Column(Integer, primary_key=True, index=True)
    #user_id = Column(Integer,ForeignKey("users.id"), nullable=False)  # Should be a ForeignKey ideally
    title = Column(String, nullable=False)
    content = Column(String, nullable=False)
    created_at = Column(TIMESTAMP(timezone=True), nullable=False, server_default=text("now()"))

