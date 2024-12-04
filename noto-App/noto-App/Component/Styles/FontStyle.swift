import SwiftUI

// 폰트 구조체 정의
struct CurrentPageFont: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.custom("Freesentation-7Bold", size: 30))
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

struct ProjectContnentFont: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.custom("Freesentation-6SemiBold", size: 13))
      .foregroundColor(.customDarkGray)
  }
}

struct DescriptionFont: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.custom("Freesentation-5Medium", size: 13))
      .foregroundColor(.customDarkGray)
      .multilineTextAlignment(.leading)
      .lineSpacing(10)
  }
}

struct ViewAllFont: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.custom("Freesentation-5Medium", size: 13))
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
  
  func viewAllFont() -> some View {
    self.modifier(ViewAllFont())
  }
  
  func emphasizeFont() -> some View {
    self.modifier(EmphasizedFont())
  }
  
  func projectContentFont() -> some View {
    self.modifier(ProjectContnentFont())
  }
}

// 스타일 정의
extension View {
  func actionButtonStyle() -> some View {
    self.modifier(ActionButtonStyle())
  }
}
