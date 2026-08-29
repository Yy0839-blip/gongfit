from app.services.matching import calculate_match


def test_match_recommends_when_required_skills_are_met():
    profile = {
        "major": "행정",
        "target_job": "행정",
        "certifications": ["컴퓨터활용능력"],
        "experience": ["행정 보조"],
        "skills": ["문서작성"],
        "target_region": "경기",
    }
    job = {
        "title": "행정지원",
        "required": ["행정"],
        "preferred": ["문서작성"],
    }
    result = calculate_match(profile, job)
    assert result["score"] >= 65
    assert result["decision"] == "지원 추천"


def test_match_identifies_missing_requirements():
    profile = {"major": "경영", "target_job": "행정", "certifications": [], "experience": [], "skills": []}
    job = {"title": "전산", "required": ["정보처리기사"], "preferred": []}
    result = calculate_match(profile, job)
    assert "정보처리기사" in result["required_missing"]
    assert result["decision"] in {"조건 보완 후 추천", "지원 신중"}
