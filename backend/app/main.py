from fastapi import FastAPI
from pydantic import BaseModel, Field
from typing import Optional
from .services.matching import calculate_match
from .services.chat import chat_with_ai
from .services.job_parser import parse_job_posting

app = FastAPI(title="GONGFIT API", version="0.1.0")

class Profile(BaseModel):
    education: Optional[str] = None
    major: Optional[str] = None
    certifications: list[str] = Field(default_factory=list)
    experience: list[str] = Field(default_factory=list)
    skills: list[str] = Field(default_factory=list)
    target_job: Optional[str] = None
    target_region: Optional[str] = None

class JobPosting(BaseModel):
    title: str
    organization: Optional[str] = None
    location: Optional[str] = None
    required: list[str] = Field(default_factory=list)
    preferred: list[str] = Field(default_factory=list)
    description: str = ""

class MatchRequest(BaseModel):
    profile: Profile
    job: JobPosting

class ParseJobRequest(BaseModel):
    text: str = Field(min_length=1, max_length=20000)

class ChatRequest(BaseModel):
    message: str = Field(min_length=1, max_length=4000)
    profile: Optional[Profile] = None
    job: Optional[JobPosting] = None
    analysis: Optional[dict] = None

@app.get("/health")
def health() -> dict:
    return {"status": "ok", "service": "gongfit"}

@app.post("/api/v1/jobs/parse")
def parse_job(request: ParseJobRequest) -> dict:
    return parse_job_posting(request.text)

@app.post("/api/v1/match")
def match(request: MatchRequest) -> dict:
    return calculate_match(request.profile.model_dump(), request.job.model_dump())

@app.post("/api/v1/chat")
async def chat(request: ChatRequest) -> dict:
    return await chat_with_ai(
        message=request.message,
        profile=request.profile.model_dump() if request.profile else None,
        job=request.job.model_dump() if request.job else None,
        analysis=request.analysis,
    )
