//
//  SecondViewController.swift
//  TrustBoxInNativeApp
//
//  Copyright © 2017 Trustpilot A/S. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
   
    @IBOutlet weak var starsImage: UIImageView!
    @IBOutlet weak var trustscoreLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let api = TrustpilotApi();
        api.getBusinessUnit(callback: {(jsonData) -> Void in
            if let dictionary = jsonData as? [String: Any] {
                
                let stars = dictionary["stars"] as! NSNumber
                let trustScore = dictionary["trustScore"] as! NSNumber
                
                let numberOfReviews = dictionary["numberOfReviews"] as! [String: Any]
                let totalReviews = numberOfReviews["total"] as! NSNumber
                
                
                DispatchQueue.main.async {
                    self.updateView(stars: stars.stringValue, trustScore: trustScore.stringValue, totalReviews: totalReviews.stringValue)
                }
            }
        })
    }
    
    func updateView(stars: String, trustScore: String, totalReviews: String) {
        starsImage.image = UIImage(named: stars + "-stars")
        
        let regular = [NSFontAttributeName: UIFont.systemFont(ofSize: 10)]
        let bold = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 10)]
        
        let labelText = NSMutableAttributedString(string: "TRUSTSCORE ", attributes: regular)
        
        labelText.append(NSAttributedString(string: trustScore, attributes: bold))
        labelText.append(NSAttributedString(string: "  |  ", attributes: regular))
        labelText.append(NSAttributedString(string: totalReviews, attributes: bold))
        labelText.append(NSAttributedString(string: " REVIEWS", attributes: regular))

        trustscoreLabel.textColor = UIColor.gray
        trustscoreLabel.textAlignment = NSTextAlignment.center
        trustscoreLabel.attributedText = labelText
        
        self.view.setNeedsDisplay()
        self.view.setNeedsLayout()
    }
}

