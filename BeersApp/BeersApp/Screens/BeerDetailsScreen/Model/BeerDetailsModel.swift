//
//  BeerDetailsModel.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 9.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import Foundation

struct BeerDetailsModel: BABeerModel {
    
    let id: Int
    let name: String
    let tagLine: String
    let image_url: String?
    let description: String
    let firstBrewed: String
    let foodPairing: [String]
    let brewingTips: String
    let contributedBy: String
    
    let abv: Double
    let ibu: Double
    let ebc: Double
    
    let malt: [Malt]
    let hops: [Hops]
    let yeast: String
}
