import SwiftUI

struct barGraphComponent: View {
  var progress: Int
  var width: CGFloat
  var height: CGFloat
  
  var body: some View {
    ZStack(alignment: .leading) {
      Capsule()
        .frame(width: width, height: height)
        .foregroundColor(.customLightGray)
        ZStack(alignment: .center) {
            // Foreground capsule with blue color
            Capsule()
                .frame(width: width * CGFloat(progress) / 100, height: height) // Convert progress to CGFloat and scale by 100%
                .foregroundColor(.customBlue)
                .animation(.easeInOut, value: progress)
            
            // Text showing the progress as a percentage
            Text("\(progress, specifier: "%.d")%")
                .font(.custom("Freesentation-7Bold", size: 9))
                .foregroundColor(.customLightGray)
        }
    }
  }
}

struct simpleProgressRow: View {
  var title: String
  var progress: Int
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
          Text("D\(Dday)")
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
