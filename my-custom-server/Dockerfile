# 1. 베이스 이미지 선택 (가볍고 빠른 alpine 버전)
FROM nginx:alpine

# 2. 이미지 메타데이터 추가 (라벨)
LABEL maintainer="yourname@example.com"
LABEL description="나의 첫 번째 커스텀 웹 서버 이미지"

# 3. 환경 변수 설정 (컨테이너 안에서 사용할 변수)
ENV APP_ENV=production
ENV WELCOME_MSG="도커 공부 화이팅!"

# 4. 내 컴퓨터의 site 폴더 내용을 컨테이너 안의 웹 경로로 복사
COPY site/ /usr/share/nginx/html/

# 5. 컨테이너가 사용할 포트 명시 (문서화 용도)
EXPOSE 80

# 6. (선택) 컨테이너 시작 시 실행될 명령어 (Nginx는 기본적으로 설정되어 있어 생략 가능)
CMD ["nginx", "-g", "daemon off;"]