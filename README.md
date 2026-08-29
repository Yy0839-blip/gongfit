# 공핏 (GONGFIT)

> 공공기관 취업 준비를 한 곳에서 분석하고 준비하는 AI 취업 도우미

## Product

공핏은 사용자의 스펙/경험과 채용공고를 함께 분석해 **지원 가능 여부 → 직무 적합도 → 보완점 → 자기소개서 → 면접 → AI 상담**으로 연결하는 서비스입니다.

## MVP

- 사용자 프로필 입력
- 채용공고 붙여넣기 및 저장
- 지원자격/우대사항 구조화
- 직무 적합도 분석
- 강점/보완점 분석
- 준비 액션 제안
- 자기소개서 작성 보조
- 면접 예상 질문 생성
- 공핏 AI 챗봇

## Tech direction

- Frontend: Flutter
- Backend: FastAPI
- Database: Supabase/PostgreSQL (production)
- AI: provider abstraction (Llama-compatible endpoint / OpenAI-compatible endpoint)
- Auth: Supabase Auth or Firebase Auth

API 키와 모델 secret은 앱에 포함하지 않고 백엔드 환경변수로만 관리합니다.

## AI chatbot architecture

`Flutter Chat UI -> FastAPI /api/v1/chat -> AI provider adapter -> LLM`

챗봇 요청에는 사용자의 프로필과 현재 분석 중인 채용공고/분석 결과를 선택적으로 context로 전달합니다.

Llama를 사용할 경우 OpenAI-compatible API를 제공하는 호스팅 환경을 provider로 연결할 수 있도록 인터페이스를 분리합니다. 모델 공급자를 교체해도 Flutter 앱과 핵심 도메인 로직은 변경하지 않는 것이 목표입니다.

## API outline

- `GET /health`
- `POST /api/v1/profile/analyze`
- `POST /api/v1/jobs/analyze`
- `POST /api/v1/match`
- `POST /api/v1/chat`

## Local development

```bash
cd backend
python -m venv .venv
# Windows
.venv\\Scripts\\activate
# macOS/Linux
# source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

### Environment

```env
AI_BASE_URL=
AI_API_KEY=
AI_MODEL=
```

`AI_BASE_URL`, `AI_API_KEY`, `AI_MODEL`은 실제 배포 환경에서 설정합니다.
