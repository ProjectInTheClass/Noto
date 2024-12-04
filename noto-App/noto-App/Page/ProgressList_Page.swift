import SwiftUI

struct ProgressDetailPage_ContentView: View {
  @State private var currentScreen: Page = .progressList
  @State private var prevScreen: Page = .main
  @State private var clickedIndex: Int = 1
  var body: some View {
    ProgressDetailPage(currentScreen: $currentScreen, prevScreen: prevScreen, pid: clickedIndex)
  }
}

struct ProgressDetailPage_ContentView_Preview: PreviewProvider {
  static var previews: some View {
    ProgressDetailPage_ContentView()
  }
}

struct ProgressDetailPage: View {
  @State private var searchText = ""
  @Binding var currentScreen: Page
  var prevScreen: Page
  var pid: Int
  
  var body: some View {
    VStack {
      ScrollView {
        VStack(spacing: 15) {
          dumyHeader()
          goBackHeader(goBackAction: { currentScreen = prevScreen })
          searchBar(searchText: $searchText, action: { print("검색 버튼 수정 필요") })
          
          ForEach(projectList.indices, id: \.self) { index in
            VStack {
              VStack(alignment: .leading, spacing: 20) {
                Spacer()
                projectTitleRow(imageName: projectList[index].imageName, name: projectList[index].name)
                barGraphComponent(progress: projectList[index].progress, width: 335, height: 20)
                projectContentRows(projectIndex: index)
                  .padding(.bottom, 10)
              }
              viewAllComponent(title: "프로젝트 페이지로 이동", action: {currentScreen = .projectDetail})
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

struct projectTitleRow: View {
  var imageName: String
  var name: String
  
  var body: some View {
    HStack {
      imageComponent(imageName: imageName, shape: .rectangle, size: 24)
      Text(name)
        .titleFont()
        .padding(.leading, 10)
    }
  }
}

struct projectContentRows: View {
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
