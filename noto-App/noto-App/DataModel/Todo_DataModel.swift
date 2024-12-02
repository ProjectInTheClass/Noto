import SwiftUI

// Todo 데이터 모델
struct Todo: Identifiable {
  let id = UUID()
  let imageName: String
  let title: String
  let tag: Int // 0: 회의, 1: 개발
  let url: String
  let startDate: Date
  let endDate: Date
  let subtitle: String
}

// Todo 더미데이터
let todolist: [Todo] = [
  Todo(imageName: "user",
       title: "메인화면 레이아웃 설계 및 구현",
       tag: 1,
       url: "https://www.google.com",
       startDate: dateFormatter.date(from: "2024-10-01 14:00")!,
       endDate: dateFormatter.date(from: "2024-11-10 23:59")!,
       subtitle: "할 일 목록을 표시하는 메인 화면의 레이아웃을 설계하고 구현.목록은 동적으로 할 일 항목을 추가하거나 삭제할 수 있는 기능을 고려해 설계. SwiftUI 또는 UIKit을 사용하여 화면 배치를 완료"),
  Todo(imageName: "user",
       title: "할일 추가 기능 UI 구현",
       tag: 1,
       url: "https://github.com/ProjectInTheClass/Noto",
       startDate: dateFormatter.date(from: "2024-10-01 14:00")!,
       endDate: dateFormatter.date(from: "2024-11-05 23:59")!,
       subtitle: "할 일 목록을 표시하는 메인 화면의 레이아웃을 구현. 사용자가 쉽게 할 일을 추가할 수 있는 위치에 배치하고, 추가 버튼을 눌렀을 때 텍스트 필드가 비어있는지 확인하는 로직도 포함."),
  Todo(imageName: "user",
       title: "할 일 완료 기능 UI 구현",
       tag: 1,
       url: "https://www.apple.com/kr/store",
       startDate: dateFormatter.date(from: "2024-10-01 14:00")!,
       endDate: dateFormatter.date(from: "2024-11-12 23:59")!,
       subtitle: "할 일을 완료하면 체크박스를 클릭하여 완료 상태를 표시하는 기능을 구현. 체크박스를 클릭하면 해당 항목이 리스트에서 표시되거나 스타일이 변경되도록 설정"),
  Todo(imageName: "user",
       title: "할 일 삭제 기능 구현",
       tag: 1,
       url: "https://developer.apple.com/kr/design/human-interface-guidelines/gestures",
       startDate: dateFormatter.date(from: "2024-10-01 14:00")!,
       endDate: dateFormatter.date(from: "2024-11-05 23:59")!,
       subtitle: "사용자가 할 일을 삭제할 수 있는 기능을 구현. 각 할 일 항목에 삭제 버튼을 추가하고, 사용자가 클릭 시 해당 항목을 삭제하도록 구현"),
  Todo(imageName: "user",
       title: "앱 전반적인 UI 스타일링",
       tag: 0,
       url: "https://developer.apple.com/kr/design/human-interface-guidelines/",
       startDate: dateFormatter.date(from: "2024-10-01 14:00")!,
       endDate: dateFormatter.date(from: "2024-11-30 23:59")!,
       subtitle: "앱의 전반적인 UI 스타일링을 정리하고, IOS 디자인 가이드라인에 맞게 사용자 경험을 개선. 색상, 버튼 스타일, 폰트 크기 등을 조정하여 앱의 일관성을 유지")
]
