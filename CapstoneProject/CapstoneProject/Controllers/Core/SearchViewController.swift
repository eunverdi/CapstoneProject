//
//  SearchViewController.swift
//  CapstoneProject
//
//  Created by Ensar Batuhan Ünverdi on 25.07.2022.
//

import UIKit

class SearchViewController: UIViewController {

    var page = 2
    var movieArray: [MovieResults?] = []
    var emptyArray: [MovieResults?] = []

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: MovieListCell.identifier, bundle: nil), forCellReuseIdentifier: MovieListCell.identifier)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Search for a Movie".localized()
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        configureSearchViewControllerComponents()
        searchController.searchResultsUpdater = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func configureSearchViewControllerComponents() {
        title = "Search".localized()
        navigationItem.searchController = searchController
        view.backgroundColor = .systemBackground
    }

    func fetchData() {
        APICaller.shared.getDiscoverMovies(with: page) { [weak self] result in
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
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
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

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height-100-scrollView.frame.size.height) {
            page += 1
            APICaller.shared.getDiscoverMovies(with: page) { [weak self] result in
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

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.movieArray = emptyArray
        self.tableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if searchBar.text == "" {
            self.movieArray = emptyArray
            self.tableView.reloadData()
        }
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        APICaller.shared.searchMovie(with: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self?.movieArray = results.results
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case.failure(let error):
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
