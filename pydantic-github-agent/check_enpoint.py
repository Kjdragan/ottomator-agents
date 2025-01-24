from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class AgentRequest(BaseModel):
    query: str
    user_id: str
    request_id: str
    session_id: str

@app.post("/api/pydantic-github-agent")
async def process_request(request: AgentRequest):
    # Your agent logic here
    return {"success": True}
