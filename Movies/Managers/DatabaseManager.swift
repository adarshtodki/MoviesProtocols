//
//  DatabaseManager.swift
//  Movies
//
//  Created by Adarsh Todki on 22/09/18.
//  Copyright © 2018 Sakhatech. All rights reserved.
//

import Foundation
import CoreData

class DataBaseManager {
    
    static var shared = DataBaseManager()
    
    private init() {
    }
    
    var moviewsInfo: MovieListResponse? {
        do {
            let results = try DataBaseManager.viewContext.fetch(MovieListResponse.fetchRequest()) as? [MovieListResponse]
            return results?.first
        } catch  {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    static var viewContext: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
}
