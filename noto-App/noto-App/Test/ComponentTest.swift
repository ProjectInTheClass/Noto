import SwiftUI

struct ComponentTest_ContentView: View {
  var body: some View {
      VStack(spacing: 20) {
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

