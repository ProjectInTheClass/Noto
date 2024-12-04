import SwiftUI

struct RequestPage_ContentView: View {
  @State private var currentScreen: Page = .requestList
  @State private var rid: Int = 0
  @State private var type: Int = 1
  @State private var rejected: Int = 1
  var body: some View {
    RequestListPage(currentScreen: $currentScreen,
                    selectedRid: $rid,
                    selectedRequestType: $type,
                    selectedRequestRejected: $rejected)
  }
}

struct RequestPage_ContentView_Preview: PreviewProvider {
  static var previews: some View {
    RequestPage_ContentView()
  }
}


struct RequestListPage: View {
  @Binding var currentScreen: Page
  @Binding var selectedRid: Int
  @Binding var selectedRequestType: Int
  @Binding var selectedRequestRejected: Int
  
  var body: some View {
    VStack {
      ScrollView {
        VStack(spacing: 15) {
          dumyHeader()
          requestHeader(onGoBack: {currentScreen = .main}, addAction: {print("리퀘스트 추가 버튼 클릭 (수정 필요)")})
          
          // 보낸 일정
          Spacer()
          titleRow_2(title: "보낸 리퀘스트", imageName: "paper-plane", imageSize: 20)
          VStack(spacing: 5){
            Spacer()
            ForEach(sentRequests.indices, id: \.self) { index in
              HStack {
                let request = sentRequests[index]
                rowComponent(imageName: "mail",
                             title: request.title,
                             subtitle: request.subtitle,
                             action: { currentScreen = .requestDetail
                                       selectedRid = request.rid
                                       selectedRequestType = 1
                                       selectedRequestRejected = request.rejected})
              }
              if index < sentRequests.count - 1 {
                Divider()
                  .padding(.horizontal, 20)
              }
            }
            viewAllComponent(title: "보낸 리퀘스트 모두 보기", action: {print("보낸 리퀘스트 모두 보기 클릭 (수정 필요)")})
          }
          .blockStyle(height: .infinity)
          
          // 받은 일정
          Spacer()
          titleRow_2(title: "받은 리퀘스트", imageName: "receive", imageSize: 24)
          VStack(spacing: 5){
            Spacer()
            ForEach(receivedRequests.indices, id: \.self) { index in
              HStack {
                let request = receivedRequests[index]
                rowComponent(imageName: "check",
                             title: request.title,
                             subtitle: request.subtitle,
                             action: { currentScreen = .requestDetail
                                       selectedRid = request.rid
                                       selectedRequestType = 2
                                       selectedRequestRejected = 0})
              }
              if index < receivedRequests.count - 1 {
                Divider()
                  .padding(.horizontal, 20)
              }
            }
            viewAllComponent(title: "받은 리퀘스트 모두 보기", action: {print("받은 리퀘스트 모두 보기 클릭 (수정 필요)")})
          }
          .blockStyle(height: .infinity)
          
          dumyBottom()
        }
        .backgroundStyle()
      }
      .scrollViewStyle()
    }
  }
}
