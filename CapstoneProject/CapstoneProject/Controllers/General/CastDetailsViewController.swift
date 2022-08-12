//
//  CastDetailViewController.swift
//  CapstoneProject
//
//  Created by Ensar Batuhan Ünverdi on 1.08.2022.
//

import UIKit
import SDWebImage

class CastDetailsViewController: UIViewController {
    
    var castID: Int?
    var details: CastDetailsModel?

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var placeOfBirthLabel: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!
    @IBOutlet weak var deathday: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCastDetails()
        configureAllComponents()
    }

    func configureAllComponents() {
        if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(details?.profilePath ?? "")") {
            profileImageView.sd_setImage(with: url, completed: nil)
        }
        nameLabel.text = details?.name
        birthdayLabel.text = details?.birthday
        placeOfBirthLabel.text = details?.placeOfBirth
        biographyLabel.text = details?.biography
        deathday.text = details?.deathday
    }

    func fetchCastDetails() {
        APICaller.shared.getCastDetails(with: castID ?? 0) { [weak self] result in
            switch result {
            case .success(let results):
                DispatchQueue.main.async {
                    self?.details = results
                    self?.configureAllComponents()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
