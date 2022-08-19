//
//  UserSingleton.swift
//  SnapchatClone
//
//  Created by Mustafa Göktuğ İbolar on 10.08.2022.
//

import Foundation

class UserSingleton {
    
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    
    private init() {
        
    }
    
    
}

