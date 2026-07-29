# 1. 베이스 이미지로 nginx(웹 서버) 최신 버전을 사용합니다.
FROM nginx:latest

# 2. 우리가 만든 index.html 파일을 nginx의 기본 웹 경로로 복사합니다.
COPY index.html /usr/share/nginx/html/index.html