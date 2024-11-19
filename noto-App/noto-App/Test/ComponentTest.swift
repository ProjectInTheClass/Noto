import SwiftUI

func test(_ comment: String) {
  print(comment)
}

var imageName: String = "user"
var title: String  = "메인화면 레이아웃 설계 및 구현"
var subtitle: String = "할 일 목록을 표시하는 메인 화면의 레이아웃을 설계하고 구현"

struct ComponentTest_ContentView: View {
  @State private var searchText = ""
  var body: some View {
      VStack(spacing: 20) {
        searchBar(searchText: $searchText, action: test)
        requestComponent(req_count: 5, action: test)
        rowComponent(imageName: imageName, title: title, subtitle: subtitle)
          .blockStyle(height: 100)
        
        // 첫 번째 블럭: 사진 포함
        Image(systemName: "photo")
          .resizable()
          .scaledToFit()
          .blockStyle(height: 150) // 높이를 지정하여 블럭 생성

        // 두 번째 블럭: 여러 텍스트 포함
        VStack {
          Text("This is a title")
            .font(.headline)
          Text("This is a description of the block.")
            .font(.subheadline)
            .foregroundColor(.gray)
        }
        .blockStyle(height: 120)

        // 세 번째 블럭: 사용자 정의 콘텐츠
        VStack {
          Text("Custom Content")
          Image(systemName: "star.fill")
            .foregroundColor(.yellow)
        }
        .blockStyle(height: 180)
      }
      .backgroundStyle()
  }
}

struct ComponentTest_ContentView_Preview: PreviewProvider {
  static var previews: some View {
    ComponentTest_ContentView()
  }
}

