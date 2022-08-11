//
//  CastDetailModel.swift
//  CapstoneProject
//
//  Created by Ensar Batuhan Ünverdi on 29.07.2022.
//

import Foundation

struct CastDetailsModel: Codable {
    var biography, birthday: String?
    var name, placeOfBirth: String?
    var profilePath: String?
    let deathday: String?

    enum CodingKeys: String, CodingKey {
        case biography, birthday, name
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
        case deathday
    }
}
