//
//  AddFoodViewController.swift
//  WhatToEat
//
//  Created by Will Hodges on 3/27/16.
//  Copyright © 2016 Will T. Hodges. All rights reserved.
//

import UIKit
import iAd

class AddFoodViewController: UIViewController, ADBannerViewDelegate {
    
    var bannerView = ADBannerView()
    
    
    @IBOutlet weak var foodField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAds()
        
        if let resultsArray = prefs.object(forKey: "results") {
            results = resultsArray as! NSArray as! [String]
            results = results.sorted() { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
            
        }
        else {
            results = ["Burritos", "Tacos", "Spaghetti", "Meatball Sub", "Pizza", "Burgers", "Hot Dogs", "Turkey Sandwich", "Egg Salad Sandwhich", "Nachos", "Steak", "Peanut Butter & Jelly", "Pad Thai", "Pineapple Fried Rice", "Drunken Noodles", "Fish", "Rice", "Grilled Cheese", "Barbecue", "Tomato Soup", "Chicken Noodle Soup", "Ham Sandwich"]
            results = results.sorted() { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadAds() {
        // iAd
        // Changed banners width to match the width of the view it is on
        // You need to set the y origin relative to your view. Not a static number.
        bannerView = ADBannerView(frame: CGRect(x: 0, y: self.view.frame.size.height - bannerView.frame.height, width: self.view.frame.size.width, height: bannerView.frame.height))
        bannerView.delegate = self
        view.addSubview(bannerView)
        // Hide iAd initially
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
        UIView.commitAnimations()
    }
    
    @IBAction func addButtonPressed(_ sender: AnyObject) {
        results.append(foodField!.text!)
        prefs.set(results, forKey: "results")
        foodField.text! = ""
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
