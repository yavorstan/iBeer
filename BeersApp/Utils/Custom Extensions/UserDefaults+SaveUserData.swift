//
//  UserDefaults+SaveUserData.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 10.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    //MARK: Check if App is launched for the first time on this device
    func isFirstLaunch() -> Bool {
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasBeenLaunchedBefore.rawValue)
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.hasBeenLaunchedBefore.rawValue)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
    
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
    func hasUserInPhoneMemory() -> Bool {
        if self.string(forKey: UserDefaultsKeys.idToken.rawValue) == nil {
            return false
        }
        return true
    }
    func deleteUserFromPhoneMemory() {
        set(nil, forKey: UserDefaultsKeys.idToken.rawValue)
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
    
    //MARK: Random Beer
    func saveRandomBeerSetting(fromFavourites: Bool) {
        set(fromFavourites, forKey: UserDefaultsKeys.randomBeer.rawValue)
    }
    func randomBeerIsFromFavourites() -> Bool {
        if FavouriteBeersManager.shared.getFavouriteBeersArray()!.isEmpty {
            return false
        }
        return self.bool(forKey: UserDefaultsKeys.randomBeer.rawValue)
    }
    
    //MARK: Beers Per Page
    func saveBeersPerPage(amount: Int) {
        self.set(amount, forKey: UserDefaultsKeys.beersPerPage.rawValue)
    }
    func getBeersPerPage() -> Int? {
        self.integer(forKey: UserDefaultsKeys.beersPerPage.rawValue)
    }
    
    //MARK: Langauge Change
    func saveIfLanguageChange(isChanged: Bool) {
        self.set(isChanged, forKey: UserDefaultsKeys.isLanguageChanged.rawValue)
    }
    func isLanguageChanged() -> Bool {
        self.bool(forKey: UserDefaultsKeys.isLanguageChanged.rawValue)
    }
    
    //MARK: Adverts Settings
    func saveIfAdvertsAreAllowed(_ areAllowed: Bool) {
        self.set(areAllowed, forKey: UserDefaultsKeys.adverts.rawValue)
    }
    func areAdvertsAllowed() -> Bool {
        return self.bool(forKey: UserDefaultsKeys.adverts.rawValue)
    }
    
    //MARK: Time
    func saveDateOfAdTimerStart(date: Date) {
        self.set(date, forKey: UserDefaultsKeys.time.rawValue)
    }
    func getDateOfAdTimerStart() -> Date {
        return self.object(forKey: UserDefaultsKeys.time.rawValue) as! Date
    }
    
    func saveIfHasTimerForAd(_ hasTimer: Bool) {
        self.set(hasTimer, forKey: UserDefaultsKeys.hasTimer.rawValue)
    }
    func hasTimerForAd() -> Bool {
        return self.bool(forKey: UserDefaultsKeys.hasTimer.rawValue)
    }
}

enum UserDefaultsKeys : String {
    case hasBeenLaunchedBefore
    
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
    
    case randomBeer
    
    case beersPerPage
    
    case isLanguageChanged
    
    case adverts
    
    case time
    
    case hasTimer
    
    case appKilled
}
