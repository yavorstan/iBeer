//
//  SessionManager.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 14.04.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import Foundation

class SessionManager {
    
    static let shared = SessionManager()
    private init() {}
    
    var user: User?
    var authType: AuthenticationTypes?
    var timeOfRewardedAdWatch: Date?

    func setCurrentSession(user: User, auth: AuthenticationTypes){
        self.user = user
        self.authType = auth
    }
    
    func deleteCurrentSession() {
        self.user = nil
        self.authType = nil
    }
}
