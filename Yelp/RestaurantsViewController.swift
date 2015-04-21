//
//  ViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class RestaurantsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewDelegate {
    
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var searchBar: UISearchBar!
    var client: YelpClient!
    @IBOutlet weak var tableView: UITableView!
    
    
    //Default Categories and Switch States
    var category = "Food"
    var sortBy = "Best Match"
    var searchRadius = 50
    var dealsOn = false
    var switchStates = [
        "Category": [true, false],
        "Sort By": [true, false, false],
        "General Features":[false]
        ]
    
    //Business Data and Filtered Data for Searching
    var businesses: [Business]? = [Business]()
    var filteredData: [Business]! = [Business]()
    
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    let yelpConsumerKey = "jESCh_79s2fo5JH_nmK3Ww"
    let yelpConsumerSecret = "RBTapHSyPffIdhZqiXXmVE0WVDo"
    let yelpToken = "ZV7ihCqv-mnmGfD9MgZMva46ke7tW6JK"
    let yelpTokenSecret = "xssMmFDjpOSJkDDv6S7aILBbFA4"
    
    //Numerical Constants
    let searchBarWidth: CGFloat = 40.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.titleView = searchBar
        
        //Create YelpClient
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        //Query the Yelp API to populate the table
        queryYelpAPI()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        searchBar.delegate = self
        
    }

/*
 * Queries the Yelp API, searching using the instance variable 'category'
 */
    func queryYelpAPI() {
        client.searchWithTerm(category, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            self.businesses  = self.populateBusinesses(response["businesses"] as! [NSDictionary])
            self.filteredData = self.businesses
            self.sortBusinesses()
            self.tableView.reloadData()
            
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }

/*
 * Search Bar delegate method. Called when the search bar text changes.
 */
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty) {
            filteredData = businesses
            searchBar.resignFirstResponder()
            tableView.reloadData()
            return
        }
        
        filteredData = businesses!.filter({(business: Business) -> Bool in
            var name = business.name
            return name.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        
        
        tableView.reloadData();
    }
    
/*
 * Attempt to get the search bar keyboard to dismiss. Does not work.
 */
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

    }

/*
 * Populates 'businesses' array with instances of the Business class, based off 
 * information from querying the Yelp API.
 */
    func populateBusinesses(businessesDictionary: [NSDictionary]) -> [Business]? {
        var businesses = [Business]()
        println("Starting Query")
        
        for(var i = 0; i < businessesDictionary.count; i++) {
            var business = businessesDictionary[i]
            var imageURL = "http://placehold.it/70x70"
            println(business)
            
            if business["image_url"] != nil {
                imageURL = business["image_url"] as! String
            }
            
            var name = business["name"] as! String
            var ratingImageURL = business["rating_img_url"] as! String
            var distance = CGFloat(arc4random_uniform(5) + 1)   //Just use a random value for distance
            var numReviews = 0
            var rating = business["rating"] as! CGFloat
            
            var location = business["location"] as! NSDictionary
            var displayAddress = location["display_address"] as! [String]
            var address = ""
            for(var i = 0; i < displayAddress.count; i++) {
                address += displayAddress[i]
                if i != (displayAddress.count - 1) {
                    address += ", "
                }
            }
            
            var categories = ""
            for(var j = 0; j < business["categories"]!.count; j++) {
                categories += business["categories"]![j][0] as! String
                if(j != business["categories"]!.count - 1) {
                    categories += ", "
                }
            }
            
            businesses.append(Business(imgURL: imageURL, name: name, ratingImageURL: ratingImageURL, numReviews: numReviews, address: address, categories: categories, distance: distance, businessRating: rating))
        }
        
        return businesses
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("businessCell", forIndexPath: indexPath) as! BusinessCell
        var relevantBusiness = filteredData[indexPath.row]
        cell.setNewBusiness(relevantBusiness)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func sortBusinesses() {
        businesses = sorted(businesses!, { (b1: Business, b2: Business) -> Bool in
            if(self.sortBy == "Distance") {
                return b1.distance < b2.distance
            }
            
            if(self.sortBy == "Highest Rated") {
                return b1.rating > b2.rating
            }
            
            return true
        })
        
        filteredData = businesses
    }
    
/*
 * FiltersViewDelegate Method. Called when we return from the Filters View to the Restaurants View
 */
    
    func filtersViewController(filtersViewController: FiltersViewController, Category category: String, SortBy sorter: String, Radius radius: Int, Deals deals: Bool, SwitchStates switchStates: [String: Array<Bool>]) {
        if(category != self.category) {
            self.category = category
            queryYelpAPI()
        }
        
        if(sorter != sortBy) {
            self.sortBy = sorter
            sortBusinesses()
        }
        
        self.searchRadius = radius
        self.dealsOn = deals
        self.switchStates = switchStates
        
        tableView.reloadData()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nav = segue.destinationViewController as! UINavigationController
        var filtersViewController = nav.topViewController as! FiltersViewController
        filtersViewController.switchStates = switchStates
        filtersViewController.delegate = self
        filtersViewController.radius = searchRadius
        
    }
    
}

