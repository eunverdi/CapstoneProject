//
//  CastResults.swift
//  CapstoneProject
//
//  Created by Ensar Batuhan Ünverdi on 28.07.2022.
//

import Foundation

struct CastResults: Codable {
    let name: String?
    let profilePath: String?
    let character: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case name
        case profilePath = "profile_path"
        case character
        case id
    }
}
