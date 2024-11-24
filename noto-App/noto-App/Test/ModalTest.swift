//
//  ModalTest.swift
//  noto-App
//
//  Created by 박상현 on 11/19/24.
//
import SwiftUI

struct ModalTest_ContentView: View {
    @State var presentSheet: Bool = false
    
    var body: some View {
        Button("Tap me") {
            self.presentSheet.toggle()
        }
        .sheet(isPresented: self.$presentSheet) {
            modalProjectListView()
        }
    }
}

struct ModalTest_ContentView_Preview: PreviewProvider {
  static var previews: some View {
      ModalTest_ContentView()
  }
}
