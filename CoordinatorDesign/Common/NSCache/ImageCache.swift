//
//  ImageCache.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 02/02/26.
//

import Foundation
import SwiftUI

final class ImageCache {
    private let cache = NSCache<NSURL, UIImage>()

    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    func store(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}


