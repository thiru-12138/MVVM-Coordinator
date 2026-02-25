//
//  PostListView.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 31/01/26.
//

import SwiftUI

struct PostListView: View {
    @StateObject var viewModel: PostListViewModel

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView("Posts Loading")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage).foregroundStyle(.red)
            } else {
                List(viewModel.posts) { post in
                    Button(post.title) {
                        viewModel.selectPost(post)
                    }
                }
            }
        }
        .navigationTitle("Posts")
        .task { [weak viewModel] in
            await viewModel?.loadPosts()
        }
        .toolbar {
            Button("Refresh") {
                print("refreshed")
            }
        }
    }
}
