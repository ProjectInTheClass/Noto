import SwiftUI

struct RequestPage_ContentView: View {
  @State private var currentScreen: Page = .requestList
  @State private var rid: Int = 0
  @State private var type: Int = 1
  @State private var rejected: Int = 1
  var body: some View {
    RequestListPage(currentScreen: $currentScreen,
                    selectedRid: $rid,
                    prevScreen: .main)
  }
}

struct RequestPage_ContentView_Preview: PreviewProvider {
  static var previews: some View {
    RequestPage_ContentView()
  }
}


struct RequestListPage: View {
  @State private var showingRequestList: Bool = false
  @State private var showingRequest: Bool = false
  @State private var selectedModal: Modal = .sendRequestList
  @Binding var currentScreen: Page
  @Binding  var selectedRid: Int
  var prevScreen: Page
    
  @State private var requestListData: RequestList? = nil
    
  let url = "https://www.bestbirthday.co.kr:8080/api"
  
  var body: some View {
    VStack {
      ScrollView {
          VStack(spacing: 15) {
              dumyHeader()
              requestHeader(onGoBack: {currentScreen = prevScreen}, addAction: {
                  print("리퀘스트 추가 버튼 클릭 (수정 필요)")
                  showingRequest = true
              })
              .sheet(isPresented: $showingRequest, onDismiss: {
                  showingRequest = false
                  
                  Task {
                      do {
                          let requestListResponse = try await get(url: url + "/request/list?userId=1", responseType: RequestList.self)
                          // Handle the response here
                          print(requestListResponse)
                          
                          requestListData = requestListResponse.data
                      } catch {
                          print("Error fetching data: \(error.localizedDescription)")
                      }
                  }
              }){
                  modalRequestView()
              }
              
              if let requestListData = requestListData{
                  // 받은 일정
                  Spacer()
                  titleRow_2(title: "받은 리퀘스트", imageName: "receive", imageSize: 24)
                  VStack(spacing: 5){
                      Spacer()
                      ForEach(requestListData.receiveRequest.prefix(5), id: \.self) { receiveRequest in
                          HStack {
                              rowComponent(imageName: "mail",
                                           title: receiveRequest.title,
                                           subtitle: receiveRequest.sender,
                                           action: {
                                  currentScreen = .requestDetail
                                  selectedRid = receiveRequest.requestId
                              })
                          }
                          if receiveRequest != requestListData.receiveRequest.prefix(5).last {
                              Divider()
                                  .padding(.horizontal, 20)
                          }
                      }
                      viewAllComponent(title: "받은 리퀘스트 모두 보기", action: {
                          showingRequestList = true
                          selectedModal = .receiveRequestList
                      })
                  }
                  .blockStyle(height: .infinity)
                  
                  // 보낸 일정
                  Spacer()
                  titleRow_2(title: "보낸 리퀘스트", imageName: "paper-plane", imageSize: 20)
                  VStack(spacing: 5){
                      Spacer()
                      ForEach(requestListData.sendRequest.prefix(5), id: \.self) { sendRequest in
                          HStack {
                              rowComponent(imageName: "mail",
                                           title: sendRequest.title,
                                           subtitle: sendRequest.sender,
                                           action: {
                                  currentScreen = .requestDetail
                                  selectedRid = sendRequest.requestId
                              })
                          }
                          if sendRequest != requestListData.sendRequest.prefix(5).last {
                              Divider()
                                  .padding(.horizontal, 20)
                          }
                      }
                      viewAllComponent(title: "보낸 리퀘스트 모두 보기", action: {
                          showingRequestList = true
                          selectedModal = .sendRequestList
                      })
                  }
                  .blockStyle(height: .infinity)
              }
              dumyBottom()
          }
        }
        .backgroundStyle()
      }
      .scrollViewStyle()
      .task {
          do {
              let requestListResponse = try await get(url: url + "/request/list?userId=1", responseType: RequestList.self)
              // Handle the response here
              print(requestListResponse)
              
              requestListData = requestListResponse.data
          } catch {
              print("Error fetching data: \(error.localizedDescription)")
          }
      }
      .sheet(isPresented: $showingRequestList, onDismiss: {
          showingRequestList = false
      }){
          modalRequestListView(requestListData: $requestListData, selectedModal: $selectedModal, currentScreen: $currentScreen, selectedRid: $selectedRid)
      }
    }
}
