//
//  CachedImage.swift
//  Pasikudhey
//
//  Created by Thirumalai Ganesh G on 16/02/26.
//

import SwiftUI

struct CachedImage: View {
    @StateObject private var loader: CacheImageLoader
    
    init(url: URL) {
        _loader = StateObject(wrappedValue: CacheImageLoader(url: url))
    }
    
    var body: some View {
        ZStack {
            Group {
                if let image = loader.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    ProgressView()
                }
            }
        }
        .task { [weak loader] in
            await loader?.load()
        }
    }
}
