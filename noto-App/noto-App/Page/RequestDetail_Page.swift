
import SwiftUI

//struct RequestDetailPage_ContentView: View {
//  @State private var currentScreen: Page = .todoDetail
//  @State private var prevScreen: Page = prev
//  @State private var rid: Int = 1
//  @State private var type: Int = 1
//  @State private var rejected: Int = 1
//  var body: some View {
//    RequestDetailPage(currentScreen: $currentScreen, prevScreen: prevScreen, rid: rid, type: type, rejected: rejected)
//  }
//}
//
//struct RequestDetailPage_ContentView_Preview: PreviewProvider {
//  static var previews: some View {
//    RequestDetailPage_ContentView()
//  }
//}

struct RequestDetailPage: View {
  @Binding var currentScreen: Page
  @Binding  var selectedRid: Int
  var prevScreen: Page
    
    @State private var type: Int = 1
    @State private var rejected: Int = 1
    @State private var rid: Int = 1
    
    @State private var requestInfoData: RequestInfo? = nil
    @State private var requestReceivedData: [RequestReceived]? = nil
    @State private var showingSheet: Bool = false
    @State private var showingDialog: Bool = false
    
    @State private var receiverId: Int = 0
    @State private var comment: String = ""
    @State private var status: String = ""
    
    let url = "https://www.bestbirthday.co.kr:8080/api"
  
  @State private var person: String = ""
  @State private var role: String = ""
  @State private var title: String = ""
  @State private var subtitle: String = ""
  @State private var sentDate: Date = Date()
  @State private var rejectedReason: String = "이 자리는 리퀘스트 반려 사유가 적히는 자리로, 현재는 하드코딩되어 있는 상태이지만 데이터베이스와 연결하면서 수정이 필요하다. 잘 부탁드립니다."
  
  
  var body: some View {
    VStack {
      ScrollView {
          if let requestInfoData = requestInfoData {
              VStack(spacing: 15) {
                  dumyHeader()
                  goBackHeader(goBackAction: {currentScreen = prevScreen})
                  
                  // 리퀘스트 설명
                  VStack(spacing: 10){
                      Spacer()
                      if !requestInfoData.isSender {
                          titleRow_3(title: title, optionAction: {
                              print("리퀘스트 설정 버튼 클릭 (수정 필요)")
                              showingDialog = true
                          })
                          .confirmationDialog("Choose an option", isPresented: $showingDialog) {
                              Button("수락", role: .none) {
                                  print("수락")
                                  status = "수락"
                                  Task {
                                      let response = try await patch(url: url + "/request" + "/\(selectedRid)", body: RequestRequestReceived(receiverId: receiverId, comment: comment, status: status))
                                      // Handle the response here
                                      print(response)
                                  }
                              }
                              Button("거부", role: .destructive) {
                                  print("거부")
                                  status = "거부"
                                  showingSheet = true
                              }
                              Button("취소", role: .cancel) {
                                  print("취소")
                              }
                          }
                          .padding(.top, 10)
                          .sheet(isPresented: $showingSheet) {
                              modalRequestRejectView(comment: $comment)
                          }
                      } else {
                          titleRow_1(title: title)
                      }
                      Divider()
                          .padding(.horizontal, 20)
                          .padding(.bottom, 10)
                      
                      VStack(spacing: 15) {
                          if let receivers = requestInfoData.receivers {
                              personRow(sender: requestInfoData.sender, receivers: receivers)
                          }
                          
                          requestDescriptionRow(description: requestInfoData.content)
                      }
                      Spacer()
                  }
                  .blockStyle(height: .infinity)
                  
                  if requestInfoData.isSender {
                      // 리퀘스트 반려 사유 (Comment)
                      VStack(alignment: .leading, spacing: 10) {
                          Spacer()
                          titleRow_1(title: "리퀘스트 반려 사유")
                              .padding(.top, 10)
                          Divider()
                              .padding(.horizontal, 20)
                              .padding(.bottom, 10)
                          
                          if let requestReceivedData = requestReceivedData {
                              ForEach(requestReceivedData, id: \.self) { requestReceived in
                                  if requestReceived.status == "거절" {
                                      Text ("\(requestReceived.receiverName)")
                                          .subTitleFont()
                                          .padding(.leading, 20)
                                      Text ("\(requestReceived.comment)")
                                          .subTitleFont()
                                          .lineLimit(nil)  // 줄바꿈을 허용하고, 필요시 여러 줄로 출력
                                          .multilineTextAlignment(.leading)  // 왼쪽 정렬
                                          .padding(.leading, 20)
                                  }
                              }
                          }
                          
                          Spacer()
                      }
                      .blockStyle(height: .infinity)
                  }
              }
              .backgroundStyle()
          }
      }
      .scrollViewStyle()
      .task {
          do {
              let requestInfoResponse = try await get(url: url + "/request/info" + "/\(selectedRid)" + "?userId=1", responseType: RequestInfo.self)
              // Handle the response here
              print(requestInfoResponse)
              
              requestInfoData = requestInfoResponse.data

              let requestReceivedResponse = try await get(url: url + "/request_receive" + "/\(selectedRid)", responseType: [RequestReceived].self)
              // Handle the response here
              print(requestReceivedResponse)
              
              requestReceivedData = requestReceivedResponse.data
          } catch {
              print("Error fetching data: \(error.localizedDescription)")
          }
      }
    }
    .onAppear {
      filterRequests()
    }
  }
  
  private func filterRequests() {
    if type == 1 {
      let request = sentRequests.filter { request in
        return request.rid == rid // startDate와 endDate 사이인지 확인
      }
      person = request[0].receiver
      role = request[0].role
      title = request[0].title
      subtitle = request[0].subtitle
      sentDate = request[0].dateSent
    } else if type == 2 {
      let request = receivedRequests.filter { request in
        return request.rid == rid
      }
      person = request[0].sender
      role = request[0].role
      title = request[0].title
      subtitle = request[0].subtitle
      sentDate = request[0].dateSent
    }
  }
}

struct personRow: View {
  var sender: String
  var receivers: [String]
  
  var body: some View {
    HStack {
      Image("user")
        .resizable()
        .frame(width: 24, height: 24)
        .padding(.horizontal, 10)
      Text("리퀘스트 전송")
        .subTitleFont()
      
      Spacer()
      
      HStack {
        Text("\(sender)")
          .subTitleFont()
          .submitLabel(.continue)
      
        Image(systemName: "chevron.right")
          .font(.system(size: 13))
          .foregroundColor(.customDarkGray)
        
          // ScrollView를 추가하여 가로로 스크롤 할 수 있도록 합니다.
          if totalTextWidth(receivers) > 100 {
              ScrollView(.horizontal, showsIndicators: false) {
                  HStack(spacing: 8) {
                      // 텍스트들 사이에 간격을 추가합니다.
                      ForEach(receivers, id: \.self) { receiver in
                          Text(receiver)
                              .subTitleFont()
                              .lineLimit(1)
                      }
                  }
                  .frame(maxWidth: .infinity, alignment: .trailing)  // 오른쪽 정렬
              }
              .frame(maxWidth: 100)  // 최대 너비 200
          } else {
              // 텍스트가 200 이하일 경우, 오른쪽 정렬
              HStack(spacing: 8) {
                  Spacer()
                  ForEach(receivers, id: \.self) { receiver in
                      Text(receiver)
                          .subTitleFont()
                          .lineLimit(1)
                  }
              }
              .frame(maxWidth: 200, alignment: .trailing)  // 최대 너비 200
          }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 20)
  }
    
    // 총 텍스트의 너비를 계산하는 helper 함수
    private func totalTextWidth(_ participants: [String]) -> CGFloat {
        // 전체 텍스트 길이를 대략적으로 계산합니다.
        let text = participants.joined(separator: " ")
        let font = UIFont.preferredFont(forTextStyle: .body)  // 적절한 폰트를 사용
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        return size.width
    }
}

struct requestDescriptionRow: View  {
  var description: String
  var body: some View {
    VStack(alignment: .leading, spacing: 10){
      HStack {
        Image("note")
          .resizable()
          .frame(width: 22, height: 22)
          .padding(.horizontal, 10)
        Text("리퀘스트 설명")
          .subTitleFont()
          .padding(.trailing, 25)
      }
      
      HStack{
        Text(description)
          .descriptionFont()
          .multilineTextAlignment(.leading)
          .lineLimit(10)
      }
      .padding(.leading, 10)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 20)
  }
}
