//
//  TestHelper.swift
//  DropBoxTests
//
//  Created by Marutharaj Kuppusamy on 3/14/19.
//

import Foundation
import Quick
import Nimble
import OHHTTPStubs

@testable import DropBox

class TestHelper {
    func getFakeContents(bundleTypeOf: QuickSpec, jsonFileName: String) -> Contents {
        var contents: Contents?
        
        if let path = Bundle(for: type(of: bundleTypeOf)).path(forResource: jsonFileName,
                                                               ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path),
                                    options: .alwaysMapped)
                let decoder = JSONDecoder()
                contents = try decoder.decode(Contents.self, from: data)
            } catch {
                print("JSON parsing error.")
            }
        }
        if let contents = contents {
            return contents
        }
        return Contents.init()
    }
    
    func fakeContentsServiceWithSuccess() {
        stub(condition: isHost("dl.dropboxusercontent.com") && isPath("/s/2iodh4vg0eortkl/facts.json")) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("contents.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
        }
    }
    
    func fakeContentsServiceWithError() {
        let error = NSError(domain: "Contents service not found.", code: 404, userInfo: nil)
        stub(condition: isHost("dl.dropboxusercontent.com") && isPath("/s/2iodh4vg0eortkl/facts.json")) { _ in
            return OHHTTPStubsResponse(error: error)
        }
    }
    
    func removeAllStubs() {
        OHHTTPStubs.removeAllStubs()
    }
}
