//
//  BusinessCell.swift
//  Yelp
//
//  Created by Nathaniel Okun on 4/16/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

//    @IBOutlet weak var thumbnailImage: UIImageView!
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var distanceLabel: UILabel!
//    @IBOutlet weak var reviewsLabel: UILabel!
//    @IBOutlet weak var ratingImage: UIImageView!
//    @IBOutlet weak var addressLabel: UILabel!
//    @IBOutlet weak var priceLabel: UILabel!
//    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var business: Business?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setNewBusiness(newBusiness: Business) {
        business = newBusiness
        
        var thumbnailURL = NSURL(string: business!.imageURL)
        thumbnailImage.setImageWithURL(thumbnailURL)
        
        nameLabel.text = business!.name
        
        var ratingImgURL = NSURL(string: business!.ratingImageURL)
        ratingImage.setImageWithURL(ratingImgURL)
        
        distanceLabel.text = NSString(format: "%.2f mi", business!.distance) as String
        
        reviewsLabel.text = NSString(format: "%d reviews", business!.numReviews) as String
        
        addressLabel.text = business!.address
        
        priceLabel.text = "$$"
        
        categoryLabel.text = business!.categories
        
        
        
    }
    
}
