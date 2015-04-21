//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Nathaniel Okun on 4/19/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

protocol FiltersViewDelegate {
    func filtersViewController(filtersViewController: FiltersViewController, Category category: String, SortBy sorter: String, Radius radius:Int, Deals deals: Bool, SwitchStates switchStates: [String: Array<Bool>])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GeneralFilterCellDelegate, TextFieldCellDelegate {

    var filterSections = [
                    "Category": ["Food", "Health & Medical"],
                    "Radius": ["Empty"],
                    "Sort By": ["Best Match", "Distance", "Highest Rated"],
                    "General Features":["Deals"]
                    ]
   
    var switchStates: [String: Array<Bool>]!
    
    var filterSectionTitles = [
                    "Category",
                    "Radius",
                    "Sort By",
                    "General Features"
                    ]
    
    var sectionCellIndentifiers = [
                    "GeneralFilterCell",
                    "TextFieldCell",
                    "GeneralFilterCell",
                    "GeneralFilterCell",
                    ]
    
    var radius = 50
    
    var delegate: FiltersViewDelegate?
    
    var expandedSortView = true
    var expandedCategoryView = true
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }

/*
 * Sends information back to the RestaurantsViewController when the NavBar Button 'Search' is pressed.
 */
    @IBAction func searchButtonPressed(sender: AnyObject) {
        var category = whichFieldIsOn("Category")
        var sortBy = whichFieldIsOn("Sort By")
        
        delegate?.filtersViewController(self, Category: category, SortBy: sortBy, Radius: radius, Deals: switchStates["General Features"]![0], SwitchStates: switchStates)
        
        dismissViewControllerAnimated(true, completion: nil)    //Switches modals
    }

/*
 * Returns which field is on in a given category.
 */
    func whichFieldIsOn(categoryName: String) -> String {
        var switches = switchStates[categoryName]
        var onIndex = 0
        for(onIndex; onIndex < switches!.count; onIndex++) {
            if(switches![onIndex]) {
                break
            }
        }
        
        return filterSections[categoryName]![onIndex]
    }

/*
 * Returns the number of sections in the table view.
 */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filterSections.count
    }
/*
 * Returns the number of columns in the given section.
 */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sectionTitle = filterSectionTitles[section]
        
        //If statements are for accordian view.
        if(sectionTitle == "Sort By"){
            if(!expandedSortView) {
               return 1
            }
        }
        
        if(sectionTitle == "Category"){
            if(!expandedCategoryView) {
                return 1
            }
        }
        
        var sectionEntries = filterSections[sectionTitle]
        return sectionEntries!.count
    }
    
/*
 * Delegate method for GeneralFilterCell.
 */
    func settingsChanged(cell: GeneralFilterCell, isOn: Bool) {
        let indexPath = tableView.indexPathForCell(cell)
        let section = indexPath!.section
        let row = indexPath!.row
        let title = filterSectionTitles[section]
        
        if(title == "Category" || title == "Sort By") {
            switchAllOffButOne(title, row: row, isOn: isOn)
        } else {
            switchStates[title]![row] = isOn
        }
        
        tableView.reloadData()
    }

/*
 * Switches off all the switches in a given section but the one at 'row'.
 */
    func switchAllOffButOne(title: String, row: Int, isOn: Bool) {
        var index = row
        if(!isOn) { //If the user clicked the value that was already on in a filter that needs one to be on
                    //just set the first to be on
            index = 0
        }
        for(var i = 0; i < switchStates[title]!.count; i++) {
            switchStates[title]![i] = i == index
        }
    }
    
/*
 * Delegate method for TextFieldCell.
 */
    func textTyped(cell: TextFieldCell, text: String) {
        println("Radius Changed in Delegate")
        if text.toInt() != nil {
            radius = text.toInt()!
        }
    }

/*
 * Dequeing cell for table view.
 */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identifier = sectionCellIndentifiers[indexPath.section]
        if(identifier == "GeneralFilterCell") {
            var cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! GeneralFilterCell
            cell.nameLabel.text = chooseLabelText(indexPath.section, row: indexPath.row)
            cell.filterSwitch.on = chooseSwitchOn(indexPath.section, row: indexPath.row)
            cell.delegate = self
            return cell
        }
        
        if(identifier == "TextFieldCell") {
            var cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! TextFieldCell
            cell.nameLabel.text = "Radius"
            cell.textField.text = String(radius)
            cell.delegate = self
            return cell
        }
        
        return UITableViewCell()
    }
    
/*
 * Given a section and a row, return the text in that cell.
 */
    func chooseLabelText(section: Int, row: Int) -> String {
        var title = filterSectionTitles[section]
        return filterSections[title]![row]
    }
    
/*
 * Given a section and a row, return the state of the switch in that area.
 * Not input safe. If bad section and row are given, method will result in crash.
 */
    func chooseSwitchOn(section: Int, row: Int) -> Bool {
        var title = filterSectionTitles[section]
        return switchStates[title]![row]
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filterSectionTitles[section]
    }
    
    
/*
 * Implements accordian view by setting one of two global variables to true or false depending on which section
 * was clicked.
 */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 0) {
           expandedCategoryView = true  //!expandedCategoryView
        }
        
        if(indexPath.section == 2) {
            expandedSortView = true     //!expandedSortView
        }
        
        tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
