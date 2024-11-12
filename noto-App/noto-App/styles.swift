import SwiftUI

struct CurrentPageFont: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.custom("Freesentation-9Black", size: 30))
      .foregroundColor(.customBlue)
      .multilineTextAlignment(.leading)
      .lineSpacing(10)
  }
}

struct TitleFont: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.custom("Freesentation-7Bold", size: 18))
      .foregroundColor(.customBlack)
      .multilineTextAlignment(.leading)
      .lineSpacing(10)
  }
}

struct ActionButtonStyle: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding()
      .font(.custom("freesentation-5Medium", size: 18))
      .foregroundColor(.customBlue)
  }
}

struct SubTitleFont: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.custom("Freesentation-6SemiBold", size: 15))
      .foregroundColor(.customBlack)
      .multilineTextAlignment(.leading)
      .lineSpacing(10)
  }
}

struct InnerTabFont: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.custom("Freesentation-5Medium", size: 15))
      .foregroundColor(.customBlack)
      .multilineTextAlignment(.leading)
      .lineSpacing(10)
  }
}

struct DescriptionFont: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.custom("Freesentation-5Medium", size: 10))
      .foregroundColor(.customLightGray)
      .multilineTextAlignment(.leading)
      .lineSpacing(10)
  }
}

struct EmphasizedFont: ViewModifier {
  func body(content: Content) -> some View {
    content
      .foregroundColor(.customBlue)
      .multilineTextAlignment(.leading)
      .lineSpacing(10)
  }
}

// 폰트 정의
extension View {
  func currentPageFont() -> some View {
    self.modifier(CurrentPageFont())
  }
  
  func titleFont() -> some View {
    self.modifier(TitleFont())
  }
  
  func subTitleFont() -> some View {
    self.modifier(SubTitleFont())
  }
  
  func innerTabFont() -> some View {
    self.modifier(InnerTabFont())
  }
  
  func descriptionFont() -> some View {
    self.modifier(DescriptionFont())
  }
  
  func emphasizeFont() -> some View {
    self.modifier(EmphasizedFont())
  }
}

// 스타일 정의
extension View {
  func actionButtonStyle() -> some View {
    self.modifier(ActionButtonStyle())
  }
}

extension Color {
  static let customBlue = Color(red: 36 / 255, green: 112 / 255, blue: 211 / 255)
  static let customBackgroundColor = Color(red: 247 / 255, green: 247 / 255, blue: 247 / 255)
  static let customLightGray = Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255)
  static let customDarkGray = Color(red: 173 / 255, green: 172 / 255, blue: 172 / 255)
  static let customBlack = Color(red: 50 / 255, green: 50 / 255, blue: 50 / 255)
}
