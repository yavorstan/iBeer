//
//  ResponseManager.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 5.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import Foundation

protocol ResponseManagerDelegate {
    func didGetResponse(_ responseManager: ResponseManagerDelegate, _ beerList: [BABeerModel])
    func didFailWithError(error: Error)
}

class ResponseManager {
    var delegate: ResponseManagerDelegate?
    
    func parseJSON(categoryData: Data, delegate: ResponseManagerDelegate?) -> [BABeerModel]?{
        /*
         Method must be overriden!
         */
        return nil
    }
}
