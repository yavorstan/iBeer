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
    static let defaultImageForBeer = "https://media-public.canva.com/MADGxu2zqjY/4/thumbnail_large.png"
    static let defaultImageForUser = "https://app.helperbit.com/media/avatar/png/single_user_anonymous_256x256.png"
    static let mainURL = "https://api.punkapi.com/v2/"
    static let getBeerById = "https://api.punkapi.com/v2/beers/"
    static let getBeersListPage = "https://api.punkapi.com/v2/beers?page="
    static let beersPerPage = "&per_page=25"
}

struct PopOverConstants {
    static let width = 250
}

struct GoogleSignInConstant {
    static let clientID = "425649820306-0altkl2nfpfit075qjk9m4dm77085as9.apps.googleusercontent.com"
}

struct BeerInfoTextConstants {
    static let ABV = "Alcohol by volume (abbreviated as ABV, abv, or alc/vol) is a standard measure of how much alcohol is contained in a given volume of an alcoholic beverage."
    static let ABVWindowHeight = 85
    static let IBU = "International Bitterness (or 'Bittering') Unit or IBU was invented because it was hard to measure how 'bitter' a beer was, just like it's hard to measure how 'comfortable' your favorite sweater is...it was all about the perception."
    static let IBUWindowsHeight = 130
    static let EBC = "Color Units EBC (European Brewery Convention) refer to the color of a beer measured in a technical manner."
    static let EBCWindownHeight = 70
}

struct PushNotificationsConstants {
    static let title = "iBeer"
    static let body = "Come to take a look at our amazing collection of beers!"
    static let timeInterval = 7
}
