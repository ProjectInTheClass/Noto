import SwiftUI

struct ImageTest_ContentView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Image("Noto 로고")
        .resizable() // 크기를 조정할 수 있도록 합니다.
        .aspectRatio(contentMode: .fit) // 비율을 유지하며 맞춤
        .frame(width: 100, height: 100) // 원하는 크기로 설정
        .clipShape(Circle()) // 이미지 모양을 원형으로 자르기
    }
  }
}

struct ImageTest_ContentView_Preview: PreviewProvider {
  static var previews: some View {
    ImageTest_ContentView()
      .previewLayout(.sizeThatFits)
  }
}
