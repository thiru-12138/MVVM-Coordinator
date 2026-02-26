//
//  ObjectModel.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 31/01/26.
//

import Foundation

struct User: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let email: String
}

struct Post: Decodable, Identifiable, Hashable {
    let id: Int
    let title: String
    let body: String
}
