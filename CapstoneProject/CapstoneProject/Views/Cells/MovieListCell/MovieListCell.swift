//
//  CustomTableViewCell.swift
//  CapstoneProject
//
//  Created by Ensar Batuhan Ünverdi on 25.07.2022.
//

import UIKit
import SDWebImage

class MovieListCell: UITableViewCell {

    static let identifier = String(describing: MovieListCell.self)
    var movieID: Int?

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImage.image = nil
        ratingLabel.text = nil
        releaseDateLabel.text = nil
        titleLabel.text = nil
        favouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }

    func configureMovieResultsComponents(_ model: MovieResults?) {
        if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model?.posterPath ?? "")") {
            posterImage.sd_setImage(with: url, completed: nil)
        }
        if let rating = model?.voteAverage {
            ratingLabel.text = "\(rating)"
        }
        titleLabel.text = model?.title
        releaseDateLabel.text = "Release Date".localized()
        releaseDate.text = ": \(model?.releaseDate ?? "")"
        CoreDataManager.shared.checkIsFavourite(with: movieID ?? 0) { result in
            switch result {
            case .success(let bool):
                bool ? self.favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal) : self.favouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            case .failure(let error):
                print(error)
            }
        }
    }

    func configureFavouriteMoviesComponents(_ model: FavouriteMovie) {
        if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterPath ?? "")") {
            posterImage.sd_setImage(with: url, completed: nil)
        }
        titleLabel.text = model.title
        releaseDateLabel.text = "Release Date".localized()
        releaseDate.text = ": \(model.releaseDate ?? "")"
        ratingLabel.text = "\(model.voteAverage)"
        CoreDataManager.shared.checkIsFavourite(with: movieID ?? 0) { result in
            switch result {
            case .success(let bool):
                bool ? self.favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal) : self.favouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            case .failure(let error):
                print(error)
            }
        }
    }
}
