from __future__ import annotations

import re


SECTION_LABELS = {
    "required": ["자격요건", "필수", "지원자격", "필수요건"],
    "preferred": ["우대사항", "우대", "가점", "우대조건"],
}


def _extract_lines(text: str) -> list[str]:
    return [re.sub(r"^[\-•●▪◦\d\.\)\s]+", "", line).strip() for line in text.splitlines() if line.strip()]


def parse_job_posting(text: str) -> dict:
    """Lightweight deterministic parser used before an LLM is introduced.

    It intentionally avoids claiming that every extracted term is an official requirement.
    """
    lines = _extract_lines(text)
    required: list[str] = []
    preferred: list[str] = []
    section = None

    for line in lines:
        lowered = line.lower()
        matched = False
        for key, labels in SECTION_LABELS.items():
            if any(label in line for label in labels):
                section = key
                matched = True
                break
        if matched:
            continue
        if section == "required":
            required.append(line)
        elif section == "preferred":
            preferred.append(line)

    title = lines[0] if lines else "채용공고"
    organization = lines[1] if len(lines) > 1 else None
    return {
        "title": title,
        "organization": organization,
        "location": None,
        "required": required[:20],
        "preferred": preferred[:20],
        "description": text[:12000],
    }
