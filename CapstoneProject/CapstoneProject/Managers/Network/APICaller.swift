//
//  APICaller.swift
//  CapstoneProject
//
//  Created by Ensar Batuhan Ünverdi on 25.07.2022.
//

import Foundation

struct Constants {
    static let BASE_URL = "https://api.themoviedb.org"
    static let API_KEY  = "7c9031d735e66fc4df43fcf9079def36"
}

struct Language {
    static func getLanguage() -> String {
        guard let locale = NSLocale.current.languageCode else {
            return ""
        }
        return locale
    }
}

class APICaller {
    static let shared = APICaller()
    private init() {}

    func getPopularMovies(with page: Int, completion: @escaping (Result<MovieModel, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/3/movie/popular?api_key=\(Constants.API_KEY)&page=\(page)&language=\(Language.getLanguage())") else {
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(MovieModel.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }

    func getDetailsOfMovie(with id: Int, completion: @escaping (Result<MovieDetailsModel, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/3/movie/\(id)?api_key=\(Constants.API_KEY)&language=\(Language.getLanguage())") else {
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(MovieDetailsModel.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }

    func searchMovie(with query: String, completion: @escaping (Result<MovieModel, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        guard let url = URL(string: "\(Constants.BASE_URL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)&language=\(Language.getLanguage())") else {
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(MovieModel.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }

    func getDiscoverMovies(with page: Int, completion: @escaping (Result<MovieModel, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=\(Language.getLanguage())&page=\(page)") else {
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(MovieModel.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
            }
        }
        .resume()
    }

    func getRecommendations(with id: Int, completion: @escaping (Result<MovieModel, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/3/movie/\(id)/recommendations?api_key=\(Constants.API_KEY)&language=\(Language.getLanguage())") else {
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(MovieModel.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }

    func getCastData(with id: Int, completion: @escaping (Result<CastModel, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/3/movie/\(id)/credits?api_key=\(Constants.API_KEY)&language=\(Language.getLanguage())") else {
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(CastModel.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }

    func getCastDetails(with id: Int, completion: @escaping (Result<CastDetailsModel, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/3/person/\(id)?api_key=\(Constants.API_KEY)&language=\(Language.getLanguage())") else {
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(CastDetailsModel.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }
}
