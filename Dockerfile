# 1. 기본 재료 준비: 가벼운 웹 서버(Nginx)를 가져옵니다.
FROM nginx:alpine

# 2. 내 파일 넣기: 방금 만든 HTML 파일을 도커 안의 웹 서버 폴더로 복사합니다.
COPY index.html /usr/share/nginx/html/index.html