//
//  DetailViewController.swift
//  test
//
//  Created by Ensar Batuhan Ünverdi on 22.07.2022.
//

import UIKit
import SDWebImage
import SafariServices

class DetailsViewController: UIViewController {

    var recommendation: [MovieResults?] = []
    var movieResults: MovieResults?
    var movieID: Int?
    var allDetails: MovieDetailsModel?
    var castDetails: [CastResults?] = []

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var releaseText: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var originalLanguageText: UILabel!
    @IBOutlet weak var originalLanguageLabel: UILabel!
    @IBOutlet weak var originalTitleLabel: UILabel!
    @IBOutlet weak var budgetText: UILabel!
    @IBOutlet weak var revenueText: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var runtimeText: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var minuteText: UILabel!
    @IBOutlet weak var companyText: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var castTitle: UILabel!
    @IBOutlet weak var recommendationTitle: UILabel!
    @IBOutlet weak var homePage: UIButton!
    @IBOutlet weak var addFavouriteButton: UIBarButtonItem!
    @IBOutlet weak var castCollectionView: UICollectionView! {
        didSet {
            castCollectionView.delegate = self
            castCollectionView.dataSource = self
            castCollectionView.register(UINib(nibName: CastListCell.identifier, bundle: nil), forCellWithReuseIdentifier: CastListCell.identifier)
        }
    }

    @IBOutlet weak var recommendationCollectionView: UICollectionView! {
        didSet {
            recommendationCollectionView.delegate = self
            recommendationCollectionView.dataSource = self
            recommendationCollectionView.register(UINib(nibName: RecommendationListCell.identifier, bundle: nil), forCellWithReuseIdentifier: RecommendationListCell.identifier)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBarAndBackground()
        fetchDetails()
        configureComponents()
        fetchRecommendations()
        fetchCastDatas()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CoreDataManager.shared.checkIsFavourite(with: movieID ?? 0) { result in
            switch result {
            case .success(let bool):
                if bool {
                    self.addFavouriteButton.image = UIImage(systemName: "heart.fill")
                } else {
                    self.addFavouriteButton.image = UIImage(systemName: "heart")
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func configureNavigationBarAndBackground() {
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .systemBackground
    }

    func fetchCastDatas() {
        APICaller.shared.getCastData(with: movieID ?? 0) { [weak self] result in
            switch result {
            case .success(let castData):
                DispatchQueue.main.async {
                    self?.castDetails = castData.cast
                    self?.castCollectionView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
            }
        }
    }

    func fetchDetails() {
        APICaller.shared.getDetailsOfMovie(with: movieID ?? 0) { [weak self] result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self?.allDetails = movies
                    self?.configureComponents()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
            }
        }
    }

    func fetchRecommendations() {
        APICaller.shared.getRecommendations(with: movieID ?? 0) { [weak self] result in
            switch result {
            case .success(let recommendations):
                DispatchQueue.main.async {
                    self?.recommendation = recommendations.results
                    self?.recommendationCollectionView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func configureComponents() {
        if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(allDetails?.posterPath ?? "")") {
            posterImage.sd_setImage(with: url, completed: nil)
        }
        for company in allDetails?.productionCompanies ?? [] {
            companyLabel.text = ": \((company?.name ?? "") + "")"
        }
        for genre in allDetails?.genres ?? [] {
            genresLabel.text = (genre?.name ?? "") + ""
        }
        titleLabel.text = allDetails?.title
        overviewLabel.text = allDetails?.overview?.localized()
        originalLanguageText.text = "Original Language".localized()
        originalLanguageLabel.text = ": \(allDetails?.originalLanguage ?? "")"
        originalTitleLabel.text = "(\(allDetails?.originalTitle ?? ""))"
        budgetText.text = "Budget".localized()
        budgetLabel.text = ": \(allDetails?.budget?.currencyUS ?? "")"
        revenueText.text = "Revenue".localized()
        revenueLabel.text = ": \(allDetails?.revenue?.currencyUS ?? "")"
        runtimeText.text = "Runtime".localized()
        runtimeLabel.text = ": \(allDetails?.runtime ?? 0)"
        minuteText.text = "minutes".localized()
        releaseText.text = "Release Date".localized()
        releaseDateLabel.text = ": \(allDetails?.releaseDate ?? "")"
        companyText.text = "Company".localized()
        castTitle.text = "Cast".localized()
        recommendationTitle.text = "Recommendation".localized()
        homePage.setTitle("Homepage".localized(), for: .normal)
    }

    @IBAction func goToHomepage(_ sender: Any) {
        guard let url = URL(string: allDetails?.homepage ?? "") else {
            return
        }
        let webVC = SFSafariViewController(url: url)
        present(webVC, animated: true)
    }

    @IBAction func addFavouriteButtonTapped(_ sender: UIBarButtonItem) {
        CoreDataManager.shared.checkIsFavourite(with: movieID ?? 0) { result in
            switch result {
            case .success(let bool):
                if bool {
                    CoreDataManager.shared.deleteMovie(with: self.movieID ?? 0) { error in
                        print(error)
                    }
                    self.addFavouriteButton.image = UIImage(systemName: "heart")
                } else {
                    CoreDataManager.shared.createMovie(with: self.movieResults!)
                    self.addFavouriteButton.image = UIImage(systemName: "heart.fill")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension DetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case castCollectionView:
            guard let cell = castCollectionView.dequeueReusableCell(withReuseIdentifier: CastListCell.identifier, for: indexPath) as? CastListCell else {
                return UICollectionViewCell()
            }
            cell.configureComponents(castDetails[indexPath.row])
            return cell
        case recommendationCollectionView:
            guard let cell = recommendationCollectionView.dequeueReusableCell(withReuseIdentifier: RecommendationListCell.identifier, for: indexPath) as? RecommendationListCell else {
                return UICollectionViewCell()
            }
            cell.configureComponents(recommendation[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case recommendationCollectionView:
            let detailVC = DetailsViewController.instantiate()
            let selectedMovie = recommendation[indexPath.row]
            detailVC.movieID = selectedMovie?.id
            detailVC.movieResults = selectedMovie
            navigationController?.pushViewController(detailVC, animated: true)
        case castCollectionView:
            let castDetailVC = CastDetailsViewController.instantiate()
            castDetailVC.castID = castDetails[indexPath.row]?.id
            navigationController?.pushViewController(castDetailVC, animated: true)
        default:
            return
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case castCollectionView:
            return castDetails.count
        case recommendationCollectionView:
            return recommendation.count
        default:
            return 0
        }
    }
}
