//
//  FirstViewController.swift
//  TrustBoxInNativeApp
//
//  Copyright © 2017 Trustpilot A/S. All rights reserved.
//

import UIKit
import WebKit

class FirstViewController: UIViewController {

    private var trustboxWebView: WKWebView?
    @IBOutlet weak var trustboxView: UIView!
    
    override func loadView() {
        super.loadView()
        
        trustboxWebView = WKWebView(frame: trustboxView.bounds)
        trustboxView.addSubview(trustboxWebView!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let metaTag = String(format:"<meta name=\"viewport\" content=\"width=%f, shrink-to-fit=YES\">", (trustboxWebView?.frame.width)!)

        // The following two variables have been grabbed from the TrustBox library
        // after configuring a TrustBox.
        let trustboxScript = "<!-- TrustBox script -->" +
            "<script type=\"text/javascript\" src=\"https://widget.trustpilot.com/bootstrap/v5/tp.widget.bootstrap.min.js\" async></script>" +
        "<!-- End Trustbox script -->"
        
        let trustboxWidget = "<!-- TrustBox widget - Mini Carousel -->" +
            "<div class=\"trustpilot-widget\" data-locale=\"en-US\" data-template-id=\"539ad0ffdec7e10e686debd7\" data-businessunit-id=\"46d6a890000064000500e0c3\" data-style-height=\"330px\" data-style-width=\"100%\" data-theme=\"light\" data-stars=\"1,2,3,4,5\">" +
            "<a href=\"https://www.trustpilot.com/review/www.trustpilot.com\" target=\"_blank\">Trustpilot</a>" +
            "</div>" +
        "<!-- End TrustBox widget -->"
        
        trustboxWebView?.scrollView.isScrollEnabled = false
        trustboxWebView?.loadHTMLString(metaTag + trustboxScript + trustboxWidget, baseURL: nil)
    }
}
