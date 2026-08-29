from __future__ import annotations

import os
from typing import Any

import httpx


SYSTEM_PROMPT = """당신은 공핏(GONGFIT)의 공공기관 취업 전문 AI 상담사입니다.
사용자의 프로필, 현재 채용공고, 공핏 분석 결과를 근거로 현실적이고 구체적으로 답합니다.
확인되지 않은 채용조건이나 합격 가능성을 사실처럼 단정하지 않습니다.
답변은 한국어로, 실행할 다음 행동을 포함해 간결하게 제공합니다.
"""


def _build_context(profile: dict | None, job: dict | None, analysis: dict | None) -> str:
    chunks: list[str] = []
    if profile:
        chunks.append(f"[사용자 프로필]\n{profile}")
    if job:
        chunks.append(f"[채용공고]\n{job}")
    if analysis:
        chunks.append(f"[공핏 분석 결과]\n{analysis}")
    return "\n\n".join(chunks)


async def chat_with_ai(
    message: str,
    profile: dict | None = None,
    job: dict | None = None,
    analysis: dict | None = None,
) -> dict[str, Any]:
    base_url = os.getenv("AI_BASE_URL", "").strip()
    api_key = os.getenv("AI_API_KEY", "").strip()
    model = os.getenv("AI_MODEL", "").strip()

    # No external provider configured: keep the API usable and honest in local development.
    if not (base_url and api_key and model):
        return {
            "provider": "fallback",
            "answer": "현재 AI 모델이 연결되지 않았습니다. 서버의 AI_BASE_URL, AI_API_KEY, AI_MODEL을 설정하면 공핏 AI 상담을 사용할 수 있습니다.",
            "configured": False,
        }

    context = _build_context(profile, job, analysis)
    payload = {
        "model": model,
        "messages": [
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "system", "content": context or "현재 제공된 프로필/공고 정보가 없습니다."},
            {"role": "user", "content": message},
        ],
        "temperature": 0.3,
    }

    headers = {"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"}
    async with httpx.AsyncClient(timeout=30) as client:
        response = await client.post(f"{base_url.rstrip('/')}/chat/completions", json=payload, headers=headers)
        response.raise_for_status()
        data = response.json()

    answer = data.get("choices", [{}])[0].get("message", {}).get("content", "")
    return {"provider": "openai-compatible", "answer": answer, "configured": True}
