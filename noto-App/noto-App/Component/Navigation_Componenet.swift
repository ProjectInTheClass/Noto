import SwiftUI

// 네비게이션바 컴포넌트
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
