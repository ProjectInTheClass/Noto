import SwiftUI
/*
struct RequestPage_ContentView: View {
  var body: some View {
    RequestPage()
  }
}

struct RequestPage_ContentView_Preview: PreviewProvider {
  static var previews: some View {
    RequestPage_ContentView()
  }
}
*/

struct RequestPage: View {
  @Binding var currentScreen: mainPageScreen
  
  var body: some View {
    VStack {
      ScrollView {
        VStack(spacing: 15) {
          mainHeader()
          requestHeader(onGoBack: {currentScreen = .main}, addAction: {print("수정 필요")})
          
        }
        .backgroundStyle()
      }
      .scrollViewStyle()
    }
  }
}
