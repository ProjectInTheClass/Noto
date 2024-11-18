import SwiftUI

struct StyleTest_ContentView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("Current Page Font").currentPageFont()
      Text("Title Font").titleFont()
      Text("SubTitle Font").subTitleFont()
      Text("InnerTab Font").innerTabFont()
      Text("Description Font").descriptionFont()
      Text("Emphasized Font")
        .emphasizeFont()
      Button("Action Button") {}
        .actionButtonStyle()
    }
  }
}

struct StyleTest_ContentView_Preview: PreviewProvider {
  static var previews: some View {
    StyleTest_ContentView()
      .previewLayout(.sizeThatFits)
  }
}
