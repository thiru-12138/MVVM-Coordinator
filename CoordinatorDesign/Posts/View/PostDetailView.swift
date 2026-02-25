//
//  PostDetailView.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 31/01/26.
//

import SwiftUI

struct PostDetailView: View {
    let post: Post
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(post.title).font(.largeTitle)
            Text(post.body).foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .navigationTitle("Post Details")
    }
}
