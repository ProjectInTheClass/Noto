import SwiftUI

// 앱 사용자 데이터 모델
struct user: Identifiable {
  let id = UUID() // 고유 ID
  let uid: Int
  let name: String
  let role: String
}

let userInfo: user = user(uid: 0, name: "김지민", role: "admin")
