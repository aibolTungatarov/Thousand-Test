//
//  Movie.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import Foundation

struct Movies: Codable {
    var page: Int?
    var total_results: Int?
    var total_pages: Int?
    var results: [Movie]?
}

struct Movie: Codable {
    var popularity: Double?
    var vote_count, id: Int?
    var video, adult: Bool?
    var poster_path, backdrop_path: String?
    var original_language, original_title: String?
    var genre_ids: [Int]?
    var title: String?
    var vote_average: Double?
    var overview: String?
    var release_date: String?
}

struct Genres: Codable {
    var genres: [Genre]?
}

struct Genre: Codable {
    var id: Int
    var name: String?
}

struct Status: Codable {
    var status_code: Int?
    var status_message: String?
}
