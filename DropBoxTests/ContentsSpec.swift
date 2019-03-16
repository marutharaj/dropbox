//
//  ContentsSpec.swift
//  DropBoxTests
//
//  Created by Marutharaj Kuppusamy on 3/15/19.
//

import Quick
import Nimble

@testable import DropBox

public class ContentsSpec: QuickSpec {
    
    override public func spec() {
        var contents: Contents?
        
        describe("ContentsSpec") {
            context("When get response from the contents service") {
                beforeEach {
                    contents = TestHelper().getFakeContents(bundleTypeOf: self, jsonFileName: "contents")
                }
                it("should have title") {
                    if let contents = contents {
                        if let title = contents.title {
                            expect(title).to(equal("About Canada"))
                        }
                    }
                }
                it("should parse content information") {
                    if let contents = contents {
                        let content = contents.content[5]
                        expect(content.title).to(equal("Housing"))
                        expect(content.description).to(equal("Warmer than you might think."))
                        expect(content.imageHref).to(equal("http://icons.iconarchive.com/icons/iconshock/alaska/256/Igloo-icon.png"))
                    }
                }
            }
        }
    }
}
