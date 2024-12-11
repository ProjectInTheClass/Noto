import SwiftUI

// receivedRequest 데이터 모델
struct receivedRequest: Identifiable {
  let id = UUID() // 고유 ID
  let rid: Int
  let sender: String
  let role: String
  let title: String
  let subtitle: String
  let dateSent: Date
}

// sendedRequest 데이터 모델
struct sentRequest: Identifiable {
  let id = UUID() // 고유 ID
  let rid: Int
  let rejected: Int
  let receiver: String
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

// Request 더미데이터 (사용자가 받은 요청)
let receivedRequests: [receivedRequest] = [
  receivedRequest(rid: 0,
                  sender: "김지민",
                  role: "관리자",
                  title: "새로운 할 일 배정",
                  subtitle: "할 일 추가: '할 일 완료 체크 기능 구현' 작업에 배정되었습니다. 이 작업을 수락하시겠습니까?",
                  dateSent: dateFormatter.date(from: "2024-11-10 14:00")!),
  receivedRequest(rid: 1,
                  sender: "한나리",
                  role: "참가자",
                  title: "프로젝트 참여 요청",
                  subtitle: "'iOS 앱 테스트' 프로젝트에 배정되었습니다. 이 프로젝트에 참여하시겠습니까?",
                  dateSent: dateFormatter.date(from: "2024-10-12 15:30")!),
  receivedRequest(rid: 2,
                  sender: "임진우",
                  role: "참가자",
                  title: "할 일 수정 요청",
                  subtitle: "'할 일 삭제 기능 구현' 작업의 기한이 변경되었습니다. 수정된 기한을 수락하시겠습니까?",
                  dateSent: dateFormatter.date(from: "2024-10-11 16:00")!),
  receivedRequest(rid: 3,
                  sender: "김지민",
                  role: "관리자",
                  title: "프로젝트 파일 검토 요청",
                  subtitle: "프로젝트 'iOS Todo 앱'의 문서 검토 요청이 왔습니다. 검토 후 승인하시겠습니까?",
                  dateSent: dateFormatter.date(from: "2024-10-10 09:11")!),
  receivedRequest(rid: 4,
                  sender: "한나리",
                  role: "참가자",
                  title: "할 일 우선순위 변경 요청",
                  subtitle: "현재 작업 중인 'UI 스타일링' 작업의 우선순위가 변경되었습니다. 이를 수락하시겠습니까?",
                  dateSent: dateFormatter.date(from: "2024-10-09 23:54")!)
]

// Request 더미데이터 (사용자가 보낸 요청)
let sentRequests: [sentRequest] = [
  sentRequest(rid: 0,
              rejected: 0,
              receiver: "한나리",
              role: "참가자",
              title: "작업 요청",
              subtitle: "할 일: '테스트 시나리오 작성' 작업을 수행해 주세요.",
              dateSent: dateFormatter.date(from: "2024-11-08 10:00")!),
  sentRequest(rid: 1,
              rejected: 0,
              receiver: "한나리",
              role: "참가자",
              title: "프로젝트 초대",
              subtitle: "프로젝트 'iOS 앱 테스트'에 초대되었습니다. 참여를 수락해 주세요.",
              dateSent: dateFormatter.date(from: "2024-11-07 15:45")!),
  sentRequest(rid: 2,
              rejected: 1,
              receiver: "임진우",
              role: "참가자",
              title: "기한 연장 요청",
              subtitle: "현재 진행 중인 '디자인 검토' 작업의 기한을 3일 연장해 주세요.",
              dateSent: dateFormatter.date(from: "2024-11-06 14:30")!),
  sentRequest(rid: 3,
              rejected: 1,
              receiver: "임진우",
              role: "참가자",
              title: "작업 우선순위 변경",
              subtitle: "'UI 테스트' 작업의 우선순위를 조정해 주세요.",
              dateSent: dateFormatter.date(from: "2024-11-05 09:00")!),
  sentRequest(rid: 4,
              rejected: 0,
              receiver: "한나리",
              role: "참가자",
              title: "작업 완료 검토 요청",
              subtitle: "'UI 스타일링' 작업을 완료했습니다. 검토 후 승인해 주세요.",
              dateSent: dateFormatter.date(from: "2024-11-04 13:20")!)
]
