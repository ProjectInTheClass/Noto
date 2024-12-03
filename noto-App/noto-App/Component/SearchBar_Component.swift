import SwiftUI

// 검색창 컴포넌트
struct searchBar: View {
  @Binding var searchText: String
  var action: () -> Void
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
