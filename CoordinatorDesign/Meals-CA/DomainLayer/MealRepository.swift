//
//  MealRepository.swift
//  TestAPI
//
//  Created by Thirumalai Ganesh G on 27/01/26.
//

import Foundation

protocol MealRepository {
    func getMeals(category: String) async throws -> [Meals]
}

protocol MealDetailRepository {
    func getMealDetails(id: String) async throws -> [MealDetail]
}
