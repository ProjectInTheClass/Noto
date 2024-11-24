//
//  ComboboxTest.swift
//  noto-App
//
//  Created by 박상현 on 11/20/24.
//
import SwiftUI

struct ComboboxTest_ContentView: View {
    @State var isShownSheet = false
    @State var isShownFullScreenCover = false
    
    var body: some View {
        Button {
            self.isShownFullScreenCover.toggle()
        } label: {
            Text("Show Full Screen Cover")
        }
        .fullScreenCover(isPresented: $isShownFullScreenCover) {
            ComboboxTest_MyFullScreenCover(isShownFullScreenCover: $isShownFullScreenCover)
        }
        .fullScreenCover(isPresented: $isShownFullScreenCover) {
            Text("Full Screen Cover")
        }
    }
}

struct ComboboxTest_MyFullScreenCover: View {
    
    @Binding var isShownFullScreenCover: Bool
    
    var body: some View {
        VStack {
            
            HStack {
                Button {
                    self.isShownFullScreenCover.toggle()
                } label: {
                    Text("cancel")
                }
                Spacer()

            }
            .padding(.leading)
            
            Spacer()
            Text("Full Screen Cover")
            Spacer()
        }
    }
}

struct ComboboxTest_ContentView_Preview: PreviewProvider {
  static var previews: some View {
      ComboboxTest_ContentView()
  }
}
