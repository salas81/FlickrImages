//
//  FlickrItemDetailViewModel.swift
//  FlickrGallery
//
//  Created by Lorenzo on 1/16/25.
//

import Foundation
import SwiftUI

struct FlickrItemDetailViewModel {
    let item: FlickrItem

    var title: String {
        item.title
    }
    
    var description: String {
        item.description
    }
    
    var author: String {
        "Author: \(item.author)"
    }
    
    var publishedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formatter.date(from: item.published) {
            return "Published on \(date)"
        }
        
        return "Published date not available"
    }
}
