//
//  Model_Api.swift
//  noto-App
//
//  Created by 박상현 on 12/6/24.
//
import SwiftUI

struct ApiModel<T: Codable>: Codable {
    let code: String
    let message: String
    let data: T
}
