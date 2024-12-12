//
//  Post_Api.swift
//  noto-App
//
//  Created by 박상현 on 12/10/24.
//
import SwiftUI

// POST 요청을 처리하는 함수
func post<T: Codable, U: Codable>(url: String, body: U, responseType: T.Type) async throws -> ApiModel<T> {
    // Try to create a URL from the string
    guard let url = URL(string: url) else {
        throw NSError(domain: "Invalid URL", code: 0, userInfo: nil) // Throw error if URL is invalid
    }
    
    // Create the URLRequest for the POST request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    // Set the request's content-type header (application/json for JSON data)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Encode the body into JSON
    let encoder = JSONEncoder()
    
    // 날짜 포맷 설정
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"  // 서버에서 요구하는 날짜 형식으로 설정
    
    // JSONEncoder에 날짜 인코딩 전략 설정
    encoder.dateEncodingStrategy = .formatted(formatter)
    
    let bodyData = try encoder.encode(body)
    request.httpBody = bodyData
    
    // Perform the network request and get the response data
    let (data, _) = try await URLSession.shared.data(for: request)
    
    // Print the raw data for debugging
    if let jsonString = String(data: data, encoding: .utf8) {
        print("Raw JSON Response: \(jsonString)")
    }

    // Create a JSON decoder
    let decoder = JSONDecoder()

    // Set the custom formatter to the decoder
    decoder.dateDecodingStrategy = .formatted(formatter)

    // Decode the API response
    let apiResponse = try decoder.decode(ApiModel<T>.self, from: data)
    return apiResponse
}
