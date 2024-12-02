import SwiftUI

// Request 데이터 모델
struct Request: Identifiable {
  let id = UUID() // 고유 ID
  let sender: String
  let role: String
  let title: String
  let subtitle: String
  let dateSent: Date
}

let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "yyyy-MM-dd HH:mm"
  return formatter
}()

// Request 더미데이터
let requests: [Request] = [
  Request(sender: "김지민",
          role: "관리자",
          title: "새로운 할 일 배정",
          subtitle: "할 일 추가: '할 일 완료 체크 기능 구현' 작업에 배정되었습니다. 이 작업을 수락하시겠습니까?",
          dateSent: dateFormatter.date(from: "2024-11-10 14:00")!),
  Request(sender: "한나리",
          role: "참가자",
          title: "프로젝트 참여 요청",
          subtitle: "'iOS 앱 테스트' 프로젝트에 배정되었습니다. 이 프로젝트에 참여하시겠습니까?",
          dateSent: dateFormatter.date(from: "2024-10-12 15:30")!),
  Request(sender: "임진우",
          role: "참가자",
          title: "할 일 수정 요청",
          subtitle: "'할 일 삭제 기능 구현' 작업의 기한이 변경되었습니다. 수정된 기한을 수락하시겠습니까?",
          dateSent: dateFormatter.date(from: "2024-10-11 16:00")!),
  Request(sender: "김지민",
          role: "관리자",
          title: "프로젝트 파일 검토 요청",
          subtitle: "프로젝트 'iOS Todo 앱'의 문서 검토 요청이 왔습니다. 검토 후 승인하시겠습니까?",
          dateSent: dateFormatter.date(from: "2024-10-10 09:11")!),
  Request(sender: "한나리",
          role: "참가자",
          title: "할 일 우선순위 변경 요청",
          subtitle: "현재 작업 중인 'UI 스타일링' 작업의 우선순위가 변경되었습니다. 이를 수락하시겠습니까?",
          dateSent: dateFormatter.date(from: "2024-10-09 23:54")!),
]
