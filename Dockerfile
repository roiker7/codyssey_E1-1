# 가벼운 웹 서버 Nginx 를 가져옵니다.
FROM nginx:alpine

# 방금 만든 HTML 파일을 도커 안의 웹 서버 폴더로 복사합니다.
COPY index.html /usr/share/nginx/html/index.html

# 웹 사이트에서 사용할 포트
EXPOSE 80