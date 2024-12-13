//
//  Delete_Api.swift
//  noto-App
//
//  Created by 박상현 on 12/10/24.
//
import SwiftUI

// DELETE 요청을 처리하는 함수
func delete(url: String) async throws -> ApiModel<String?> {
    // URL을 유효한 형식으로 만들기
    guard let url = URL(string: url) else {
        throw NSError(domain: "Invalid URL", code: 0, userInfo: nil) // URL이 유효하지 않으면 에러 던지기
    }

    // URLRequest 객체 생성
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE" // DELETE 요청 메소드 설정
    
    // 비동기적으로 DELETE 요청 보내기
    let (data, _) = try await URLSession.shared.data(for: request)

    // 응답 데이터 출력 (디버깅용)
    if let jsonString = String(data: data, encoding: .utf8) {
        print("Raw JSON Response: \(jsonString)")
    }

    // JSONDecoder 생성
    let decoder = JSONDecoder()

    // Custom DateFormatter를 사용하여 특정 날짜 형식 처리
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"  // 필요한 날짜 형식으로 설정

    // 커스텀 포맷터를 디코더에 설정
    decoder.dateDecodingStrategy = .formatted(formatter)

    // API 응답을 지정된 모델로 디코딩
    let apiResponse = try decoder.decode(ApiModel<String?>.self, from: data)
    return apiResponse
}
