//
//  Contents.swift
//  DropBox
//
//  Created by Marutharaj Kuppusamy on 3/14/19.
//

import UIKit

struct Content: Codable {
    var title: String?
    var description: String?
    var imageHref: String?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case description
        case imageHref
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let jsonTitle = try? values.decode(String.self, forKey: .title) {
            title = jsonTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            title = ""
        }
        
        if let jsonDescription = try? values.decode(String.self, forKey: .description) {
            description = jsonDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            description = ""
        }
        
        if let jsonImageHref = try? values.decode(String.self, forKey: .imageHref) {
            imageHref = jsonImageHref
        } else {
            imageHref = ""
        }
    }
}

struct Contents: Codable {
    var title: String?
    var content: [Content]
    
    private enum CodingKeys: String, CodingKey {
        case title
        case content = "rows"
    }
    
    init() {
        title = ""
        content = []
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try? values.decode(String.self, forKey: .title)

        if let jsonContent = try? values.decode([Content].self, forKey: .content) {
            content = jsonContent
        } else {
            content = []
        }
    }
}
