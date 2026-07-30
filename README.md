# codyssey_test
## 프로젝트 개요 
이 프로젝트는 개발과 인프라 운영의 필수 기본기인 리눅스 터미널 제어, Docker를 활용한 컨테이너 구축 및 운영, Git/GitHub을 통한 버전 관리를 직접 실습하고 증명하는 미션입니다<br>

모든 과정은 명령어와 실행 결과를 기록하여 기술 문서로 남기며, 이를 통해 인프라 환경을 스스로 구성하고 문제를 해결할 수 있는 능력을 기르는 것을 목표로 합니다<br>

## 실행 환경 
OS: macOS Sequoia 15.7.4
Termional: Apple_Terminal
Shell: /bin/zsh 
Docker 버전 : 29.4.0
Git 버전 : 2.53.0

## 미션 수행 체크리스트 
### Step 1. Git 설정 및 GitHub 연동 
- Git 사용자 이름과 이메일을 설정하고 git config --list 결과 기록하기
- GitHub에 새로운 Repository 생성하기
- 로컬 환경과 GitHub Repository 연동하고 증거(스크린샷 등) 첨부하기
<br><br>
### Step 2. 리눅스 터미널 및 권한 실습 
- 기본 명령어 실습 (명령어 + 출력 결과 기록)
    - 현재 위치 확인 (pwd) 및 숨김 파일 포함 목록 확인 (ls -al)
    - 디렉토리 이동 (cd), 생성 (mkdir), 삭제 (rm -r)
    - 빈 파일 생성 (touch), 내용 확인 (cat)
    - 파일 복사 (cp), 이동 및 이름 변경 (mv)
- 권한 실습
    - 파일 1개, 디렉토리 1개의 권한 변경하기 (chmod)
    - 권한 변경 전/후의 ls -al 결과를 비교하여 기록하기
<br><br>
### Step 3. Docker 기본 조작 및 컨테이너 실행 
- Docker 환경 점검
    - Docker 버전 확인 (docker --version)
    - Docker 데몬 정상 동작 확인 (docker info)
- 기본 운영 명령어 실습
    - 이미지 다운로드 및 목록 확인 (docker pull, docker images)
    - 컨테이너 실행, 중지, 목록 확인 (docker run, docker stop, docker ps -a)
    - 컨테이너 로그 확인 (docker logs) 및 리소스 확인 (docker stats)
- 컨테이너 실행 실습
    - hello-world 이미지 실행하고 성공 화면 기록하기
    - ubuntu 컨테이너 실행 후 내부로 진입하여 간단한 명령어(ls, echo) 실행하기
    - 컨테이너 종료 방식(exit로 종료 vs Ctrl+P,Q로 유지)의 차이점 간단히 정리하기
<br><br>
### Step 4. 커스텀 Docker 이미지 제작 및 포트 매핑 
- Dockerfile 작성 (A선택)
    - (A) 웹 서버(NGINX/Apache 등) 베이스 + 정적 파일 교체
    - 선택한 베이스 이미지와 커스텀한 목적(이유) 간단히 요약하기
    - 커스텀 이미지 빌드 (docker build) 및 실행 (docker run) 성공 결과 기록하기
- 포트 매핑 검증
    - 호스트 포트와 컨테이너 포트 연결하기 (-p 옵션)
    - 브라우저 접속 화면 또는 curl 응답 결과 스크린샷 첨부하기
<br><br>
### Step 5. Docker 볼륨 영속성 검증 
- Docker 볼륨 생성하기 (docker volume create)
- 볼륨을 연결하여 컨테이너 실행하기 (-v 옵션)
- 컨테이너 내부에 테스트 데이터(파일) 생성하기
- 컨테이너를 삭제한 후, 새로운 컨테이너에 같은 볼륨을 연결해 데이터가 그대로 남아있는지 증명하기
<br><br>
### Step 6. 문서화 및 보안 점검 
- 모든 명령어와 출력 결과가 마크다운 코드 블록(```)으로 깔끔하게 정리되었는지 확인하기
- 문서나 스크린샷에 비밀번호, 토큰, 개인키 등 민감한 정보가 노출되지 않았는지 확인하기