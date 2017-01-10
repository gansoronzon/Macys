//
//  ViewController.swift
//  Macy
//
//  Created by Gansoronzon on 1/9/17.
//  Copyright © 2017 Optima Global Solution Inc. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var searchController    : UISearchController!
    var acronym             : Acronym!
    var acronymViews        = [UIView]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.searchController = UISearchController(searchResultsController:  nil)
        
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        
        self.navigationItem.titleView = searchController.searchBar
        
        self.definesPresentationContext = true
        
//        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: 3000)
//        scrollView.backgroundColor = UIColor.gray
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        MBProgressHUD.showAdded(to: searchController.view, animated: true)
        if searchBar.text != nil {
            loadMeanings(str: searchBar.text!)
        }
        searchController.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMeanings(str: String) {
        
        let url                     = URL(string: "http://www.nactem.ac.uk/software/acromine/dictionary.py")
        let parameters : Parameters = ["sf": str]
        
        Alamofire.request(url!,
                          method: .get,
                          parameters: parameters,
                          encoding: URLEncoding.default).responseJSON { (response) in
                            if let json = response.result.value {
                                self.acronym = Acronym(json: JSON(json))
                                DispatchQueue.main.async {
                                    MBProgressHUD.hide(for: self.searchController.view, animated: true)
                                    self.searchController.dismiss(animated: true, completion: nil)
                                    self.updateContentView()
                                }
                                
                            } else {
                                //failure
                                let alertController = UIAlertController(title: "Error",
                                                                        message: "Failed to load",
                                                                        preferredStyle: .alert)
                                let action = UIAlertAction(title: "OK",
                                                           style: .cancel,
                                                           handler: nil)
                                alertController.addAction(action)
                                self.present(alertController, animated: true, completion: nil)
                            }
        }
    }
    
    func updateContentView() {
        
        //Remove views added previously
        for aView in acronymViews {
            aView.removeFromSuperview()
        }
        
        //Initial y position for adding views for meanings
        var posY = 5
        var hasBgColor = false
    
        
        for str in acronym.lfStrings {
            
            let aLabel = UILabel(frame: CGRect(x: 10, y: 5, width: Int(self.view.frame.width) - 20, height: 0))
            aLabel.font = UIFont(name: "HelveticaNeue", size: 22)
            aLabel.text = str
            aLabel.numberOfLines = 0
            aLabel.textColor = UIColor.darkGray
            
            //Resizing label height depending on size of the text
            
            let aLabelSize = (aLabel.text)?.boundingRect(
                with: CGSize(width: self.view.frame.width - 20, height: CGFloat.infinity),
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: [NSFontAttributeName: aLabel.font],
                context: nil).size
            
            aLabel.frame = CGRect(x: 10, y: 5, width: Int(self.view.frame.width) - 20, height: Int((aLabelSize?.height)!) + 10)
            
            let aView = UIView(frame: CGRect(x: 0,
                                             y: posY,
                                             width: Int(self.view.frame.width),
                                             height: Int((aLabelSize?.height)! + 20)))
            
            //Alternating background color
            
            if hasBgColor {
                aView.backgroundColor = SWColor(hexString: "e70c00", alpha: 0.15)
                hasBgColor = false
            } else {
                hasBgColor = true
            }

            
            aView.addSubview(aLabel)
            
            self.scrollView.addSubview(aView)
            
            acronymViews.append(aView)
            
            posY += Int(aView.frame.height)
            
            scrollView.contentSize = CGSize(width: Int(self.view.frame.width), height: posY)
        }
    }
}


