//
//  Account.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import Foundation

struct AccountDetails: Codable {
    var id: Int?
    var status_code: Int?
    var status_message: String?
    var avatar: Gravatar
    var iso_639_1: String?
    var iso_3166_1: String?
    var name: String?
    var include_adult: Bool?
    var username: String?
}

struct Gravatar: Codable {
    var hash: String?
}

struct RequestToken: Codable {
    var success: Bool
    var expires_at: String?
    var request_token: String?
    var status_code: Int?
    var status_message: String?
}

struct Session: Codable {
    var success: Bool?
    var session_id: String?
    var status_message: String?
    var status_code: Int?
}

struct SessionWithLogin: Codable {
    var status_code: Int?
    var status_message: String?
    var success: Bool?
    var expires_at: String?
    var request_token: String?
}

struct User {
    var username: String?
    var password: String?
}

struct Account: Codable {
    var id: Int?
    var status_code: Int?
    var status_message: String?
    var avatar: Gravatar
    var iso_639_1: String?
    var iso_3166_1: String?
    var name: String?
    var include_adult: Bool?
    var username: String?
}
