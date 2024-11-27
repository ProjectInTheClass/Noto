import SwiftUI

// 헤더 컴포넌트
struct mainHeader: View {
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

struct currentPageHeader: View {
  var currentPage: String
  
  var body: some View {
    HStack {
      Text(currentPage)
        .currentPageFont()
      Spacer()
    }
    .frame(width: .infinity, height: 96, alignment: .bottomLeading)
    .padding(.leading, 10)
  }
}

struct goBackHeader: View {
  var action: () -> Void
  var body: some View {
    HStack {
      Button(action: {
        print("goBack button clicked")
        action()
      }) {
        Text("뒤로 가기")
          .actionButtonStyle()
      }
    }
    .frame(width: 380, height: 20, alignment: .leading)
  }
}

struct goBackCompletionHeader: View {
  var goBackAction: () -> Void
  var completionAction: () -> Void
  var body: some View {
    HStack {
      Button(action: {
        print("goBack button clicked")
        goBackAction()
      }) {
        Text("뒤로 가기")
          .actionButtonStyle()
      }
      
      Spacer()
      
      Button(action: {
        print("completion button clicked")
        completionAction()
      }) {
        Text("완료")
          .actionButtonStyle()
      }
    }
    .frame(width: 380, height: 20, alignment: .leading)
  }
}

struct requestHeader: View {
  var onGoBack: () -> Void
  var addAction: () -> Void
  
  var body: some View {
    HStack{
      Button(action: {
        onGoBack()
      }) {
        Text("뒤로 가기")
          .actionButtonStyle()
      }
      
      Spacer()
      
      Button(action: {
        print("리퀘스트 추가 버튼 클릭")
        addAction()
      }) {
        HStack {
          Image(systemName: "plus")
            .font(.system(size:15, weight: .bold))
            .foregroundColor(.customDarkGray)
            .padding(.trailing, 10)
        }
      }
    }
    .frame(width: 380, height: 20, alignment: .trailing)
  }
}
