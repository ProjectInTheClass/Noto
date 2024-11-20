import SwiftUI

func test(_ comment: String) {
  print(comment)
}

var imageName: String = "user"
var title: String  = "메인화면 레이아웃 설계 및 구현"
var title2: String = "오늘 내 할 일 모두 보기"
var subtitle: String = "할 일 목록을 표시하는 메인 화면의 레이아웃을 설계하고 구현"
var row_count: Int = 6

struct ComponentTest_ContentView: View {
  @State private var searchText = ""
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        headerComponent()
        searchBar(searchText: $searchText, action: test)
        requestComponent(req_count: 5, action: test)
        VStack(spacing: 10) {
          rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)
          rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)
          rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)
          rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)
          rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)
          rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)
          viewAllComponent(title: title2, action: test)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.top, 20)
        .blockStyle(height: .infinity)
      }
      .backgroundStyle()
    }
    .scrollViewStyle()
  }
}

struct ComponentTest_ContentView_Preview: PreviewProvider {
  static var previews: some View {
    ComponentTest_ContentView()
  }
}

