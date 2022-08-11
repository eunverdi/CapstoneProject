//
//  CoreDataStack.swift
//  CapstoneProject
//
//  Created by Ensar Batuhan Ünverdi on 6.08.2022.
//

import Foundation
import CoreData

final class CoreDataStack {

    private let modelName: String

    init(modelName: String) {
        self.modelName = modelName
    }

    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var managedContext: NSManagedObjectContext = {
        let context = storeContainer.viewContext
        return context
    }()

    func saveContext () {
        guard managedContext.hasChanges else {
            return
        }
        do {
            try managedContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
