Seminar1 Assignment
================================

### **due: 2023.10.07 (토) 24:00**

## 과제 목적
- 가장 많이 사용하게 될 컴포넌트인 UITableView과 관련 API에 익숙해집니다.
- Delegate 패턴과 MVVM 패턴에 익숙해집니다.
- 데이터를 관리하기 위한 방법에 대해 고민해보는 시간을 가져봅니다.
- 구글링에 더 익숙해집니다.

## 과제 - 미리알림 클론코딩하기

아래와 같이 동작하는 앱을 만들어주세요.

<img width="300" alt="Todo" src="./static/demo.gif">

### "할 일" 화면
- [ ] 데이터가 없는 경우에는 "미리 알림 없음"이라고 적힌 화면을 표시합니다.
- [ ] "미리 알림 없음" 화면을 탭하면 제목이 빈 문자열(`""`)인 새로운 미리 알림 항목이 나타나야 합니다.
  - 힌트: `UITapGestureRecognizer`를 사용해보세요.
- [ ] 각 미리 알림 항목에는 `UITextField`로 구현된 `title`과 `memo` 필드가 있으며, 터치해서 직접 수정할 수 있습니다.
- [ ] 테이블뷰 하단의 여백을 탭하면 새로운 미리 알림 항목이 나타나야 합니다.
  - 힌트: 마찬가지로 `UITapGestureRecognizer`를 사용할 수 있어요. 탭한 지점의 y 좌표(`location.y`)가 `tableView.contentSize.height` 보다 크다면 여백을 탭했다고 볼 수 있을 것 같아요.
- [ ] `title`이 빈 문자열인 상태에서 키보드가 내려가면 해당 미리 알림 항목은 삭제되어야 합니다.
- [ ] `title`을 수정 중인 상태에서, 키보드로 Return 을 탭하면 새로운 미리 알림 항목이 나타나며, 키보드 커서도 새 항목의 `title` 필드로 이동해야 합니다.
- [ ] `memo`가 빈 문자열이거나 `nil`이 아니라면, 메모는 항상 표시해야 합니다.
- [ ] `memo`가 빈 문자열이거나 `nil`이라면, 해당 미리 알림 항목을 수정중인 경우(=`title` 필드 또는 `memo` 필드에 커서가 있는 경우)에만 메모를 표시합니다.
  - 힌트: `memo` 필드가 선택적으로 보이기 때문에,  `title`과 `memo`를 `UIStackView` 안에 넣으면 UIKit이 Auto Layout을 자동으로 관리해줘서 편리해요.
  - 힌트: 셀별로 높이가 동적으로 변화하는 테이블뷰를 구현해야 하는데, `UITableView.automaticDimension`를 키워드로 해서 검색해보세요.
- [ ] 왼쪽 동그라미 이미지를 탭하여 완료 상태를 변경할 수 있으며, 완료된 미리 알림의 `title` 필드는 어두운 색으로 변경됩니다.
- [ ] 키보드를 아래쪽으로 드래그하면 interactive하게 키보드가 내려가도록 해주세요.
  - 힌트: 동그라미 이미지는 SF Symbol을 사용하여 추가할 수 있습니다. `UIImageView SF Symbol`이라고 구글링해보세요. 제가 사용한 심볼 이미지는 각각 `circle`, `circle.inset.filled` 입니다.
- [ ] 셀을 왼쪽으로 스와이프해서 삭제할 수 있습니다.
- [ ] 앱을 종료하고 다시 시작해도 마지막으로 저장된 미리 알림 항목들이 표시되도록 구현해주세요.

## 구현 체크 리스트
- [ ] **[중요]** 데이터 저장, 조회, 변경은 별도의 ViewModel 객체에서 관리하도록 구현해주세요. ViewController는 절대 데이터를 들고 있어선 안됩니다.
- [ ] Storyboard를 사용하지 않고 코드로만 뷰를 구성해주세요.
  - [참고 자료](https://medium.com/@yatimistark/removing-storyboard-from-app-xcode-14-swift-5-2c707deb858)
- [ ] 모든 뷰에는 오토 레이아웃이 적용되어 있어야 합니다.

## 동적으로 높이가 변하는 셀을 구현하려면?

`UITableView.automaticDimension`을 사용하면 셀이 렌더링되는 시점에 UIKit이 해당 셀에 얼만큼의 높이를 부여할지 정하게 됩니다. 이번 과제를 예로 들면, `title`과 `memo`가 포함된 `UIStackView`의 크기가 셀의 높이에 결정적인 요인이 되겠죠? 하지만 UIKit이 `UIStackView`의 높이를 제대로 계산할 수 있게 하려면, `UITableViewCell.contentView`의 4방향 anchor가 내부 Subview들과 어떻게든 맞닿아 있어야 해요. 그래야만 UIKit이 제약 조건들의 해를 잘 구해서 높이를 결정할 수 있거든요.

두 번째로 유의할 점은, 위 방식대로 구현하면 셀이 렌더링되는 시점에는 높이가 잘 반영이 되지만, 셀이 이미 렌더링된 이후에 높이가 변하는 경우(e.g. `memo` 텍스트 필드가 보이거나 숨겨지는 경우)에는 높이를 제대로 업데이트해주지 않아요. 이 문제를 해결하려면 아래 두 가지 방법이 있습니다.
1. [reloadRows(at:with:)](https://developer.apple.com/documentation/uikit/uitableview/1614935-reloadrows)를 호출하여 해당 셀을 다시 렌더링하기
   - 자매품: `beginUpdates()`, `endUpdates()`, `performBatchUpdates(_:completion)`
2. iOS 16에서 추가된 self-resizing 방법을 이용하기 ([영상 링크](https://developer.apple.com/videos/play/wwdc2022/10068/?time=1145))
   - 요약하자면 높이를 업데이트해야 할 때마다 Cell 안에서 `invalidateIntrinsicContentSize()`를 호출하라는 내용입니다.

어떤 방식을 사용할지는 여러분의 자유이지만, 후자 방식이 훨씬 직관적이고 사용하기 편리할 것 같네요! :)

## 기타 유의사항
- 코드를 깔끔하게 관리해주세요. 하나의 함수/파일/클래스는 하나의 일만 해야 합니다.
- 스펙 설명이 모호한 부분이 있다면 iOS 미리 알림 앱의 동작을 따라 구현해주세요.
- 체크리스트에 포함된 내용만 채점할 예정입니다. 그 외 부분은 자유롭게 구현해주세요.
- 스펙이 변경될 경우에는 슬랙 채널을 통해 공지하겠습니다.
- 디자인은 스펙을 벗어나지 않는 범위 내에서 자유롭게 구현해주셔도 좋습니다.

## 참고 키워드
1. UITextFieldDelegate
2. UITableViewDelegate
3. UITableView Dynamic Height / automaticDimension
4. keyboardDismissMode
5. UITableViewDataSource
6. SF Symbol
7. UIImage / UIImageView
8. becomeFirstResponder / isFirstResponder
9. UIStackView
10. UITapGestureRecognizer
11. SnapKit
12. UITableViewCell