import SwiftUI

struct project: Identifiable {
  var id = UUID()
  var name: String
  var imageName: String
  var participants: [person]
  var progress: Double
  var startDate: Date
  var endDate: Date
}

let projectList: [project] = [
  project(name: "iOS Todo 앱 개발",
          imageName: "projectImage",
          participants: personList,
          progress: 0.48,
          startDate: dateFormatter.date(from: "2024-10-01 13:00")!,
          endDate: dateFormatter.date(from: "2024-12-21 23:59")!)
]

func calculateDDay(from start: Date, to end: Date) -> Int {
  let calendar = Calendar.current
  let startOfStart = calendar.startOfDay(for: start)
  let startofEnd = calendar.startOfDay(for: end)
  
  let components = calendar.dateComponents([.day], from: startOfStart, to: startofEnd)
  return components.day ?? 0
}
