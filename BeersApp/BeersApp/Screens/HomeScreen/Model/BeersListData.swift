//
//  BeersListData.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 5.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import Foundation

struct BeerListData: Codable {
    let id: Int
    let name: String
    let tagline: String
    let image_url: String?
}
