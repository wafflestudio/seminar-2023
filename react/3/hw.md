# React 과제 2

## 과제 목적

- 백엔드와 연결한다

## 제출 방법

(과제2의 제출방법과 대동소이합니다)

- 과제2를 작업했던 기존의 레포(wafflw-react-hw1)에서 과제에서 새로 브랜치를 파서 진행합니다.
- 과제2의 채점이 끝나면 main에 머지하고, main에서 새로운 브랜치 hw3를 파서 과제3 작업 내용을 푸시하세요.
- 과제3이 완료되면 PR을 열고 세미나장과 조교에게 리뷰 리퀘스트를 걸어주세요.
  - 리뷰 리퀘스트를 걸지 않으면 제출 확인이 어려워 채점이 늦어질 수 있습니다.

## 과제 스펙

- 로그인 화면
  - 로그인되어 있지 않을 경우, 어느 url로 접속하든 항상 로그인 화면을 보여준다.
  - 로그인 화면에서 username 과 password 를 입력하고 로그인 버튼을 누르면 [`POST /auth/login`](http://localhost:8080/docs/static/index.html#/default/post_auth_login) api를 이용해 로그인을 시도한다.
  - username 또는 password 중 하나라도 비어 있다면 로그인 버튼이 `disable`되어 있다.
  - password 인풋은 `<input type="password" />` 를 이용해야 한다.
  - 로그인이 실패했을 경우 alert 로 로그인이 실패했음을 알린다.
  - 로그인이 성공했을 경우 리뷰 목록 페이지 (`/` 경로) 으로 이동한다.
  - (보너스) 자동 로그인을 구현한다.
    - 힌트: 이전에 로그인한 적이 있다면 쿠키에 리프레시 토큰이 있을 것이므로, [`POST /auth/refresh`](http://localhost:8080/docs/static/index.html#/default/post_auth_refresh) api를 이용해 access token을 재발급받을 수 있고, 자동 로그인을 구현할 수 있다.
- 리뷰 목록 페이지
  - [`GET /reviews`](http://localhost:8080/docs/static/index.html#/default/get_snacks) api를 이용해 리뷰 목록을 가져온다.
  - [`POST /reviews`](http://localhost:8080/docs/static/index.html#/default/post_reviews) api를 이용해 리뷰를 추가한다. 추가 후 추가된 리뷰가 화면에도 보여야 한다.
- 새 과자 페이지
  - [`POST /snacks`](http://localhost:8080/docs/static/index.html#/default/post_snacks) api를 이용해 과자를 추가한다.
- 과자 목록 페이지
  - [`GET /snacks`](http://localhost:8080/docs/static/index.html#/default/get_snacks) api를 이용해 과자 목록을 가져온다.
- 과자 상세 페이지
  - [`GET /reviews`](http://localhost:8080/docs/static/index.html#/default/get_reviews) api를 이용해 리뷰 목록을 가져온다. 리뷰 목록 페이지와는 다르게, api의 url 쿼리파라미터에 snack을 전달해야 한다.
  - [`PATCH /reviews/{id}`](http://localhost:8080/docs/static/index.html#/default/patch_reviews__id_) api를 이용해 리뷰를 수정한다. 수정 후 화면에도 반영되어 있어야 한다.
  - [`DELETE /reviews/{id}`](http://localhost:8080/docs/static/index.html#/default/delete_reviews__id_) api를 이용해 리뷰를 삭제한다. 삭제 후 화면에도 반영되어 있어야 한다.
