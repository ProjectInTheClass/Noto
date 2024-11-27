import SwiftUI

enum Tab { case settings, home, projects }
enum Page { case main, requestList, todoDetail }

struct MainPage_ContentView: View {
  @State private var selectedTab: Tab = .home
  
  var body: some View {
    TabView(selection: $selectedTab) {
      SettingPage()
        .tabItem { Image(systemName: "gear") }
        .tag(Tab.settings)
      mainPage(selectedTab: $selectedTab)
        .tabItem { Image(systemName: "house") }
        .tag(Tab.home)
      ProjectSelectionView()
        .tabItem { Image(systemName: "folder") }
        .tag(Tab.projects)
    }
    .background(Color.white)
  }
}

struct MainPage_ContentView_Preview: PreviewProvider {
  static var previews: some View {
    MainPage_ContentView()
  }
}

struct mainPage: View {
  @State private var searchText = ""
  @State private var currentScreen: Page = .main
  @Binding var selectedTab: Tab
  
  var body: some View {
    VStack{
      if currentScreen == .main {
        ScrollView {
          VStack(spacing: 20) {
            mainHeader()
            searchBar(searchText: $searchText, action: test)
            requestComponent(req_count: 5, action: { currentScreen = .requestList })
            
            VStack(spacing: 10) {
              rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: {print("버튼 클릭")})
              viewAllComponent(title: "오늘 내 할 일 모두 보기", action: test)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.top, 20)
            .blockStyle(height: .infinity)
            
            VStack(spacing: 10) {
              simpleProgressRow(progress: 0.5, Dday: 48, action: test)
              simpleProgressRow(progress: 0.7, Dday: 30, action: test)
              viewAllComponent(title: "프로젝트 진행 현황 모두 보기", action: test)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.top, 20)
            .padding(.horizontal, 20)
            .blockStyle(height: .infinity)
          }
          .backgroundStyle()
        }
        .scrollViewStyle()
      } else if(currentScreen == .requestList) {
        RequestPage(currentScreen: $currentScreen)
      }
    }
  }
}
