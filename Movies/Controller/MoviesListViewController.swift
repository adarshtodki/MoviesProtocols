//
//  MoviesListViewController.swift
//  Movies
//
//  Created by Adarsh Todki on 22/09/18.
//  Copyright © 2018 Sakhatech. All rights reserved.
//

import UIKit
import Alamofire

class MoviesListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var searchBar: UISearchBar?
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activity.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
        tableView.tableFooterView = activity
        return activity
    }()

    private let viewModel: MovieViewModelProtocol = MovieViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        viewModel.getMoviesList()
        setupNavBar()
    }
}

//MARK:- UITableViewDataSource
extension MoviesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeCell(type: MovieCell.self, indexPath: indexPath)
        let data = viewModel.movies![indexPath.row]
        let expand = viewModel.expandedIndexes.contains(indexPath.row)
        cell.cellData = (data, expand)
        return cell
    }
    
}

//MARK:- UITableViewDelegate
extension MoviesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.canLoadTheNextChunkData(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.toggleExpandIndex(index: indexPath.row)
        endEditing()
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        endEditing()
    }
}

//MARK: - UISearchBarDelegate
extension MoviesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        endEditing()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        endEditing()
    }
}

//MARK: - UISearchControllerDelegate
extension MoviesListViewController: UISearchControllerDelegate {
    func willDismissSearchController(_ searchController: UISearchController) {
        viewModel.searchText = ""
    }
}

//MARK: - MovieViewModelDelegate
extension MoviesListViewController: MovieViewModelDelegate {
    func activityIndicator(show: Bool) {
        if show {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
    }

    func dataUpdated() {
        tableView.reloadData()
    }

    func reloadIndex(index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)],
                             with: .fade)
    }
}

//MARK:- Private Methods
extension MoviesListViewController {
    private func initialize() {
        viewModel.delegate = self
        self.title = viewModel.title

        registerCells()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    private func registerCells() {
        tableView.registerCellNib(type: MovieCell.self)
    }

    private func setupNavBar() {
        if #available(iOS 11.0, *) {
            let searchVC = UISearchController(searchResultsController: nil)
            searchBar = searchVC.searchBar
            searchBar?.delegate = self
            searchVC.delegate = self
            searchVC.dimsBackgroundDuringPresentation = false

            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.searchController = searchVC
        } else {
            searchBar = UISearchBar()
            searchBar?.delegate = self
            navigationItem.titleView = searchBar
        }
    }

    private func endEditing() {
        searchBar?.endEditing(true)
    }
}

