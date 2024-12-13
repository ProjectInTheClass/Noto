//
//  Request_Model.swift
//  noto-App
//
//  Created by 박상현 on 12/6/24.
//
import SwiftUI

struct RequestNumber: Codable {
    let numberOfRequest: Int
}

struct RequestListDetail: Codable, Hashable {
    let requestId: Int
    let title: String
    let sender: String
}

struct RequestList: Codable {
    let sendRequest: [RequestListDetail]
    let receiveRequest: [RequestListDetail]
}

struct RequestInfo: Codable {
    let id: Int
    let project: String
    let schedule: String?
    let startDate: Date
    let endDate: Date
    let receivers: [String]?
    let sender: String
    let title: String
    let content: String
    let isSender: Bool
}

struct RequestReceived: Codable, Hashable {
    let receiverName: String
    let comment: String
    let status: String
}

struct RequestRequest: Codable, Hashable {
    let projectId: Int
    let scheduleId: Int
    let receivers: [String]
    let sender: Int
    let title: String
    let content: String
}

struct RequestRequestReceived: Codable, Hashable {
    let receiverId: Int
    let comment: String
    let status: String
}
