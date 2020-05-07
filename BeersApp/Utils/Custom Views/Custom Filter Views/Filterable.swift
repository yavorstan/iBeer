//
//  BAFiltersProtocol.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 24.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import Foundation

@objc protocol Filterable {
    func setFilterDescriptionName(to name: String)
    func hasFilter() -> Bool
    func getTextFieldInputForURL() -> String
    func clearFilter()
}
