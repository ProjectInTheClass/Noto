import SwiftUI

// 컴포넌트 정의
struct BackgroundComponent: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding()
      .frame(maxWidth: .infinity, maxHeight: .infinity) // 화면 크기에 맞게 확장
      .background(Color.customBackgroundColor) // 배경색 설정
      .edgesIgnoringSafeArea(.all) // 모든 영역에 적용
  }
}

struct BlockComponent: ViewModifier {
  var height: CGFloat
  
  func body(content: Content) -> some View {
    content
      .frame(maxWidth: 380)
      .frame(height: height)
      .background(Color.white)
      .cornerRadius(20)
      .shadow(color: Color.customShadownColor, radius: 4, x: 0, y: 0)
  }
}

// 리퀘스트 및 알림 컴포넌트
struct requestComponent: View {
  @State var req_count: Int
  var action: (String) -> Void
  
  var body: some View {
    Button(action: {
      action("Request component clicked")
    }) {
      HStack {
        Text("리퀘스트 및 알림")
          .titleFont()
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 15)
        Spacer()
        HStack(spacing: 5) {
          Text("\(req_count)")
            .foregroundColor(.customBlue)
            .font(.custom("Freesentation-9Black", size: 15))
            .padding(5)
          Image(systemName: "chevron.right")
            .font(.system(size:15, weight: .bold))
            .foregroundColor(.customLightGray)
        }
        .padding(.trailing, 15)
      }
    }
    .padding()
    .frame(maxWidth: .infinity)
    .frame(height: 49)
    .background(Color.white)
    .cornerRadius(20)
    .shadow(color: Color.customShadownColor, radius: 4, x: 0, y: 0)
  }
}

// 검색창 컴포넌트
struct searchBar: View {
  @Binding var searchText: String
  var action: (String) -> Void
  var placeholder: String = "검색"
  
  var body: some View {
    HStack {
      Image(systemName: "magnifyingglass")
        .resizable()
        .frame(width: 20, height:  20)
        .foregroundColor(.customLightGray)
      TextField(placeholder, text: $searchText)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.custom("Freesentation-4Regular", size: 20))
        .foregroundColor(.customLightGray)
        .padding(.leading, 5)
        .overlay(
          HStack {
            Spacer()
            if !searchText.isEmpty {
              Button(action: {
                searchText = ""
              }) {
                Image(systemName: "xmark.circle.fill")
                  .foregroundColor(.customLightGray)
              }
              .padding(.trailing, 8)
            }
          }
        )
    }
    .padding()
    .frame(maxWidth: .infinity)
    .frame(height: 37)
    .background(Color.white)
    .cornerRadius(10)
    .shadow(color: Color.customShadownColor, radius: 4, x: 0, y: 0)
  }
}

// 행 컴포넌트
struct rowComponent: View {
  var imageName: String
  var title: String
  var subtitle: String
  
  var body: some View {
    HStack {
      Image(imageName)
        .resizable()
        .frame(width: 24, height: 24)
        .padding(.trailing, 5)
      VStack(alignment: .leading) {
        Text(title)
          .subTitleFont()
        Text(subtitle)
          .descriptionFont()
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.leading, 20)
  }
}

// 컴포넌트 정의
extension View {
  func backgroundStyle() -> some View {
    self.modifier(BackgroundComponent())
  }
  
  func blockStyle(height: CGFloat) -> some View {
    self.modifier(BlockComponent(height: height))
  }
}
