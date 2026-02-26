//
//  ScreenAView.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 02/02/26.
//

import SwiftUI

struct ScreenAView: View {
    @State var model: ScreenAViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 20.0) {
                ZStack {
                    if model.isLoading {
                        ProgressView()
                    } else if let img = model.image {
                        Image(uiImage: img)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100, alignment: .center)
                            .onTapGesture(perform: {
                                model.selectImage(img)
                            })
                    } else {
                        if let errMsg = model.errMsg {
                            Text(errMsg).foregroundStyle(.red)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100, alignment: .center)
                        }
                    }
                }.padding()
                
                //Spacer(minLength: 20.0)
                
                Button(action: {
                    Task { [weak model] in
                        await model?.loadImage()
                    }
                }, label: {
                    Text("Download")
                })
            }
        }
        .navigationTitle("NSCache Image")
    }
}
