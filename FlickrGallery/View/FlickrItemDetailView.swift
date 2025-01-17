//
//  FlickrItemDetailView.swift
//  FlickrGallery
//
//  Created by Lorenzo on 1/16/25.
//

import SwiftUI

struct FlickrItemDetailView: View {
    let viewModel: FlickrItemDetailViewModel
    @Binding var entry: FlickrSearchViewModel.CacheEntry?
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            if let entry = entry, case .ready(let image) = entry {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
            
            Text(viewModel.title)
                .font(.headline)
            
            if let nsAttributedString = try? NSAttributedString(data: Data(viewModel.title.utf8), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil),
               let attributedString = try? AttributedString(nsAttributedString, including: \.uiKit) {
                Text(attributedString)
            } else {
                Text(viewModel.title)
            }
            
            Text(viewModel.author)
                .font(.body)
            
            Text(viewModel.publishedDate)
                .font(.body)
        }
        .padding(.horizontal, 10)
    }
}

