//
//  Business.swift
//  Yelp
//
//  Created by Nathaniel Okun on 4/16/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class Business: NSObject {
   
    var imageURL: String!
    var name: String!
    var ratingImageURL: String!
    var numReviews: Int!
    var address: String!
    var categories: String!
    var distance: CGFloat!
    var rating: CGFloat!
    
    init(imgURL: String!, name: String!, ratingImageURL: String!, numReviews: Int!, address: String!, categories: String!, distance: CGFloat!, businessRating: CGFloat!) {
        self.imageURL = imgURL
        self.name = name
        self.ratingImageURL = ratingImageURL
        self.numReviews = numReviews
        self.address = address
        self.categories = categories
        self.distance = distance
        self.rating = businessRating
    }
    
    func toString() {
        
        println(name)
        println(imageURL)
        println(ratingImageURL)
        println(distance)
        println(categories)
        println(address)
        println(numReviews)
    }
}
