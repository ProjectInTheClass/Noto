import SwiftUI

struct ProjectPage_ContentView: View {
  @State private var currentScreen: Page = .projectDetail
  @State private var prevScreen: Page = .main
  @State private var pid: Int = 0
  @State private var selectedDate: Date? = nil
  var body: some View {
    ProjectPage(selectedDate: $selectedDate,
                currentScreen: $currentScreen,
                prevScreen: prevScreen,
                pid: pid)
  }
}

struct ProjectPage_ContentView_Preview: PreviewProvider {
  static var previews: some View {
    ProjectPage_ContentView()
  }
}

struct ProjectPage: View {
  @State private var searchText = ""
  @Binding var selectedDate: Date?
  @Binding var currentScreen: Page
  var prevScreen: Page
  var pid: Int
  let calendar = Calendar.current
  
  var body: some View {
    let project = projectList[pid]
    
    VStack {
      ScrollView {
        VStack(spacing: 20) {
          mainHeader()
          requestComponent(req_count: 5, action: { currentScreen = .requestList })
          
          VStack{
            VStack(alignment: .leading, spacing: 5) {
              Spacer()
              titleRow(title: project.name, optionAction: {print("설정 버튼 수정 필요")})
                .padding(.top, 10)
              Divider()
                .padding(10)
              VStack(alignment: .leading, spacing: 15){
                dateRow(startDate: project.startDate, endDate: project.endDate)
                participantRow()
                Divider()
                  .padding(.horizontal, 10)
                descriptionRow(description: project.description)
              }
              Spacer()
            }
          }
          .blockStyle(height: .infinity)
          
          VStack{
            Spacer()
            CalendarView(selectedDate: $selectedDate, project: project)
              .padding(.top, 10)
          }
          .blockStyle(height: .infinity)
          
          if(selectedDate != nil) {
            VStack(spacing: 10) {
              Spacer()
              
              let filteredTodos = todolist.filter { todo in
                  guard let selectedDate = selectedDate else { return false }
                  return (todo.startDate...todo.endDate).contains(selectedDate) // startDate와 endDate 사이인지 확인
              }
              
              if filteredTodos.isEmpty {
                Text("선택된 날짜에 할 일이 없습니다.")
                  .foregroundColor(.gray)
                  .padding()
              } else {
                ForEach(filteredTodos.indices, id: \.self) { index in
                  let todo = filteredTodos[index]
                  HStack {
                    rowComponent(
                      imageName: todo.imageName,
                      title: todo.title,
                      subtitle: todo.subtitle,
                      action: {
                        currentScreen = .todoDetail
                        //clickedIndex = index // 클릭된 인덱스 저장
                      }
                    )
                  }
                  if index < filteredTodos.count - 1 {
                    Divider()
                      .padding(.horizontal, 20)
                  }
                }
              }
              viewAllComponent(title: "오늘 내 할 일 모두 보기", action: {currentScreen = .todoList})
            }
            .blockStyle(height: .infinity)
          }
        }
        .backgroundStyle()
      }
      .scrollViewStyle()
    }
  }
}

struct CalendarView: View {
  // 현재 월 및 연도
  @State private var currentDate = Date()
  @Binding var selectedDate: Date?
  let calendar = Calendar.current
  let project: project
  
  var body: some View {
    VStack(alignment: .leading) {
      Spacer()
      titleRow(title: "\(monthAndYear(for: currentDate)) 캘린더", optionAction: {print("설정 버튼 수정 필요")})
      
      Divider()
        .padding(.horizontal, 20)
        .padding(.top, 10)
      
      // 캘린더 레이아웃
      CalendarGridView(currentDate: $currentDate, selectedDate: $selectedDate)
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
  @Binding var selectedDate: Date?
  let calendar = Calendar.current
  
  var body: some View {
    let daysInMonth = getDaysInMonth(for: currentDate)
    let firstDayOfMonth = getFirstDayOfMonth(for: currentDate)
    let weekdays = calendar.shortWeekdaySymbols
    
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
          Button(action: {
            selectedDate = currentDay
          }) {
            VStack(spacing: 0){
              // 날짜 숫자
              Text("\(day)")
                .foregroundColor(.customBlack)
                .font(.body)
                .frame(maxWidth: .infinity)
              
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


