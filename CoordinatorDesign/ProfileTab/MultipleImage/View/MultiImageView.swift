//
//  MultiImageView.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 26/02/26.
//

import SwiftUI

struct MultiImageView: View {
    @StateObject var model: MultiImageViewModel
    
    var body: some View {
        ZStack {
            if let errorMsg = model.errorMsg {
                Text(errorMsg).foregroundStyle(.red)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: [.init(.adaptive(minimum: 100))]) {
                        ForEach(Array(model.images).enumerated(), id: \.offset) { index, item in
                            if let image = item {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .onTapGesture(perform: {
                                        Task {
                                            await model.selectedImage(image)
                                        }
                                    })
                            } else {
                                ProgressView().frame(width: 100, height: 100)
                            }
                        }
                    }
                }.padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task { [weak model] in
            await model?.downloadAllImages()
        }
    }
}
