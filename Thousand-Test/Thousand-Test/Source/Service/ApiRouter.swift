//
//  ApiRouter.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import Foundation

enum ApiRouter: ApiRequest {
    case getList(page: Int)
    case getGenres
    case getMovieDetails(movie_id: Int)
    case getComment(movie_id: Int, page: Int)
    case searchByText(text: String, page: Int)
    case requestToken
    case createSessionWithLogin(username: String, password: String, requestToken: String)
    case createSession(requestToken: String)
    case getAccount(sessionId: String)
    case markFavourite(account_id: Int, sessionId: String, media_id: Int, fav: Bool, media_type: String)
    case getFavouriteMovies(account_id: Int, session_id: String, page: Int)
    
    var path: String {
        switch self {
        case .getList:
            return "movie/popular"
        case .getGenres:
            return "genre/movie/list"
        case .searchByText:
            return "search/movie"
        case .getMovieDetails(let movie_id):
            return String.init(format: "movie/%d", movie_id)
        case .getComment(let movie_id, _):
            return String.init(format: "movie/%d/reviews", movie_id)
        case .requestToken:
            return "authentication/token/new"
        case .createSessionWithLogin:
            return "authentication/token/validate_with_login"
        case .createSession:
            return "authentication/session/new"
        case .getAccount:
            return "account"
        case .markFavourite(let account_id, _, _, _, _):
            return String.init(format: "account/%d/favorite", account_id)
        case .getFavouriteMovies(let account_id, _, _):
            return String.init(format: "account/%d/favorite/movies", account_id)
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case .getList(let page), .getComment(_, let page):
            return ["page": String(page), HTTPHeaderField.apiKey.rawValue: Constants.APIParameterKey.apiKey]
        case .getGenres, .getMovieDetails, .requestToken:
            return [HTTPHeaderField.apiKey.rawValue: Constants.APIParameterKey.apiKey]
        case .searchByText(let text, let page):
            return ["query": text, "page": String(page), HTTPHeaderField.apiKey.rawValue: Constants.APIParameterKey.apiKey]
        case .createSessionWithLogin(let username, let password, let requestToken):
            return ["username": username, "password": password,
                    "request_token": requestToken, HTTPHeaderField.apiKey.rawValue: Constants.APIParameterKey.apiKey]
        case .createSession(let requestToken):
            return ["request_token": requestToken, HTTPHeaderField.apiKey.rawValue: Constants.APIParameterKey.apiKey]
        case .getAccount(let sessionId):
            return ["session_id": sessionId, HTTPHeaderField.apiKey.rawValue: Constants.APIParameterKey.apiKey]
        case .markFavourite( _, let sessionId, let media_id, let fav, let media_type):
            return ["media_id": String(media_id),"media_type": media_type,"favorite": String(fav), "session_id": sessionId, HTTPHeaderField.apiKey.rawValue: Constants.APIParameterKey.apiKey]
        case .getFavouriteMovies(_, let sessionId, let page):
            return ["session_id": sessionId, "page": String(page), HTTPHeaderField.apiKey.rawValue: Constants.APIParameterKey.apiKey]
        }
        
    }
    
    var method: RequestType {
        switch self {
        case .getList, .getGenres,
             .searchByText, .getMovieDetails,
             .getComment, .requestToken, .getAccount, .getFavouriteMovies:
            return .GET
        case .createSessionWithLogin, .createSession, .markFavourite:
            return .POST
        }
    }
    
    func asURLRequest() -> URLRequest {
        let baseUrl = URL(string: Constants.ProductionServer.baseURL)!.appendingPathComponent(path)
        guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false) else { fatalError("Couldn't create url components") }
        components.queryItems = parameters.map {
            URLQueryItem(name: $0, value: $1)
        }
        guard let url = components.url else { fatalError("Couldn't get url") }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return request
    }
}
