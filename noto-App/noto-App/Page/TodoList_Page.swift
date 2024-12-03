import SwiftUI

import SwiftUI

struct TodoListPage_ContentView: View {
  @State private var currentScreen: Page = .todoList
  @State private var prevScreen: Page = .main
  @State private var clickedIndex: Int = 1
  var body: some View {
    TodoListPage(currentScreen: $currentScreen, prevScreen: prevScreen)
  }
}

struct TodoListPage_ContentView_Preview: PreviewProvider {
  static var previews: some View {
    TodoListPage_ContentView()
  }
}

struct TodoListPage: View {
  @State private var searchText = ""
  @Binding var currentScreen: Page
  var prevScreen: Page
  
  var body: some View {
    VStack {
      ScrollView {
        VStack(alignment: .leading, spacing: 15) {
          dumyHeader()
          goBackHeader(goBackAction: { currentScreen = prevScreen })
          searchBar(searchText: $searchText, action: { print("검색 버튼 수정 필요") })
          
          ForEach(projectList.indices, id: \.self) { projectIndex in
            let relatedTodos = todolist.filter { $0.pid == projectList[projectIndex].pid }
            VStack(alignment: .leading, spacing: 15) {
              Spacer()
              projectTitleRow(imageName: projectList[projectIndex].imageName, name: projectList[projectIndex].name)
              
              if relatedTodos.isEmpty {
                Text("할 일이 없습니다.")
                  .descriptionFont()
              } else {
                ForEach(relatedTodos.indices, id: \.self) { todoIndex in
                  Text("Todo: \(relatedTodos[todoIndex].title)")
                }
              }
              //viewAllComponent(title: "프로젝트 페이지로 이동", action: {print("프로젝트 이동 클릭")})
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

struct todoTitleRow: View {
  var imageName: String
  var title: String
  
  var body: some View {
    HStack {
      imageComponent(imageName: imageName, shape: .rectangle, size: 24)
      Text(title)
        .titleFont()
        .padding(.leading, 10)
    }
  }
}

struct todoContentRows: View {
  var projectIndex: Int
  
  var body: some View {
    VStack(spacing: 10) {
      // 프로젝트 참여자 정보 출력
      HStack {
        Text("프로젝트 참여자")
          .projectContentFont()
          .padding(.trailing, 10)
        
        HStack {
          ForEach(projectList[projectIndex].participants.indices, id: \.self) { index in
            Text("\(projectList[projectIndex].participants[index].name)")
              .projectContentFont()
          }
        }
      }
      // 프로젝트 시작일 정보 출력
      HStack {
        Text("프로젝트 시작일")
          .projectContentFont()
          .padding(.trailing, 10)
        
        Text("\(dateFormatter.string(from: projectList[projectIndex].startDate))")
          .projectContentFont()
          .submitLabel(.continue)
      }
      // 프로젝트 마감일 정보 출력
      HStack {
        Text("프로젝트 마감일")
          .projectContentFont()
          .padding(.trailing, 10)
        
        Text("\(dateFormatter.string(from: projectList[projectIndex].endDate))")
          .projectContentFont()
      }
    }
  }
}

