//
//  RequestManager.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 5.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import Foundation
import PKHUD

class RequestManager {
    
    //MARK: - Constants
    static let shared = RequestManager()
    
    //MARK: - Variables
    var delegate: ResponseManagerDelegate?
    var responseManager = ResponseManager()
    
    //MARK: - Instance methods
    private init(){ }
    
    func fetch(url: String, delegate: ResponseManagerDelegate?, responseManager: ResponseManager){
        
        DispatchQueue.main.async {
            HUD.show(.progress)
        }
        
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        self.delegate = delegate
        self.responseManager = responseManager
        self.performRequest(urlString: encodedURL)
        
    }
    
    //MARK: - Util methods
    private func performRequest(urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    
                    if let beerList = self.responseManager.parseJSON(categoryData: safeData, delegate: self.delegate) {
                        
                        self.delegate?.didGetResponse(self.delegate!, beerList)
                        DispatchQueue.main.async {
                            HUD.hide()
                        }
                        
                    }
                    
                }
                
            }
            task.resume()
            
        }
        
    }
    
}
