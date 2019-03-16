//
//  ContentsServiceSpec.swift
//  DropBoxTests
//
//  Created by Marutharaj Kuppusamy on 3/15/19.
//

import Quick
import Nimble

@testable import DropBox

class ContentsServiceSpec: QuickSpec {
    
    override func spec() {
        describe("ContentsServiceSpec") {
            afterEach {
                TestHelper().removeAllStubs()
            }
            
            context("when view model call contents service") {
                it("should return contents") {
                    
                    TestHelper().fakeContentsServiceWithSuccess()
                    
                    ContentsService().getContents(completionHandler: { contents in
                        expect(contents).toNot(beNil())
                    })
                }
            }
        }
    }
}
