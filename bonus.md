# 🐳 Docker Compose 및 GitHub SSH 설정 실습 
---
 
# Docker Compose 기초
docker-compose.yml의 기본 구조를 학습하고, 단일 서비스를 Compose로 실행한다.
```
services:
  web:
    image: nginx:alpine
    container_name: my_web_server
    ports:
      - "8080:80"
    restart: always

  cache:
    image: redis:alpine
    container_name: my_redis_cache
    ports:
      - "6379:6379"
    restart: always
```
- 배움 포인트: 컨테이너 실행 명령이 “문서화된 실행 설정”으로 바뀌는 이유
Docker Compose를 쓰면 컨테이너를 실행할 때 필요한 이미지, 포트, 환경변수, 볼륨, 네트워크 같은 설정을 긴 `docker run` 명령어로 매번 입력하지 않고 `compose.yaml` 파일에 기록해 둡니다. 그래서 실행 방법이 터미널 기록이나 개인 기억에 의존하지 않고, 파일 자체에 문서처럼 남게 됩니다. 이 파일을 보면 어떤 컨테이너가 어떤 설정으로 실행되는지 바로 알 수 있고, 팀원도 같은 파일로 동일한 환경을 쉽게 재현할 수 있습니다. 즉, Docker Compose는 컨테이너 실행 명령을 단순히 줄여 주는 도구가 아니라, 실행 방법을 명확하게 저장하고 공유할 수 있는 “문서화된 실행 설정”으로 바꿔 주기 때문에 사용합니다. 잘 이해하고 계세요. 핵심은 재현성, 공유성, 관리 편의성입니다.

---

# Docker Compose 멀티 컨테이너
- 웹 서버 + (임의의 보조 서비스) 2개 이상을 Compose로 함께 실행한다.
```
services:
  web:
    image: nginx:alpine
    container_name: my_web_server
    ports:
      - "8080:80"

  cache:
    image: redis:alpine
    container_name: my_redis_cache

  db:
    image: postgres:15-alpine
    container_name: my_db_server
    environment:
      POSTGRES_PASSWORD: mypassword
```
- 컨테이너 간 네트워크 통신이 가능한지 확인한다.
```
% docker compose exec web nslookup cache
% docker compose exec web nslookup db
zsh: command not found: #
Server:         127.0.0.11
Address:        127.0.0.11:53

Non-authoritative answer:
Name:   cache
Address: 192.168.97.3

Non-authoritative answer:

Server:         127.0.0.11
Address:        127.0.0.11:53

Non-authoritative answer:
Name:   db
Address: 192.168.97.4

Non-authoritative answer:
```
 - 배움 포인트: 네트워크/서비스 디스커버리 개념 맛보기

Docker Compose에서는 여러 컨테이너가 함께 실행될 때 자동으로 같은 네트워크에 묶입니다. 그래서 컨테이너끼리는 IP 주소를 직접 외우지 않아도 되고, `db`, `redis`, `app` 같은 서비스 이름으로 서로를 찾을 수 있습니다. 예를 들어 Compose 파일에 `db`라는 서비스가 있으면, 다른 컨테이너는 `localhost`가 아니라 `db:3306`처럼 접속합니다. 이것이 서비스 디스커버리의 기본 개념입니다.

즉, 네트워크는 컨테이너들이 서로 통신할 수 있는 공간이고, 서비스 디스커버리는 그 안에서 “어떤 서비스가 어디 있는지”를 이름으로 찾게 해주는 기능입니다. Docker Compose는 이 과정을 자동으로 처리해 주기 때문에 개발자는 컨테이너 IP를 신경 쓰지 않고 서비스 이름만 사용하면 됩니다.

핵심은 이겁니다. **컨테이너끼리는 localhost가 아니라 서비스 이름으로 통신한다.**  
예를 들어 웹 앱 컨테이너가 DB에 접속할 때는 `localhost:3306`이 아니라 `db:3306`을 사용합니다.

```yaml
services:
  app:
    build: .
    depends_on:
      - db

  db:
    image: mysql:8
```
위 설정에서 `app` 컨테이너는 `db`라는 이름으로 MySQL 컨테이너를 찾을 수 있습니다. 그래서 애플리케이션 DB 주소를 `db`로 설정하면 됩니다. 잘 짚고 있어요. 이 개념을 이해하면 Compose에서 여러 컨테이너가 어떻게 서로 연결되는지 훨씬 쉽게 보입니다.

---

# Compose 운영 명령어 습득
- up, down, ps, logs를 사용해 실행/종료/상태/로그를 관리한다.
| 명령어 | 설명 | 주요 옵션 및 사용 예시 |
| --- | --- | --- |
| **`docker compose up`** | 설정 파일(`docker-compose.yml`)에 정의된 모든 서비스 컨테이너를 생성하고 실행합니다. | **`-d`**: 백그라운드에서 실행<br>

<br>`docker compose up -d` |
| **`docker compose ps`** | 현재 실행 중인 멀티 컨테이너들의 상태, 포트 매핑 등을 조회합니다. | 기본형태<br>

<br>`docker compose ps` |
| **`docker compose logs`** | 컨테이너 내부의 시스템 로그를 확인하여 에러 디버깅 등에 활용합니다. | **`-f`**: 실시간 로그 추적<br>

<br>`docker compose logs -f` |
| **`docker compose down`** | 실행 중인 모든 컨테이너를 중지하고 삭제하며, 내부 네트워크까지 깔끔하게 정리합니다. | **`-v`**: 데이터 볼륨까지 함께 삭제<br>

<br>`docker compose down` |

- 배움 포인트: 운영 관점의 “상태 확인 루틴” 만들기
```
docker compose up -d   # 실행
docker compose ps      # 상태 확인
docker compose logs -f # 로그 확인
docker compose down    # 종료/정리
```
핵심은 켜기 → 상태 보기 → 로그 보기 → 끄기입니다.
즉, 단순히 실행만 하는 게 아니라 ps로 정상인지 확인하고, 문제가 있으면 logs로 원인을 찾는 습관을 만드는 것이 배움 포인트입니다.
---

# 환경 변수 활용
- Dockerfile 또는 Compose에서 환경 변수를 주입해 서버 포트/모드를 바꿔본다.
```
services:
  web:
    image: nginx:alpine
    container_name: my_web_server
    ports:
      # .env의 WEB_PORT를 가져오고, 없으면 8080을 사용
      - "${WEB_PORT:-8080}:80" 
    restart: always

  cache:
    image: redis:alpine
    container_name: my_redis_cache
    # 변수 없이 직접 작성할 수도 있지만, 필요한 경우 아래처럼 넣을 수 있음
    environment:
      - REDIS_MODE=standalone
```
```
oiker78137@c4r1s4 codyssey_E1-1 % docker compose up -d
WARN[0000] Found orphan containers ([my_db_server]) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up. 
[+] up 2/2
 ✔ Container my_web_server  Started                                                                                         1.2s
 ✔ Container my_redis_cache Started 
```
- 배움 포인트: 설정과 코드의 분리
환경 변수는 코드에 직접 쓰면 안 되는 설정값을 밖으로 빼는 방법입니다.
예를 들어 DB 비밀번호, 포트 번호, API 키 같은 값은 코드에 고정하지 않고 .env나 Compose의 environment로 관리합니다.
핵심은 코드는 그대로 두고, 실행 환경에 따라 설정만 바꿀 수 있게 하는 것입니다.

---

# GitHub SSH 키 설정
- HTTPS 대신 SSH로 푸시가 가능하도록 키를 등록하고 동작을 확인한다.
```
roiker78137@c4r1s4 codyssey_E1-1 % ls -al ~/.ssh
total 8
drwxr-xr-x   3 roiker78137  roiker78137   96  8 17 17:37 .
drwxr-x---+ 29 roiker78137  roiker78137  928  8 17 20:50 ..
-rw-r--r--   1 roiker78137  roiker78137  210  8 17 17:37 config
```
```
% ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
Generating public/private rsa key pair.
```

- 배움 포인트: 인증 방식 차이와 보안 습관
GitHub SSH 키 설정의 핵심은 비밀번호 대신 SSH 키로 안전하게 인증하는 것입니다.
HTTPS는 아이디/토큰으로 인증하고, SSH는 내 컴퓨터에 있는 개인키와 GitHub에 등록한 공개키가 짝이 맞는지 확인해서 인증합니다.
중요한 보안 습관은 개인키는 절대 공유하지 않고, GitHub에는 공개키만 등록하는 것입니다.
정리하면, 배움 포인트는 인증 방식의 차이를 이해하고, 비밀키를 안전하게 관리하는 습관을 만드는 것입니다.