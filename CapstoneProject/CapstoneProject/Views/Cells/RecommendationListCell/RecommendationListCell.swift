//
//  RecommendationCollectionViewCell.swift
//  CapstoneProject
//
//  Created by Ensar Batuhan Ünverdi on 28.07.2022.
//

import UIKit
import SDWebImage

class RecommendationListCell: UICollectionViewCell {

    static let identifier = String(describing: RecommendationListCell.self)

    @IBOutlet weak var posterImageView: UIImageView!

    func configureComponents(_ model: MovieResults?) {
        if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model?.posterPath ?? "")") {
            posterImageView.sd_setImage(with: url, completed: nil)
        }
    }
}
