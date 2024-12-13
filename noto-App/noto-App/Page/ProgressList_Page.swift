import SwiftUI

//struct ProgressDetailPage_ContentView: View {
//  @State private var currentScreen: Page = .progressList
//  @State private var prevScreen: Page = .main
//  @State private var selectedPid: Int = 0
//  var body: some View {
//      ProgressDetailPage(currentScreen: $currentScreen, selectedPid: $selectedPid, prevScreen: .main)
//  }
//}
//
//struct ProgressDetailPage_ContentView_Preview: PreviewProvider {
//  static var previews: some View {
//    ProgressDetailPage_ContentView()
//  }
//}

struct ProgressDetailPage: View {
  @State private var searchText = ""
  @State private var projectProgressData: ProjectProgress? = nil
  @Binding var currentScreen: Page
  @Binding var selectedPid: Int
  var prevScreen: Page
  let url = "https://www.bestbirthday.co.kr:8080/api"
  
  var body: some View {
    VStack {
      ScrollView {
        VStack(spacing: 15) {
          dumyHeader()
          goBackHeader(goBackAction: { currentScreen = prevScreen })
          searchBar(searchText: $searchText, action: { print("검색 버튼 수정 필요") })
          
            if let projectProgressData = projectProgressData {
                // 처음 1개 항목만 처리
                ForEach(projectProgressData.projectProgress, id: \.self) { projectProgress in
                    VStack {
                      VStack(alignment: .leading, spacing: 20) {
                        Spacer()
                        projectTitleRow(imageName: "projectImage", name: projectProgress.name)
                          if let progress = projectProgress.progress {
                              barGraphComponent(progress: progress, width: 335, height: 20)
                          }
                        projectContentRows(projectProgress: projectProgress)
                      }
                        viewAllComponent(title: "프로젝트 페이지로 이동", action: {
                            currentScreen = .projectDetail
                            selectedPid = projectProgress.id
                        })
                    }
                    .blockStyle(height: .infinity)
                }
            }
        
        }
        .backgroundStyle()
      }
      .scrollViewStyle()
      .task {
          do {              
              let projectProgressResponse = try await get(url: url + "/project/progress?userId=1", responseType: ProjectProgress.self)
              // Handle the response here
              print(projectProgressResponse)
              
              projectProgressData = projectProgressResponse.data
          } catch {
              print("Error fetching data: \(error.localizedDescription)")
          }
      }
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
  let projectProgress: ProjectProgressDetail
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
  var body: some View {
    VStack(spacing: 10) {
      // 프로젝트 참여자 정보 출력
      HStack {
        Text("프로젝트 참여자")
          .projectContentFont()
        
          ScrollView(.horizontal, showsIndicators: false) {  // Horizontal ScrollView 추가
              HStack {
                  ForEach(projectProgress.participants, id: \.self) { participant in
                      Text("\(participant)")
                          .projectContentFont()
                          .lineLimit(1)          // 한 줄로 제한
                  }
              }
          }
      }
      .frame(maxWidth: 333, alignment: .leading)
      // 프로젝트 시작일 정보 출력
      HStack {
        Text("프로젝트 시작일")
          .projectContentFont()
        
        Text("\(dateFormatter.string(from: projectProgress.startDate))")
          .projectContentFont()
          .submitLabel(.continue)
      }
      .frame(maxWidth: 333, alignment: .leading)
      // 프로젝트 마감일 정보 출력
      HStack {
        Text("프로젝트 마감일")
          .projectContentFont()
        
        Text("\(dateFormatter.string(from: projectProgress.endDate))")
          .projectContentFont()
      }
      .frame(maxWidth: 333, alignment: .leading)
    }
  }
}
