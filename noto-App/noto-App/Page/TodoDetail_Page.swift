import SwiftUI

struct TodoDetailPage_ContentView: View {
  @State private var currentScreen: Page = .todoDetail
  @State private var prevScreen: Page = .main
  @State private var clickedIndex: Int = 1
  var body: some View {
    TodoDetialPage(currentScreen: $currentScreen, prevScreen: prevScreen, index: clickedIndex)
  }
}

struct TodoDetailPage_ContentView_Preview: PreviewProvider {
  static var previews: some View {
    TodoDetailPage_ContentView()
  }
}

struct TodoDetialPage: View {
  @Binding var currentScreen: Page
  var prevScreen: Page
  var index: Int
  
  var body: some View {
    VStack {
      ScrollView {
        VStack(spacing: 15) {
          dumyHeader()
          goBackCompletionHeader(goBackAction: {currentScreen = prevScreen},
                                 completionAction: { print("일정 완료 버튼 수정 필요") })
          
          VStack(spacing: 10){
            titleRow(title: todolist[index].title, optionAction: {print("모달 나오게 수정")})
              .padding(.top, 40)
            Divider()
              .padding(.horizontal, 20)
              .padding(.bottom, 10)
            
            VStack(spacing: 15) {
              dateRow(startDate: todolist[index].startDate, endDate: todolist[index].endDate)
              participantRow()
              tagRow(tag: todolist[index].tag)
              urlRow(url: todolist[index].url)
              Divider()
                .padding(.horizontal, 20)
              descriptionRow(description: todolist[index].subtitle)
            }
            Spacer()
          }
          .blockStyle(height: .infinity)
          
          VStack {
            urlButton(url: todolist[index].url)
          }
          .blockStyle(height: .infinity)
          .padding(.top, 20)
          .padding(.horizontal, 5)
          
        }
        .backgroundStyle()
      }
      .scrollViewStyle()
    }
  }
}

// 행 컴포넌트
struct titleRow: View {
  var title: String
  var optionAction: () -> Void
  
  var body: some View {
    HStack {
      Text(title)
        .titleFont()
        .lineLimit(1)
        .truncationMode(.tail)
      Spacer()
      Button(action: {
        optionAction()
      }) {
        Image(systemName: "ellipsis")
          .font(.system(size: 24))
          .foregroundColor(.customBlack)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 20)

  }
}

struct dateRow: View {
  var startDate: Date
  var endDate: Date
  
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
  var body: some View {
    HStack {
      Image("user")
        .resizable()
        .frame(width: 24, height: 24)
        .padding(.horizontal, 10)
      Text("일정 참가자")
        .subTitleFont()
      
      Spacer()
      
      HStack {
        ForEach(personList.indices, id: \.self) { index in
          VStack{
            imageComponent(imageName: personList[index].imageName, shape: .rectangle, size: 24)
          }
          
          if index < personList.count - 1 {
            Divider()
          }
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 20)
  }
}

struct tagRow: View {
  var tag: Int
  
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
        if tag == 0 {
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
        } else if tag == 1 {
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
  var url: String
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
      
      HStack{
        Text(url)
          .font(.custom("Freesentation-5Medium", size: 12))
          .foregroundColor(.customBlack)
          .lineLimit(1)
          .truncationMode(.tail)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 20)
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
