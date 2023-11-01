Seminar2 Assignment
================================

### **due: 2023.10.28 (토) 24:00**

## 과제 목적
- UICollectionView과 DiffableDataSource의 사용 방법을 이해합니다.
- Combine의 Operator를 적용하여 복잡한 스펙을 구현할 수 있습니다.

## 과제 - 넷플릭스 만들기

[TMDB API](https://developer.themoviedb.org/reference/intro/getting-started)를 활용하여 아래와 같이 동작하는 앱을 만들어주세요.

<video width="393" alt="Netflix" src="https://github.com/wafflestudio/seminar-2023/assets/33917774/fdb708ab-1b96-46b8-9c31-20822070aeec"></video>

### Now Playing

> **주의**
>
> Now Playing API를 사용할 때, 여러 페이지에 걸쳐서 중복된 영화가 나타나는 경우가 종종 발생하는 것 같습니다. UI가 비정상적으로 동작하는 것을 방지하려면 직접 중복된 영화를 제거해주어야 합니다.

- [ ] `UITabBarController`를 사용하여 하단에 탭을 추가해주세요.
- [ ] `UICollectionViewFlowLayout` 또는 `UICollectionViewCompositionalLayout`를 사용하여 UICollectionView를 구성해주세요. 레이아웃 구성은 자유입니다.
  - (참고) `UICollectionViewCompositionalLayout`을 사용하여 각 섹션별로 `orthogonalScrollingBehavior`를 적용하면 넷플릭스 앱과 유사한 레이아웃을 구성할 수 있습니다. 이와 같이 레이아웃을 구성할 경우 Grace Day 3일 부여하겠습니다.
- [ ] 각 Cell에는 포스터와 제목이 반드시 포함되어야 합니다.
- [ ] `GET https://api.themoviedb.org/3/movie/now_playing` API를 사용하여 현재 상영중인 영화의 목록을 보여주세요.
- [ ] 아래로 스크롤할 경우 자연스럽게 Pagination이 이루어지도록 구현해주세요.
- [ ] `UICollectionView`를 업데이트할 때에는 `DiffableDataSource`와 `Combine`을 함께 사용해주세요. `reloadData` 등 `UICollectionView`를 직접 업데이트하는 메서드는 **호출해서는 안됩니다**.
- [ ] 스크롤할 때 이미지 렌더링, API 호출 등으로 인한 버벅임이 없어야 합니다.
- [ ] 스크롤할 때 셀 재사용, 비동기 호출로 인해 셀의 내용이 갑자기 바뀌거나 정합성이 깨지는 경우가 없어야 합니다.
- [ ] 이미지를 렌더링하기 전에 다운샘플링을 해서 메모리 사용량이 너무 높아지지 않도록 주의해주세요.

### Search
- [ ] navigationController에 `UISearchController`를 추가해주세요.
- [ ] 유저가 검색창에서 타이핑하면 위에서 구현한 `UICollectionView`가 검색 결과에 맞게 자동으로 업데이트되어야 합니다.
- [ ] 유저가 타이핑할 때 과도한 API 호출이 발생하지 않도록, 적절한 간격으로 `debounce`를 걸어주세요.
- [ ] 검색 결과를 업데이트할 때는 마찬가지로 `Combine`과 `DiffableDataSource`를 사용해주세요.
- [ ] 취소 버튼을 누르면 다시 `Now Playing` API 첫 번째 페이지의 데이터를 불러와야 합니다.
- [ ] 검색 도중에는 Pagination을 구현하지 않아도 괜찮습니다.
 
## 구현 체크 리스트
- [ ] Swift Concurrency의 `async/await` 문법을 사용해주세요.
- [ ] UI 관련 코드는 Main Thread(`@MainActor`)에서만 실행되도록 유의해주세요.
- [ ] **[중요]** 데이터 저장, 조회, 변경은 별도의 ViewModel 객체에서 관리하도록 구현해주세요. ViewController는 절대 데이터를 들고 있어선 안됩니다.
- [ ] Storyboard를 사용하지 않고 코드로만 뷰를 구성해주세요.
  - [참고 자료](https://medium.com/@yatimistark/removing-storyboard-from-app-xcode-14-swift-5-2c707deb858)
- [ ] 모든 뷰에는 오토 레이아웃이 적용되어 있어야 합니다

## 기타 유의사항
- 코드를 깔끔하게 관리해주세요. 하나의 함수/파일/클래스는 하나의 일만 해야 합니다.
- 체크리스트에 포함된 내용만 채점할 예정입니다. 그 외 부분은 자유롭게 구현해주세요.
- 스펙이 변경될 경우에는 슬랙 채널을 통해 공지하겠습니다.
- 디자인은 스펙을 벗어나지 않는 범위 내에서 자유롭게 구현해주셔도 좋습니다.

## 참고 키워드
1. Combine
   - CurrentValueSubject
   - PassthroughSubject
   - debounce
2. UICollectionView
   - UICollectionViewDiffableDataSource
   - NSDiffableDataSourceSnapshot
   - UICollectionViewDelegateFlowLayout
3. UISearchController
