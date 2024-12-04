
import SwiftUI

struct RequestDetailPage_ContentView: View {
  @State private var currentScreen: Page = .todoDetail
  @State private var prevScreen: Page = .main
  @State private var rid: Int = 1
  @State private var type: Int = 1
  @State private var rejected: Int = 1
  var body: some View {
    RequestDetailPage(currentScreen: $currentScreen, prevScreen: prevScreen, rid: rid, type: type, rejected: rejected)
  }
}

struct RequestDetailPage_ContentView_Preview: PreviewProvider {
  static var previews: some View {
    RequestDetailPage_ContentView()
  }
}

struct RequestDetailPage: View {
  @Binding var currentScreen: Page
  var prevScreen: Page
  var rid: Int // 리퀘스트 아이디
  var type: Int // 리퀘스트 종류 (1: sentRequest, 2: receivedRequest)
  var rejected: Int
  
  @State private var person: String = ""
  @State private var role: String = ""
  @State private var title: String = ""
  @State private var subtitle: String = ""
  @State private var sentDate: Date = Date()
  @State private var rejectedReason: String = "이 자리는 리퀘스트 반려 사유가 적히는 자리로, 현재는 하드코딩되어 있는 상태이지만 데이터베이스와 연결하면서 수정이 필요하다. 잘 부탁드립니다."
  
  
  var body: some View {
    VStack {
      ScrollView {
        VStack(spacing: 15) {
          dumyHeader()
          goBackHeader(goBackAction: {currentScreen = prevScreen})
          
          // 리퀘스트 설명
          VStack(spacing: 10){
            Spacer()
            titleRow_3(title: title, optionAction: { print("리퀘스트 설정 버튼 클릭 (수정 필요)")})
              .padding(.top, 10)
            Divider()
              .padding(.horizontal, 20)
              .padding(.bottom, 10)
            
            VStack(spacing: 15) {
              if type == 1 { personRow(sender: userInfo.name, receiver: person, type: type) }
              else if type == 2 { personRow(sender: person, receiver: userInfo.name, type: type) }
              
              requestDescriptionRow(description: subtitle)
            }
            Spacer()
          }
          .blockStyle(height: .infinity)
          
          if rejected == 1 {
            // 리퀘스트 반려 사유 (Comment)
            VStack(alignment: .leading, spacing: 10) {
              Spacer()
              titleRow_1(title: "리퀘스트 반려 사유")
                .padding(.top, 10)
              Divider()
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
              
              VStack(alignment: .leading) {
                Text("\(rejectedReason)")
                  .descriptionFont()
                  .multilineTextAlignment(.leading)
                  .lineLimit(10)
              }
              .padding(.horizontal, 20)
              
              Spacer()
            }
            .blockStyle(height: .infinity)
          }
        }
        .backgroundStyle()
      }
      .scrollViewStyle()
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
  var receiver: String
  var type: Int
  
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
      
        Image(systemName: type == 1 ? "chevron.right" : "chevron.left")
          .font(.system(size: 13))
          .foregroundColor(.customDarkGray)
        
        Text("\(receiver)")
          .subTitleFont()
          .submitLabel(.continue)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 20)
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
