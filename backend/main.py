# from fastapi import FastAPI

# app = FastAPI()

# @app.get("/")
# def home():
#     return {"message": "FastAPI is working"}

# from fastapi import FastAPI
# from sqlalchemy import create_engine, text
# from sqlalchemy.orm import sessionmaker

# DATABASE_URL = "mysql+pymysql://root:@localhost/iot"

# engine = create_engine(DATABASE_URL)
# SessionLocal = sessionmaker(bind=engine)

# app = FastAPI()

# @app.get("/")
# def test_db():
#     try:
#         db = SessionLocal()
#         db.execute(text("SELECT 1"))  # ✅ FIX HERE
#         return {"message": "Database connected successfully"}
#     except Exception as e:
#         return {"error": str(e)}
#     finally:
#         db.close()

from fastapi import FastAPI, Depends
from sqlalchemy import create_engine, Column, Integer, String, Double, TIMESTAMP, text
from sqlalchemy.orm import sessionmaker, Session, declarative_base
from fastapi.middleware.cors import CORSMiddleware
# DATABASE
DATABASE_URL = "mysql+pymysql://root:@localhost/iot"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine)

Base = declarative_base()

# TABLE MODEL (must match your MySQL table)
class UserLocation(Base):
    __tablename__ = "users_location"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String(50))
    latitude = Column(Double)
    longitude = Column(Double)
    update_at = Column(TIMESTAMP)

# APP
app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
# DB SESSION
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# TEST ROUTE
@app.get("/")
def home():
    return {"message": "API is working"}

# UPDATE LOCATION API
@app.post("/update-location")
def update_location(
    user_id: str,
    latitude: float,
    longitude: float,
    db: Session = Depends(get_db)
):

    user = db.query(UserLocation).filter(UserLocation.user_id == user_id).first()

    if user:
        # UPDATE existing record
        user.latitude = latitude
        user.longitude = longitude
    else:
        # INSERT new record
        new_user = UserLocation(
            user_id=user_id,
            latitude=latitude,
            longitude=longitude
        )
        db.add(new_user)

    db.commit()

    return {
        "message": "Location updated successfully",
        "user_id": user_id,
        "latitude": latitude,
        "longitude": longitude
    }

@app.get("/get-location/{user_id}")
def get_location(user_id: str, db: Session = Depends(get_db)):
    user = db.query(UserLocation).filter(UserLocation.user_id == user_id).first()

    if not user:
        return {"error": "User not found"}

    return {
        "user_id": user.user_id,
        "latitude": user.latitude,
        "longitude": user.longitude
    }