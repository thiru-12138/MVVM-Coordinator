//
//  MealDetailView.swift
//  TestAPI
//
//  Created by Thirumalai Ganesh G on 27/01/26.
//

import SwiftUI

struct MealDetailView: View {
    let mealID: String
    @State var model: MealDetailViewModel
    @StateObject var loader = ImageLoader()
    @State private var isZoom = false
        
    var body: some View {
        ZStack {
            GeometryReader { geo in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 15.0) {
                        if model.isLoading {
                            ProgressView()
                        }
                        
                        
                        if let data = model.mealDetail.first {
                            Text(data.name).font(Font.system(size: 20, weight: .bold))
                            
                            Group {
                                if let image = loader.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .onTapGesture(perform: {
                                            self.isZoom = true
                                        })
                                } else {
                                    ProgressView()
                                }
                            }
                            .frame(width: geo.size.width/1.09, height: geo.size.width/2.2, alignment: .center)
                            .clipShape(RoundedRectangle.init(cornerRadius: 20.0))
                            .task { [weak loader] in
                                await loader?.load(from: data.thumbnail)
                            }
                            .sheet(isPresented: $isZoom, content: {
                                ZoomImageView(name: data.name, image: loader.image ?? UIImage())
                            })

                            /*AsyncImage(url: URL(string: data.thumbnail)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(width: geo.size.width/1.09, height: geo.size.width/2.2, alignment: .center)
                            .clipShape(RoundedRectangle.init(cornerRadius: 20.0))*/
                            
                            Text("Instructions: ").font(.headline)
                            Text(data.instructions).font(.default)

                            if data.ingredients.count > 0 {
                                Text("Ingredients: ").font(.headline)
                                ForEach(data.ingredients, id: \.id) { item in
                                    HStack {
                                        Text(item.name).font(.footnote)
                                        Spacer()
                                        Text(item.measure).font(.footnote)
                                    }
                                }
                            }
                            
                        } else {
                            if let errorMeassage = model.errorMeassage {
                                Text(errorMeassage).foregroundStyle(.red)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                }
            }
        }
        .navigationTitle("Meal Deails")
        .task { [weak model] in
            await model?.fetchDetails(mealID)
        }
    }
}


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
