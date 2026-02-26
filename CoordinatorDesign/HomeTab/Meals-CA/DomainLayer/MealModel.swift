//
//  MealModel.swift
//  TestAPI
//
//  Created by Thirumalai Ganesh G on 27/01/26.
//

import Foundation

struct MealResponse: Codable {
    let meals: [Meals]
}

struct Meals: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let imageurl: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case imageurl = "strMealThumb"
    }
}

struct MealDetailResponse: Decodable {
    let meals: [MealDetail]
}

//struct MealDetail1: Codable {
//    let id: String?
//    let name: String?
//    let category: String?
//    let instructions: String?
//    let imageurl: String?
//    let tags: String?
//    let youtubeurl: String?
//    let sourceurl: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id = "idMeal"
//        case name = "strMeal"
//        case category = "strCategory"
//        case instructions = "strInstructions"
//        case imageurl = "strMealThumb"
//        case tags = "strTags"
//        case youtubeurl = "strYoutube"
//        case sourceurl = "strSource"
//    }
//}

struct MealDetail: Decodable, Identifiable {
    let id: String
    let name: String
    let category: String
    let area: String
    let instructions: String
    let thumbnail: String
    let youtube: String?
    let ingredients: [Ingredient]

    enum CodingKeys: String, CodingKey {
        case idMeal
        case strMeal
        case strCategory
        case strArea
        case strInstructions
        case strMealThumb
        case strYoutube

        // Ingredients
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5
        case strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10
        case strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15
        case strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20

        // Measures
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5
        case strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10
        case strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15
        case strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .idMeal)
        name = try container.decode(String.self, forKey: .strMeal)
        category = try container.decode(String.self, forKey: .strCategory)
        area = try container.decode(String.self, forKey: .strArea)
        instructions = try container.decode(String.self, forKey: .strInstructions)
        thumbnail = try container.decode(String.self, forKey: .strMealThumb)
        youtube = try container.decodeIfPresent(String.self, forKey: .strYoutube)

        var tempIngredients: [Ingredient] = []

        for index in 1...20 {
            let ingredientKey = CodingKeys(rawValue: "strIngredient\(index)")!
            let measureKey = CodingKeys(rawValue: "strMeasure\(index)")!

            let ingredient = try container.decodeIfPresent(String.self, forKey: ingredientKey)?
                .trimmingCharacters(in: .whitespacesAndNewlines)

            let measure = try container.decodeIfPresent(String.self, forKey: measureKey)?
                .trimmingCharacters(in: .whitespacesAndNewlines)

            if let ingredient, !ingredient.isEmpty {
                tempIngredients.append(
                    Ingredient(
                        name: ingredient,
                        measure: measure ?? ""
                    )
                )
            }
        }

        ingredients = tempIngredients
    }
}

struct Ingredient: Identifiable {
    let id = UUID()
    let name: String
    let measure: String
}
