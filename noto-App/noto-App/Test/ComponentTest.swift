import SwiftUI

func test() {
  print("테스트")
}
func goBackTest() {
  
}

var imageName: String = "user"
var title: String  = "메인화면 레이아웃 설계 및 구현"
var title2: String = "오늘 내 할 일 모두 보기"
var subtitle: String = "할 일 목록을 표시하는 메인 화면의 레이아웃을 설계하고 구현"
var row_count: Int = 6

struct ComponentTest_ContentView: View {
  @State private var selectedTab: Tab = .home
  
  var body: some View {
    TabView(selection: $selectedTab) {
      SettingsView()
        .tabItem { Image(systemName: "gear") }
        .tag(Tab.settings)
      HomeView(selectedTab: $selectedTab)
        .tabItem { Image(systemName: "house") }
        .tag(Tab.home)
      ProjectSelectionView()
        .tabItem { Image(systemName: "folder") }
        .tag(Tab.projects)
    }
    .background(Color.white)
  }
}

struct ComponentTest_ContentView_Preview: PreviewProvider {
  static var previews: some View {
    ComponentTest_ContentView()
  }
}

struct SettingsView: View {
  @State private var currentScreen: Screen = .settings
  var body: some View {
    VStack {
      if currentScreen == .settings {
        Text("Settings Screen")
            .font(.largeTitle)
            .padding()
        Button(action: {
          //currentScreen = .inner
        }){
          Text("Go to inner screen")
            .font(.headline)
            .padding()
        }
      //} else if currentScreen == .inner {
       // InnerView(onGoBack: {
        //  currentScreen = .settings
        //}, onCompletion: {
          //test("Completion button clicked")
        //})
      }
    }
  }
}

struct InnerView: View {
  let onGoBack: () -> Void
  let onCompletion: () -> Void
  var body: some View {
    VStack {
      Text("Inner Screen")
        .font(.largeTitle)
        .padding()
      //goBackHeader(action: onGoBack)
      goBackCompletionHeader(goBackAction: onGoBack, completionAction: onCompletion)
    }
  }
}

struct HomeView: View {
  @State private var searchText = ""
  @Binding var selectedTab: Tab
  
  var body: some View {
    VStack{
      ScrollView {
        VStack(spacing: 20) {
          mainHeader()
          //searchBar(searchText: $searchText, action: test)
          //requestComponent(req_count: 5, action: test)
          VStack(spacing: 10) {
            rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)
            rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)
            rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)
            rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)
            rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)
            rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)
            //viewAllComponent(title: title2, action: test)
          }
          .frame(maxWidth: .infinity, alignment: .topLeading)
          .padding(.top, 20)
          .blockStyle(height: .infinity)
          VStack(spacing: 10) {
            barGraphComponent(progress: 0.5, width: 312, height: 12)
          }
        }
        .backgroundStyle()
      }
      .scrollViewStyle()
    }
  }
}

struct ProjectSelectionView: View {
    var body: some View {
        VStack {
            Text("Projects Screen")
                .font(.largeTitle)
                .padding()
        }
    }
}
