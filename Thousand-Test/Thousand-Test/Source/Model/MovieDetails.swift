//
//  MovieDetails.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import Foundation
import RealmSwift

struct DetailedMovie: Codable {
    var adult: Bool?
    var poster_path, backdrop_path: String?
    var genres: [Genre]?
    var id, imbd_id: Int?
    var original_title, overview: String?
    var popularity: Double?
    var release_date: String?
    var runtime: Int?
    var vote_average: Double?
    var vote_count: Int?
    var production_countries: [ProductionCountry]?
}

struct ProductionCountry: Codable {
    var iso_3166_1, name: String?
}

struct Comments: Codable {
    var id, page: Int?
    var results: [Comment]?
    var total_pages, total_results: Int?
}

struct Comment: Codable {
    var id, author, content: String?
}

class MovieId: Object {
    @objc dynamic var id: Int = 0
}

