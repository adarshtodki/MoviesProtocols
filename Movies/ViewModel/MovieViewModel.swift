//
//  MoviesListViewController.swift
//  Movies
//
//  Created by Adarsh Todki on 22/09/18.
//  Copyright © 2018 Sakhatech. All rights reserved.
//

import Foundation

protocol MovieViewModelDelegate: class {
    func activityIndicator(show: Bool)
    func dataUpdated()
    func reloadIndex(index: Int)
}

protocol MovieViewModelProtocol: class {
    var title: String { get }
    var searchText: String { get set }

    var delegate: MovieViewModelDelegate? { set get }

    var manager: APIManager { get }
    var movies: [Movie]? { get }
    var expandedIndexes: Set<Int> { get }

    func toggleExpandIndex(index: Int)
    func canLoadTheNextChunkData(at index: Int)
    func getMoviesList()
}

class MovieViewModel: MovieViewModelProtocol {
    var title: String = "Movies"
    weak var delegate: MovieViewModelDelegate?
    internal let manager = APIManager()
    var expandedIndexes = Set<Int>()

    var searchText: String = "" {
        didSet {
            expandedIndexes = Set<Int>()
            updateMoviesList()
        }
    }

    private var isRequestPending: Bool = false {
        didSet {
            delegate?.activityIndicator(show: isRequestPending)
        }
    }

    private var responseData: MovieListResponse? {
        didSet {
            updateMoviesList()
        }
    }

    var movies: [Movie]? {
        didSet {
            delegate?.dataUpdated()
        }
    }

    var isSearchActive: Bool {
        return !searchText.isEmpty
    }


    private func updateMoviesList() {
        let allMovies = responseData?.movies?.array as? [Movie]

        if searchText.isEmpty {
            movies = allMovies
        } else {
            movies = allMovies?.filter({ (movie) -> Bool in
                if let title = movie.title?.lowercased() {
                    return title.contains(searchText.lowercased())
                }
                return false
            })
        }
    }

    func toggleExpandIndex(index: Int) {
        if expandedIndexes.contains(index) {
            expandedIndexes.remove(index)
        } else {
            expandedIndexes.insert(index)
        }

        delegate?.reloadIndex(index: index)
    }

    func canLoadTheNextChunkData(at index: Int) {
        if isSearchActive == false,
            let responseData = responseData,
            let movies = movies,
            movies.count - 1 == index,
            responseData.page != responseData.totalPages,
            Connectivity.isConnectedToInternet() {
            getMoviesList()
        }
    }

    func getMoviesList() {
        guard isRequestPending == false else {
            return
        }

        let pageNumber = (responseData?.page ?? 0) + 1
        isRequestPending = true
        manager.getMovies(pageNumber: pageNumber) { (response) in
            self.isRequestPending = false
            self.responseData = response
        }
    }
}
