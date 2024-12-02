import SwiftUI

// 컴포넌트 정의
struct ScrollViewStyle: ViewModifier {
  func body(content: Content) -> some View {
    content
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color.customBackgroundColor)
      .edgesIgnoringSafeArea(.all)
  }
}

struct BackgroundStyle: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding()
  }
}

struct BlockStyle: ViewModifier {
  var height: CGFloat
  
  func body(content: Content) -> some View {
    content
      .frame(maxWidth: 380)
      .frame(maxHeight: height)
      .background(Color.white)
      .cornerRadius(20)
      .shadow(color: Color.customShadownColor, radius: 4, x: 0, y: 0)
  }
}

// 블럭 컴포넌트 내에 모두 보기 버튼
struct viewAllComponent: View {
  var title: String
  var action: () -> Void
  
  var body: some View {
    Divider()
      .padding(.top, 5)
      .padding(.horizontal, 15)
    Button(action: {
      action()
    }) {
      HStack {
        Text("\(title)")
          .viewAllFont()
        Image(systemName: "chevron.right")
          .font(.system(size:10, weight: .medium))
          .foregroundColor(.customLightGray)
      }
      .padding(.bottom, 10)
      .frame(width: 300, height: 30)
    }
  }
}

// 컴포넌트 정의
extension View {
  func scrollViewStyle() -> some View {
    self.modifier(ScrollViewStyle())
  }
  
  func backgroundStyle() -> some View {
    self.modifier(BackgroundStyle())
  }
  
  func blockStyle(height: CGFloat) -> some View {
    self.modifier(BlockStyle(height: height))
  }
}
