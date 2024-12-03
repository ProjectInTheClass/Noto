import SwiftUI

struct RequestPage_ContentView: View {
  @State private var currentScreen: Page = .requestList
  var body: some View {
    RequestPage(currentScreen: $currentScreen)
  }
}

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
          
          VStack(spacing: 10){
            Spacer()
            ForEach(requests.indices, id: \.self) { index in
              HStack {
                let request = requests[index]
                rowComponent(imageName: "check", title: request.title, subtitle: request.subtitle, action: {print("모달 나오게 수정")})
              }
              if index < requests.count - 1 {
                Divider()
              }
            }
            Spacer()
          }
          .blockStyle(height: .infinity)
          
        }
        .backgroundStyle()
      }
      .scrollViewStyle()
    }
  }
}
