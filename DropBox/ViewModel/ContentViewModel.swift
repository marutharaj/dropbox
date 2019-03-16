//
//  ContentViewModel.swift
//  DropBox
//
//  Created by Marutharaj Kuppusamy on 3/14/19.
//

import UIKit

protocol ContentsRepositoriesDelegate {
    func contentResultsDidChanged()
}

protocol ContentViewModelType {
    var contents: Contents {get}
    
    var query: String {get set}
    
    var delegate: ContentsRepositoriesDelegate? {get set }
}

class ContentViewModel: ContentViewModelType {
    var delegate: ContentsRepositoriesDelegate?
    
    var contents: Contents = Contents.init() {
        didSet {
            // Notify to view controller once received contents data from the server
            delegate?.contentResultsDidChanged()
        }
    }
    
    var contentsService: ContentsService
    
    var query: String = "" {
        didSet {
            if query.isEmpty {
                // Initialize default value for contents
                contents = Contents.init()
            } else {
                getContents()
            }
        }
    }
    
    init(service: ContentsService) {
        self.contentsService = service
    }
    
    // Find empty content index to remove from the contents
    private func getEmptyContentIndex() -> [Int] {
        var index: Int = 0
        var arrayIndex: [Int] = []
        for content in self.contents.content {
            if let title = content.title, let description = content.description, let imageHref = content.imageHref {
                let isContentEmpty: Bool = title.isEmpty && description.isEmpty && imageHref.isEmpty
                if isContentEmpty {
                    arrayIndex.append(index)
                }
            }
            index += 1
        }
        return arrayIndex
    }
    
    // Call content service to get contents
    private func getContents() {
        self.contentsService.getContents(completionHandler: { (contents) in
            self.contents = contents
            // Get empty content index
            let arrayIndex: [Int] = self.getEmptyContentIndex()
            // Remove empty content from the contents
            let arrayFilteredContents = self.contents.content
                .enumerated()
                .filter { !arrayIndex.contains($0.offset) }
                .map { $0.element }
            self.contents.content = arrayFilteredContents
        })
    }
}
