//
//  ReviewPageViewController.swift
//  TrustBoxInNativeApp
//
//  Copyright © 2017 Trustpilot A/S. All rights reserved.
//

import UIKit

class ReviewPageViewController : UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private var reviews: [[String: Any]]?
    
    override func viewDidLoad() {
        self.dataSource = self
        self.delegate = self
        
        let api = TrustpilotApi();
        api.getReviews(callback: {(jsonData) -> Void in
            let dictionary = jsonData as? [String: Any]
            self.reviews = dictionary?["reviews"] as? [[String:Any]]
            
            let viewControllers = [self.viewControllerAtIndex(index: 0)!]
            
            DispatchQueue.main.async {
                self.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
            }
        })
    }
    
    func viewControllerAtIndex(index: Int) -> ReviewViewController? {
        if(reviews?.count == 0 || index >= (reviews?.count)!) {
            return nil
        }
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
        let review = reviews?[index]

        viewController.pageIndex = index
        viewController.reviewTitle = review?["title"] as? String
        viewController.reviewText = review?["text"] as? String
        viewController.stars = review?["stars"] as? NSNumber
        
        let consumer = review?["consumer"] as? [String: Any]

        viewController.consumer = consumer?["displayName"] as? String
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        
        if let updatedAt = review?["updatedAt"] as? String {
            viewController.reviewDate = dateFormatter.date(from: updatedAt)
        }
        else {
            let createdAt = review?["createdAt"] as? String
            viewController.reviewDate = dateFormatter.date(from: createdAt!)
        }
        
        return viewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ReviewViewController).pageIndex!

        if index == 0 || index == NSNotFound {
            return nil;
        }

        index -= 1;
        return self.viewControllerAtIndex(index: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ReviewViewController).pageIndex!
        if index == NSNotFound {
            return nil
        }
        index += 1
        
        if index == self.reviews?.count {
            return nil
        }
       
        return self.viewControllerAtIndex(index: index)
    }
}
