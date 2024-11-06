//
//  ViewController.swift
//  ApiCall
//
//  Created by Kishore B on 11/6/24.
//

import CoreData
import Foundation

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    // MARK: - Core Data stack
    private lazy var managedObjectContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ApiTask")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // MARK: - Save Article Data
    func saveArticle(_ data: Doc) {
        let context = managedObjectContext
        let entity = DocEntity(context: context)
        
        // Set text properties
        entity.title = data.headline?.main
        entity.abstract = data.abstract
        entity.date = data.pubDate
        
        if let imageUrlString = data.multimedia?.first?.url, let imageURL = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: imageURL) { imageData, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error downloading image: \(error.localizedDescription)")
                        entity.imageData = nil
                    } else {
                        entity.imageData = imageData
                    }
                    
                    self.saveContext()
                }
            }.resume()
        } else {
            entity.imageData = nil
            self.saveContext()
        }
    }
    
    // MARK: - Fetch Articles from Core Data
    func fetchArticles() -> [Doc2] {
        let fetchRequest: NSFetchRequest<DocEntity> = DocEntity.fetchRequest()
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            let articles = results.map { articleEntity in
                return Doc2(
                    title: articleEntity.title ?? "",
                    description: articleEntity.abstract ?? "",
                    pubDate: articleEntity.date ?? "",
                    imageUrl: articleEntity.imageData
                )
            }
            print("Article list count: \(articles.count)")
            return articles
        } catch {
            print("Could not fetch: \(error)")
            return []
        }
    }
    
    // MARK: - Delete All Articles from Core Data
    func deleteAllArticles() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = DocEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext.execute(deleteRequest)
            try managedObjectContext.save()
            print("All articles deleted successfully.")
        } catch {
            print("Failed to delete all articles: \(error.localizedDescription)")
        }
    }

    // MARK: - Save Context
    private func saveContext() {
        let context = managedObjectContext
        do {
            try context.save()
            print("Context saved successfully")
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
