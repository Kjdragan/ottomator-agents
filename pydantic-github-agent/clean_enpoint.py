from fastapi import FastAPI
from pydantic import BaseModel
from supabase import create_client
import uuid

app = FastAPI()

# Supabase client
supabase = create_client(
    "https://qaumfhxjaqudeabrgibs.supabase.co",
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFhdW1maHhqYXF1ZGVhYnJnaWJzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc2NzQxNTAsImV4cCI6MjA1MzI1MDE1MH0.pF1_3GeL1S5QEQ56BNJV6lPjfMOgPDdH2SODTQ4xV7I"
)

class AgentRequest(BaseModel):
    query: str
    user_id: str
    request_id: str
    session_id: str

@app.post("/api/pydantic-github-agent")
async def process_request(request: AgentRequest):
    try:
        # Insert user message
        supabase.table('messages').insert({
            "session_id": request.session_id,
            "message": {
                "content": request.query,
                "type": "human"
            }
        }).execute()
        
        # Insert AI response
        supabase.table('messages').insert({
            "session_id": request.session_id,
            "message": {
                "content": f"Hello! You said: {request.query}",
                "type": "ai"
            }
        }).execute()
        
        return {"success": True}
    except Exception as e:
        return {"success": False, "error": str(e)}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8003)
