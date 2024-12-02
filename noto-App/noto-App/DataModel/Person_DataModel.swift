import SwiftUI

struct person: Identifiable {
  let id = UUID()
  let imageName: String
  let name: String
  let role: String
  let email: String
  let phone: String
  let CreateDate: Date
  let lastLoginDate: Date
}

let personList: [person] = [
  person(imageName: "profile",
         name: "김지민",
         role: "관리자",
         email: "jiminkim@google.com",
         phone: "010-1029-4857",
         CreateDate: dateFormatter.date(from: "2023-05-15 12:44")!,
         lastLoginDate: dateFormatter.date(from: "2024-11-02 14:35")!),
  person(imageName: "profile",
         name: "한나리",
         role: "참여자",
         email: "jiminkim@google.com",
         phone: "010-1029-4857",
         CreateDate: dateFormatter.date(from: "2023-05-15 12:44")!,
         lastLoginDate: dateFormatter.date(from: "2024-11-02 14:35")!),
  person(imageName: "profile",
         name: "임진우",
         role: "참여자",
         email: "jiminkim@google.com",
         phone: "010-1029-4857",
         CreateDate: dateFormatter.date(from: "2023-05-15 12:44")!,
         lastLoginDate: dateFormatter.date(from: "2024-11-02 14:35")!)
  
]
