//
//  Country.swift
//  Day59 - Challenge
//
//  Created by Alperen Çerkez on 27.11.2024.
//

import Foundation

struct Country: Codable {
    let name: CountryName
    let capital: [String]?
    let population: Int
    let region: String
    let subregion: String
    let currencies: [String: Currency]?
    let flags: Flag
    
    struct CountryName: Codable {
        let common: String
    }
    
    struct Currency: Codable {
        let name: String
    }
    
    struct Flag: Codable {
        let png: String
    }
}
