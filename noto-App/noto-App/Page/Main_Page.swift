import SwiftUI

enum Tab { case settings, home, projects }
enum Page { case main, requestList, requestDetail, todoDetail, progressList, projectDetail,
                 settings, user, pw, alarm, display, client, faq, info }
enum Modal { case todoList, sendRequestList, receiveRequestList, project }

struct MainPage_ContentView: View {
  @State private var projectListData: ProjectList? = nil
  @State var currentScreen: Page = .main
  @State var prevScreen: Page = .main
  @State var selectedPid: Int = 0
  @State var selectedSid: Int = 0
    
  @State private var prevTab: Tab = .home
  @State var selectedTab: Tab = .home
  @State private var showingSheet: Bool = false
    
    let url = "https://www.bestbirthday.co.kr:8080/api"
  
    var body: some View {
//        ZStack{
//            // TabView는 여전히 화면 전환을 처리합니다
//            TabView(selection: $selectedTab) {
//                SettingPage()
//                    .tabItem { Image(systemName: "gear") }
//                    .tag(Tab.settings)
//                
//                mainPage(selectedTab: $selectedTab)
//                    .tabItem { Image(systemName: "house") }
//                    .tag(Tab.home)
//                ProjectSelectionView()
//                    .tabItem { Image(systemName: "folder") }
//                    .tag(Tab.projects)
//            }
//            // Custom Button을 TabBar 위에 덮어 놓기
//            VStack {
//                HStack{
//                    Button(action: {
//                        print("Custom button tapped.")
//                        showingSheet = true
//                    }) {
//                        ZStack{
//                            // 큰 배경 박스를 만들기 위한 Rectangle
//                            Rectangle()
//                                .fill(Color.customBackgroundColor)
//                                .frame(width: 135, height: 75) // 버튼 크기 조정
//                                .offset(x: 0, y: 20)
//                            Image(systemName: "folder")
//                                .resizable()
//                                .frame(width: 24, height: 21) // 버튼 크기 조정
//                                .foregroundColor(.gray)
//                        }
//                    }
//                    .frame(width: 30, height: 30)
//                }
//                .frame(maxHeight: 750, alignment: .bottom)
//            }
//            .frame(maxWidth: 300, alignment: .trailing)
//        }
            
        TabView(selection: $selectedTab) {
            SettingPage(currentScreen: $currentScreen)
                .tabItem { Image(systemName: "gear") }
                .tag(Tab.settings)
            mainPage(currentScreen: $currentScreen, prevScreen: $prevScreen, selectedSid: $selectedSid, selectedPid: $selectedPid)
                .tabItem { Image(systemName: "house") }
                .tag(Tab.home)
            if currentScreen != .projectDetail {
                if prevTab == .home {
                    mainPage(currentScreen: $currentScreen, prevScreen: $prevScreen, selectedSid: $selectedSid, selectedPid: $selectedPid)
                        .tabItem { Image(systemName: "folder") }
                        .tag(Tab.projects)
                }
                else if prevTab == .settings {
                    SettingPage(currentScreen: $currentScreen)
                        .tabItem { Image(systemName: "folder") }
                        .tag(Tab.projects)
                }
            } else {
                ProjectPage(currentScreen: $currentScreen, selectedPid: $selectedPid, selectedSid: $selectedSid)
                    .tabItem { Image(systemName: "folder") }
                    .tag(Tab.projects)
            }
        }
        .background(Color.white)
        .onChange(of: selectedTab) { newTab in
            if newTab == .projects {
                if currentScreen != .projectDetail {
                    showingSheet = true
                }
            } else {
                prevTab = newTab
                if newTab == .home {
                    currentScreen = .main
                } else {
                    currentScreen = .settings
                }
            }
        }
        .onChange(of: currentScreen) { newScreen in
            if newScreen == .projectDetail {
                selectedTab = .projects
            }
        }
        .sheet(isPresented: $showingSheet, onDismiss: {
            showingSheet = false
            if currentScreen == .main || currentScreen == .settings {
                selectedTab = prevTab
            }
        }){
            VStack {
                // 데이터가 로딩된 후 실제 모달 화면 표시
                if let projectListData = projectListData {
                    modalProjectListView(projectListData: $projectListData, currentScreen: $currentScreen, selectedPid: $selectedPid)
                }
            }
            .task {
                // 비동기 작업을 통해 데이터를 가져옴
                do {
                    let projectListResponse = try await get(url: url + "/project/list?userId=1", responseType: ProjectList.self)
                    // 프로젝트 리스트 데이터를 업데이트
                    DispatchQueue.main.async {
                        projectListData = projectListResponse.data
                    }
                } catch {
                    print("Error fetching data: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct MainPage_ContentView_Preview: PreviewProvider {
  static var previews: some View {
    MainPage_ContentView()
  }
}

struct mainPage: View {
  @State private var searchText = ""
  @Binding var currentScreen: Page
  @Binding var prevScreen: Page
  @State var selectedId: Int = 0
  @Binding var selectedSid: Int
  @Binding var selectedPid: Int
  @State var selectedRid: Int = 0
  @State private var selectedRequestType: String = ""
  @State private var selectedRequestRejected: Int = 0
  @State private var showingSheet: Bool = false
    
    @State private var scheduleTodayData: ScheduleToday? = nil
    
    @State private var requestNumberData: RequestNumber? = nil
    
    @State private var projectProgressData: ProjectProgress? = nil
    
    let url = "https://www.bestbirthday.co.kr:8080/api"
  
  var body: some View {
    VStack{
      if currentScreen == .main {
        ScrollView {
          VStack(spacing: 20) {
            mainHeader()
            searchBar(searchText: $searchText, action: {print("검색창 클릭 수정 필요")})
              if let requestNumberData = requestNumberData {
                  requestComponent(req_count: requestNumberData.numberOfRequest, action: { currentScreen = .requestList })
              }
            
            VStack(spacing: 10) {
              Spacer()
                if let scheduleTodayData = scheduleTodayData {
                    // 처음 5개 항목만 처리
                    ForEach(scheduleTodayData.todaySchedule.prefix(5), id: \.self) { todaySchedule in
                        HStack {
                            rowComponent(
                                imageName: "user",
                                title: todaySchedule.name,
                                subtitle: todaySchedule.description,
                                action: {
                                    currentScreen = .todoDetail
                                    selectedSid = todaySchedule.id
                                }
                            )
                        }
                        
                        // 마지막 항목에 대해 다른 처리를 할 수 있습니다.
                        if todaySchedule != scheduleTodayData.todaySchedule.prefix(5).last {
                            Divider().padding(.horizontal, 20)
                        }
                    }
                }
                
                viewAllComponent(title: "오늘 내 할 일 모두 보기", action: {
                    showingSheet = true
                })
            }
            .blockStyle(height: .infinity)
            
            VStack(spacing: 10) {
                if let projectProgressData = projectProgressData {
                    // 처음 1개 항목만 처리
                    ForEach(projectProgressData.projectProgress.prefix(1), id: \.self) { projectProgress in
                        if let progress = projectProgress.progress{
                            simpleProgressRow(title: projectProgress.name,
                                              progress: progress,
                                              Dday: projectProgress.dday,
                                              action: {})
                        }
                    }
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
        .task {
            do {
                let scheduleTodayResponse = try await get(url: url + "/schedule/today?userId=1", responseType: ScheduleToday.self)
                // Handle the response here
//                print(scheduleTodayResponse)
                
                scheduleTodayData = scheduleTodayResponse.data
                
                let requestNumberResponse = try await get(url: url + "/request/number?userId=1", responseType: RequestNumber.self)
                // Handle the response here
//                print(requestNumberResponse)
                
                requestNumberData = requestNumberResponse.data
                
                let projectProgressResponse = try await get(url: url + "/project/progress?userId=1", responseType: ProjectProgress.self)
                // Handle the response here
//                print(projectProgressResponse)
                
                projectProgressData = projectProgressResponse.data
            } catch {
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
        .sheet(isPresented: $showingSheet, onDismiss: {
            showingSheet = false
        }){
            modalTodayTodoListView(scheduleTodayData: $scheduleTodayData, currentScreen: $currentScreen, selectedSid: $selectedSid)
        }
        .onAppear() {
            prevScreen = .main
        }
      } else if(currentScreen == .requestList) {
          RequestListPage(currentScreen: $currentScreen, selectedRid: $selectedRid, prevScreen: prevScreen)
      } else if(currentScreen == .todoDetail) {
          TodoDetialPage(currentScreen: $currentScreen, selectedSid: $selectedSid, selectedPid: $selectedPid, prevScreen: prevScreen)
      } else if(currentScreen == .progressList) {
          ProgressDetailPage(currentScreen: $currentScreen, selectedPid: $selectedPid, prevScreen: .main)
      } else if(currentScreen == .requestDetail) {
          RequestDetailPage(currentScreen: $currentScreen, selectedRid: $selectedRid, prevScreen: .requestList)
      } else if(currentScreen == .projectDetail) {
          ProjectPage(currentScreen: $currentScreen, selectedPid: $selectedPid, selectedSid: $selectedSid)
          .onAppear() {
              prevScreen = .projectDetail
          }
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


