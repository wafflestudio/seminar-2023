---
marp: true
paginate: true
---
<!-- _class: lead -->
<style>
section {
  justify-content: flex-start;
}
section.lead {
  justify-content: center;
}
section.lead > h1 {
  font-size: 3rem;
}
ul {
  margin-bottom: 1rem;
}
section > div.vs {
  display: flex;
  gap: 0.5rem;
}
section > div.vs > - {
  flex: 1;
}
</style>

<!-- _class: lead -->

# Waffle Studio <br>Frontend Seminar - 4

---
# Contents

- 개발 mindset
- 리액트 심화
  - immutable
  - ref
  - 제어 비제어 컴포넌트
- 정적 타입 검사
- 브라우저 렌더 원리
- CSS 심화

---
# 개발 mindset

구현하는 방법은 실컷 배웠으니,

이제 정말 중요한 이야기들을 해 보겠습니다

---
# 개발자?

만들어내는 사람!

![w:700](img/React%20Seminar%2040.png)

---
# 개발에 임하는 자세

1순위: “만들어내는 것”

2순위: “성능의 하한”

3순위: “더 나은 구조”

---
# 1순위: 만들어내는 것

당연하게도 가장 중요한 건 일단 클라이언트 (혹은 본인)의 요청대로  __돌아가게 만들어내는__  것

일단 만들어내야 그 다음에 성능이든 뭐든 논할 수 있음

---
# 2순위: 성능의 하한

기능은 작동하지만 성능이 끔찍하다면?

옷 사려고 쇼핑몰에 접속하는데 30초가 걸린다면?

내가 만든 페이지가 서버에 쓸데없는 요청을 너무 많이 보내서 서버비가 너무 많이 나온다면?

결과물의 의미를 살리기 위해 성능이 괜찮은 결과물을 만들어내야 한다

---
# 3순위: 더 나은 구조

- 사실 성능과도 밀접한 연관이 있지만
- 다른 사람들과 함께 구현한다면?
- 나중에 이 페이지를 계속 유지하고 보수해서 발전시켜야 한다면?
  - 구조가 부적절하면 스노우볼이 굴러감
- 구조가 좋지 않으면 개발하는 데 시간이 많이 소요됨

---
# (4순위: 더 나은 성능)

먼지 한 톨까지 최적화하고 싶은 마음 충분히 이해합니다

하지만 이상한 짓만 안하면 요즘 세상에 성능은 웬만큼 나옵니다

일단 괜찮은 구조를 만들어낸 다음에

서비스의 성장이나 생각치 못한 코너케이스로 성능저하가 생기면

그때 가서 최적화해도 늦지 않습니다

---
# 개발을 배우는 자세

어떻게

왜

> 좋은 개발자는 어떻게 작동하는지 아는 개발자이고,
> 훌륭한 개발자는 왜 그렇게 작동하는지 아는 개발자이다.

---
# 어떻게 작동할까?

- 자바스크립트 이벤트 루프

- useEffect의 동작 순서

- 컴포넌트가 렌더될 때 일어나는 일

- 브라우저 렌더와 리액트 컴포넌트 렌더의 차이

제대로 작동하는 코드를 구현하기 위해 꼭 필요한 단계
개발을 하기 위한 최소치

---
# 왜 그렇게 작동할까?

- 왜 html의 구조가 그렇게 디자인됐을까?

- 왜 http를 사용할까?

- 왜 리액트가 flux로 디자인됐을까?

- JWT 토큰 말고는 어떤 인증 방식이 있을까?

- 왜 url은 그렇게 생겼을까?

- 기술의 탄생 배경과 탄생 이유를 이해하는 단계

어떻게 작동하는지 이해하면 그냥 코더지만,
이걸 이해하고서부터는 좋은 개발자가 된다고 합니다

---
# 과제

사실 어떻게 돌아갈까에 대한 부분이 과제에서 자연스럽게 잡혀야 하는데, 프론트엔드는 막 짜도 “돌아는” 가기 때문에..

Discussion 적극적으로 활용하셔서 “이게 뭘까”, “이게 맞나” 에 대한 부분을 같이 고민하면 좋을 것 같아요

---

<!-- _class: lead -->

# 리액트 심화

잡다하고 중요하고 어렵고 재밌는 것들

immutable, ref, controlled

---

<!-- _class: lead -->
# immutable
## 불변성

immutable이 왜 중요할까


---
# 왜 후자로 짜라고 할까

![](img/React%20Seminar%2041.png)

![](img/React%20Seminar%2042.png)

---
# 가변성? 불변성?

변할 수 있는가?

![](img/React%20Seminar%2043.png) ![](img/React%20Seminar%2044.png)

---
# 프로그래밍에서 불변성이 중요한 이유

- 불변성을 지키면 값이 “예측 가능”해짐
- 내가 사용할 변수의 값에 대한 확신
  - 선언될 때 이후로 변경된 적이 없으므로, 그 변수에 무슨 일이 일어났는지 체크하지 않아도 됨
- 내가 무슨 짓을 해도  <span style="color:#388E3C">다른 부분 코드에 영향을 주지 않을 거</span> 라는 확신
  - 변수의 값을 변경할 일이 없으므로, 값을 이렇게 변경했다가 다른 부분에서 이 값을 사용하면 어쩌지? 하는 고민을 하지 않아도 됨
- 때문에 개발 테스트 로드가 줄고, 생산성이 올라감
- JS뿐 아니라 어떤 언어에서든 대규모 프로젝트일수록 중요해지는 개념

__“내가 만들어둔 / 보고 있는 이 친구는 선언된 이후로 바뀌지 않았고, 앞으로도 바뀌지 않을 거야.”__

---
# React에서의 불변성과 얕은 비교

- 리액트에서는 불변성을 아주 중요한 컨셉으로 잡고, 대놓고 “불변성을 유지해야만 잘 작동하도록” 디자인
- ★ 리액트에서 개발자에게 요구하는 불변성에 대한 가정  ( <span style="color:#C53929"> __중요.__ </span> )
  - 객체의 주소가 같다면 무조건 내부의 값이 모두 같다고 가정해 버리겠다
  - 이를 통해 객체를 비교할 때 내부 값이 아니라, 객체 주소만 이용해 비교할 수 있다 (얕은 비교) -> 성능 향상
- 얕은 비교가 이루어진다는 증거
  - .state = 2;. 이런 식으로 state 객체의 값을 바꿀 경우 render되지 않음
  - 심지어 setState에 기존 state 객체에서 값만 바꾼 걸 집어넣을 경우에도 render되지 않음
- Virtual DOM 이 가능한 이유이기도 합니다

---
# React에서의 불변성과 얕은 비교
![](img/React%20Seminar%2045.png)

---
# React에서의 불변성

따라서 React 코드를 짤 때는 항상 불변성을 생각하며  <span style="color:#FF0000">거의 모든 것을 immutable하게</span>  구현해야 합니다.

전혀 혼동의 여지가 없는 경우라면 가끔은 불변성을 무시해도 되겠지만… 99%는 불변적으로 해결할 수 있습니다.

- 지양해야 하는 친구들
  `splice`, `push`, `assign`, `=`, ...

- 좋은 친구들
  `map`, `filter`, `concat`, spread, ..

---
# React에서의 불변성
예외적으로 불변성 무시해도 되는 경우의 대표적인 예시:

![](img/React%20Seminar%2046.png)

- `fold`로 짤 수도 있겠지만 이게 훨씬 더 깔끔
- 이 예제에서도 여전히 함수 안에서만 오브젝트를 수정한다
  - 함수 밖에서 온 오브젝트를 수정하거나, 수정되는 오브젝트를 함수 밖으로 내보내지 않음

---
# 요약

불변성을 유지하면서 짜야 한다.

특히 리액트에서는 불변성을 아주 중요하게 생각해야 한다.

---

<!-- _class: lead -->
# Ref

리액트에서 state만으로 해결할 수 없는 것들

---
# Ref란?

가끔 state와 props만으로는 구현할 수 없는 것들이 있음

- input 자동 포커스

- DOM 자동 스크롤

- DOM 노드의 크기 가져오기

이런 식으로  DOM에 직접적인 조작을 가할 때 ref를 사용

- document.getElementById 등은 NEVER

---
# Ref 사용하는 법

JSX단에서 노드에 ref 속성을 지정

예시: 전화번호 입력창 (examples/ref.tsx)

- useRef() 로 ref 생성해서 전달
  ```ts
  const inputRef = useRef<HTMLInputElement>(null);
  return <div>
    <input ref={inputRef} />
    <button onClick={() => inputRef?.focus()}>포커스</button>
  </div>
  ```
- 콜백 형태로 ref 전달 -- DOM 요소가 마운트 또는 언마운트될 때 호출됨

---
# Ref 사용하는 법

- 주의: div 등의 JSX 태그가 아닌 함수 컴포넌트에는 ref를 지정할 수 없다.
  함수 컴포넌트 속의 *어떤* 태그의 DOM 요소를 리턴할 것인가?
- ref를 props로 전달하는 것은 가능
  ```ts
  function Child({ inputRef }) {
    return <input ref={inputRef} />;
  }
  function Parent() {
    const ref = useRef(null);
    return <Child inputRef={ref} />;
    // ref를 통해 Child의 input에 접근할 수 있다
  }
  ```

---
# Ref 응용하기

ref를 응용하면 react에서 mutable한 객체를 다루고 싶을 때 사용 가능
- 앞서 설명했듯이 리액트는 immutable을 기본 원칙으로 가지므로, 특성상 render가 다시 되면 모든 값이 날라가고 다시 접근할 수 없어짐
- 때문에 항상 유지되는 mutable한 하나의 ‘저장소'가 없음

ref 객체의 current (`myRef.current`)에는 mutable한 값을 넣을 수가 있다
- 이를 응용해서 재렌더가 필요하지 않은 값(e. g. setTimeout handle)을 담을 수 있다: [(예시)](https://overreacted.io/making-setinterval-declarative-with-react-hooks/)

---
# Ref 응용하기

ref를 사용하면 React가 만들어준 불변성의 낙원에서 쫓겨나게 된다
- 앱의 상태가 어떻게 변할지, 언제 렌더링을 일으켜야 할지 고민해야 한다

> 칸토어는 우리를 위해 무한이라는 낙원을 만들고 갔다. 그 무엇도 우리를 이 낙원에서 쫒아낼 수 없을 것이다 -- 다비드 힐베르트

---
# 정리

DOM에 직접 접근하고 싶은 경우 ref 속성을 활용할 수 있음

mutable한 객체를 사용하고 싶은 경우 ref 객체를 활용할 수 있음

ref를 사용할 때는  <span style="color:#FF0000">코드 구조에 신경을 써서 신중하게 </span> 사용해야 함

---

<!-- _class: lead -->

# 제어 vs 비제어 컴포넌트
## 왜 제어 컴포넌트를 쓰라고 할까

공식문서 (꼭 읽어보세요.)

[제어 컴포넌트](https://ko.reactjs.org/docs/forms.html#controlled-components)

[비제어 컴포넌트](https://ko.reactjs.org/docs/uncontrolled-components.html)

---
# 지금까지 인풋을 관리하는 방법

state에 인풋을 놔두고 onChange에서 setState

귀찮게 왜?

과제 0때는 버튼 눌렀을 때 DOM 접근해서 해냈는데
왜 리액트는 귀찮게 state를 쓰라고 할까

<div style=position:absolute;right:0;top:200px>

![](img/React%20Seminar%2048.png)

</div>

---
# 인풋을 관리하는 두 가지 방식

![](img/React%20Seminar%2049.png)

![](img/React%20Seminar%20410.png)

---
# 인풋을 관리하는 두 가지 방식 (full version; controlled)

```ts
const App = () => {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const handleSubmit: FormEventHandler = (e) => { 
    e.preventDefault();
    console.log(username);
    console.log(password);
  };
  return (
    <form onSubmit={handleSubmit}>
      <input value={username} onChange={(e) => setUsername(e.target.value)} />
      <input value={password} onChange={(e) => setPassword(e.target.value)} />
      <button>로그인</button>
    </form>
  );
};
```

---
# 인풋을 관리하는 두 가지 방식 (full version; **un**controlled)

```ts
const App = () => {
  const loginRef = useRef<HTMLFormElement>(null);
  const handleSubmit: FormEventHandler = (e) => {
    e.preventDefault();
    console.log(loginRef.current.username.value);
    console.log(loginRef.current.password.value);
  }
  return (
    <form ref={loginRef} onSubmit={handleSubmit}>
      <input name="username" />
      <input name="password" />
      <button>로그인</button>
    </form>
  );
}
export default App;
```

---
# 제어 vs 비제어

- 제어 컴포넌트
  - state를 이용해 값을 관리
  - 값 변경 시 state를 set하고 재렌더링
  - 이벤트 발생 시 state에 저장된 값에 접근
- 비제어 컴포넌트
  - 데이터를 브라우저 DOM이 가지고 있음
  - 값 변경도 DOM에 저장됨 (재렌더링 없음)
  - 이벤트 발생 시 DOM이 가지고 있는 데이터를 땡겨옴

---
# 제어 vs 비제어: 왜 제어 컴포넌트를 쓰라고 할까?

- 써보면 확실히 느껴지는데,
  - 사용할 수 있는 기능이 많아짐
    - 제어 컴포넌트가 훨씬 다양한 기능을 사용할 수 있습니다 (가령 핸드폰 번호 입력 시 자동 포맷)
  - react의 철학에 부합합
    - flux 패턴에 의해 한 상태에 대해 하나의 값이 동일해야 하고, 흘러내리는 데이터를 보여줘야 하기 때문에 제어가 더 적합함
  - 리팩토링할 때 훨씬 편함
- 그럼 결국 제어를 쓰라는 건데 비제어는 왜 알려주시나요?
  - 파일 인풋은 비제어 없이 구현 못합니다
  - 간혹 성능상의 이유로 비제어 컴포넌트를 사용하는 게 나을 수 있습니다.

---
# 요약

하던 대로 제어 컴포넌트 쓰면 된다. 하지만 비제어도 알아야 한다.

---

<!-- _class: lead -->
# 브라우저 <br>렌더 원리

![right bg contain](img/React%20Seminar%20422.png)

---
# https://d2.naver.com/helloworld/59361

(꼭) 읽어보세요.

오늘은 여기 있는 내용 중 1% 정도 수업합니다

---
# 브라우저?

- 사용자가 요청한 주소 (URI)의 자원을 받아와 사용자에게 보여주는 소프트웨어
- 웹 표준에 따라 정해진 방식대로 HTML 등의 자원을 띄워 보여줌
- 크롬 사파리 엣지 이런 애들

---
# Step 1: 파일 로드

해당 url에 있는 파일 (우리의 경우 HTML이겠죠) 달라고 요청

HTML을 읽으면서 필요한 추가 파일들 요청해서 다운로드하면서 파싱

<div style=display:flex>

![](img/React%20Seminar%20424.png)

![](img/React%20Seminar%20425.png)

![](img/React%20Seminar%20426.png)

</div>

---
# Step 2: 파싱과 렌더 트리 구축

브라우저마다 조금씩 다름

HTML 파싱 -> DOM
CSS 파싱 -> CSSOM

![](img/React%20Seminar%20427.png)

---
# Step 2: 파싱과 렌더 트리 구축

Chrome 등이 사용하는 webkit 엔진의 렌더 과정
DOM과 CSSOM을 합침

![w:600](img/React%20Seminar%20428.png) ![](img/React%20Seminar%20429.png)

---
# Step 3: 배치

이제 트리가 있으니 그리기만 하면 됩니다

---
# 그럼 JS는요?

HTML을 파싱하다 보면 script 태그가 나오겠죠?

JS는 DOM을 변경할 수 있기 때문에, html 파서는 script가 나오면 파싱을 중단하고 JS가 다 로드되고 수행되기를 기다립니다

또한 CSSOM이 생성되기 전에 JS가 수행되면 오류가 발생할 수 있기 때문에, CSSOM이 생성될 때까지 JS는 수행되지 않습니다.

_즉 CSSOM이 JS의 수행을 block하고, JS의 수행은 html DOM 생성을 block합니다._

---
# CSS와 JS를 각각 어디에 배치해야 할까?

JS는 DOM 생성을 중단하고 로드됨

CSSOM은 JS 수행을 중단함

즉 CSS는 최대한 빨리, JS는 최대한 늦게 로드해야 “렌더링이 시작되는 시점"을 앞당길 수 있음

따라서  보통 CSS는 head에, JS는 body 태그 맨 밑에 배치

CRA 쓰면 빌드할 때 이 정도는 자동으로 해 줍니다

---
# CSS Advanced



CSS Modules
SASS
CSS-in-JS

---
# 지금까지의 CSS

![](img/React%20Seminar%20430.png)

- 선택자를 이용한 match
- 오타 검증 안됨
- className 중복되면 귀찮아짐
- 태그마다 className= 이거 달아주는거 가독성 X
- 복잡한 연산 불가
- 리팩토링할 때 어디까지 옮겨야 되는지 보는거 귀찮음
- 관리하기 빡셈
- 그냥 언어 자체가 어렵고 더러움
  - 그건..

![](img/React%20Seminar%20431.png)

---
# CSS를 더 편하게 쓰기 위한 다양한 기술들

CSS Modules

Sass

CSS-in-JS

![](img/React%20Seminar%20432.png)

---
# CSS Modules

CSS className이나 id를 고유하게 만들어주는 기술

선택자가 고유해지고 확실해지는 장점

오타에 대한 걱정이 크게 줄어듦

선택자 중복으로 인한 대참사 방지

---
# CSS Modules 코드

![](img/React%20Seminar%20433.png)

![](img/React%20Seminar%20434.png)

![](img/React%20Seminar%20435.png)

---
# SASS

![](img/React%20Seminar%20436.png)

CSS의 단점을 많이 개선한 CSS 전처리기

CSS에 더해 아주 많은 편리한 기능들을 제공

이건 예시를 보면 바로 이해됩니다

SASS 전처리기를 이용해서, 빌드 시에는 css로 자동 변환됨

대표주자: SCSS

---
# SASS 코드

![](img/React%20Seminar%20437.png)

![](img/React%20Seminar%20438.png)

![](img/React%20Seminar%20439.png)

---
# CSS-in-JS

CSS를 JS 안에서 사용하겠다.

모든 스타일이 변수로 연결되어 있기 때문에 유지보수가 아주 간편해짐

진짜 써보면 신세계입니다 코드 관리가 너무 편안하고 명확해져요

그래서 요즘 아주 유행하고 있습니다  _[(확인: npm trends)](https://www.npmtrends.com/styled-components)_

대표주자:  _[styled-components](https://styled-components.com/)_

![](img/React%20Seminar%20440.png)

---
# CSS-in-JS 코드

<span style="color:#434343">깔끔하죠</span>

<span style="color:#434343">하지만 치명적인 단점이 있는데</span>

<span style="color:#434343">다음 슬라이드에서 설명합니다</span>

![](img/React%20Seminar%20441.png)

---
# CSS-in-CSS vs CSS-in-JS (1)

CSS-in-CSS (css가 스타일을 담당하는 기존 방식)는 스타일이 CSS 안에 있음

![](img/React%20Seminar%20442.png)

![](img/React%20Seminar%20443.png)

![](img/React%20Seminar%20444.png)

CSS-in-JS는 스타일이 JS 안에 있음

![](img/React%20Seminar%20445.png)

![](img/React%20Seminar%20446.png)

- 앞서 공부한 브라우저 렌더 원리와 연결지어 보면?
- CSS는 html을 파싱할 때 로드된 이후 DOM 생성과 병렬적으로 파싱 및 분석됨
  - CSS가 커지면 병렬 딜레이
- JS는 html을 파싱할 때 로드되고 html 파싱을 중단하고 지가 먼저 로드됨
  - JS가 크면 직렬 딜레이
- 스타일 정보가 JS에 있다면 JS가 커진다
- 직렬 딜레이가 있으면 병렬 딜레이보다 느리다
- 정확한 삼단논법에 의해  __CSS-in-JS는 느리다__ 는 결론이 나옵니다.
- _[https://pustelto.com/blog/css-vs-css-in-js-perf/](https://pustelto.com/blog/css-vs-css-in-js-perf/)_  에 다르면 실제로 수백 ms 정도 느리다고 합니다

---
# 뭘 쓸까요?

- 일단 그냥 css를 쓰는 곳은 못 봤고
- 사용자에게 보여질 경우: CSS Modules + SCSS
  - 웹 최적화와 성능 등이 중요
  - 비교적 배포하는 빈도가 낮음
  - 개발이 좀더 오래 걸려도 제대로 만들어야 하는 것들
- 백오피스로 사용될 경우: styled-components
  - 빠른 개발속도가 중요
  - 피쳐가 자주 들어오고, 배포 빈도도 높음 (하루에도 몇 번씩)
  - 기획이 자주 변경되므로 유지보수를 잘 하는 게 중요하고, CSS 양도 적음
  - 보통 CSS를 직접 짜지 않고 semantic-ui 같은 거 갖다씀

---
# 요약

CSS Modules, Sass, CSS-in-JS 라는 기술들이 있다

CSS-in-JS는 코드 유지보수 측면에서 획기적으로 좋지만 성능이 비교적 나쁘다

---
# 과제

