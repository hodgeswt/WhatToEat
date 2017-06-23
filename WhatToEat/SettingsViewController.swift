//
//  SettingsViewController.swift
//  WhatToEat
//
//  Created by Will Hodges on 3/21/16.
//  Copyright © 2016 Will T. Hodges. All rights reserved.
//

import UIKit
import iAd

let prefs = UserDefaults.standard

class SettingsViewController: UIViewController, ADBannerViewDelegate {
    
    var bannerView = ADBannerView()
    
    @IBOutlet weak var cityField: UITextField!
    
    @IBOutlet weak var soundsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Settings"
        
        if let city = prefs.string(forKey: "city"){
            cityField.text! = city
        }
        else {
            //Nothing stored in NSUserDefaults yet. Set a value.
            prefs.setValue("Savannah, Ga", forKey: "city")
            cityField.text! = "Savannah, Ga"
        }
        
        if let sounds = prefs.string(forKey: "sounds") {
            if (sounds == "true") {
                soundsSwitch.setOn(true, animated: false)
            }
            else if (sounds == "false") {
                soundsSwitch.setOn(false, animated: false)
            }
        }
        else {
            prefs.setValue("true", forKey: "sounds")
            soundsSwitch.setOn(true, animated: false)
        }
        
        
        loadAds()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveCity(_ sender: AnyObject) {
        prefs.setValue(cityField.text!, forKey: "city")
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
    @IBAction func soundSwitchPressed(_ sender: AnyObject) {
        if let sounds = prefs.string(forKey: "sounds"){
            if (sounds == "true") {
                prefs.setValue("false", forKey: "sounds")
                soundsSwitch.setOn(false, animated: false)
            }
            else {
                prefs.setValue("true", forKey: "sounds")
                soundsSwitch.setOn(true, animated: false)
            }
        }
        else{
            prefs.setValue("true", forKey: "sounds")
            soundsSwitch.setOn(true, animated: false)
        }

    }
}
