//
//  Error.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import Foundation

enum ServiceError: Int, Error {
    case unauthorized = 401
    case notFound = 404
    case noInternetConnection = 1009
}
