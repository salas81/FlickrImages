//
//  TestData.swift
//  FlickrGalleryTests
//
//  Created by Lorenzo on 1/17/25.
//

import Foundation

let testData: Data  =
"""
{
        "title": "Recent Uploads tagged porcupine",
        "link": "https://www.flickr.com/photos/tags/porcupine/",
        "description": "",
        "modified": "2025-01-17T12:05:40Z",
        "generator": "https://www.flickr.com",
        "items": [
       {
            "title": "Title numbner 1",
            "link": "https://www.anywebsite.com/id/001",
            "media": {"m":"https://www.anywebsite.com/id/001"},
            "date_taken": "2025-01-17T06:56:57-08:00",
            "description": "simple description number 1",
            "published": "2025-01-17T12:05:40Z",
            "author": "Someone, someone1@gmail.com",
            "author_id": "0000001",
            "tags": "random tags"
       },
       {
            "title": "Title numbner 2",
            "link": "https://www.anywebsite.com/id/002",
            "media": {"m":"https://www.anywebsite.com/id/002"},
            "date_taken": "2025-01-17T06:56:57-08:00",
            "description": "simple description number 2",
            "published": "2025-01-17T12:05:40Z",
            "author": "Someone, someone2@gmail.com",
            "author_id": "0000002",
            "tags": "random tags"
       },
       {
            "title": "Title numbner 3",
            "link": "https://www.anywebsite.com/id/003",
            "media": {"m":"https://www.anywebsite.com/id/003"},
            "date_taken": "2025-01-17T06:56:57-08:00",
            "description": "simple description number 3",
            "published": "2025-01-17T12:05:40Z",
            "author": "Someone, someone3@gmail.com",
            "author_id": "0000003",
            "tags": "random tags"
       }]
}

""".data(using: .utf8)!

let emptyData: Data =
"""
{
        "title": "Recent Uploads tagged porcupine",
        "link": "https://www.flickr.com/photos/tags/porcupine/",
        "description": "",
        "modified": "2025-01-17T12:05:40Z",
        "generator": "https://www.flickr.com",
        "items": []
}
""".data(using: .utf8)!

let malformedData: Data =
"""
{
    just a bunch of garbage here
}
""".data(using: .utf8)!
