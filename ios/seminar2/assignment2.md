Seminar2 Assignment
================================

### **due: 2023.10.28 (토) 24:00**

## 과제 목적
- Swift Concurrency를 사용하여 REST API를 호출하는 방법을 익힙니다.
- UITableView를 비동기 데이터와 함께 사용하는 법을 배웁니다.
- 여러 Section으로 이루어진 UITableView를 구현해봅니다.
- Pagination의 구현 방법을 이해합니다.

## 과제 - 넷플릭스 만들기

[TMDB API](https://developer.themoviedb.org/reference/intro/getting-started)를 활용하여 아래와 같이 동작하는 앱을 만들어주세요.

<video width="393" alt="Netflix" src="https://github.com/wafflestudio/seminar-2023/assets/33917774/a7f43d28-5538-42d9-bca6-aacb79bff759"></video>

### New & Hot 화면
- [ ] `UITabBarController`를 사용하여 하단에 탭을 만들어주세요. 이번 과제에서는 하나의 탭만 존재하지만, 다음 과제에서 새로운 탭이 추가될 예정입니다.
- [ ] New & Hot 화면은 하나의 `UITableView`로 이루어져 있으며, 다시 2개의 Section으로 나뉘어집니다.
  - 첫 번째 Section은 [Upcoming API](https://developer.themoviedb.org/reference/movie-upcoming-list), 두 번째 Section은 [Popular API](https://developer.themoviedb.org/reference/movie-popular-list)를 사용해주세요.
- [ ] 각 Section의 제목을 `UITableViewHeaderFooterView`를 사용해서 적절히 표시해주세요.
- [ ] 각 Section별로 Pagination을 구현해야 합니다. 최대 3페이지까지만 보여주도록 구현해주세요. 즉, Upcoming Movies 1 ~ 3페이지에 이어서 Popular Movies 1 ~ 3페이지 순서로 나타나야 합니다.
- [ ] 각 영화를 나타내는 셀에는 `title`, `overview`가 표시되어야 합니다.
- [ ] 각 영화는 키워드 목록을 갖고 있습니다. [Keywords API](https://developer.themoviedb.org/reference/movie-keywords)를 활용해서 영화의 키워드를 보여주세요.
  - [ ] 한 번에 모든 영화의 모든 키워드를 불러오는 방식으로 구현해서는 안됩니다. 셀이 렌더링되는 시점에 API 호출을 시작해주세요.
  - [ ] 키워드 목록이 불러와지면 그만큼 셀의 높이가 더 커져야 합니다 (영상 참고).
  - [ ] 한 영화에 대해서 불러온 키워드 목록은 메모리상에 캐싱되어야 합니다. 즉, 이미 렌더링한 적이 있었던 셀에 대해서는 API를 중복 호출하지 않도록 해주세요(=딜레이 없이 즉시 표시되어야 합니다).
  - [ ] Keyword API를 호출하는 도중에 사용자가 스크롤을 해서 셀이 재사용되었을 때, 진행중이던 Task는 적절히 취소되어야 합니다.
- [ ] 스크롤할 때 이미지 렌더링, API 호출 등으로 인한 버벅임이 없어야 합니다.
- [ ] 스크롤할 때 셀 재사용, 비동기 호출로 인해 셀의 내용이 갑자기 바뀌거나 정합성이 깨지는 경우가 없어야 합니다.
- [ ] 이미지를 렌더링하기 전에 다운샘플링을 해서 메모리 사용량이 너무 높아지지 않도록 주의해주세요.
 
## 구현 체크 리스트
- [ ] Swift Concurrency의 `async/await` 문법을 사용해주세요.
- [ ] UI 관련 코드는 Main Thread(`@MainActor`)에서만 실행되도록 유의해주세요.
- [ ] **[중요]** 데이터 저장, 조회, 변경은 별도의 ViewModel 객체에서 관리하도록 구현해주세요. ViewController는 절대 데이터를 들고 있어선 안됩니다.
- [ ] Storyboard를 사용하지 않고 코드로만 뷰를 구성해주세요.
  - [참고 자료](https://medium.com/@yatimistark/removing-storyboard-from-app-xcode-14-swift-5-2c707deb858)
- [ ] 모든 뷰에는 오토 레이아웃이 적용되어 있어야 합니다

## 기타 유의사항
- 코드를 깔끔하게 관리해주세요. 하나의 함수/파일/클래스는 하나의 일만 해야 합니다.
- 스펙 설명이 모호한 부분이 있다면 iOS 미리 알림 앱의 동작을 따라 구현해주세요.
- 체크리스트에 포함된 내용만 채점할 예정입니다. 그 외 부분은 자유롭게 구현해주세요.
- 스펙이 변경될 경우에는 슬랙 채널을 통해 공지하겠습니다.
- 디자인은 스펙을 벗어나지 않는 범위 내에서 자유롭게 구현해주셔도 좋습니다.

## 참고 키워드
1. UITableView Pagination
2. Swift Concurrency - Task Cancellation
3. Kingfisher
4. Alamofire
