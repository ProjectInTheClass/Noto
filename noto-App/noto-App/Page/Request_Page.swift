import SwiftUI

struct RequestPage_ContentView: View {
  @State private var currentScreen: Page = .requestList
  var body: some View {
    RequestPage(currentScreen: $currentScreen)
  }
}

// Request 모델
struct Request: Identifiable {
  let id = UUID() // 고유 ID
  let sender: String
  let title: String
}

// 요청 데이터
let requests: [Request] = [
  Request(sender: "Alice", title: "Project Approval"),
  Request(sender: "Bob", title: "Budget Increase"),
  Request(sender: "Charlie", title: "New Feature Request"),
  Request(sender: "Diana", title: "Code Review Request")
]

struct RequestPage_ContentView_Preview: PreviewProvider {
  static var previews: some View {
    RequestPage_ContentView()
  }
}


struct RequestPage: View {
  @Binding var currentScreen: Page
  
  var body: some View {
    VStack {
      ScrollView {
        VStack(spacing: 15) {
          mainHeader()
          requestHeader(onGoBack: {currentScreen = .main}, addAction: {print("수정 필요")})
          VStack{
            List(requests) { request in
              HStack {
                rowComponent(imageName: "check", title: request.title, subtitle: request.sender, action: {currentScreen = .todoDetail})
              }
            }
          }
          .blockStyle(height: 1000)
        }
        .backgroundStyle()
      }
      .scrollViewStyle()
    }
  }
}
