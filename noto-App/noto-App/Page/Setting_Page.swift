import SwiftUI

// inner는 추후 삭제
enum Screen { case settings, user, pw, alarm, display, inner }

struct SettingPage_ContentView: View {
  @State private var currentScreen: Screen = .settings
  
  var body: some View {
    VStack {
      if currentScreen == .settings {
        SettingPage()
      } else if currentScreen == .user {
        InnerView(onGoBack: {
          currentScreen = .settings
        }, onCompletion: {
          test("Completion button clicked")
        })
      }
    }
  }
}

struct SettingPage_ContentView_Preview: PreviewProvider {
  static var previews: some View {
    SettingPage_ContentView()
  }
}

struct SettingPage: View {
  @State private var searchText = ""
  @State private var currentScreen: Screen = .settings
  
  var userProfile: String = "profile"
  var userName: String = "User Name"
  var userEmail: String = "aaaaaaa@gmail.com"
  
  var body: some View {
    VStack(alignment: .leading) {
      ScrollView {
        VStack(spacing: 15){
          currentPageHeader(currentPage: "설정")
          searchBar(searchText: $searchText, action: test)
          
          userInfoRow(userImage: userProfile, userName: userName, userEmail: userEmail, action: { currentScreen = .user })
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .blockStyle(height: .infinity)
          
          VStack(spacing: 10) {
            settingRow(imageName: "locked", title: "비밀번호 변경", action: test)
            Divider()
            settingRow(imageName: "bell-ring", title: "알림 설정", action: test)
            Divider()
            settingRow(imageName: "monitor", title: "다크 모드/라이트 모드 설정", action: test)
          }
          .padding()
          .frame(maxWidth: .infinity, alignment: .leading)
          .blockStyle(height: .infinity)
          
          VStack(spacing: 10) {
            settingRow(imageName: "client", title: "고객 지원", action: test)
            Divider()
            settingRow(imageName: "faq", title: "FAQ", action: test)
            Divider()
            settingRow(imageName: "info", title: "이용약관 및 개인정보처리방침", action: test)
          }
          .padding()
          .frame(maxWidth: .infinity, alignment: .leading)
          .blockStyle(height: .infinity)
        }
        .backgroundStyle()
      }
      .scrollViewStyle()
    }
  }
}