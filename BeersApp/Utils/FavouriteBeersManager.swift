//
//  FavouriteBeersManager.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 25.04.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import Foundation
import PKHUD

class FavouriteBeersManager {
    
    static let shared = FavouriteBeersManager()
    private init(){}
    
    func manageBeer(beer: BeersListModel){
        if isFavourite(beer: beer) {
            self.removeBeerFromFavourites(beer: beer)
        } else {
            self.saveBeerToFavourites(beer: beer)
        }
    }
    
    //Add beer to favourites
    private func saveBeerToFavourites(beer: BeersListModel) {
        var favouriteBeersArray = self.getFavouriteBeersArray()!
        if favouriteBeersArray.count < FavouriteBeersConstants.maxBeersInFavourites {
            favouriteBeersArray.append(beer)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(favouriteBeersArray), forKey: UserDefaultsKeys.favouriteBeersArray.rawValue)
            
            self.saveBeerToWidget(beer: beer)
            
            HUD.flash(.success, delay: 0.5)
        } else {
            HUD.flash(.label(NSLocalizedString("str_max_fav_beers", comment: "")), delay: 1)
            return
        }
    }
    
    //Save beer for widget
    private func saveBeerToWidget(beer: BeersListModel) {
        if let data = UserDefaults(suiteName: GroupIdentifier.identifier)?.value(forKey: "widget") as? Data {
            var widgetData = try! PropertyListDecoder().decode([BeersListModel].self, from: data)
            
            widgetData.append(beer)
            UserDefaults(suiteName: GroupIdentifier.identifier)?.set(try? PropertyListEncoder().encode(widgetData), forKey: "widget")
        }
    }
    
    //Remove beer from favourites
    private func removeBeerFromFavourites(beer: BeersListModel) {
        var favouriteBeersArray = self.getFavouriteBeersArray()
        if (favouriteBeersArray?.contains(beer))! {
            let index = favouriteBeersArray!.firstIndex(of: beer)
            favouriteBeersArray!.remove(at: index!)
            
            self.removeBeerFromWidget(beer: beer)
            
            HUD.flash(.label(NSLocalizedString("str_beer_removed_from_fav", comment: "")), delay: 0.8)
        }
        UserDefaults.standard.set(try? PropertyListEncoder().encode(favouriteBeersArray), forKey: UserDefaultsKeys.favouriteBeersArray.rawValue)
    }
    
    //Delete beer from widget
    private func removeBeerFromWidget(beer: BeersListModel) {
        if let data = UserDefaults(suiteName: GroupIdentifier.identifier)?.value(forKey: "widget") as? Data {
            var widgetData = try! PropertyListDecoder().decode([BeersListModel].self, from: data)
            let index = widgetData.firstIndex(of: beer)!
            widgetData.remove(at: index)
            
            UserDefaults(suiteName: GroupIdentifier.identifier)?.set(try? PropertyListEncoder().encode(widgetData), forKey: "widget")
        }
    }
    
    func getFavouriteBeersArray() -> [BeersListModel]? {
        var beerData: [BeersListModel]
        if let data = UserDefaults.standard.value(forKey: UserDefaultsKeys.favouriteBeersArray.rawValue) as? Data {
            beerData = try! PropertyListDecoder().decode([BeersListModel].self, from: data)
            return beerData
        } else {
            return nil
        }
    }
    
    func checkIfFavourite(beerID: Int) -> Bool {
        if self.getFavouriteBeersArray() == nil || self.getFavouriteBeersArray()!.isEmpty {
            return false
        }
        let favouriteBeersArray = self.getFavouriteBeersArray()!
        for beer in favouriteBeersArray {
            if beer.id == beerID {
                return true
            }
        }
        return false
    }
    
    private func isFavourite(beer: BeersListModel) -> Bool {
        let favouriteBeersArray = self.getFavouriteBeersArray()
        return (favouriteBeersArray?.contains(beer))!
    }
    
}
