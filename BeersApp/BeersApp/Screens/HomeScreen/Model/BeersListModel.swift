//
//  BeersListModel.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 5.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import Foundation

struct BeersListModel: BABeerModel, Equatable, Codable {
    
    let id: Int
    let name: String
    let tagLine: String
    let image_url: String
    
    static func ==(lhs: BeersListModel, rhs: BeersListModel) -> Bool {
        return lhs.id == rhs.id
    }
}
