//
//  TodayViewController.swift
//  todayWidget
//
//  Created by Yavor Stanoev on 22.04.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit
import NotificationCenter
import Alamofire

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var imageView: BADownloadImageViewWithBorder!
    @IBOutlet weak var beerName: BALabel!
    @IBOutlet weak var beerTagLine: BALabel!
    
    var beerModel: [BeerModel]?
    
    @IBOutlet weak var noFavBeersLabel: BALabel!
    
    @IBOutlet var favouriteBeersViews: [TodayWidgetFavouriteCell]!
    
    var beersArray = [BeersListModel]()
    
    //MARK: Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let data = UserDefaults(suiteName: WidgetGroupIdentifier.identifier)?.value(forKey: "widget") as? Data {
            beersArray = try! PropertyListDecoder().decode([BeersListModel].self, from: data)
        }
        
        let size = beersArray.count <= WidgetConstants.maxBeersInWidget ? beersArray.count : WidgetConstants.maxBeersInWidget
        
        for view in favouriteBeersViews {
            view.isHidden = true
        }
        
        if size != 0 {
            self.noFavBeersLabel.isHidden = true
            for i in 0...size-1 {
                for view in favouriteBeersViews {
                    if view.tag == i {
                        view.beerNameLabel.text = beersArray[i].name
                        
                        let url = URL(string: beersArray[i].image_url)
                        view.beerImageView.populateImage(withURL: url)
                        
                        view.favBeerButtonAction = { () -> Void in
                            
                            let id = self.beersArray[i].id
                            
                            UserDefaults(suiteName: WidgetGroupIdentifier.identifier)?.set(id, forKey: "id")
                            
                            if let url = URL(string: "open://") {
                                self.extensionContext?.open(url, completionHandler: nil)
                            }
                        }
                        
                        view.isHidden = false
                    }
                }
            }
        } else {
            self.noFavBeersLabel.isHidden = false
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noFavBeersLabel.font = UIFont.defaultTitleFont.font
        noFavBeersLabel.text = NSLocalizedString("str_no_fav_beers", comment: "")
        
        beerName.font = UIFont.defaultTitleFont.font
        beerTagLine.font = UIFont.defaultDescriptionFont.font
        
        self.getRandomBeer()
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 260) : maxSize
    }
    
    //MARK: Button Actions
    
    @IBAction func randomBeerButtonPressed(_ sender: UIButton) {
        print(self.beerModel![0].id)
        
        let id = self.beerModel![0].id
        
        UserDefaults(suiteName: WidgetGroupIdentifier.identifier)?.set(id, forKey: "id")
        
        if let url = URL(string: "open://\(sender.tag)") {
            self.extensionContext?.open(url, completionHandler: nil)
        }
    }
    
    //MARK: Util Methods
    //request random beer
    private func getRandomBeer() {
        AF.request(WidgetURLConstants.randomURL, method: .get).validate().responseDecodable(of: [BeerModel].self) { response in
            
            switch response.result {
            case let .failure(error):
                print(error)
                self.getRandomBeer()
            default:
                self.beerModel = response.value
                let beer = self.beerModel![0]
                
                self.beerName.text = beer.name
                self.beerName.isHidden = false
                
                self.beerTagLine.text = beer.tagline
                self.beerTagLine.isHidden = false
                
                let stringURL = beer.image_url
                let url = URL(string: stringURL)
                self.imageView.populateImage(withURL: url)
                //doesn't stop the indicator
                self.imageView.activityIndicator.isHidden = true
            }
        }
    }
    
}
