//
//  FavouriteViewController.swift
//  test
//
//  Created by Ensar Batuhan Ünverdi on 22.07.2022.
//

import UIKit

class FavouritesViewController: UIViewController {

    var favouriteMoviesArray: [FavouriteMovie] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: MovieListCell.identifier, bundle: nil), forCellReuseIdentifier: MovieListCell.identifier)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTitleAndBackgroundColor()
        fetchMoviesFromPersistance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        fetchMoviesFromPersistance()
    }

    func fetchMoviesFromPersistance() {
        CoreDataManager.shared.getMoviesFromPersistance { result in
            switch result {
            case .success(let favourites):
                self.favouriteMoviesArray = favourites
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func configureTitleAndBackgroundColor() {
        title = "Favourites".localized()
        view.backgroundColor = .systemBackground
    }
}

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListCell.identifier, for: indexPath) as? MovieListCell else {
            return UITableViewCell()
        }
        cell.movieID = Int(favouriteMoviesArray[indexPath.row].id)
        cell.configureFavouriteMoviesComponents(favouriteMoviesArray[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteMoviesArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = DetailsViewController.instantiate()
        let selectedMovie = favouriteMoviesArray[indexPath.row]
        detailVC.movieID = Int(selectedMovie.id)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            CoreDataManager.shared.deleteMovie(with: Int(favouriteMoviesArray[indexPath.row].id)) { error in
                print(error)
            }
            self.favouriteMoviesArray.remove(at: indexPath.row)
        default:
            break
        }
    }
}
