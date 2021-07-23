//
//  BeerDetailsResponseManager.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 9.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import Foundation

class BeerDetailsResponseManager: ResponseManager {
    
    override func parseJSON(categoryData: Data, delegate: ResponseManagerDelegate?) -> [BABeerModel]?{
        
        self.delegate = delegate
        let decoder = JSONDecoder()
        do{
            
            let decodedData = try decoder.decode([BeerDetailsData].self, from: categoryData)
            var beerListModel = [BeerDetailsModel]()
            
            for beer in decodedData {
                
                beerListModel.append(BeerDetailsModel(id: beer.id, name: beer.name, tagLine: beer.tagline, image_url: beer.image_url ?? "", description: beer.description, firstBrewed: beer.first_brewed, foodPairing: beer.food_pairing, brewingTips: beer.brewers_tips, contributedBy: beer.contributed_by, abv: beer.abv ?? -1, ibu: beer.ibu ?? -1, ebc: beer.ebc ?? -1, malt: beer.ingredients.malt, hops: beer.ingredients.hops, yeast: beer.ingredients.yeast ?? "n/a"))
                
            }
            
            return beerListModel
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
}
