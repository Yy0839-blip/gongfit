from __future__ import annotations


def _norm(values: list[str]) -> set[str]:
    return {v.strip().lower() for v in values if v and v.strip()}


def calculate_match(profile: dict, job: dict) -> dict:
    profile_terms = _norm(
        profile.get("certifications", [])
        + profile.get("experience", [])
        + profile.get("skills", [])
        + [profile.get("major", ""), profile.get("target_job", ""), profile.get("target_region", "")]
    )
    required = _norm(job.get("required", []))
    preferred = _norm(job.get("preferred", []))

    required_hits = sorted(t for t in required if any(t in p or p in t for p in profile_terms))
    required_misses = sorted(required - set(required_hits))
    preferred_hits = sorted(t for t in preferred if any(t in p or p in t for p in profile_terms))

    req_score = 100 if not required else round(len(required_hits) / len(required) * 70)
    pref_score = 0 if not preferred else round(len(preferred_hits) / len(preferred) * 20)
    profile_depth = min(10, len(profile_terms))
    total = min(100, req_score + pref_score + profile_depth)

    decision = "지원 추천" if not required_misses and total >= 65 else "조건 보완 후 추천" if total >= 45 else "지원 신중"
    return {
        "score": total,
        "decision": decision,
        "required_match": required_hits,
        "required_missing": required_misses,
        "preferred_match": preferred_hits,
        "strengths": preferred_hits[:5] + required_hits[:5],
        "actions": [f"필수요건 보완: {', '.join(required_misses)}"] if required_misses else ["자기소개서에서 직무 연관 경험을 구체화하세요.", "면접 대비 예상질문을 준비하세요."],
    }
