//
//  URLConstants.swift
//  Movies
//
//  Created by Adarsh Todki on 22/09/18.
//  Copyright © 2018 Sakhatech. All rights reserved.
//

import Foundation

enum AppUrl {
    case movieList(pageNumber: Int32)
    case imageBasePath(imageId: String)
}

extension AppUrl {
    var url: URL {
        var urlStr = ""
        switch self {
        case .movieList(let pageNumber):
            urlStr = "https://api.themoviedb.org/3/movie/now_playing?api_key=20999204c302e5952900ea3bdfc56b2f&language=en-US&page=\(pageNumber)"
        case .imageBasePath(let imageId):
            urlStr = "http://image.tmdb.org/t/p/w185\(imageId)"
        }
        
        if let url = URL(string: urlStr) {
            return url
        }
        fatalError("Invalid url")
    }
}
