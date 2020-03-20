//
//  BeerDetailsData.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 9.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import Foundation

struct BeerDetailsData: Codable {
    let id: Int
    let name: String
    let tagline: String
    let image_url: String?
    let description: String
    let abv: Double?
    let ibu: Double?
    let ebc: Double?
    
    let ingredients: Ingredients
    
    let food_pairing: [String]
    let brewers_tips: String
    let contributed_by: String
}

struct Ingredients: Codable {
    let malt: [Malt]
    let hops: [Hops]
    let yeast: String
}

struct Malt: Codable {
    let name: String
    let amount: Amount
}

struct Hops: Codable {
    let name: String
    let amount: Amount
    let attribute: String
}

struct Amount: Codable {
    let value: Double
    let unit: String
}
