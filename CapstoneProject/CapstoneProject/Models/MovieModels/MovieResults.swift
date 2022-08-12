//
//  MovieResults.swift
//  CapstoneProject
//
//  Created by Ensar Batuhan Ünverdi on 25.07.2022.
//

import Foundation

struct MovieResults: Codable {
    let title, releaseDate: String?
    let posterPath: String?
    let voteAverage: Double?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case title
        case id
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}
