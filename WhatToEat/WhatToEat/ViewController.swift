//
//  ViewController.swift
//  WhatToEat
//
//  Created by Will Hodges on 3/20/16.
//  Copyright © 2016 Will T. Hodges. All rights reserved.
//

import UIKit
import iAd
import AVFoundation

var audioPlayer = AVAudioPlayer()

class ViewController: UIViewController, ADBannerViewDelegate {
    
    var bannerView = ADBannerView()
    
    @IBOutlet weak var spinWheel: UIImageView!
    let recognizer = UITapGestureRecognizer()
    
    func playFile(_ theFile: String, theType: String) {
        let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: theFile, ofType: theType)!)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        }
        var error:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: alertSound)
        } catch var error1 as NSError {
            error = error1
            //audioPlayer = nil
        }
        audioPlayer.play()
        
    }
    
    
    override func viewDidLoad() {
        UIViewController.prepareInterstitialAds()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Spin!"
        
        spinWheel.image = UIImage(named: "Wheel.tiff");
        spinWheel.isUserInteractionEnabled = true
        
        recognizer.addTarget(self, action: #selector(ViewController.spinWheelHasBeenTapped))
        spinWheel.addGestureRecognizer(recognizer)
        
        if let _ = prefs.string(forKey: "city"){
            // Do nothing
        }
        else{
            prefs.setValue("Savannah, Ga", forKey: "city")
        }
        
        loadAds()
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
    
    override func viewWillAppear(_ animated: Bool) {
        // View is about to be obscured by an advert.
        // Pause activities if necessary
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Advert has been dismissed. Resume paused activities
    }


    
    func spinWheelHasBeenTapped() {
        
        if let sounds = prefs.string(forKey: "sounds") {
            if (sounds == "true") {
                playFile("SpinWheel", theType: "mp3")
                spinWheel.rotate360Degrees(4)
            }
            else {
                spinWheel.rotate360Degrees(4)
            }
        }
        else {
            playFile("SpinWheel", theType: "mp3")
            spinWheel.rotate360Degrees(4)
        }

        
        let seconds = 4.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            
             self.performSegue(withIdentifier: "showResults", sender: nil)
            
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        destination.interstitialPresentationPolicy = ADInterstitialPresentationPolicy.automatic
    }

}

extension UIView {
    func rotate360Degrees(_ duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = 30.0//CGFloat(M_PI)
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate as! CAAnimationDelegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
}

