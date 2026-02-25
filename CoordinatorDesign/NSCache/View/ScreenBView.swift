//
//  ScreenBView.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 02/02/26.
//

import SwiftUI

struct ScreenBView: View {
    @State var model: ScreenBViewModel
    
    var body: some View {
        ZStack {
            Image(uiImage: model.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
        .padding()
        .navigationTitle("Image Detail")
        
    }
}
