//
//  ContentViewModelSpec.swift
//  DropBoxTests
//
//  Created by Marutharaj Kuppusamy on 3/15/19.
//

import Quick
import Nimble

@testable import DropBox

public class ContentViewModelSpec: QuickSpec {
    
    override public func spec() {
        var subject: ContentViewModel?
        
        describe("ContentViewModelSpec") {
            context("When initialize from view controller") {
                beforeEach {
                    subject = ContentViewModel(service: ContentsService())
                    subject?.query = ""
                }
                it("Model value should not be nil") {
                    expect(subject?.contents).toNot(beNil())
                    expect(subject?.contents.content.count).to(equal(0))
                    expect(subject?.contents.title).to(equal(""))
                }
            }
        }
        describe("ContentViewModelSpec") {
            context("When receive data from the server") {
                beforeEach {
                    TestHelper().fakeContentsServiceWithSuccess()
                    
                    subject = ContentViewModel(service: ContentsService())
                    subject?.query = "getContents"
                }
                it("Model value should not be nil") {
                    if let service = subject?.contentsService {
                        service.getContents(completionHandler: { (contents) in
                            expect(subject?.contents).toNot(beNil())
                            expect(subject?.contents.title).to(equal("About Canada"))
                            expect(subject?.contents.content[5].title).to(equal("Housing"))
                            expect(subject?.contents.content[5].description).to(equal("Warmer than you might think."))
                            expect(subject?.contents.content[5].imageHref).to(equal("http://icons.iconarchive.com/icons/iconshock/alaska/256/Igloo-icon.png"))
                        })
                    }
                }
            }
        }
    }
}
