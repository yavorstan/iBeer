//
//  UserSessionManager.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 14.04.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import Foundation

class UserSessionManager {
    
    //MARK: - Constants
    static let shared = UserSessionManager()
    
    //MARK: - Variables
    var user: UserModel?
    var authType: AuthenticationTypes?
    var timeOfRewardedAdWatch: Date?
    
    //MARK: - Instance methods
    private init() {}

    func setCurrentSession(user: UserModel, auth: AuthenticationTypes){
        self.user = user
        self.authType = auth
    }
    
    func deleteCurrentSession() {
        self.user = nil
        self.authType = nil
    }
    
}
