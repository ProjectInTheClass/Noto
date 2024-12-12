//
//  Modal_Component.swift
//  noto-App
//
//  Created by 박상현 on 11/20/24.
//
import SwiftUI

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
struct modalTodoListView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingSheet: Bool = false
    @State private var showingDialog: Bool = false
    @State private var deletedSid: Int = 0
    @State private var modifiedSid: Int = 0
    @Binding var scheduleProjectData: [ScheduleProject]?
    @Binding var currentScreen: Page
    @Binding var selectedPid: Int
    @Binding var selectedSid: Int
    
    var body: some View {
        VStack {
            if let scheduleProjectData = scheduleProjectData {
                ForEach(scheduleProjectData, id: \.self) { schedule in
                    HStack {
                        rowComponent(
                            imageName: "user",
                            title: schedule.name,
                            subtitle: schedule.description,
                            action: {
                                dismiss()
                                
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.001) {
                                    currentScreen = .todoDetail
                                    selectedSid = schedule.id
                                }
                            }
                        )
                        Button(action: {
                            showingDialog = true
                            deletedSid = schedule.id
                            modifiedSid = schedule.id
                        }) {
                          Image(systemName: "ellipsis")
                            .font(.system(size: 24))
                            .foregroundColor(.customBlack)
                        }
                        .padding(.trailing)
                        .confirmationDialog("Choose an option", isPresented: $showingDialog) {
                            Button("일정 수정", role: .none) {
                                print("일정 수정")
                                showingSheet = true
                            }
                            .sheet(isPresented: $showingSheet, onDismiss: {
                                showingSheet = false
                            }){
                                modalTodoView(modifiedSid: $modifiedSid, selectedPid: $selectedPid)
                            }
                            Button("일정 삭제", role: .destructive) {
                                Task {
                                    do {
                                        // 일정 삭제 호출
                                        let response = try await delete(url: "https://www.bestbirthday.co.kr:8080/api/schedule" + "/\(deletedSid)")
                                        print(response)
                                        print("일정 삭제", deletedSid)
                                    } catch {
                                        print("일정 삭제 실패: \(error.localizedDescription)")
                                    }
                                }
                            }
                            Button("취소", role: .cancel) {
                                print("취소")
                            }
                        }
                    }
                }
            }
            Divider()
            Button(action: {
                showingSheet = true
                modifiedSid = 0
            }) {
              HStack {
                Image("user")
                  .resizable()
                  .frame(width: 24, height: 24)
                  .padding(.trailing, 5)
                VStack(alignment: .leading) {
                  Text("생성")
                    .titleFont()
                    .lineLimit(1)
                    .truncationMode(.tail)
                }
              }
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.horizontal, 20)
            }
            .sheet(isPresented: $showingSheet, onDismiss: {
                showingSheet = false
            }){
                modalTodoView(modifiedSid: $modifiedSid, selectedPid: $selectedPid)
            }
        }
        .modalPresentation()
    }
}

// 일정 리스트 모달 컴포넌트
struct modalTodayTodoListView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var scheduleTodayData: ScheduleToday?
    @Binding var currentScreen: Page
    @Binding var selectedSid: Int
    
    var body: some View {
        VStack {
            if let scheduleTodayData = scheduleTodayData {
                ForEach(scheduleTodayData.todaySchedule, id: \.self) { schedule in
                    HStack {
                        rowComponent(
                            imageName: "user",
                            title: schedule.name,
                            subtitle: schedule.description,
                            action: {
                                dismiss()
                                
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.001) {
                                    currentScreen = .todoDetail
                                    selectedSid = schedule.id
                                }
                            }
                        )
                    }
                }
            }
        }
        .modalPresentation()
    }
}

// 일정 리스트 모달 컴포넌트
struct modalProjectTodoListView: View {
    @Environment(\.dismiss) var dismiss
    let scheduleProjectData: [ScheduleProject]?
    @Binding var currentScreen: Page
    @Binding var selectedSid: Int
    
    var body: some View {
        VStack {
            if let scheduleProjectData = scheduleProjectData {
                ForEach(scheduleProjectData, id: \.self) { schedule in
                    HStack {
                        rowComponent(
                            imageName: "user",
                            title: schedule.name,
                            subtitle: schedule.description,
                            action: {
                                dismiss()
                                
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.001) {
                                    currentScreen = .todoDetail
                                    selectedSid = schedule.id
                                }
                            }
                        )
                    }
                }
            }
        }
        .modalPresentation()
    }
}


// 리퀘스트 리스트 모달 컴포넌트
struct modalRequestListView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var requestListData: RequestList?
    @Binding var selectedModal: Modal
    @Binding var currentScreen: Page
    @Binding  var selectedRid: Int
    
    var body: some View {
        VStack {
            if let requestListData = requestListData {
                if selectedModal == .receiveRequestList{
                    ForEach(requestListData.receiveRequest, id: \.self) { receiveRequest in
                        HStack {
                            rowComponent(imageName: "mail",
                                         title: receiveRequest.title,
                                         subtitle: receiveRequest.sender,
                                         action: {
                                dismiss()
                                
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.001) {
                                    currentScreen = .requestDetail
                                    selectedRid = receiveRequest.requestId
                                }
                            })
                        }
                    }
                }
                else if selectedModal == .sendRequestList{
                    ForEach(requestListData.sendRequest, id: \.self) { sendRequest in
                        HStack {
                            rowComponent(imageName: "mail",
                                         title: sendRequest.title,
                                         subtitle: sendRequest.sender,
                                         action: {
                                dismiss()
                                
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.001) {
                                    currentScreen = .requestDetail
                                    selectedRid = sendRequest.requestId
                                }
                            })
                        }
                    }
                }
            }
        }
        .modalPresentation()
    }
}

// 프로젝트 리스트 모달 컴포넌트
struct modalProjectListView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingSheet: Bool = false
    @State private var showingDialog: Bool = false
    @State private var deletedPid: Int = 0
    @State private var modifiedPid: Int = 0
    @Binding var projectListData: ProjectList?
    @Binding var currentScreen: Page
    @Binding var selectedPid: Int
    
    var body: some View {
        VStack {
            if let projectListData = projectListData {
                ForEach(projectListData.projects, id: \.self) { projects in
                    HStack {
                        rowComponent(
                            imageName: "user",
                            title: projects.name,
                            subtitle: projects.description,
                            action: {
                                dismiss()
                                
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.001) {
                                    currentScreen = .projectDetail
                                    selectedPid = projects.projectId
                                }
                            }
                        )
                        Button(action: {
                            showingDialog = true
                            deletedPid = projects.projectId
                            modifiedPid = projects.projectId
                        }) {
                          Image(systemName: "ellipsis")
                            .font(.system(size: 24))
                            .foregroundColor(.customBlack)
                        }
                        .padding(.trailing)
                        .confirmationDialog("Choose an option", isPresented: $showingDialog) {
                            Button("프로젝트 수정", role: .none) {
                                print("프로젝트 수정")
                                showingSheet = true
                            }
                            .sheet(isPresented: $showingSheet, onDismiss: {
                                showingSheet = false
                            }){
                                modalProjectView(modifiedPid: $modifiedPid)
                            }
                            Button("프로젝트 삭제", role: .destructive) {
                                Task {
                                    do {
                                        // 프로젝트 삭제 호출
                                        let response = try await delete(url: "https://www.bestbirthday.co.kr:8080/api/project" + "/\(deletedPid)")
                                        print(response)
                                        print("프로젝트 삭제", deletedPid)
                                    } catch {
                                        print("프로젝트 삭제 실패: \(error.localizedDescription)")
                                    }
                                }
                            }
                            Button("취소", role: .cancel) {
                                print("취소")
                            }
                        }
                    }
                }
            }
            Divider()
            Button(action: {
                showingSheet = true
                modifiedPid = 0
            }) {
              HStack {
                Image("user")
                  .resizable()
                  .frame(width: 24, height: 24)
                  .padding(.trailing, 5)
                VStack(alignment: .leading) {
                  Text("생성")
                    .titleFont()
                    .lineLimit(1)
                    .truncationMode(.tail)
                }
              }
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.horizontal, 20)
            }
            .sheet(isPresented: $showingSheet, onDismiss: {
                showingSheet = false
            }){
                modalProjectView(modifiedPid: $modifiedPid)
            }
        }
        .modalPresentation()
        .task {
            do {
                let projectListResponse = try await get(url: "https://www.bestbirthday.co.kr:8080/api/project/list?userId=1", responseType: ProjectList.self)
                // Handle the response here
//                print(projectListResponse)
                
                projectListData = projectListResponse.data
            } catch {
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }
}

// 일정 모달 컴포넌트
struct modalTodoView: View {
    @Environment(\.dismiss) var dismiss
    @State private var projectData: Project? = nil
    @State private var scheduleInfoData: ScheduleInfo? = nil
    @State private var name: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var participants: [String] = []
    @State private var description: String = ""
    @State private var tag: String = ""
    @State private var url: String = ""
    @State private var isParticipantsListVisible: Bool = false  // 추가된 상태 변수
    
    @Binding var modifiedSid: Int
    @Binding var selectedPid: Int
    
    // 완료 버튼 활성화 조건
    private var isCompleteButtonEnabled: Bool {
        !name.isEmpty && endDate >= startDate && !participants.isEmpty && !tag.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                if modifiedSid == 0 {
                    Text("일정 생성")
                        .titleFont()
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text("일정 수정")
                        .titleFont()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button(action: {
                    Task {
                        do {
                            if modifiedSid == 0 {
                                let response = try await post(url: "https://www.bestbirthday.co.kr:8080/api/schedule", body: RequestSchedule(projectId: selectedPid, name: name, startDate: startDate, endDate: endDate, participants: participants, description: description, tag: tag, url: url), responseType: ScheduleInfo.self)
                                print(response)
                            } else {
                                let response = try await put(url: "https://www.bestbirthday.co.kr:8080/api/schedule" + "/\(modifiedSid)", body: RequestSchedule(projectId: selectedPid, name: name, startDate: startDate, endDate: endDate, participants: participants, description: description, tag: tag, url: url), responseType: ScheduleInfo.self)
                                print(response)
                            }
                            
                            dismiss()
                        } catch {
                            if modifiedSid == 0 {
                                print("일정 생성 실패: \(error.localizedDescription)")
                            } else {
                                print("일정 수정 실패: \(error.localizedDescription)")
                            }
                        }
                    }
                }) {
                    Text("완료")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundColor(isCompleteButtonEnabled ? .blue : .gray)  // 버튼 색상 변경
                }
                .disabled(!isCompleteButtonEnabled)  // 활성화 조건에 따라 버튼 활성화/비활성화
            }
            .padding(.leading)
            .padding(.trailing)
            Divider()
            
            ZStack(alignment: .topLeading) {
                // TextEditor
                TextEditor(text: $name)
                    .padding(10) // TextEditor 내부 여백
                    .frame(maxWidth: 350, maxHeight: 50) // 크기 설정
                    .background(Color.white) // 배경색 설정
                    .cornerRadius(8) // 둥근 모서리
                    .shadow(radius: 5) // 약간의 그림자 효과
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1) // 테두리 스타일
                    )
                
                // Placeholder
                if name.isEmpty {
                    Text("일정 이름")
                        .foregroundColor(.customLightGray)
                        .padding(.top, 10)
                        .padding(.leading, 11)
                }
            }
            
            DatePicker(
                "시작일 선택",
                selection: $startDate,
                displayedComponents: [.date] // 날짜만 표시
            )
            .datePickerStyle(.compact)
            .frame(maxWidth: 350)
            
            DatePicker(
                "종료일 선택",
                selection: $endDate,
                displayedComponents: [.date] // 날짜만 표시
            )
            .datePickerStyle(.compact)
            .frame(maxWidth: 350)
            
            // 참가자 선택 버튼
            Button(action: {
                isParticipantsListVisible.toggle()  // 버튼 클릭 시 리스트 토글
            }) {
                Text("참가자 선택")
                    .foregroundColor(.black)
                    .frame(maxWidth: 100, maxHeight: 40) // 크기 설정
                    .background(Color.white) // 배경색 설정
                    .cornerRadius(8) // 둥근 모서리
                    .shadow(radius: 5) // 약간의 그림자 효과
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1) // 테두리 스타일
                    )
            }
            
            // 참가자 목록이 표시되는 부분
            if isParticipantsListVisible {
                VStack {
                    if let availableParticipants = projectData?.participants {
                        List(availableParticipants, id: \.self) { participant in
                            HStack {
                                Text(participant)
                                Spacer()
                                ZStack {
                                    if participants.contains(participant) {
                                        Image(systemName: "checkmark.square.fill")
                                            .font(.largeTitle)
                                    } else {
                                        Image(systemName: "square")
                                            .font(.largeTitle)
                                    }
                                }.foregroundColor(.gray)
                                    .onTapGesture {
                                        if participants.contains(participant) {
                                            participants = participants.filter {
                                                $0 != participant
                                            }
                                        } else {
                                            participants.append(participant)
                                        }
                                    }
                            }
                        }
                    }
                }
                .frame(maxHeight: 200)  // List의 높이 제한
                .background(Color.white) // 배경색
                .cornerRadius(8)
                .shadow(radius: 5)  // 그림자 효과
                .padding(.top)
            }
            
            // Tag 선택 Picker
            Picker("태그 선택", selection: $tag) {
                Text("회의").tag("회의")
                Text("개발").tag("개발")
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(maxWidth: 350)
            
            ZStack(alignment: .topLeading) {
                // TextEditor
                TextEditor(text: $description)
                    .padding(10) // TextEditor 내부 여백
                    .frame(maxWidth: 350, maxHeight: 200) // 크기 설정
                    .background(Color.white) // 배경색 설정
                    .cornerRadius(8) // 둥근 모서리
                    .shadow(radius: 5) // 약간의 그림자 효과
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1) // 테두리 스타일
                    )
                
                // Placeholder
                if description.isEmpty {
                    Text("일정 설명")
                        .foregroundColor(.customLightGray)
                        .padding(.top, 20)
                        .padding(.leading, 11)
                }
            }
        }
        .modalPresentation()
        .task {
            if modifiedSid != 0 {
                do {
                    let scheduleInfoResponse = try await get(url: "https://www.bestbirthday.co.kr:8080/api/schedule/info" + "/\(modifiedSid)", responseType: ScheduleInfo.self)
                    // Handle the response here
                    print(scheduleInfoResponse)
                    
                    scheduleInfoData = scheduleInfoResponse.data
                } catch {
                    print("Error fetching data: \(error.localizedDescription)")
                }
                if let scheduleInfoData = scheduleInfoData {
                    name = scheduleInfoData.name
                    startDate = scheduleInfoData.startDate
                    endDate = scheduleInfoData.endDate
                    participants = scheduleInfoData.participants
                    description = scheduleInfoData.description
                    tag = scheduleInfoData.tag
                    url = scheduleInfoData.url
                }
            }
        }
        .task {
            do {
                let projectResponse = try await get(url: "https://www.bestbirthday.co.kr:8080/api/project" + "/\(selectedPid)", responseType: Project.self)
                projectData = projectResponse.data
            } catch {
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }
}

// 프로젝트 모달 컴포넌트
struct modalProjectView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var description: String = ""
    @State private var image: String = ""
    @State private var projectData: Project? = nil
    
    @Binding var modifiedPid: Int
    
    // 완료 버튼 활성화 조건
    private var isCompleteButtonEnabled: Bool {
        !name.isEmpty && endDate >= startDate
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                if modifiedPid == 0 {
                    Text("프로젝트 생성")
                        .titleFont()
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text("프로젝트 수정")
                        .titleFont()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button(action: {
                    Task {
                        do {
                            if modifiedPid == 0 {
                                let response = try await post(url: "https://www.bestbirthday.co.kr:8080/api/project", body: RequestProject(name: name, startDate: startDate, endDate: endDate, description: description, image: image), responseType: Project.self)
                                print(response)
                                projectData = response.data
                                
                                Task {
                                    do {
                                        if let projectData = projectData {
                                            let response = try await post(url: "https://www.bestbirthday.co.kr:8080/api/user/participate", body: RequestUserParticipate(userId: 1, projectId: projectData.id), responseType: String?.self)
                                            
                                            print(response)
                                        }
                                    } catch {
                                        print("유저 참가 실패: \(error.localizedDescription)")
                                    }
                                }
                            } else {
                                let response = try await put(url: "https://www.bestbirthday.co.kr:8080/api/project" + "/\(modifiedPid)", body: RequestProject(name: name, startDate: startDate, endDate: endDate, description: description, image: image), responseType: Project.self)
                                print(response)
                                projectData = response.data
                            }
                            
                            dismiss()
                        } catch {
                            if modifiedPid == 0 {
                                print("프로젝트 생성 실패: \(error.localizedDescription)")
                            } else {
                                print("프로젝트 수정 실패: \(error.localizedDescription)")
                            }
                        }
                    }
                }) {
                    Text("완료")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundColor(isCompleteButtonEnabled ? .blue : .gray)  // 버튼 색상 변경
                }
                .disabled(!isCompleteButtonEnabled)  // 활성화 조건에 따라 버튼 활성화/비활성화
            }
            .padding(.leading)
            .padding(.trailing)
            Divider()
            
            ZStack(alignment: .topLeading) {
                // TextEditor
                TextEditor(text: $name)
                    .padding(10) // TextEditor 내부 여백
                    .frame(maxWidth: 350, maxHeight: 50) // 크기 설정
                    .background(Color.white) // 배경색 설정
                    .cornerRadius(8) // 둥근 모서리
                    .shadow(radius: 5) // 약간의 그림자 효과
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1) // 테두리 스타일
                    )
                
                // Placeholder
                if name.isEmpty {
                    Text("프로젝트 이름")
                        .foregroundColor(.customLightGray)
                        .padding(.top, 10)
                        .padding(.leading, 11)
                }
            }
            
            DatePicker(
                "시작일 선택",
                selection: $startDate,
                displayedComponents: [.date] // 날짜만 표시
            )
            .datePickerStyle(.compact)
            .frame(maxWidth: 350)
            
            DatePicker(
                "종료일 선택",
                selection: $endDate,
                displayedComponents: [.date] // 날짜만 표시
            )
            .datePickerStyle(.compact)
            .frame(maxWidth: 350)
            
            ZStack(alignment: .topLeading) {
                // TextEditor
                TextEditor(text: $description)
                    .padding(10) // TextEditor 내부 여백
                    .frame(maxWidth: 350, maxHeight: 200) // 크기 설정
                    .background(Color.white) // 배경색 설정
                    .cornerRadius(8) // 둥근 모서리
                    .shadow(radius: 5) // 약간의 그림자 효과
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1) // 테두리 스타일
                    )
                
                // Placeholder
                if description.isEmpty {
                    Text("프로젝트 설명")
                        .foregroundColor(.customLightGray)
                        .padding(.top, 20)
                        .padding(.leading, 11)
                }
            }
        }
        .modalPresentation()
        .task {
            if modifiedPid != 0 {
                do {
                    let projectResponse = try await get(url: "https://www.bestbirthday.co.kr:8080/api/project" + "/\(modifiedPid)", responseType: Project.self)
                    // Handle the response here
                    print(projectResponse)
                    
                    projectData = projectResponse.data
                } catch {
                    print("Error fetching data: \(error.localizedDescription)")
                }
                if let projectData = projectData {
                    name = projectData.name
                    startDate = projectData.startDate
                    endDate = projectData.endDate
                    description = projectData.description
                }
            }
        }
    }
}

// 리퀘스트 모달 컴포넌트
struct modalRequestView: View {
    @Environment(\.dismiss) var dismiss
    @State private var projectListData: ProjectList? = nil
    @State private var projectData: Project? = nil
    @State private var scheduleInfoData: ScheduleInfo? = nil
    @State private var scheduleProjectData: [ScheduleProject]?
    @State private var isProjectsListVisible: Bool = false  // 추가된 상태 변수
    @State private var isScheduleListVisible: Bool = false  // 추가된 상태 변수
    @State private var isParticipantsListVisible: Bool = false  // 추가된 상태 변수
    
    @State private var projectId: Int = 0
    @State private var scheduleId: Int = 0
    @State private var receivers: [String] = []
    @State private var sender: Int = 1
    @State private var title: String = ""
    @State private var content: String = ""
    
    // 완료 버튼 활성화 조건
    private var isCompleteButtonEnabled: Bool {
        projectId != 0 && scheduleId != 0 && !receivers.isEmpty && !title.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("리퀘스트 전송")
                    .titleFont()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: {
                    Task {
                        do {
//                            let response = try await post(url: "https://www.bestbirthday.co.kr:8080/api/request" + "?projectId=\(projectId)" + "&scheduleId=\(scheduleId)" + "&receivers=string&sender=0&title=string&content=string", body: RequestSchedule(projectId: selectedPid, name: name, startDate: startDate, endDate: endDate, participants: participants, description: description, tag: tag, url: url), responseType: ScheduleInfo.self)
//                            print(response)
                            
                            dismiss()
                        } catch {
                            print("리퀘스트 전송 실패: \(error.localizedDescription)")
                        }
                    }
                }) {
                    Text("전송")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundColor(isCompleteButtonEnabled ? .blue : .gray)  // 버튼 색상 변경
                }
                .disabled(!isCompleteButtonEnabled)  // 활성화 조건에 따라 버튼 활성화/비활성화
            }
            .padding(.leading)
            .padding(.trailing)
            Divider()
            
            // 프로젝트 선택 버튼
            Button(action: {
                isProjectsListVisible.toggle()  // 버튼 클릭 시 리스트 토글
            }) {
                Text("프로젝트 선택")
                    .foregroundColor(.black)
                    .frame(maxWidth: 100, maxHeight: 40) // 크기 설정
                    .background(Color.white) // 배경색 설정
                    .cornerRadius(8) // 둥근 모서리
                    .shadow(radius: 5) // 약간의 그림자 효과
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1) // 테두리 스타일
                    )
            }
            
            // 프로젝트 목록이 표시되는 부분
            if isProjectsListVisible {
                VStack {
                    if let availableProjects = projectListData?.projects {
                        List(availableProjects, id: \.self) { project in
                            HStack {
                                Text(project.name)
                                Spacer()
                                ZStack {
                                    if projectId == project.projectId {  // 선택된 프로젝트가 있는지 확인
                                        Image(systemName: "checkmark.square.fill")
                                            .font(.largeTitle)
                                    } else {
                                        Image(systemName: "square")
                                            .font(.largeTitle)
                                    }
                                }
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    if projectId == project.projectId {
                                        projectId = 0
                                    } else {
                                        projectId = project.projectId  // 새로운 프로젝트 선택
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(maxHeight: 200)  // List의 높이 제한
                .background(Color.white) // 배경색
                .cornerRadius(8)
                .shadow(radius: 5)  // 그림자 효과
                .padding(.top)
            }
            
            // 일정 선택 버튼
            Button(action: {
                isScheduleListVisible.toggle()  // 버튼 클릭 시 리스트 토글
            }) {
                Text("일정 선택")
                    .foregroundColor(.black)
                    .frame(maxWidth: 100, maxHeight: 40) // 크기 설정
                    .background(Color.white) // 배경색 설정
                    .cornerRadius(8) // 둥근 모서리
                    .shadow(radius: 5) // 약간의 그림자 효과
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1) // 테두리 스타일
                    )
            }
            
            // 참가자 목록이 표시되는 부분
            if isScheduleListVisible {
                VStack {
                    if let availableSchedule = scheduleProjectData {
                        List(availableSchedule, id: \.self) { schedule in
                            HStack {
                                Text(schedule.name)
                                Spacer()
                                ZStack {
                                    if scheduleId == schedule.id {  // 선택된 프로젝트가 있는지 확인
                                        Image(systemName: "checkmark.square.fill")
                                            .font(.largeTitle)
                                    } else {
                                        Image(systemName: "square")
                                            .font(.largeTitle)
                                    }
                                }
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    if scheduleId == schedule.id {
                                        scheduleId = 0
                                    } else {
                                        scheduleId = schedule.id  // 새로운 프로젝트 선택
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(maxHeight: 200)  // List의 높이 제한
                .background(Color.white) // 배경색
                .cornerRadius(8)
                .shadow(radius: 5)  // 그림자 효과
                .padding(.top)
                .task {
                    do {
                        let scheduleProjectResponse = try await get(url: "https://www.bestbirthday.co.kr:8080/api/schedule/project" + "/\(projectId)", responseType: [ScheduleProject]?.self)
                        // Handle the response here
                        print(scheduleProjectResponse)
                        
                        scheduleProjectData = scheduleProjectResponse.data
                    } catch {
                        print("Error fetching data: \(error.localizedDescription)")
                    }
                }
            }
            
            // 참가자 선택 버튼
            Button(action: {
                isParticipantsListVisible.toggle()  // 버튼 클릭 시 리스트 토글
            }) {
                Text("수신자 선택")
                    .foregroundColor(.black)
                    .frame(maxWidth: 100, maxHeight: 40) // 크기 설정
                    .background(Color.white) // 배경색 설정
                    .cornerRadius(8) // 둥근 모서리
                    .shadow(radius: 5) // 약간의 그림자 효과
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1) // 테두리 스타일
                    )
            }
            
            // 참가자 목록이 표시되는 부분
            if isParticipantsListVisible {
                VStack {
                    if let availableParticipants = projectData?.participants {
                        List(availableParticipants, id: \.self) { participant in
                            HStack {
                                Text(participant)
                                Spacer()
                                ZStack {
                                    if receivers.contains(participant) {
                                        Image(systemName: "checkmark.square.fill")
                                            .font(.largeTitle)
                                    } else {
                                        Image(systemName: "square")
                                            .font(.largeTitle)
                                    }
                                }.foregroundColor(.gray)
                                    .onTapGesture {
                                        if receivers.contains(participant) {
                                            receivers = receivers.filter {
                                                $0 != participant
                                            }
                                        } else {
                                            receivers.append(participant)
                                        }
                                    }
                            }
                        }
                    }
                }
                .frame(maxHeight: 200)  // List의 높이 제한
                .background(Color.white) // 배경색
                .cornerRadius(8)
                .shadow(radius: 5)  // 그림자 효과
                .padding(.top)
                .task {
                    do {
                        let projectResponse = try await get(url: "https://www.bestbirthday.co.kr:8080/api/project" + "/\(projectId)", responseType: Project.self)
                        // Handle the response here
                        print(projectResponse)
                        
                        projectData = projectResponse.data
                    } catch {
                        print("Error fetching data: \(error.localizedDescription)")
                    }
                }
            }
            
            ZStack(alignment: .topLeading) {
                // TextEditor
                TextEditor(text: $title)
                    .padding(10) // TextEditor 내부 여백
                    .frame(maxWidth: 350, maxHeight: 50) // 크기 설정
                    .background(Color.white) // 배경색 설정
                    .cornerRadius(8) // 둥근 모서리
                    .shadow(radius: 5) // 약간의 그림자 효과
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1) // 테두리 스타일
                    )
                
                // Placeholder
                if title.isEmpty {
                    Text("리퀘스트 제목")
                        .foregroundColor(.customLightGray)
                        .padding(.top, 20)
                        .padding(.leading, 11)
                }
            }
            
            ZStack(alignment: .topLeading) {
                // TextEditor
                TextEditor(text: $content)
                    .padding(10) // TextEditor 내부 여백
                    .frame(maxWidth: 350, maxHeight: 200) // 크기 설정
                    .background(Color.white) // 배경색 설정
                    .cornerRadius(8) // 둥근 모서리
                    .shadow(radius: 5) // 약간의 그림자 효과
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1) // 테두리 스타일
                    )
                
                // Placeholder
                if content.isEmpty {
                    Text("리퀘스트 설명")
                        .foregroundColor(.customLightGray)
                        .padding(.top, 20)
                        .padding(.leading, 11)
                }
            }
        }
        .modalPresentation()
        .task {
            do {
                let projectListResponse = try await get(url: "https://www.bestbirthday.co.kr:8080/api/project/list?userId=1", responseType: ProjectList.self)
                // 프로젝트 리스트 데이터를 업데이트
                projectListData = projectListResponse.data
            } catch {
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }
}

// 리퀘스트 거부 모달 컴포넌트
struct modalRequestRejectView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var comment: String
    
    // 완료 버튼 활성화 조건
    private var isCompleteButtonEnabled: Bool {
        !comment.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("리퀘스트 거부")
                    .titleFont()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: {
                    Task {
                        do {
//                            let response = try await post(url: "https://www.bestbirthday.co.kr:8080/api/request" + "?projectId=\(projectId)" + "&scheduleId=\(scheduleId)" + "&receivers=string&sender=0&title=string&content=string", body: RequestSchedule(projectId: selectedPid, name: name, startDate: startDate, endDate: endDate, participants: participants, description: description, tag: tag, url: url), responseType: ScheduleInfo.self)
//                            print(response)
                            
                            dismiss()
                        } catch {
                            print("리퀘스트 전송 실패: \(error.localizedDescription)")
                        }
                    }
                }) {
                    Text("전송")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundColor(isCompleteButtonEnabled ? .blue : .gray)  // 버튼 색상 변경
                }
                .disabled(!isCompleteButtonEnabled)  // 활성화 조건에 따라 버튼 활성화/비활성화
            }
            .padding(.leading)
            .padding(.trailing)
            Divider()
            
            ZStack(alignment: .topLeading) {
                // TextEditor
                TextEditor(text: $comment)
                    .padding(10) // TextEditor 내부 여백
                    .frame(maxWidth: 350, maxHeight: 200) // 크기 설정
                    .background(Color.white) // 배경색 설정
                    .cornerRadius(8) // 둥근 모서리
                    .shadow(radius: 5) // 약간의 그림자 효과
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1) // 테두리 스타일
                    )
                
                // Placeholder
                if comment.isEmpty {
                    Text("거부 사유")
                        .foregroundColor(.customLightGray)
                        .padding(.top, 20)
                        .padding(.leading, 11)
                }
            }
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
