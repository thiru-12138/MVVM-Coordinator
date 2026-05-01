//
//  ZoomImageView.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 24/04/26.
//

import SwiftUI

struct ZoomImageView: View {
    @Environment(\.dismiss) var dismiss
    
    let name: String
    let image: UIImage
    
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 5.0) {
                HStack {
                    Text(name).font(Font.system(size: 20, weight: .bold))
                    Spacer()
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                    })
                    .frame(width: 30, height: 30, alignment: .center)
                }.padding(.top)
                
                Spacer().frame(height: 50.0)

                Image(uiImage: image) //Double-Tap to Zoom Toggle
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(scale)
                    .animation(.spring(response: 0.35), value: scale)
                    .onTapGesture(count: 2) {
                        scale = scale > 1.0 ? 1.0 : 2.5
                    }
                
                Spacer()
            }
        }.padding(.horizontal)
    }
}


struct ZoomableImageView: View {
    @Environment(\.dismiss) var dismiss
    
    let name: String
    let image: UIImage

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 5.0) {
                HStack {
                    Text(name).font(Font.system(size: 20, weight: .bold))
                    Spacer()
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                    })
                    .frame(width: 30, height: 30, alignment: .center)
                }
                
                Spacer().frame(height: 50.0)
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(scale)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                scale = lastScale * value
                            }
                            .onEnded { value in
                                lastScale = scale
                                // Clamp scale between 1x and 4x
                                scale = min(max(scale, 1.0), 4.0)
                                lastScale = scale
                            }
                    )
            }
        }.padding(.horizontal)
    }
}

#Preview {
    ZoomImageView(name: "", image: UIImage())
}
