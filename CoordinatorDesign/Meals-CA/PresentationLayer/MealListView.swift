//
//  MealListView.swift
//  TestAPI
//
//  Created by Thirumalai Ganesh G on 27/01/26.
//

import SwiftUI

struct MealListView: View {
    @State var model: MealListViewModel
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                ZStack {
                    if model.isLoading {
                        ProgressView()
                    } else if let error = model.errorMessage {
                        Text(error).foregroundStyle(.red)
                    } else {
                        List(model.meals) { meal in
                            Button(action: {
                                model.selectMeal(meal.id)
                            }, label: {
                                MealCell(meal: meal, width: geo.size.width)
                            })
                        }
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle("Meals")
        .task { [weak model] in
            await model?.loadData()
        }
        .toolbar {
            Menu(content: {
                ForEach(model.categories, id: \.self) { cate in
                    Button(action: {
                        model.selectedCategory = cate
                        print("category: ", model.selectedCategory)
                        Task { [weak model] in
                            await model?.loadData()
                        }
                    }, label: {
                        HStack {
                            Text(cate)
                            Spacer()
                            if model.selectedCategory == cate {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .frame(width: 20, height: 20, alignment: .center)
                            }
                            
                        }
                    })
                }
            }, label: {
                HStack {
                    Text(model.selectedCategory)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity)
            })
        }
    }
}


struct MealCell: View {
    var meal: Meals
    var width: CGFloat
    @StateObject private var loader = ImageLoader()

    var body: some View {
        HStack(spacing: 10.0) {
            Group {
                if let image = loader.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    ProgressView()
                }
            }
            .frame(width: width/5.5, height: width/5.5, alignment: .center)
            .clipShape(RoundedRectangle.init(cornerRadius: 15.0))

            /*AsyncImage(url: URL(string: meal.imageurl)) { phase in
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
            .frame(width: width/5.5, height: width/5.5, alignment: .center)
            .clipShape(RoundedRectangle.init(cornerRadius: 15.0))*/
            
            VStack(alignment: .leading, spacing: 10.0, content: {
                Text(meal.name).font(.headline)
            })
        }
        .task { [weak loader] in
            await loader?.load(from: meal.imageurl)
        }
    }
}
