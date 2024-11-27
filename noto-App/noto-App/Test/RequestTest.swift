import SwiftUI

func buttonTest(_ comment: String) {
  print(comment)
}

struct RequestTest_ContentView: View {
  var body: some View {
    VStack {
      acceptButton(action: buttonTest)
    }
    .backgroundStyle()
  }
}

struct RequestTest_ContentView_Preview: PreviewProvider {
  static var previews: some View {
    RequestTest_ContentView()
  }
}
