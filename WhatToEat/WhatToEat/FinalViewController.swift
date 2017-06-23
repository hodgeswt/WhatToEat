//
//  FinalViewController.swift
//  WhatToEat
//
//  Created by Will Hodges on 3/20/16.
//  Copyright © 2016 Will T. Hodges. All rights reserved.
//

import UIKit
import iAd

var results = ["Burritos", "Tacos", "Spaghetti", "Meatball Sub", "Pizza", "Burgers", "Hot Dogs", "Turkey Sandwich", "Egg Salad Sandwhich", "Nachos", "Steak", "Peanut Butter & Jelly", "Pad Thai", "Pineapple Fried Rice", "Drunken Noodles", "Fish", "Rice", "Grilled Cheese", "Barbecue", "Tomato Soup", "Chicken Noodle Soup", "Ham Sandwich"]

class FinalViewController: UIViewController, ADBannerViewDelegate {

    @IBOutlet weak var resultsLabel: UILabel!
    let recognizer = UITapGestureRecognizer()
    
    var bannerView = ADBannerView()
    
    var result = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Results!"
        
        loadAds()
        
        if let resultsArray = prefs.object(forKey: "results") {
            results = resultsArray as! NSArray as! [String]
            results = results.sorted() { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
            result = results[Int(arc4random_uniform(UInt32(results.count)))]
            resultsLabel.text! = self.result
            resultsLabel.isUserInteractionEnabled = true;
            recognizer.addTarget(self, action: #selector(FinalViewController.labelHasBeenTapped))
            resultsLabel.addGestureRecognizer(recognizer)
        }
        else {
            results = ["Burritos", "Tacos", "Spaghetti", "Meatball Sub", "Pizza", "Burgers", "Hot Dogs", "Turkey Sandwich", "Egg Salad Sandwhich", "Nachos", "Steak", "Peanut Butter & Jelly", "Pad Thai", "Pineapple Fried Rice", "Drunken Noodles", "Fish", "Rice", "Grilled Cheese", "Barbecue", "Tomato Soup", "Chicken Noodle Soup", "Ham Sandwich"]
            results = results.sorted() { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
            result = results[Int(arc4random_uniform(UInt32(results.count)))]
            resultsLabel.text! = self.result
            resultsLabel.isUserInteractionEnabled = true;
            recognizer.addTarget(self, action: #selector(FinalViewController.labelHasBeenTapped))
            resultsLabel.addGestureRecognizer(recognizer)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func labelHasBeenTapped() {
        
        var originalString = ""
        
        if let city = prefs.string(forKey: "city"){
            originalString = city
        }
        else{
            //Nothing stored in NSUserDefaults yet. Set a value.
            prefs.setValue("Savannah, Ga", forKey: "city")
            originalString = "Savannah, Ga"
        }
        
        let escapedLoc = originalString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let escapedResult = self.result.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let url = "http://www.yelp.com/search?find_desc=" + escapedResult! + "&find_loc=" + escapedLoc!
        
        UIApplication.shared.openURL(URL(string: url)!)
    }
    
    func loadAds() {
        // iAd
        // Changed banners width to match the width of the view it is on
        // You need to set the y origin relative to your view. Not a static number.
        bannerView = ADBannerView(frame: CGRect(x: 0, y: self.view.frame.size.height - bannerView.frame.height, width: self.view.frame.size.width, height: bannerView.frame.height))
        bannerView.delegate = self
        view.addSubview(bannerView)
        // Hide iAd initially
        bannerView.alpha = 0.0
    }
    
    func bannerViewDidLoadAd(_ banner: ADBannerView!) {
        // Animate fade of banners
        UIView.beginAnimations(nil, context: nil)
        // Show iAd
        bannerView.alpha = 1.0
        UIView.commitAnimations()
    }
    
    func bannerView(_ banner: ADBannerView!, didFailToReceiveAdWithError error: Error!) {
        // Animate fade of banners
        UIView.beginAnimations(nil, context: nil)
        // Hide iAd
        bannerView.alpha = 0.0
        UIView.commitAnimations()
    }
    
}
