//
//  Todo_Model.swift
//  noto-App
//
//  Created by 박상현 on 12/6/24.
//
import SwiftUI

struct ScheduleTodayDetail: Codable, Hashable {
    let id: Int
    let name: String
    let description: String
    let endDate: Date
}

struct ScheduleToday: Codable {
    let todaySchedule: [ScheduleTodayDetail]
}

struct ScheduleInfo: Codable {
    let id: Int
    let name: String
    let startDate: Date
    let endDate: Date
    let participants: [String]
    let description: String
    let tag: String
    let url: String
}

struct ScheduleProject: Codable, Hashable {
    let id: Int
    let name: String
    let description: String
    let startDate: Date
    let endDate: Date
}

struct RequestSchedule: Codable {
    let projectId: Int
    let name: String
    let startDate: Date
    let endDate: Date
    let participants: [String]
    let description: String
    let tag: String
    let url: String
}
