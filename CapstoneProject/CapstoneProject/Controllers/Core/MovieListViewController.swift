//
//  MovieListViewController.swift
//  CapstoneProject
//
//  Created by Ensar Batuhan Ünverdi on 25.07.2022.
//

import UIKit

class MovieListViewController: UIViewController {

    var page: Int = 1
    var movieArray: [MovieResults?] = []

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
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func fetchData() {
        APICaller.shared.getPopularMovies(with: page) { [weak self] result in
            switch result {
            case .success(let results):
                self?.movieArray = results.results
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
            }
        }
    }

    func configureTitleAndBackgroundColor() {
        title = "Movies".localized()
        view.backgroundColor = .systemBackground
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListCell.identifier, for: indexPath) as? MovieListCell else {
            return UITableViewCell()
        }
        cell.movieID = movieArray[indexPath.row]?.id
        cell.configureMovieResultsComponents(movieArray[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieArray.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = DetailsViewController.instantiate()
        let selectedMovie = movieArray[indexPath.row]
        detailVC.movieID = selectedMovie?.id
        detailVC.movieResults = selectedMovie
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension MovieListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height-100-scrollView.frame.size.height) {
            page += 1
            APICaller.shared.getPopularMovies(with: page) { [weak self] result in
                switch result {
                case .success(let results):
                    self?.movieArray.append(contentsOf: results.results)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
