import SwiftUI

enum Tab { case settings, home, projects }
enum Page { case main, requestList, todoDetail, progressList, todoList, projectDetail }

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
  @State private var clickedIndex: Int? = 0
  @Binding var selectedTab: Tab
  
  
  var body: some View {
    VStack{
      if currentScreen == .main {
        ScrollView {
          VStack(spacing: 20) {
            mainHeader()
            searchBar(searchText: $searchText, action: {print("검색창 클릭 수정 필요")})
            requestComponent(req_count: 5, action: { currentScreen = .requestList })
            
            VStack(spacing: 10) {
              Spacer()
              ForEach(todolist.indices, id: \.self) { index in
                HStack {
                  let todo = todolist[index]
                  rowComponent(
                    imageName: todo.imageName,
                    title: todo.title,
                    subtitle: todo.subtitle,
                    action: {
                      currentScreen = .todoDetail
                      clickedIndex = index // 클릭된 인덱스 저장
                    }
                  )
                }
                if index < todolist.count - 1 {
                  Divider()
                    .padding(.horizontal, 20)
                }
              }
              viewAllComponent(title: "오늘 내 할 일 모두 보기", action: {currentScreen = .progressList})
            }
            .blockStyle(height: .infinity)
            
            VStack(spacing: 10) {
              ForEach(projectList.indices, id: \.self) { index in
                simpleProgressRow(title: projectList[index].name,
                                  progress: projectList[index].progress,
                                  Dday: calculateDDay(from: projectList[index].startDate, to: projectList[index].endDate),
                                  action: { print("프로젝트 클릭 수정 필요")
                                            clickedIndex = index})
              }
              
              viewAllComponent(title: "프로젝트 진행 현황 모두 보기", action: {currentScreen = .progressList})
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
      } else if(currentScreen == .todoDetail) {
        TodoDetialPage(currentScreen: $currentScreen, prevScreen: .main, index: clickedIndex ?? 0)
      } else if(currentScreen == .progressList) {
        ProgressDetailPage(currentScreen: $currentScreen, prevScreen: .main, index: clickedIndex ?? 0)
      } else if(currentScreen == .todoList) {
        
      }
    }
  }
}

struct ProjectSelectionView: View {
    var body: some View {
        VStack {
            Text("Projects Screen")
                .font(.largeTitle)
                .padding()
        }
    }
}
