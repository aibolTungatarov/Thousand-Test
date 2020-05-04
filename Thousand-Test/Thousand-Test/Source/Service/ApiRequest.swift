//
//  ApiRequest.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import Foundation
public enum RequestType: String {
    case GET, POST, DELETE, PATCH
}
protocol ApiRequest {
    var method: RequestType { get }
    var path: String { get }
    var parameters: [String: String] { get }
}
