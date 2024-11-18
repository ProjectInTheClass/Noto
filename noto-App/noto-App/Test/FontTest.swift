import SwiftUI

// 폰트 목록을 출력하는 함수 정의
func printAvailableFonts() {
  // 폰트 체크 하기
  UIFont.familyNames.sorted().forEach { familyName in
    print("*** \(familyName) ***")
    UIFont.fontNames(forFamilyName: familyName).forEach { fontName in
      print("\(fontName)")
    }
    print("---------------------")
  }
}

struct FontTest_ContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Freesentation-Thin")
                .font(.custom("Freesentation-1Thin", size: 20))
                .foregroundColor(.primary)

            Text("Freesentation-ExtraLight")
                .font(.custom("Freesentation-2ExtraLight", size: 20))
                .foregroundColor(.primary)

            Text("Freesentation-Light")
                .font(.custom("Freesentation-3Light", size: 20))
                .foregroundColor(.primary)

            Text("Freesentation-Regular")
                .font(.custom("Freesentation-4Regular", size: 20))
                .foregroundColor(.primary)

            Text("Freesentation-Medium")
                .font(.custom("Freesentation-5Medium", size: 20))
                .foregroundColor(.primary)

            Text("Freesentation-SemiBold")
              .font(.custom("Freesentation-6SemiBold", size: 20))
              .foregroundColor(.primary)
          
            Text("Freesentation-Bold")
                .font(.custom("Freesentation-7Bold", size: 20))
                .foregroundColor(.primary)
          
            Text("Freesentation-ExtraBold")
              .font(.custom("Freesentation-8ExtraBold", size: 20))
              .foregroundColor(.primary)

            Text("Freesentation-Black")
                .font(.custom("Freesentation-9Black", size: 20))
                .foregroundColor(.primary)
        }
        .padding()
    }
}

struct FontTest_ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FontTest_ContentView()
            .previewLayout(.sizeThatFits)
    }
}
