//
//  APIManager.swift
//  Movies
//
//  Created by Adarsh Todki on 22/09/18.
//  Copyright © 2018 Sakhatech. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

class APIManager {
    func getMovies(pageNumber: Int32, completionHandler: @escaping (MovieListResponse?) -> ()) {
        let url = AppUrl.movieList(pageNumber: pageNumber).url
        var moviesInfo = DataBaseManager.shared.moviewsInfo
        if Connectivity.isConnectedToInternet() {
            Alamofire.request(url).responseJSON { (response) in
                do {
                    if let data = response.data {
                        if let json = try JSONSerialization.jsonObject(with: data,
                                                                       options: .allowFragments) as? [String: AnyObject] {
                            if moviesInfo != nil {
                                if pageNumber == 1, let movies = moviesInfo?.movies {
                                    moviesInfo?.removeFromMovies(movies)
                                }
                                moviesInfo?.update(dict: json, context: DataBaseManager.viewContext)
                            } else {
                                moviesInfo = MovieListResponse.createObjectWith(dict: json, context: DataBaseManager.viewContext)
                            }
                            appDelegate.saveContext()
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                completionHandler(moviesInfo)
            }
        } else {
            completionHandler(moviesInfo)
        }
    }
}

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
