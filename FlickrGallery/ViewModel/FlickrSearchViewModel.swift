//
//  FlickrSearchViewModel.swift
//  FlickrGallery
//
//  Created by Lorenzo on 1/16/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class FlickrSearchViewModel: ObservableObject {
    @Published var imageCache: [UUID: UIImage] = [:]
    @Published var items: [FlickrItem] = []
    @Published var isLoading = false
    @Published var hasError = false
    @Published var errorMessage = ""
    @Published var searchQuery: String = ""

    private var cancellables = Set<AnyCancellable>()
    private let flickrService: FlickrService
    private var lastQuery: String?

    init(flickrService: FlickrService = FlickrService()) {
        self.flickrService = flickrService
        
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                if query == self?.lastQuery { return }
                self?.lastQuery = query
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
//    func loadImageFor(_ item: FlickrItem) async {
//        guard let url = URL(string: item.media.m) else { return }
//        print("Dowloaded image for \(item.id)")
//
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            guard let image = UIImage(data: data) else {
//                imageCache[item.id] = UIImage(systemName: "photo")!
//                return
//            }
//            print("Dowloaded image for \(item.id)")
//            imageCache[item.id] = image
//        } catch {
//            imageCache[item.id] = UIImage(systemName: "photo")!
//        }
//    }

    private func performSearch(query: String) {
        guard !query.isEmpty else {
            items = []
            return
        }

        isLoading = true
        hasError = false

        Task {
            do {
                let items = try await flickrService.fetchFlickrFeed(for: query)
                self.isLoading = false
                self.items = items
                self.imageCache = await self.downloadImages()
            } catch {
                self.isLoading = false
                self.hasError = true
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    private func downloadImages() async -> [UUID: UIImage] {
        var photos = [UUID: UIImage]()
        
        for item in items {
            do {
                async let photo = downloadImageFor(item: item)
                photos[item.id] = try await photo
            } catch {
                photos[item.id] = UIImage(systemName: "photo")!
            }
        }
        
        return photos
    }
    
    func downloadImageFor(item: FlickrItem) async throws -> UIImage {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: item.media.m)!)
            return UIImage(data: data)!
        } catch {
            return UIImage(systemName: "photo")!
        }
    }
}

