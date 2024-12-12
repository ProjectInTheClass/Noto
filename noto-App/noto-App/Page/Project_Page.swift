import SwiftUI

//struct ProjectPage_ContentView: View {
//  @State private var currentScreen: Page = .projectDetail
//    @State var selectedId: Int = 0
//  @State private var prevScreen: Page = .main
//  @State private var pid: Int = 0
//  var body: some View {
//      ProjectPage(currentScreen: $currentScreen, selectedId: $selectedId,
//                prevScreen: prevScreen,
//                pid: pid)
//  }
//}
//
//struct ProjectPage_ContentView_Preview: PreviewProvider {
//  static var previews: some View {
//    ProjectPage_ContentView()
//  }
//}

struct ProjectPage: View {
    @State private var searchText = ""
    @State var selectedDate: Date = Date()
    @State private var requestNumberData: RequestNumber? = nil
    @State private var projectData: Project? = nil
    @State private var scheduleProjectData: [ScheduleProject]? = nil
    @State private var showingModalProject: Bool = false
    @State private var showingModalTodoList: Bool = false
    @Binding var currentScreen: Page
    @Binding var selectedPid: Int
    @Binding var selectedSid: Int
    @Namespace var todoSection
    let calendar = Calendar.current
    
    let url = "https://www.bestbirthday.co.kr:8080/api"
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 20) {
                        mainHeader()
                        
                        if let requestNumberData = requestNumberData {
                            requestComponent(req_count: requestNumberData.numberOfRequest, action: {
                                currentScreen = .requestList
                            })
                        }
                        
                        if let projectData = projectData {
                            VStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Spacer()
                                    titleRow_3(title: projectData.name, optionAction: {
                                        print("프로젝트 설정 버튼 클릭 (수정 필요)")
                                        showingModalProject = true
                                    })
                                    .padding(.top, 10)
                                    .sheet(isPresented: $showingModalProject, onDismiss: {
                                        showingModalProject = false
                                    }) {
                                        modalProjectView(modifiedPid: $selectedPid)
                                    }
                                    Divider()
                                        .padding(10)
                                    VStack(alignment: .leading, spacing: 15){
                                        dateRow(startDate: projectData.startDate, endDate: projectData.endDate)
                                        if let participants = projectData.participants {
                                            participantRow(participants: participants)
                                        }
                                        Divider()
                                            .padding(.horizontal, 10)
                                        descriptionRow(description: projectData.description)
                                    }
                                    Spacer()
                                }
                            }
                            .blockStyle(height: .infinity)
                            
                            VStack {
                                Spacer()
                                CalendarView(currentScreen: $currentScreen, selectedPid: $selectedPid, selectedSid: $selectedSid, selectedDate: $selectedDate,
                                             onDateSelected: {
                                    withAnimation { proxy.scrollTo(todoSection, anchor: .bottom) }
                                }, project: projectData)
                                .padding(.top, 10)
                            }
                            .blockStyle(height: .infinity)
                        }
                        
                        VStack(spacing: 10) {
                            Spacer()
                            if let scheduleProjectData = scheduleProjectData {
                                let filteredScheduleData = scheduleProjectData.filter { schedule in
                                    return (schedule.startDate...schedule.endDate).contains(selectedDate)
                                }
                                
                                if filteredScheduleData.isEmpty {
                                    Text("선택된 날짜에 할 일이 없습니다.")
                                        .foregroundColor(.gray)
                                        .padding()
                                } else {
                                    ForEach(filteredScheduleData.prefix(5), id: \.id) { schedule in
                                        HStack {
                                            rowComponent(
                                                imageName: "user",
                                                title: schedule.name,
                                                subtitle: schedule.description,
                                                action: {
                                                    currentScreen = .todoDetail
                                                    selectedSid = schedule.id
                                                }
                                            )
                                        }
                                        if schedule != filteredScheduleData.prefix(5).last {
                                            Divider().padding(.horizontal, 20)
                                        }
                                    }
                                    
                                    viewAllComponent(title: "할 일 모두 보기", action: {
                                        showingModalTodoList = true
                                    })
                                    .sheet(isPresented: $showingModalTodoList, onDismiss: {
                                        showingModalTodoList = false
                                    }) {
                                        modalProjectTodoListView(scheduleProjectData: filteredScheduleData, currentScreen: $currentScreen, selectedSid: $selectedSid)
                                    }
                                }
                            }
                        }
                        .blockStyle(height: .infinity)
                        
                        dumyBottom()
                            .id(todoSection)
                    }
                    .backgroundStyle()
                }
                .scrollViewStyle()
                .task {
                    do {
                        let projectResponse = try await get(url: url + "/project" + "/\(selectedPid)", responseType: Project.self)
                        projectData = projectResponse.data
                        
                        let requestNumberResponse = try await get(url: url + "/request/number?userId=1", responseType: RequestNumber.self)
                        requestNumberData = requestNumberResponse.data
                        
                        let scheduleProjectResponse = try await get(url: url + "/schedule/project" + "/\(selectedPid)", responseType: [ScheduleProject]?.self)
                        scheduleProjectData = scheduleProjectResponse.data
                    } catch {
                        print("Error fetching data: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}


struct CalendarView: View {
  // 현재 월 및 연도
  @State private var currentDate = Date()
  @State private var showingSheet = false
  @State private var scheduleProjectData: [ScheduleProject]? = nil
  @Binding var currentScreen: Page
  @Binding var selectedPid: Int
  @Binding var selectedSid: Int
  @Binding var selectedDate: Date
  var onDateSelected: () -> Void
  let calendar = Calendar.current
  let project: Project
  
  var body: some View {
    VStack(alignment: .leading) {
      Spacer()
        titleRow_3(title: "\(monthAndYear(for: currentDate)) 캘린더", optionAction: {
            print("캘린더 설정 버튼 클릭 (수정 필요)")
            showingSheet = true
        })
        .sheet(isPresented: $showingSheet, onDismiss: {
            showingSheet = false
        }){
            VStack {
                // 데이터가 로딩된 후 실제 모달 화면 표시
                if let scheduleProjectData = scheduleProjectData {
                    modalTodoListView(scheduleProjectData: $scheduleProjectData, currentScreen: $currentScreen, selectedPid: $selectedPid, selectedSid: $selectedSid)
                }
            }
            .task {
                // 비동기 작업을 통해 데이터를 가져옴
                do {
                    let scheduleProjectResponse = try await get(url: "https://www.bestbirthday.co.kr:8080/api/schedule/project" + "/\(selectedPid)", responseType: [ScheduleProject]?.self)
                    // 프로젝트 리스트 데이터를 업데이트
                    DispatchQueue.main.async {
                        scheduleProjectData = scheduleProjectResponse.data
                    }
                } catch {
                    print("Error fetching data: \(error.localizedDescription)")
                }
            }
        }
      
      Divider()
        .padding(.horizontal, 20)
        .padding(.top, 10)
      
      // 캘린더 레이아웃
      CalendarGridView(currentDate: $currentDate,
                       selectedDate: $selectedDate,
                       onDateSelected: onDateSelected)
        .padding()
    
    }
  }
  
  // 현재 월 및 연도 텍스트 표시
  private func monthAndYear(for date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy MMMM"
    formatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
    return formatter.string(from: date)
  }
}

struct CalendarGridView: View {
  @Binding var currentDate: Date
  @Binding var selectedDate: Date
  var onDateSelected: () -> Void
  let calendar = Calendar.current
  
  var body: some View {
    let daysInMonth = getDaysInMonth(for: currentDate)
    let firstDayOfMonth = getFirstDayOfMonth(for: currentDate)
    let weekdays = calendar.shortWeekdaySymbols
    let components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
    
    VStack(spacing: 5) {
      // 요일 헤더
      HStack {
        ForEach(weekdays, id: \.self) { day in
          Text(day)
            .frame(maxWidth: .infinity)
            .titleFont()
        }
      }
      .padding(.bottom, 10)
      
      // 날짜 셀
      LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
        // 빈 공간 추가 (첫째 주의 시작 요일에 맞춤)
        ForEach(0..<firstDayOfMonth, id: \.self) { _ in
          Text("").frame(maxWidth: .infinity)
        }
        // 날짜와 이벤트 렌더링
        ForEach(1...daysInMonth, id: \.self) { day in
          let currentDay = calendar.date(byAdding: .day, value: day - 1, to: getFirstDateOfMonth(for: currentDate))!
          let currentDayComponents = calendar.dateComponents([.year, .month, .day], from: currentDay)
          Button(action: {
            selectedDate = currentDay
            onDateSelected()
          }) {
            VStack(spacing: 0){
              // 날짜 숫자
              if(currentDayComponents == components){
                Text("\(day)")
                  .foregroundColor(.customBlue)
                  .font(.body)
                  .fontWeight(.bold)
                  .frame(maxWidth: .infinity)
              } else {
                Text("\(day)")
                  .foregroundColor(.customBlack)
                  .font(.body)
                  .frame(maxWidth: .infinity)
              }
              
              // 이벤트 바
              if (eventForDate(currentDay) != nil) {
                Circle()
                  .fill(Color.blue)
                  .frame(height: 5)
              }
            }
            .frame(height: 40, alignment: .top)
          }
        }
      }
    }
    .gesture(
      DragGesture()
        .onEnded { value in
          if value.translation.width < 0 {
            currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
          } else if value.translation.width > 0 {
            currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
          }
        }
    )
  }
  
  // 특정 날짜에 이벤트가 있는지 확인
  private func eventForDate(_ date: Date) -> Todo? {
      for todo in todolist {
          if calendar.isDate(date, inSameDayAs: todo.startDate) ||
              (todo.startDate...todo.endDate).contains(date) {
              return todo
          }
      }
      return nil
  }
  
  // 해당 월의 첫째 날 가져오기
  private func getFirstDateOfMonth(for date: Date) -> Date {
      let components = calendar.dateComponents([.year, .month], from: date)
      return calendar.date(from: components)!
  }
  
  // 해당 월의 첫째 날의 요일 가져오기
  private func getFirstDayOfMonth(for date: Date) -> Int {
      let firstDate = getFirstDateOfMonth(for: date)
      return calendar.component(.weekday, from: firstDate) - 1
  }
  
  // 해당 월의 날짜 수 가져오기
  private func getDaysInMonth(for date: Date) -> Int {
      guard let range = calendar.range(of: .day, in: .month, for: date) else { return 0 }
      return range.count
  }
}


