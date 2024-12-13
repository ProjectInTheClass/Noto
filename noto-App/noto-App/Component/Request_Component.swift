import SwiftUI

// 리퀘스트 및 알림 컴포넌트
struct requestComponent: View {
  let req_count: Int
  var action: () -> Void
  
  var body: some View {
    Button(action: {
      action()
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
            .padding(.trailing, 10)
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

struct acceptButton: View {
  var action: (String) -> Void
  var body: some View {
    Button(action: {
      action("accept Button clicked")
    }) {
      Text("수락")
        .actionButtonStyle()
    }
  }
}
