//
//  Petition.swift
//  Petitions
//
//  Created on 9.10.22.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}

struct Petitions: Codable {
    var results: [Petition]
}
