//
//  Constants.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 4.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

struct LabelConstants {
    static let appTitle = "iBeer"
}

struct BALogoConstants {
    static let cornerRadius = 15
    static let animationDuration = 0.6
    static let startingConstraintConstant = -500
    static let finishConstraintConstant = 80
}

struct BAButtonConstants {
    static let cornerRadius = 15
    static let shadowOpacity = 0.6
    static let shadowRadius = 0
}

struct BAImageConstants {
    static let cornerRadius = 15
    static let borderWidth = 5
}

struct BAAvatarConstants {
    static let borderWidth = 7.0
    static let shadowOpacity = 0.6
    static let shadowRadius = 5
}

struct SegueConstants {
    static let goToHome = "goToHome"
    static let goToBeerDetails = "goToBeerDetails"
    static let goToFilterScreen = "goToFilterScreen"
    static let goToLogin = "goToLogin"
    static let goToRegister = "goToRegister"
}

struct CellConstants {
    static let BeersListCell = "BeersListCell"
    static let BeerDetailsCell = "BeerDetailsCell"
}

struct CarouselConstants {
    static let CarouselCell = "CarouselCell"
    static let width = 240
    static let height = 380
    static let cornerRadius = 35
    static let borderWidth = 7.5
}

struct BeerDetailsConstants {
    static let imageHeight = 190
    static let imageWidth = 150
}

struct URLConstants {
    static let defaultImageForUser = "https://app.helperbit.com/media/avatar/png/single_user_anonymous_256x256.png"
    static let punkAPI = "https://api.punkapi.com/v2/"
    static let testAPI = "https://d9e554f2.ngrok.io/v2/"
    static let testAPIAuthenticate = "https://d9e554f2.ngrok.io/authenticate/google?idToken="
    static let mainURL = URLConstants.punkAPI
    static let getBeerById = "\(URLConstants.mainURL)beers/"
    static let getBeersListPage = "\(URLConstants.mainURL)beers?page="
    static var beersByPage = UserDefaults.standard.getBeersPerPage()!
    static var withPages = "&per_page=\(URLConstants.beersByPage)&"
    static let beerByName = "\(URLConstants.mainURL)beers?beer_name="
}

struct PopOverConstants {
    static let width = 250
}

struct FiltersViewConstants {
    static let animationDuration = 0.6
    static let animationDelay = 0.1
}

struct SettingsScrollViewConstants {
    static let noAdsHeight = CGFloat(630)
    static let onlyWatchAdButtonHeight = CGFloat(720)
    static let adSettingsHeight = CGFloat(790)
    
    static let watchAdvertViewHeight = CGFloat(80)
    static let allowSettingsViewTopConstraint = CGFloat(15)
}

struct GoogleSignInConstant {
    static let clientID = "425649820306-0altkl2nfpfit075qjk9m4dm77085as9.apps.googleusercontent.com"
}

struct BeerInfoTextConstants {
    static let ABV = NSLocalizedString("abv", comment: "")
    static let ABVWindowHeight = 90
    static let IBU = NSLocalizedString("ibu", comment: "")
    static let IBUWindowsHeight = 135
    static let EBC = NSLocalizedString("ebc", comment: "")
    static let EBCWindownHeight = 75
}

struct PushNotificationsConstants {
    static let title = "iBeer"
    static let body = "Come to take a look at our amazing collection of beers!"
    static let timeInterval = 7
}

struct ImagesNamesConstants {
    static let chevronUp = "chevron.up.circle"
    static let chevronDown = "chevron.down.circle"
    static let randomButtom = "wand.and.stars.inverse"
    static let filtersButton = "line.horizontal.3.decrease.circle"
    
    static let descriptionIcon = "pencil.and.ellipsis.rectangle"
}

struct BeerDetailsIcons {
    static let date = "pencil.and.ellipsis.rectangle"
}

struct SegmentedControlConstants {
    static let favouritesTableStyle = 0
    static let favouritesCarouselStyle = 1
    
    static let randomBeerFromAllBeers = 0
    static let randomBeerFromFavorites = 1
    
    static let tenBeersPerPage = 0
    static let twentyFiveBeersPerPage = 1
    static let fiftyBeersPerPage = 2
    
    static let englishLanguage = 0
    static let bulgarianLanguage = 1
    static let arabicLanguage = 2
    
}

struct CarouselCellSize {
    static let iPhoneSize = CGSize(width: 243, height: 377)
    static let iPadSize = CGSize(width: 443, height: 577)
}

struct AdvertsConstants {
    static let bannerAdUnitID = "ca-app-pub-3940256099942544/2934735716"
    static let rewaredAdUnitID = "ca-app-pub-3940256099942544/1712485313"
    
    static let timeIntervalForRewardedAd = 100.0 //in seconds
}

struct GroupIdentifier {
    static let identifier = "group.org.BeersApp"
}

struct FavouriteBeersConstants {
    static let maxBeersInFavourites = 15
}
