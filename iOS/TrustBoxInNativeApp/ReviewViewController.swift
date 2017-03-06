//
//  ReviewViewController.swift
//  TrustBoxInNativeApp
//
//  Copyright © 2017 Trustpilot A/S. All rights reserved.
//

import UIKit

class ReviewViewController : UIViewController {
    var reviewTitle: String?
    var reviewText: String?
    var stars: NSNumber?
    var consumer: String?
    var reviewDate: Date?
    var pageIndex: Int?
    
    @IBOutlet weak var reviewTitleLabel: UILabel!
    @IBOutlet weak var reviewTextLabel: UILabel!
    @IBOutlet weak var starsImage: UIImageView!
    @IBOutlet weak var consumerNameLabel: UILabel!

    override func viewDidLoad() {
        reviewTitleLabel.text = self.reviewTitle
        reviewTextLabel.text = self.reviewText
        reviewTextLabel.sizeToFit()
        starsImage.image = UIImage(named: "\(stars!.stringValue)-stars")
        consumerNameLabel.text = consumer
    }
}
