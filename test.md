# 🐳 Docker & Linux & Git 실습 미션

## 📋 프로젝트 개요

본 프로젝트는 리눅스 터미널 기본 조작, 파일 권한 관리, Docker 기본 운영, 커스텀 이미지 제작, 볼륨 영속성 검증, Git/GitHub 연동까지 개발 환경 구축의 핵심 요소를 실습하고 문서화하는 것을 목표로 한다.

## 💻 실행 환경

```text
OS        : UmacOS Sequoia 15.7.4
Shell     : zsh
Terminal  : Apple Terminal
Docker    : Docker version 29.4.0
Git       : git version 2.53.0
```

## ✅ 수행 항목 체크리스트

| 항목 | 수행 여부 |
|---|---|
| 터미널 기본 명령어 실습 | ✅ |
| 파일/디렉토리 권한 실습 (chmod) | ✅ |
| Docker 설치 및 환경 점검 | ✅ |
| Docker 기본 운영 명령 (image/container) | ✅ |
| 컨테이너 실행 실습 (hello-world, ubuntu) | ✅ |
| 커스텀 Dockerfile 제작 및 빌드 | ✅ |
| 포트 매핑 검증 | ✅ |
| Docker 볼륨 영속성 검증 | ✅ |
| Git 설정 및 GitHub 연동 | ✅ |
| 보안/민감정보 마스킹 점검 | ✅ |

---

## Step 1. Git 설정 및 GitHub 연동

### 1-1. Git 사용자 정보 설정

```bash
git config --global user.name "<user>"
git config --global user.email "<user_email>"
git config --global init.defaultBranch main
```

### 1-2. 설정 확인

```bash
git config --list
```

```text
user.name=your-username
user.email=your-email@example.com
init.defaultbranch=main
core.editor=vim
core.autocrlf=input
```

### 1-3. GitHub Repository 생성 및 로컬 연동

GitHub 웹사이트에서 `New Repository` 버튼을 눌러 저장소를 생성한 뒤, 아래 명령으로 로컬 저장소와 연동했다.

```bash
git init
git remote add origin https://github.com/your-username/your-repo.git
git add .
git commit -m "Initial commit: 미션 실습 문서 추가"
git branch -M main
git push -u origin main
```

```text
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Writing objects: 100% (5/5), 1.02 KiB | 1.02 MiB/s, done.
To https://github.com/your-username/your-repo.git
 * [new branch]      main -> main
branch 'main' set up to track 'origin/main'.
```

> 📸 **[증거 스크린샷]** GitHub Repository 생성 화면 및 `git push` 성공 후 커밋이 반영된 저장소 화면 첨부 (`docs/images/github-connect.png`)

---

## Step 2. 리눅스 터미널 및 권한 실습

### 2-1. 기본 명령어 실습

**현재 위치 확인**

```bash
pwd
```

```text
/home/user/mission
```

**숨김 파일 포함 목록 확인**

```bash
ls -al
```

```text
drwxr-xr-x  4 user user 4096 Aug 17 10:00 .
drwxr-xr-x 20 user user 4096 Aug 17 09:58 ..
-rw-r--r--  1 user user   45 Aug 17 09:59 .env.example
drwxr-xr-x  2 user user 4096 Aug 17 10:00 practice
-rw-r--r--  1 user user  120 Aug 17 09:58 README.md
```

**디렉토리 이동 / 생성**

```bash
mkdir practice
cd practice
pwd
```

```text
/home/user/mission/practice
```

**빈 파일 생성 및 내용 확인**

```bash
touch sample.txt
cat sample.txt
```

```text
(빈 파일이므로 출력 없음)
```

**파일 복사**

```bash
cp sample.txt sample_copy.txt
ls -al
```

```text
-rw-r--r-- 1 user user 0 Aug 17 10:02 sample.txt
-rw-r--r-- 1 user user 0 Aug 17 10:03 sample_copy.txt
```

**이동 및 이름 변경**

```bash
mv sample_copy.txt renamed.txt
ls -al
```

```text
-rw-r--r-- 1 user user 0 Aug 17 10:02 sample.txt
-rw-r--r-- 1 user user 0 Aug 17 10:03 renamed.txt
```

**삭제**

```bash
rm -r practice
cd ..
ls -al
```

```text
drwxr-xr-x  3 user user 4096 Aug 17 10:05 .
drwxr-xr-x 20 user user 4096 Aug 17 09:58 ..
-rw-r--r--  1 user user  120 Aug 17 09:58 README.md
```

### 2-2. 권한 실습 (chmod)

**대상**: 파일 1개(`sample.txt`), 디렉토리 1개(`practice_dir`)

**변경 전 확인**

```bash
touch sample.txt
mkdir practice_dir
ls -al
```

```text
-rw-r--r-- 1 user user    0 Aug 17 10:10 sample.txt
drwxr-xr-x 2 user user 4096 Aug 17 10:10 practice_dir
```

**권한 변경**

```bash
chmod 600 sample.txt
chmod 700 practice_dir
```

**변경 후 확인**

```bash
ls -al
```

```text
-rw------- 1 user user    0 Aug 17 10:10 sample.txt
drwx------ 2 user user 4096 Aug 17 10:10 practice_dir
```

**비교 요약**

| 대상 | 변경 전 | 변경 후 | 의미 |
|---|---|---|---|
| `sample.txt` | `rw-r--r--` (644) | `rw-------` (600) | 소유자만 읽기/쓰기 가능, 그룹/기타 사용자 접근 차단 |
| `practice_dir` | `rwxr-xr-x` (755) | `rwx------` (700) | 소유자만 디렉토리 접근·탐색 가능 |

---

## Step 3. Docker 기본 조작 및 컨테이너 실행

### 3-1. Docker 환경 점검

```bash
docker --version
```

```text
Docker version 24.0.7, build afdd53b
```

```bash
docker info
```

```text
Client:
 Version:    24.0.7
 Context:    default

Server:
 Containers: 3
  Running: 1
  Paused: 0
  Stopped: 2
 Images: 5
 Server Version: 24.0.7
 Storage Driver: overlay2
 ...
```

### 3-2. 기본 운영 명령어

**이미지 다운로드 및 목록 확인**

```bash
docker pull ubuntu:22.04
docker images
```

```text
REPOSITORY    TAG       IMAGE ID       CREATED       SIZE
ubuntu        22.04     3db8720ec3d3   2 weeks ago   77.9MB
hello-world   latest    d2c94e258dcb   6 weeks ago   13.3kB
```

**컨테이너 실행 / 중지 / 목록 확인**

```bash
docker run -d --name test-nginx nginx
docker ps
docker stop test-nginx
docker ps -a
```

```text
CONTAINER ID   IMAGE   COMMAND                  STATUS         NAMES
5f3a9c1b2e4d   nginx   "/docker-entrypoint.…"   Up 5 seconds   test-nginx

CONTAINER ID   IMAGE   STATUS                     NAMES
5f3a9c1b2e4d   nginx   Exited (0) 2 seconds ago   test-nginx
```

**로그 확인 / 리소스 확인**

```bash
docker logs test-nginx
```

```text
/docker-entrypoint.sh: Configuration complete; ready for start up
2026/08/17 10:20:00 [notice] 1#1: start worker processes
```

```bash
docker stats --no-stream
```

```text
CONTAINER ID   NAME         CPU %     MEM USAGE / LIMIT     MEM %
5f3a9c1b2e4d   test-nginx   0.00%     2.1MiB / 7.759GiB     0.03%
```

### 3-3. 컨테이너 실행 실습

**hello-world 실행**

```bash
docker run hello-world
```

```text
Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
 3. The Docker daemon created a new container from that image.
```

**ubuntu 컨테이너 진입 후 명령 실행**

```bash
docker run -it ubuntu:22.04 bash
```

```text
root@a1b2c3d4e5f6:/# ls
bin  boot  dev  etc  home  lib  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
root@a1b2c3d4e5f6:/# echo "Hello Docker Practice"
Hello Docker Practice
root@a1b2c3d4e5f6:/# exit
exit
```

### 3-4. 컨테이너 종료 방식 차이 정리

| 방식 | 동작 | 컨테이너 상태 |
|---|---|---|
| `exit` | 컨테이너의 메인 프로세스(쉘)를 종료 | 컨테이너가 **정지(Exited)** 됨 |
| `Ctrl + P, Q` | 터미널 연결만 해제(detach), 프로세스는 유지 | 컨테이너가 **계속 실행(Up)** 상태 유지 |

> `exit`은 컨테이너 안에서 쉘 프로세스 자체를 종료시키므로 컨테이너가 멈추지만, `Ctrl+P, Q`는 attach된 터미널 세션만 빠져나오는 것이라 컨테이너 내부 프로세스는 백그라운드에서 계속 살아있다. 이후 `docker attach` 또는 `docker exec`로 재진입할 수 있다.

---

## Step 4. 커스텀 Docker 이미지 제작 및 포트 매핑

### 4-1. 선택한 베이스 이미지

- **선택 방식**: (A) 웹 서버 베이스 이미지 활용
- **베이스 이미지**: `nginx:alpine`
- **커스텀 목적**: 기본 nginx 웰컴 페이지를 나만의 정적 HTML 페이지로 교체하여, 이미지 빌드 시 정적 콘텐츠가 함께 배포되도록 구성

### 4-2. Dockerfile 작성

```dockerfile
# Dockerfile
FROM nginx:alpine

# 커스텀 정적 페이지로 교체 (목적: 기본 웰컴 페이지 대체)
COPY ./static/index.html /usr/share/nginx/html/index.html

# 컨테이너 헬스체크 추가 (목적: 서비스 정상 동작 여부 자동 점검)
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -q --spider http://localhost/ || exit 1

EXPOSE 80
```

```html
<!-- static/index.html -->
<!DOCTYPE html>
<html>
<head><title>My Custom Nginx</title></head>
<body>
  <h1>Docker 미션 실습 - 커스텀 페이지</h1>
</body>
</html>
```

### 4-3. 빌드 및 실행

```bash
docker build -t my-custom-nginx:1.0 .
```

```text
[+] Building 3.2s (8/8) FINISHED
 => [1/2] FROM docker.io/library/nginx:alpine
 => [2/2] COPY ./static/index.html /usr/share/nginx/html/index.html
 => exporting to image
 => naming to docker.io/library/my-custom-nginx:1.0
```

```bash
docker run -d -p 8080:80 --name custom-web my-custom-nginx:1.0
docker ps
```

```text
CONTAINER ID   IMAGE                   COMMAND                  STATUS         PORTS                  NAMES
7c8d9e0f1a2b   my-custom-nginx:1.0     "/docker-entrypoint.…"   Up 3 seconds   0.0.0.0:8080->80/tcp   custom-web
```

### 4-4. 포트 매핑 검증

```bash
curl http://localhost:8080
```

```text
<!DOCTYPE html>
<html>
<head><title>My Custom Nginx</title></head>
<body>
  <h1>Docker 미션 실습 - 커스텀 페이지</h1>
</body>
</html>
```

> 📸 **[증거 스크린샷]** 브라우저에서 `http://localhost:8080` 접속 시 커스텀 페이지가 정상 출력되는 화면 첨부 (`docs/images/port-mapping.png`)

---

## Step 5. Docker 볼륨 영속성 검증

### 5-1. 볼륨 생성

```bash
docker volume create mission-data
docker volume ls
```

```text
DRIVER    VOLUME NAME
local     mission-data
```

### 5-2. 볼륨 연결하여 컨테이너 실행 + 테스트 데이터 생성

```bash
docker run -it --name vol-test -v mission-data:/data ubuntu:22.04 bash
```

```text
root@f1e2d3c4b5a6:/# echo "persistent-data-check" > /data/test.txt
root@f1e2d3c4b5a6:/# cat /data/test.txt
persistent-data-check
root@f1e2d3c4b5a6:/# exit
```

### 5-3. 컨테이너 삭제

```bash
docker rm vol-test
```

```text
vol-test
```

### 5-4. 새 컨테이너로 동일 볼륨 연결 및 데이터 확인

```bash
docker run -it --name vol-test-new -v mission-data:/data ubuntu:22.04 bash
```

```text
root@a9b8c7d6e5f4:/# cat /data/test.txt
persistent-data-check
```

**결론**: 컨테이너(`vol-test`)를 삭제한 후 새로운 컨테이너(`vol-test-new`)에 동일한 볼륨(`mission-data`)을 연결했을 때 `test.txt` 파일 내용이 그대로 유지되는 것을 확인했다. → **Docker 볼륨은 컨테이너 생명주기와 독립적으로 데이터를 영속 보관한다.**

---

## Step 6. 문서화 및 보안 점검

### 6-1. 문서화 점검

- [x] 모든 명령어와 출력 결과를 ` ```bash ` / ` ```text ` 코드 블록으로 정리함
- [x] 각 실습 단계별 검증 방법과 결과(또는 결과 위치)를 명시함
- [x] Step 4의 브라우저/curl 접속 증거, Step 1의 GitHub 연동 증거를 스크린샷 첨부 위치로 표시함

### 6-2. 보안 및 개인정보 점검

- [x] `git config` 결과에 실제 개인 이메일 대신 예시 계정(`your-email@example.com`) 사용
- [x] 문서 내 토큰, 비밀번호, 개인키, 인증 코드 등 민감 정보 미포함 확인
- [x] `.env`, 인증 정보 파일은 `.gitignore`에 등록하여 저장소에 포함되지 않도록 처리

```bash
# .gitignore 예시
.env
*.pem
*.key
secrets/
```

- [x] 만약 민감정보가 실수로 커밋된 이력이 발견될 경우, `git filter-repo` 등으로 히스토리에서 제거 후 해당 토큰/키를 즉시 재발급하는 절차를 따른다.

---

## 📎 참고: 실행 환경 재현 방법

```bash
git clone https://github.com/your-username/your-repo.git
cd your-repo
docker build -t my-custom-nginx:1.0 .
docker run -d -p 8080:80 my-custom-nginx:1.0
```

---

> ⚠️ 본 문서의 명령어 출력 결과는 실습 절차 이해를 돕기 위한 예시이며, 실제 제출 시에는 본인 환경에서 직접 수행한 명령어와 출력 결과, 스크린샷으로 교체해야 합니다.
