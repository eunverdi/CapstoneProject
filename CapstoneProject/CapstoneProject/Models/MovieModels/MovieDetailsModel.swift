//
//  MovieDetailsModel.swift
//  CapstoneProject
//
//  Created by Ensar Batuhan Ünverdi on 25.07.2022.
//

import Foundation

struct MovieDetailsModel: Codable {
    let budget: Int?
    let genres: [Genre?]?
    let homepage: String?
    let originalLanguage, originalTitle, overview: String?
    let posterPath: String?
    let productionCompanies: [ProductionCompany?]?
    let releaseDate: String?
    let revenue, runtime: Int?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case budget, homepage, overview, genres
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case releaseDate = "release_date"
        case revenue, runtime, title
    }
}

struct Genre: Codable {
    let id: Int?
    let name: String?
}

struct ProductionCompany: Codable {
    let id: Int?
    let logoPath, name, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}
