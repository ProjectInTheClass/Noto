import SwiftUI

// 컴포넌트 정의
struct ScrollViewComponent: ViewModifier {
  func body(content: Content) -> some View {
    content
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color.customBackgroundColor)
      .edgesIgnoringSafeArea(.all)
  }
}

struct BackgroundComponent: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding()
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

// 헤더 컴포넌트
struct headerComponent: View {
  var body: some View {
    VStack {
      Image("Noto 로고")
        .resizable()
        .scaledToFit()
        .frame(width: 120)
    }
    .frame(width: .infinity, height: 96, alignment: .bottom)
  }
}

// 네비게이션바 컴포넌트
enum Tab {
  case settings, home, projects
}

struct navigationBar: View {
  @Binding var selectedTab: Tab
  
  var body: some View {
    HStack {
      Spacer()
      Button(action: { selectedTab = .settings }) {
        settingMenuIcon()
      }
      Spacer(minLength: 100)
      Button(action: { selectedTab = .home }) {
        homeMenuIcon()
      }
      Spacer(minLength: 100)
      Button(action: { selectedTab = .projects }) {
        projectMenuIcon()
      }
      Spacer()
    }
    .background(Color.white)
    .frame(width: .infinity, height: 50)
  }
}


struct DetailView: View {
  var body: some View {
    VStack {
      Text("Detail Screen")
        .font(.largeTitle)
    }
    .navigationTitle("Detail")
  }
}

struct settingMenuIcon: View {
  var body: some View {
    Image(systemName: "gearshape")
      .font(.system(size: 32, weight: .medium))
      .foregroundColor(.customLightGray)
  }
}

struct homeMenuIcon: View {
  var body: some View {
    Image(systemName: "house")
      .font(.system(size: 32, weight: .medium))
      .foregroundColor(.customLightGray)
  }
}

struct projectMenuIcon: View {
  var body: some View {
    Image(systemName: "square.grid.2x2")
      .font(.system(size: 32, weight: .medium))
      .foregroundColor(.customLightGray)
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
          .padding(.leading, 20)
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
  var action: (String) -> Void
  
  var body: some View {
    Button(action: {
      action("Row component clicked")
    }) {
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
}

// 블럭 컴포넌트 내에 모두 보기 버튼
struct viewAllComponent: View {
  var title: String
  var action: (String) -> Void
  
  var body: some View {
    Divider()
      .padding(.top, 5)
      .padding(.horizontal, 15)
    Button(action: {
      action("View-all button clicked")
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
    self.modifier(ScrollViewComponent())
  }
  
  func backgroundStyle() -> some View {
    self.modifier(BackgroundComponent())
  }
  
  func blockStyle(height: CGFloat) -> some View {
    self.modifier(BlockComponent(height: height))
  }
}
