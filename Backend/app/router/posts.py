from fastapi import APIRouter, Depends, Response, status, HTTPException
from typing import List
from sqlalchemy.orm import Session
from .. import schemas,models, database


router = APIRouter(
    prefix= "/posts",
    tags= ["Posts"]
)

# Get All Posts
@router.get('', response_model= List[schemas.Post])
def get_posts(db: Session = Depends(database.get_db)):
    posts = db.query(models.Post).all()
    return posts

# Get Specific Post
@router.get('/{id}', response_model= schemas.Post)
def get_one_post(id: int, db: Session = Depends(database.get_db)):
    one_post = db.query(models.Post).filter(models.Post.id == id).first()

    # Logic for not finding the post
    if not one_post:
        raise HTTPException(status_code= status.HTTP_404_NOT_FOUND, detail= f"Post with {id} not found.")
    return one_post


# Post the Post
@router.post('', status_code= status.HTTP_201_CREATED, response_model= schemas.Post)
def createPost(post: schemas.PostCreate, db: Session = Depends(database.get_db)):
    new_post = models.Post(**dict(post))
    db.add(new_post)
    db.commit()
    db.refresh(new_post)
    return new_post

# Update Specific Post
@router.put('/{id}', response_model= schemas.Post)
def update_post(id :int, update_post : schemas.PostCreate, db : Session = Depends(database.get_db)):
    post_query = db.query(models.Post).filter(models.Post.id == id)
    post  = post_query.first()
    if post == None:
        raise HTTPException(status_code= status.HTTP_404_NOT_FOUND, detail= f"Post with {id} not found.")
    
    post_query.update(dict(update_post), synchronize_session= False)
    db.commit()
    return post_query.first()

# Delete a post
@router.delete('/{id}', status_code= status.HTTP_204_NO_CONTENT, response_model= None)
def delete_post(id : int, db : Session = Depends(database.get_db)):

    del_post = db.query(models.Post).filter(models.Post.id == id)

    if del_post.first() == None:
        raise HTTPException(status_code= status.HTTP_404_NOT_FOUND, detail= f"Post with {id} not found")
    
    del_post.delete(synchronize_session= False)
    db.commit()
    return Response(status_code= status.HTTP_204_NO_CONTENT)