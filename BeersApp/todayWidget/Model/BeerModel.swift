//
//  BeerModel.swift
//  todayWidget
//
//  Created by Yavor Stanoev on 22.04.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import Foundation

struct BeerModel: Decodable {
    let id: Int
    let name: String
    let tagline: String
    let image_url: String
}
