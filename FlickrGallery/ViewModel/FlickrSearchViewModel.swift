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
    enum CacheEntry {
        case inProgress(Task<UIImage, Error>)
        case ready(UIImage)
    }
    
    @Published var cache: [String: CacheEntry] = [:]
    var items: [FlickrItem] = [] {
        didSet {
            for item in items {
                Task {
                    let image = try await downloadImage(for: item)
                    DispatchQueue.main.async {
                        self.cache[item.id.uuidString] = .ready(image)
                    }
                }
            }
        }
    }
    @Published var isLoading = false
    @Published var hasError = false
    @Published var errorMessage = ""
    @Published var searchQuery: String = ""

    private var cancellables = Set<AnyCancellable>()
    let flickrService: FlickrService
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
            } catch {
                self.isLoading = false
                self.hasError = true
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func load(for item: FlickrItem) async throws -> UIImage {
        print("Loading image for \(item.id.uuidString)")
        
        if let cached = cache[item.id.uuidString] {
            switch cached {
            case .ready(let image):
                return image
            case .inProgress(let task):
                Task {
                    return try await task.value
                }
            }
        }
        
        let task = Task {
            try await downloadImage(for: item)
        }
        
        cache[item.id.uuidString] = .inProgress(task)

        let image = try await task.value
        cache[item.id.uuidString] = .ready(image)
        
        return image
    }
    
    private func downloadImage(for item: FlickrItem) async throws -> UIImage {
        guard let url = URL(string: item.media.m) else { return UIImage(systemName: "photo")! }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return UIImage(systemName: "photo")! }
            return image
        } catch {
            return UIImage(systemName: "photo")!
        }
    }
}

