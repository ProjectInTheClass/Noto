//
//  Get_Api.swift
//  noto-App
//
//  Created by 박상현 on 12/6/24.
//
import SwiftUI

// GET 요청을 처리하는 함수
func get<T: Codable>(url: String, responseType: T.Type) async throws -> ApiModel<T> {
    // Try to create a URL from the string
    guard let url = URL(string: url) else {
        throw NSError(domain: "Invalid URL", code: 0, userInfo: nil) // Throw error if URL is invalid
    }

    // Now `url` is of type URL, so we can proceed with the network request
    let (data, _) = try await URLSession.shared.data(from: url)

    // Print the raw data for debugging
    if let jsonString = String(data: data, encoding: .utf8) {
        print("Raw JSON Response: \(jsonString)")
    }

    // Create a JSON decoder
    let decoder = JSONDecoder()
    
    // Custom DateFormatter for the expected date format
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"  // Specify your custom date format here

    // Set the custom formatter to the decoder
    decoder.dateDecodingStrategy = .formatted(formatter)

    // Decode the API response
    let apiResponse = try decoder.decode(ApiModel<T>.self, from: data)
    return apiResponse
}



