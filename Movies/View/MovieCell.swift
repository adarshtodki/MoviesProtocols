//
//  MovieCell.swift
//  Movies
//
//  Created by Adarsh Todki on 22/09/18.
//  Copyright © 2018 Sakhatech. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher

class MovieCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var releaseDateLbl: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var overviewLbl: UILabel!
    @IBOutlet weak var directionImageView: UIImageView!
    
    var cellData: (data: Movie, showOverview: Bool)? {
        didSet {
            setData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterImageView.layer.borderColor = UIColor.lightGray.cgColor
        posterImageView.layer.borderWidth = 1.0
        posterImageView.kf.indicatorType = .activity
    }
    
    private func setData() {
        
        guard let cellData = cellData else {
            return
        }
        
        nameLbl.text = cellData.data.title
        releaseDateLbl.text = cellData.data.releaseDate
        ratingView.rating = cellData.data.voteAverage/2
        ratingView.text = "(\(cellData.data.voteCount))"
     
        
        if cellData.showOverview {
            overviewLbl.text = cellData.data.overview
            directionImageView.image = #imageLiteral(resourceName: "UpArrow")
        } else {
            overviewLbl.text = nil
            directionImageView.image = #imageLiteral(resourceName: "DownArrow")
        }
        
        posterImageView.image = nil
        if let imagePath = cellData.data.posterPath {
            let url = AppUrl.imageBasePath(imageId: imagePath).url
            posterImageView.kf.setImage(with: url)
        }
    }
}
