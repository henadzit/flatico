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
    
    var emptyStringArray : [String] = []
    var latitude = 0.0
    var longitude = 0.0
    
}
