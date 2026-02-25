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
                                } else {
                                    ProgressView()
                                }
                            }
                            .frame(width: geo.size.width/1.09, height: geo.size.width/2.2, alignment: .center)
                            .clipShape(RoundedRectangle.init(cornerRadius: 20.0))
                            .task { [weak loader] in
                                await loader?.load(from: data.thumbnail)
                            }

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
