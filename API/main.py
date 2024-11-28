from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from sqlalchemy import text

app = FastAPI()

@app.get("/")
def root():
    return {"message": "Welcome to the FastAPI MySQL Integration!"}


@app.get("/test-db")
def test_database(db: Session = Depends(get_db)):
    try:
        # Use text() for raw SQL
        result = db.execute(text("SELECT 1;")).fetchone()
        return {"result": result[0]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database connection failed: {str(e)}")


@app.get("/call-procedure/")
def call_procedure(player_answer: str, db: Session = Depends(get_db)):
    try:
        # Call the stored procedure with text()
        db.execute(
            text("""
                CALL GetHouseScores(:player_answer, @winning_house, @gryffindor_score, @slytherin_score, @ravenclaw_score, @hufflepuff_score);
            """),
            {"player_answer": player_answer},
        )

        # Fetch output parameters with text()
        results = db.execute(
            text("""
                SELECT @winning_house, @gryffindor_score, @slytherin_score, @ravenclaw_score, @hufflepuff_score;
            """)
        ).fetchone()

        return {
            "winning_house": results[0],
            "gryffindor_score": results[1],
            "slytherin_score": results[2],
            "ravenclaw_score": results[3],
            "hufflepuff_score": results[4],
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Procedure execution failed: {str(e)}")

