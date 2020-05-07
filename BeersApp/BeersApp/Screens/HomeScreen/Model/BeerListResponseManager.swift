//
//  BeerListResponseManager.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 9.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import Foundation


class BeerListResponseManager: ResponseManager {
    
    override func parseJSON(categoryData: Data, delegate: ResponseManagerDelegate?) -> [BABeerModel]?{
        self.delegate = delegate
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode([BeerListData].self, from: categoryData)
            var beerListModel = [BeersListModel]()
            
            for beer in decodedData {
                beerListModel.append(BeersListModel(id: beer.id, name: beer.name, tagLine: beer.tagline, image_url: beer.image_url ?? ""))
            }
            
            return beerListModel
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
