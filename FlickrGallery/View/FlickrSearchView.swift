//
//  FlickrSearchView.swift
//  FlickrGallery
//
//  Created by Lorenzo on 1/16/25.
//

import SwiftUI

struct FlickrSearchView: View {
    @ObservedObject private var viewModel = FlickrSearchViewModel()
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationView {
            VStack {
                searchTextField
                if viewModel.isLoading {
                    progressView
                } else if viewModel.hasError {
                    errorView
                } else {
                    photoListView
                }
                Spacer()
            }
            .navigationTitle("Flickr Search")
        }
    }
}

private extension FlickrSearchView {
    var searchTextField: some View {
        TextField("Search for photos", text: $viewModel.searchQuery)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
    }
    
    var progressView: some View {
        ProgressView("Loading...")
            .padding()
    }
    
    var photoListView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.items) { item in
                    NavigationLink {
                        FlickrItemDetailView(viewModel: FlickrItemDetailViewModel(item: item), entry: $viewModel.cache[item.id.uuidString])
                    } label: {
                        if let entry = viewModel.cache[item.id.uuidString], case .ready(let image) = entry {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                        } else {
                            ProgressView()
                        }
                    }
                    .onAppear {
                        Task {
                            try await viewModel.load(for: item)
                        }
                    }
                }
                .padding(.horizontal, 10)
            }
        }
    }
    
    var errorView: some View {
        Text("An error occurred: \(viewModel.errorMessage)")
            .foregroundColor(.red)
            .padding()
    }
}

#Preview {
    FlickrSearchView()
}
