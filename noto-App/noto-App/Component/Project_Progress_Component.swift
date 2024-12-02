import SwiftUI

struct barGraphComponent: View {
  var progress: Double
  var width: CGFloat
  var height: CGFloat
  
  var body: some View {
    ZStack(alignment: .leading) {
      Capsule()
        .frame(width: width, height: height)
        .foregroundColor(.customLightGray)
      ZStack(alignment: .center) {
        Capsule()
          .frame(width: width * progress, height: height)
          .foregroundColor(.customBlue)
          .animation(.easeInOut, value: progress)
        Text("\(progress * 100, specifier: "%.2f")%")
          .font(.custom("Freesentation-7Bold", size: 9))
          .foregroundColor(.customLightGray)
      }
    }
  }
}

struct simpleProgressRow: View {
  var title: String
  var progress: Double
  var Dday : Int
  var action: () -> Void
  
  var body: some View {
    Button(action: {
      action()
    }) {
      VStack(alignment: .leading) {
        HStack {
          imageComponent(imageName: "projectImage", shape: .rectangle, size: 20)
            .padding(.trailing, 5)
          
          Text(title)
            .font(.custom("Freesentation-7Bold", size: 15))
            .foregroundColor(.customBlack)
          
          Spacer()
          Text("D-\(Dday)")
            .descriptionFont()
            .padding(.trailing, 5)
        }
        HStack {
          barGraphComponent(progress: progress, width: 335, height: 12)
        }
      }
      .padding(.horizontal, 20)
      .padding(.bottom, 5)
    }
  }
}
