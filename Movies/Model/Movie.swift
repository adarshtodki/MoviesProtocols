//
//  Movie.swift
//  Movies
//
//  Created by Adarsh Todki on 22/09/18.
//  Copyright © 2018 Sakhatech. All rights reserved.
//

import Foundation
import CoreData

extension MovieListResponse {
    enum CodingKeys: String, CodingKey {
        case results, page
        case totalPages = "total_pages"
    }
    
    static func createObjectWith(dict: [String: AnyObject], context: NSManagedObjectContext) -> MovieListResponse {
        let object = MovieListResponse(context: context)
        object.update(dict: dict, context: context)
        return object
    }
    
    func update(dict: [String: AnyObject], context: NSManagedObjectContext) {
        self.page = dict[CodingKeys.page.rawValue] as? Int32 ?? 0
        self.totalPages = dict[CodingKeys.totalPages.rawValue] as? Int32 ?? 0
        
        if let moviesDict = dict[CodingKeys.results.rawValue] as? [[String: AnyObject]] {
            for movieDict in moviesDict {
                let movie = Movie.createObjectWith(dict: movieDict, context: context)
                self.addToMovies(movie)
            }
        }
        
    }
}

extension Movie {
    enum CodingKeys: String, CodingKey {
        case voteCount = "vote_count"
        case id
        case voteAverage = "vote_average"
        case title
        case posterPath = "poster_path"
        case overview
        case releaseDate = "release_date"
    }
    
    static func createObjectWith(dict: [String: AnyObject], context: NSManagedObjectContext) -> Movie {
        let object = Movie(context: context)
        object.voteCount = dict[CodingKeys.voteCount.rawValue] as? Int32 ?? 0
        object.id = dict[CodingKeys.id.rawValue] as? Int32 ?? 0
        object.voteAverage = dict[CodingKeys.voteAverage.rawValue] as? Double ?? 0.0
        object.title = dict[CodingKeys.title.rawValue] as? String
        object.posterPath = dict[CodingKeys.posterPath.rawValue] as? String
        object.overview = dict[CodingKeys.overview.rawValue] as? String
        object.releaseDate = dict[CodingKeys.releaseDate.rawValue] as? String
        
        return object
    }
}
