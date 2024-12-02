//
//  Modal_Component.swift
//  noto-App
//
//  Created by 박상현 on 11/20/24.
//
import SwiftUI

// Add 행 컴포넌트
struct rowAddComponent: View {
  var action: (String) -> Void
  
  var body: some View {
    Button(action: {
      action("Row component clicked")
    }) {
      HStack {
        Image("user")
          .resizable()
          .frame(width: 24, height: 24)
          .padding(.trailing, 5)
        VStack(alignment: .leading) {
          Text("추가")
            .subTitleFont()
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading, 20)
    }
  }
}

// 레퍼런스 모달 컴포넌트
struct modalReferenceView: View {
    var body: some View {
        VStack {
            // Change this
            ForEach(0..<13) {
                index in
                Text("\(index)")
                    .font(.title)
                    .padding(20)
                    .frame(maxWidth: .infinity)
            }
        }
        .modalPresentation()
    }
}

// 일정 리스트 모달 컴포넌트
struct modalScheduleListView: View {
    var body: some View {
        VStack {
            /*rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)
            rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)
            rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)
            rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)
            rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)
            rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)
            rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)*/
            
        }
        .modalPresentation()
    }
}

// 프로젝트 리스트 모달 컴포넌트
struct modalProjectListView: View {
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                /*rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)
                rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)
                rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)
                rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)
                rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)
                rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)
                rowComponent(imageName: imageName, title: title, subtitle: subtitle, action: test)*/
                Divider()
                //rowAddComponent(action: test)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top)
            .padding(.bottom)
            .blockStyle(height: .infinity)
        }
        .modalPresentation()
    }
}

// 일정 모달 컴포넌트
struct modalScheduleView: View {
    var action: (String) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("일정 생성")
                    .titleFont()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: {
                    action("modalScheduleView complete component clicked")
                }) {
                    Text("완료")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            Divider()
        }
        .modalPresentation()
    }
}

// modal modifiers //
struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat?

    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        guard let nextValue = nextValue() else { return }
        value = nextValue
    }
}

private struct ReadHeightModifier: ViewModifier {
    private var sizeView: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: HeightPreferenceKey.self,
                value: geometry.size.height)
        }
    }

    func body(content: Content) -> some View {
        content.background(sizeView)
    }
}

struct OverflowContentViewModifier: ViewModifier {
    @State private var contentOverflow: Bool = false
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
            .background(
                GeometryReader { contentGeometry in
                    Color.clear.onAppear {
                        contentOverflow = contentGeometry.size.height > geometry.size.height
                    }
                }
            )
            .wrappedInScrollView(when: contentOverflow)
        }
    }
}

struct ModalPresentationModifier: ViewModifier {
    @State var detentHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .padding(.top)
            .padding(.bottom)
            .presentationDragIndicator(.visible)
            .readHeight()
            .onPreferenceChange(HeightPreferenceKey.self) { height in
                if let height {
                    self.detentHeight = height
                }
            }
            .presentationDetents([.height(self.detentHeight)])
            .scrollOnOverflow()
    }
}

extension View {
    func readHeight() -> some View {
        self.modifier(ReadHeightModifier())
    }
    
    @ViewBuilder
    func wrappedInScrollView(when condition: Bool) -> some View {
        if condition {
            ScrollView {
                self
            }
        } else {
            self
        }
    }
    
    func scrollOnOverflow() -> some View {
        modifier(OverflowContentViewModifier())
    }
    
    func modalPresentation() -> some View {
        self.modifier(ModalPresentationModifier())
    }
}
