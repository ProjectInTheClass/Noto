//
//  Project_Model.swift
//  noto-App
//
//  Created by 박상현 on 12/6/24.
//
import SwiftUI

struct ProjectProgressDetail: Codable, Hashable {
    let id: Int
    let name: String
    let progress: Int?
    let participants: [String]
    let startDate: Date
    let endDate: Date
    let dday: Int
}

struct ProjectProgress: Codable {
    let projectProgress: [ProjectProgressDetail]
}

struct Project: Codable {
    let id: Int
    let name: String
    let startDate: Date
    let endDate: Date
    let participants: [String]?
    let description: String
    let url: String
    let imageurl: String
}

struct ProjectsDetail: Codable, Hashable {
    let name: String
    let projectId: Int
    let description: String
}

struct ProjectList: Codable {
    let projects: [ProjectsDetail]
}

struct RequestProject: Codable {
    let name: String
    let startDate: Date
    let endDate: Date
    let description: String
    let image: String
}
