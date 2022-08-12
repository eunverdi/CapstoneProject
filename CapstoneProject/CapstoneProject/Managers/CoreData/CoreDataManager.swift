//
//  CoreDataManager.swift
//  CapstoneProject
//
//  Created by Ensar Batuhan Ünverdi on 6.08.2022.
//

import Foundation
import CoreData

class CoreDataManager {

    static let shared = CoreDataManager()
    var coreDataStack: CoreDataStack
    var moc: NSManagedObjectContext {
        return coreDataStack.managedContext
    }

    private init(coreDataStack: CoreDataStack = CoreDataStack(modelName: "FavouriteMovie")) {
        self.coreDataStack = coreDataStack
    }

    private func movieIDPredicate(of request: NSFetchRequest<FavouriteMovie>, with id: Int) -> NSPredicate {
        request.predicate = NSPredicate(format: "id == %d", id)
        return request.predicate!
    }

    func checkIsFavourite(with movieID: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            let request: NSFetchRequest<FavouriteMovie> = FavouriteMovie.fetchRequest()
            request.returnsObjectsAsFaults = false
            request.predicate = movieIDPredicate(of: request, with: movieID)
            let fetchedResults = try moc.fetch(request)
            fetchedResults.first != nil ? completion(.success(true)) : completion(.success(false))
        } catch {
            completion(.failure(error))
        }
    }

    func getMoviesFromPersistance(completion: @escaping (Result<[FavouriteMovie], Error>) -> Void) {
        do {
            let request: NSFetchRequest<FavouriteMovie> = FavouriteMovie.fetchRequest()
            request.returnsObjectsAsFaults = false
            let movies = try moc.fetch(request)
            completion(.success(movies))
        } catch {
            completion(.failure(error))
        }
    }

    func createMovie(with movieResult: MovieResults) {
        let favouriteMovie = FavouriteMovie(context: moc)
        favouriteMovie.id = Int64(movieResult.id ?? 0)
        favouriteMovie.title = movieResult.title
        favouriteMovie.voteAverage = movieResult.voteAverage ?? 0.0
        favouriteMovie.posterPath = movieResult.posterPath
        favouriteMovie.releaseDate = movieResult.releaseDate
        coreDataStack.saveContext()
    }

    func deleteMovie(with movieID: Int, completion: @escaping (Error) -> Void) {
        let request: NSFetchRequest<FavouriteMovie> = FavouriteMovie.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = movieIDPredicate(of: request, with: movieID)
        do {
            let fetchedResult = try moc.fetch(request)
            if let movieModel = fetchedResult.first {
                moc.delete(movieModel)
                coreDataStack.saveContext()
            }
        } catch {
            completion(error)
        }
    }
}
