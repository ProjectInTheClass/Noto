import SwiftUI

//struct TodoDetailPage_ContentView: View {
//  @State private var currentScreen: Page = .todoDetail
//  @State private var prevScreen: Page = .main
//  @State private var clickedIndex: Int = 1
//  var body: some View {
//    TodoDetialPage(currentScreen: $currentScreen, prevScreen: prevScreen, index: clickedIndex)
//  }
//}
//
//struct TodoDetailPage_ContentView_Preview: PreviewProvider {
//  static var previews: some View {
//    TodoDetailPage_ContentView()
//  }
//}

struct TodoDetialPage: View {
    @Environment(\.dismiss) var dismiss
  @State private var scheduleInfoData: ScheduleInfo? = nil
  @State private var showingSheet: Bool = false
  @Binding var currentScreen: Page
  @Binding  var selectedSid: Int
  @Binding var selectedPid: Int
  var prevScreen: Page
    
  let url = "https://www.bestbirthday.co.kr:8080/api"
  
  var body: some View {
    VStack {
      ScrollView {
        VStack(spacing: 15) {
          dumyHeader()
          goBackCompletionHeader(goBackAction: {currentScreen = prevScreen},
                                 completionAction: {
              print("일정 완료 버튼 클릭 (수정 필요)")
              Task {
                  do {
                      let response = try await putNoneBody(url: url + "/schedule/complete" + "/\(selectedSid)")
                      // Handle the response here
                      print(response)
                      currentScreen = prevScreen
                  } catch {
                      print("Error fetching data: \(error.localizedDescription)")
                  }
              }
          })
            if let scheduleInfoData = scheduleInfoData {
                VStack(spacing: 10){
                    Spacer()
                    titleRow_3(title: scheduleInfoData.name, optionAction: {
                        print("일정 수정 버튼 클릭 (수정 필요)")
                        showingSheet = true
                    })
                    .padding(.top, 10)
                    .sheet(isPresented: $showingSheet, onDismiss: {
                        showingSheet = false
                    }) {
                        modalTodoView(currentScreen: $currentScreen, modifiedSid: $selectedSid, selectedPid: $selectedPid, selectedSid: $selectedSid)
                    }
                    Divider()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    
                    VStack(spacing: 15) {
                        dateRow(startDate: scheduleInfoData.startDate, endDate: scheduleInfoData.endDate)
                        participantRow(participants: scheduleInfoData.participants)
                        tagRow(tag: scheduleInfoData.tag)
                        urlRow(url: scheduleInfoData.url)
                        Divider()
                            .padding(.horizontal, 20)
                        descriptionRow(description: scheduleInfoData.description)
                    }
                    Spacer()
                }
                .blockStyle(height: .infinity)
                
                VStack {
                    urlButton(url: scheduleInfoData.url)
                }
                .blockStyle(height: .infinity)
                .padding(.top, 20)
                .padding(.horizontal, 5)
            }
          
        }
        .backgroundStyle()
      }
      .scrollViewStyle()
      .task {
          do {
              let scheduleInfoResponse = try await get(url: url + "/schedule/info" + "/\(selectedSid)", responseType: ScheduleInfo.self)
              // Handle the response here
              print(scheduleInfoResponse)
              
              scheduleInfoData = scheduleInfoResponse.data
          } catch {
              print("Error fetching data: \(error.localizedDescription)")
          }
      }
      .onChange(of: currentScreen) {
          dismiss()
      }
    }
  }
}

struct dateRow: View {
  let startDate: Date
  let endDate: Date

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
  
  var body: some View {
    HStack {
      Image("schedule")
        .resizable()
        .frame(width: 24, height: 24)
        .padding(.horizontal, 10)
      Text("일정 기간")
        .subTitleFont()
      
      Spacer()
      
      VStack(alignment: .leading) {
        HStack {
          Text("from: ")
            .viewAllFont()
          Text("\(dateFormatter.string(from: startDate))")
            .subTitleFont()
            .submitLabel(.continue)
        }
        HStack {
          Text("to:       ")
            .viewAllFont()
          Text("\(dateFormatter.string(from: endDate))")
            .subTitleFont()
            .submitLabel(.continue)
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 20)
  }
}

struct participantRow: View {
  let participants: [String]
    
  var body: some View {
    HStack {
      Image("user")
        .resizable()
        .frame(width: 24, height: 24)
        .padding(.horizontal, 10)
      Text("일정 참가자")
        .subTitleFont()
      
        Spacer()
        
        // ScrollView를 추가하여 가로로 스크롤 할 수 있도록 합니다.
        if totalTextWidth(participants) > 200 {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    // 텍스트들 사이에 간격을 추가합니다.
                    ForEach(participants, id: \.self) { participant in
                        Text(participant)
                            .projectContentFont()
                            .lineLimit(1)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)  // 오른쪽 정렬
            }
            .frame(maxWidth: 200)  // 최대 너비 200
        } else {
            // 텍스트가 200 이하일 경우, 오른쪽 정렬
            HStack(spacing: 8) {
                Spacer()
                ForEach(participants, id: \.self) { participant in
                    Text(participant)
                        .projectContentFont()
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: 200, alignment: .trailing)  // 최대 너비 200
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

struct tagRow: View {
  let tag: String
  
  var body: some View {
    HStack {
      Image("tag")
        .resizable()
        .frame(width: 22, height: 22)
        .padding(.horizontal, 10)
      Text("태그")
        .subTitleFont()
      
      Spacer()
      
      HStack {
        if tag == "개발" {
          ZStack{
            Rectangle()
              .fill(Color.customLightGray)
              .frame(width: 80, height: 30)
              .cornerRadius(10)
            Text("회의")
              .foregroundColor(.customDarkGray)
              .subTitleFont()
          }
          
          ZStack {
            Rectangle()
              .fill(Color.customBlue)
              .frame(width: 80, height: 30)
              .cornerRadius(10)
            Text("개발")
              .foregroundColor(.white)
              .subTitleFont()
          }
        } else if tag == "회의" {
          ZStack{
            Rectangle()
              .fill(Color.customBlue)
              .frame(width: 80, height: 30)
              .cornerRadius(10)
            Text("회의")
              .foregroundColor(.white)
              .subTitleFont()
          }
          
          ZStack {
            Rectangle()
              .fill(Color.customLightGray)
              .frame(width: 80, height: 30)
              .cornerRadius(10)
            Text("개발")
              .foregroundColor(.customDarkGray)
              .subTitleFont()
          }
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 20)
  }
}

struct urlRow: View {
  let url: String
  var body: some View {
    HStack {
      Image("chain")
        .resizable()
        .frame(width: 22, height: 22)
        .padding(.horizontal, 10)
      Text("URL")
        .subTitleFont()
        .padding(.trailing, 40)
      
      Spacer()
      
        // URL 텍스트의 길이가 200을 넘으면 ScrollView를 사용하여 스크롤 가능하게 처리
        if urlWidth(url) > 200 {
            ScrollView(.horizontal, showsIndicators: false) {
                Text(url)
                    .font(.custom("Freesentation-5Medium", size: 12))
                    .foregroundColor(.customBlack)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .frame(maxWidth: 200, alignment: .leading)  // 최대 너비를 200으로 제한
        } else {
            Text(url)
                .font(.custom("Freesentation-5Medium", size: 12))
                .foregroundColor(.customBlack)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: 200, alignment: .leading)  // 텍스트가 200 이하일 때 왼쪽 정렬
        }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 20)
  }
    
    // URL 텍스트의 너비를 계산하는 함수
    private func urlWidth(_ url: String) -> CGFloat {
        let font = UIFont(name: "Freesentation-5Medium", size: 12) ?? UIFont.systemFont(ofSize: 12)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let size = (url as NSString).size(withAttributes: attributes)
        return size.width
    }
}

struct descriptionRow: View  {
  var description: String
  var body: some View {
    VStack(alignment: .leading, spacing: 10){
      HStack {
        Image("note")
          .resizable()
          .frame(width: 22, height: 22)
          .padding(.horizontal, 10)
        Text("일정 설명")
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

struct urlButton: View {
  var url: String
  
  var body: some View {
    Button(action: {
      openURL(url)
    }) {
      HStack {
        Text("일정 URL로 이동")
          .subTitleFont()
          .padding(.trailing, 40)
        Spacer()
        Image("chain")
          .resizable()
          .frame(width: 22, height: 22)
          .padding(.horizontal, 10)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 30)
      .padding(.vertical, 15)
    }
  }
}

func openURL(_ urlString: String) {
  if let url = URL(string: urlString) {
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  } else {
    print("Invalid URL")
  }
}
