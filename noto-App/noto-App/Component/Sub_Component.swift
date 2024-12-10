import SwiftUI

// 행 컴포넌트
struct rowComponent: View {
  var imageName: String
  var title: String
  var subtitle: String
  var action: () -> Void
  
  var body: some View {
    Button(action: {
      action()
    }) {
      HStack {
        Image(imageName)
          .resizable()
          .frame(width: 24, height: 24)
          .padding(.trailing, 5)
        VStack(alignment: .leading) {
          Text(title)
            .subTitleFont()
            .lineLimit(1)
            .truncationMode(.tail)
          Text(subtitle)
            .descriptionFont()
            .lineLimit(1)
            .truncationMode(.tail)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 20)
    }
  }
}

struct userInfoRow: View {
  var userImage: String
  var userName: String
  var userEmail: String
  var action: () -> Void

  var body: some View {
    Button(action: {
      action()
    }) {
      imageComponent(imageName: userImage, shape: .circle ,size: 50)
        .padding(.trailing, 5)
      
      VStack(alignment: .leading) {
        Text(userName)
          .font(.custom("Freesentation-6SemiBold", size: 25))
          .foregroundColor(.customBlack)
        Text(userEmail)
          .descriptionFont()
      }
      
      Spacer()
      
      Image(systemName: "chevron.right")
        .font(.system(size:15, weight: .bold))
        .foregroundColor(.customLightGray)
        .padding(.trailing, 10)
    }
  }
}

struct settingRow: View {
  var imageName: String
  var title: String
  var action: () -> Void
  
  var body: some View {
    Button(action: {
      action()
    }) {
      HStack {
        Image(imageName)
          .resizable()
          .frame(width: 24, height: 24)
          .padding(.trailing, 5)
        VStack(alignment: .leading) {
          Text(title)
            .subTitleFont()
        }
        
        Spacer()
        
        Image(systemName: "chevron.right")
          .font(.system(size:15, weight: .bold))
          .foregroundColor(.customLightGray)
          .padding(.trailing, 10)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

// 행 컴포넌트
struct titleRow_1: View {
  var title: String
  
  var body: some View {
    HStack {
      Text(title)
        .titleFont()
        .lineLimit(1)
        .truncationMode(.tail)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 20)
  }
}

struct titleRow_2: View {
  var title: String
  var imageName: String
  var imageSize: CGFloat
  
  var body: some View {
    HStack {
      Image(imageName)
        .resizable()
        .frame(width: imageSize, height: imageSize)
        .padding(.trailing, 5)
      Text(title)
        .titleFont()
        .lineLimit(1)
        .truncationMode(.tail)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 20)
  }
}

struct titleRow_3: View {
  var title: String
  var optionAction: () -> Void
  
  var body: some View {
    HStack {
      Text(title)
        .titleFont()
        .lineLimit(1)
        .truncationMode(.tail)
      Spacer()
      Button(action: {
        optionAction()
      }) {
        Image(systemName: "ellipsis")
          .font(.system(size: 24))
          .foregroundColor(.customBlack)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 20)

  }
}

enum ShapeType { case circle, rectangle }

// 이미지 컴포넌트(크기는 정형 (n x n))
struct imageComponent: View {
  var imageName: String
  var shape: ShapeType
  var size: CGFloat

  var body: some View {
    if shape == .circle {
      Image(imageName)
        .resizable()
        .scaledToFill()
        .frame(width: size, height: size)
        .clipShape(Circle())
    } else if shape == .rectangle {
      Image(imageName)
        .resizable()
        .scaledToFill()
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: size/10))
    }
  }
}

// 입력창 컴포넌트
struct inputComponent: View {
  @Binding var userInput: String
  var placeholder: String

  var body: some View {
      TextField(placeholder, text: $userInput)
  }
}
