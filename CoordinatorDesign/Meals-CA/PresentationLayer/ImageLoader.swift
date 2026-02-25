//
//  ImageLoader.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 03/02/26.
//

import Foundation
import SwiftUI
import Combine

final class MealImageCache {
    static let shared = NSCache<NSString, UIImage>()
}

@MainActor
final class ImageLoader: ObservableObject {

    @Published var image: UIImage?

    func load(from urlString: String) async {
        let key = NSString(string: urlString)

        if let cached = MealImageCache.shared.object(forKey: key) {
            image = cached
            return
        }

        guard let url = URL(string: urlString) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let img = UIImage(data: data) {
                MealImageCache.shared.setObject(img, forKey: key)
                image = img
            }
        } catch {
            print("Image load failed")
        }
    }
}
