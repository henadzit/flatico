//
//  QueryModel.swift
//  Flatico
//
//  Created by Anthony Marchenko on 3/11/18.
//  Copyright © 2018 Anthony Marchenko. All rights reserved.
//

import Foundation

// MARK: - Singleton

final class QueryModel {
    
    // Can't init is singleton
    private init() { }
    
    // MARK: Shared Instance
    
    static let shared = QueryModel()
    
    // MARK: Local Variable
    
    var latitude = 0.0
    var longitude = 0.0
    var roomCount = 1
    var floor = 1
    var isBalconExist = true
    var totalSquere = 42
    
    func resetToDefault() {
        self.latitude = 0.0
        self.longitude = 0.0
        self.roomCount = 1
        self.floor = 1
        self.isBalconExist = true
        self.totalSquere = 42
    }
    
}
