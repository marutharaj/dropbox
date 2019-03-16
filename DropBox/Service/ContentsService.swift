//
//  ContentsService.swift
//  DropBox
//
//  Created by Marutharaj Kuppusamy on 3/14/19.
//

import UIKit

class ContentsService {
    func getContents(completionHandler:@escaping (_ contents: Contents) -> Void) {
        let url = URL(string: Constants.url)
        
        if let url = url {
            let task = URLSession.shared.dataTask(with: url) {(data, _, error ) in
                guard error == nil else {
                    print("Server returning error.")
                    return
                }
            
                guard let data = data else {
                    print("Server not returning data.")
                    return
                }
            
                do {
                    let decoder = JSONDecoder()
                    let jsonString = String(decoding: data, as: UTF8.self)
                    // Convert plain text json to valid json
                    if let jsonData = jsonString.data(using: String.Encoding.utf8) {
                        // Parse json
                        let contents = try decoder.decode(Contents.self, from: jsonData)
                        completionHandler(contents)
                    }
                } catch let err {
                    print("Error in json parsing.", err)
                }
            
            }
            task.resume()
        }
    }
}
