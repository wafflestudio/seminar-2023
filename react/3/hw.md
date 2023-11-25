# React 과제 3

- due: 11/28 (화) 저녁 24:00

## 과제 목적

- 백엔드와 연결한다

## 제출 방법

(과제2의 제출방법과 대동소이합니다)

- 과제2를 작업했던 기존의 레포(wafflw-react-hw1)에서 과제에서 새로 브랜치를 파서 진행합니다.
- 과제2의 채점이 끝나면 main에 머지하고, main에서 새로운 브랜치 hw3를 파서 과제3 작업 내용을 푸시하세요.
- 과제3이 완료되면 PR을 열고 세미나장과 조교에게 리뷰 리퀘스트를 걸어주세요.
  - 리뷰 리퀘스트를 걸지 않으면 제출 확인이 어려워 채점이 늦어질 수 있습니다.

## 과제 스펙

- **패스워드 변경**: `PUT /users/me/password` API를 통해 반드시 패스워드를 변경한다.
  - 힌트: curl, Postman 등의 프로그램을 활용할 수 있다.
  - 힌트: 패스워드 변경은 액세스 토큰을 필요로 한다.
- 로그인 화면
  - 로그인되어 있지 않을 경우, 어느 url로 접속하든 항상 로그인 화면을 보여준다.
  - 로그인 화면에서 username 과 password 를 입력하고 로그인 버튼을 누르면 [`POST /auth/login`](https://seminar-react-api.wafflestudio.com/docs/static/index.html#/default/post_auth_login) api를 이용해 로그인을 시도한다.
  - username 또는 password 중 하나라도 비어 있다면 로그인 버튼이 `disable`되어 있다.
  - password 인풋은 `<input type="password" />` 를 이용해야 한다.
  - 로그인이 실패했을 경우 alert 로 로그인이 실패했음을 알린다.
  - 로그인이 성공했을 경우 리뷰 목록 페이지 (`/` 경로) 으로 이동한다.
  - (보너스) 자동 로그인을 구현한다.
    - 힌트: 이전에 로그인한 적이 있다면 쿠키에 리프레시 토큰이 있을 것이므로, [`POST /auth/refresh`](https://seminar-react-api.wafflestudio.com/docs/static/index.html#/default/post_auth_refresh) api를 이용해 access token을 재발급받을 수 있고, 자동 로그인을 구현할 수 있다.
- 리뷰 목록 페이지
  - [`GET /reviews`](https://seminar-react-api.wafflestudio.com/docs/static/index.html#/default/get_reviews_) api를 이용해 리뷰 목록을 가져온다.
  - [`POST /reviews`](https://seminar-react-api.wafflestudio.com/docs/static/index.html#/default/post_reviews_) api를 이용해 리뷰를 추가한다. 추가 후 추가된 리뷰가 화면에도 보여야 한다.
- 새 과자 페이지
  - [`POST /snacks`](https://seminar-react-api.wafflestudio.com/docs/static/index.html#/default/post_snacks_) api를 이용해 과자를 추가한다.
- 과자 목록 페이지
  - [`GET /snacks`](https://seminar-react-api.wafflestudio.com/docs/static/index.html#/default/get_snacks_) api를 이용해 과자 목록을 가져온다.
- 과자 상세 페이지
  - [`GET /reviews`](https://seminar-react-api.wafflestudio.com/docs/static/index.html#/default/get_reviews_) api를 이용해 리뷰 목록을 가져온다. 리뷰 목록 페이지와는 다르게, api의 url 쿼리파라미터에 snack을 전달해야 한다.
- 리뷰의 수정 및 삭제
  - [`PATCH /reviews/{id}`](https://seminar-react-api.wafflestudio.com/docs/static/index.html#/default/patch_reviews__id_) api를 이용해 리뷰를 수정한다. 수정 후 화면에도 반영되어 있어야 한다.
  - [`DELETE /reviews/{id}`](https://seminar-react-api.wafflestudio.com/docs/static/index.html#/default/delete_reviews__id_) api를 이용해 리뷰를 삭제한다. 삭제 후 화면에도 반영되어 있어야 한다.
  - 해당 동작은 로그인한 사용자가 생성한 리뷰에만 사용할 수 있다.
  - 다른 사용자가 만든 리뷰에는 수정 및 삭제 버튼이 나타나지 않는다.
    - UI 상으로 자신의 리뷰와 다른 사람의 리뷰를 구분할 수 있게 하여도 좋다. 해당 UI는 채점에 반영하지는 않는다.

- 백엔드 서버의 주소는 다음과 같다:  https://seminar-react-api.wafflestudio.com
  - 자세한 API는 [/docs](https://seminar-react-api.wafflestudio.com/docs/static/index.html)에서 읽을 수 있다.
  - API 요청은 `https://seminar-react-api.wafflestudio.com/snacks`과 같이 위의 주소 뒤에 원하는 기능의 path를 붙여서 보내면 된다.
- 백엔드 DB에는 사용자의 목록이 이미 들어있다. `username`과 `password`는 각각 수강생의 github name과 실명으로 초기화되어있다.
  - 자신의 계정으로만 로그인하도록 한다.
- 로그인 화면의 디자인은 자율에 맡긴다.
  - 단, 이후에 추가될 test spec을 만족하기 위해서는username 및 password를 입력하기 위한 input과 로그인 버튼이 있어야 한다.

## 쿠키 사용 가이드

본 과제의 백엔드 서버는 쿠키를 통한 액세스 토큰 재발급을 지원한다. 로컬에서 쿠키를 사용하기 위해서는 아래와 같이 vite.config.ts를 수정하여 서버가 https로 실행되도록 설정해야 한다.
이 설정에 사용된 `@vitejs/plugin-basic-ssl`는 npm이나 yarn을 통해 설치할 수 있다.

```ts
import * as reactPlugin from 'vite-plugin-react'
import basicSsl from "@vitejs/plugin-basic-ssl";
import type { UserConfig } from 'vite'

const config: UserConfig = {
  jsx: 'react',
  plugins: [reactPlugin, basicSsl()],
  https: true,
}

export default config
```

fetch를 사용할 때 쿠키를 받거나 보내기 위해서는 추가적인 설정이 필요하다. axios 등 다른 라이브러리에서 필요한 설정도 쉽게 찾을 수 있을 것이다.

```ts
fetch("https://api.api/auth/login", {
  ...
  // 응답의 Set-Cookie 헤더가 작동하기 위한 설정
  credentials: "include",
});
/* ... */
fetch("https://api.api/auth/login", {
  ...
  // 요청의 Cookie 헤더에 리프레시 토큰을 넣기 위한 설정
  credentials: "include",
});
```

참고로 리프레시 토큰의 값을 js로 읽는 것은 불가능하다. 크롬의 경우 개발자도구의 네트워크 탭에서 각 요청/응답의 쿠키를 확인하거나, 어플리케이션 탭에서 저장되어있는 쿠키의 값을 찾아볼 수 있다.
작년에 여러 시행착오를 거치며 다듬어진 API이기 때문에 대체로 잘 작동할 것으로 예상되지만, 잘 작동하지 않는다면 (특히 이번 과제의 경우) 적극적으로 질문하도록 한다.
