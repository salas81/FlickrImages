//
//  FlickrClient.swift
//  FlickrGallery
//
//  Created by Lorenzo on 1/16/25.
//

import Foundation

protocol FlickrServiceProtocol {
    func fetchFlickrFeed(for tag: String) async throws -> [FlickrItem]
}

enum FlickrServiceError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
}

// MARK: - FlickrService
class FlickrService {
    private let baseURL = "https://www.flickr.com/services/feeds/photos_public.gne"
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Builds a URL with the given tag query
    /// - Parameter tag: The tag to query
    /// - Returns: A constructed URL or nil if invalid
    private func buildURL(with tag: String) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "tags", value: tag)
        ]
        return components?.url
    }
}

extension FlickrService: FlickrServiceProtocol {
    /// Fetches the Flickr feed for a given tag query
    /// - Parameter tag: The tag to query
    /// - Returns: A FlickrFeed object
    func fetchFlickrFeed(for tag: String) async throws -> [FlickrItem] {
        guard let url = buildURL(with: tag) else {
            throw FlickrServiceError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw FlickrServiceError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let feed = try decoder.decode(FlickrFeed.self, from: data)
            return feed.items
        } catch {
            throw FlickrServiceError.decodingError(error)
        }
    }
}
