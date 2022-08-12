//
//  CustomCollectionViewCell.swift
//  CapstoneProject
//
//  Created by Ensar Batuhan Ünverdi on 27.07.2022.
//

import UIKit
import SDWebImage

class CastListCell: UICollectionViewCell {

    static let identifier = String(describing: CastListCell.self)

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var originalNameLabel: UILabel!
    @IBOutlet weak var characterNameLabel: UILabel!

    func configureComponents(_ model: CastResults?) {
        if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model?.profilePath ?? "")") {
            imageView.sd_setImage(with: url, completed: nil)
        }
        originalNameLabel.text = model?.name
        characterNameLabel.text = "(\(model?.character ?? ""))"

    }
}
