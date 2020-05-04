//
//  Constants.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import Foundation

public struct Constants {
    struct ProductionServer {
        static let baseURL = "https://api.themoviedb.org/3/"
        //get poster_path for image
        static let imageURL = "https://image.tmdb.org/t/p/w500/"
    }
    struct APIParameterKey {
        static let apiKey = "986dda4a8d6675753829007ce45c0165"
    }
    static let ERROR_EMPTY_USERNAME = "Empty User Name"
    static let ERROR_EMPTY_PASSWORD = "Empty Password"
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case apiKey = "api_key"
}

enum ContentType: String {
    case json = "application/json; charset=utf-8"
}
