//
//  UserDefaults+SaveUserData.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 10.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import Foundation
import PKHUD

extension UserDefaults {
    
    //MARK: Save User Data
    func saveUserInPhoneMemory(user: User){
        set(user.idToken, forKey: UserDefaultsKeys.idToken.rawValue)
        set(user.firstName, forKey: UserDefaultsKeys.firstName.rawValue)
        set(user.lastName, forKey: UserDefaultsKeys.lastName.rawValue)
        set(user.fullName, forKey: UserDefaultsKeys.fullName.rawValue)
        set(user.email, forKey: UserDefaultsKeys.email.rawValue)
        set(user.profilePicture, forKey: UserDefaultsKeys.profilePicture.rawValue)
    }
    
    //MARK: Retrieve User Data
    func getUserFromPhoneMemory() -> User{
        let user = User(
            idToken: self.string(forKey: UserDefaultsKeys.idToken.rawValue)!,
            firstName: self.string(forKey: UserDefaultsKeys.firstName.rawValue)!,
            lastName: self.string(forKey: UserDefaultsKeys.lastName.rawValue)!,
            fullName: self.string(forKey: UserDefaultsKeys.fullName.rawValue)!,
            email: self.string(forKey: UserDefaultsKeys.email.rawValue)!,
            profilePicture: self.url(forKey: UserDefaultsKeys.profilePicture.rawValue)!
        )
        return user
    }
    
    //MARK: Theme Mode
    func saveThemeModeToPhoneMemory(isDark: Bool) {
        set(isDark, forKey: UserDefaultsKeys.currentTheme.rawValue)
    }
    func isDarkTheme() -> Bool {
        return self.bool(forKey: UserDefaultsKeys.currentTheme.rawValue)
    }
    
    //MARK: FavorutiesViewStyle
    func saveFavouritesStyleToPhoneMemory(isCarousel: Bool) {
        set(isCarousel, forKey: UserDefaultsKeys.favouritesStyle.rawValue)
    }
    func isCarouselStyle() -> Bool {
        return self.bool(forKey: UserDefaultsKeys.favouritesStyle.rawValue)
    }
    
    //MARK: Notifications
    func saveNotificationsMode(enabled: Bool) {
        set(enabled, forKey: UserDefaultsKeys.notifications.rawValue)
    }
    func notificationsAreEnabled() -> Bool {
        return self.bool(forKey: UserDefaultsKeys.notifications.rawValue)
    }
    
    //MARK: Favourite Beers
    func manageBeer(beer: BeersListModel){
        if isFavourite(beer: beer) {
            UserDefaults.standard.removeBeerFromFavourites(beer: beer)
        } else {
            UserDefaults.standard.saveBeerToFavourites(beer: beer)
        }
    }
    private func saveBeerToFavourites(beer: BeersListModel) {
        if self.getFavouriteBeersArray() == nil {
            set(try? PropertyListEncoder().encode([BeersListModel]()), forKey: UserDefaultsKeys.favouriteBeersArray.rawValue)
        }
        var favouriteBeersArray = self.getFavouriteBeersArray()!
        if favouriteBeersArray.count < 15 {
            favouriteBeersArray.append(beer)
            set(try? PropertyListEncoder().encode(favouriteBeersArray), forKey: UserDefaultsKeys.favouriteBeersArray.rawValue)
            HUD.flash(.success, delay: 0.5)
        } else {
            HUD.flash(.label("Max 15 beers in favourites!"), delay: 1)
            return
        }
    }
    private func removeBeerFromFavourites(beer: BeersListModel) {
        var favouriteBeersArray = self.getFavouriteBeersArray()
        if (favouriteBeersArray?.contains(beer))! {
            let index = favouriteBeersArray!.firstIndex(of: beer)
            favouriteBeersArray!.remove(at: index!)
            HUD.flash(.label("Removed from Favourites"), delay: 0.8)
        }
        set(try? PropertyListEncoder().encode(favouriteBeersArray), forKey: UserDefaultsKeys.favouriteBeersArray.rawValue)
    }
    func getFavouriteBeersArray() -> [BeersListModel]? {
        var beerData: [BeersListModel]
        if let data = value(forKey: UserDefaultsKeys.favouriteBeersArray.rawValue) as? Data {
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

private enum UserDefaultsKeys : String {
    case idToken
    case firstName
    case lastName
    case fullName
    case email
    case profilePicture
    
    case currentTheme
    
    case favouritesStyle
    
    case notifications
    
    case favouriteBeersArray
}
