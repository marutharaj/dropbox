//
//  ContentsViewControllerSpec.swift
//  DropBoxTests
//
//  Created by Marutharaj Kuppusamy on 3/16/19.
//

import UIKit
import Quick
import Nimble

@testable import DropBox

class ContentsViewControllerSpec: QuickSpec {
    override func spec() {
        var subject: ContentsViewController!
        
        describe("ContentsViewControllerSpec") {
            beforeEach {
                TestHelper().fakeContentsServiceWithSuccess()
                subject = ContentsViewController()
                _ = subject.view
                TestHelper().fakeContentsServiceWithSuccess()

                expect(subject.view).notTo(beNil())
                expect(subject.contentTableView).notTo(beNil())
                expect(subject.contentViewModel).notTo(beNil())
                
                waitUntil { done in
                    if let service = subject?.contentViewModel.contentsService {
                        service.getContents(completionHandler: { (contents) in
                            subject.contents = contents
                            done()
                        })
                    }
                }
                subject.contentTableView.reloadData()
            }
            afterEach {
                TestHelper().removeAllStubs()
            }
            
            context("when view is loaded") {
                it("should have 14 content loaded") {
                    expect(subject?.contentTableView.numberOfRows(inSection: 0)).to(equal(14))
                }
            }
            
            context("Content Table View") {
                var cell: ContentsTableViewCell!
                
                it("should show content title and description") {
                    cell = subject.contentTableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? ContentsTableViewCell
                    expect(cell.contentTitleLabel.text).to(equal("Housing"))
                    expect(cell.contentDescriptionLabel.text).to(equal("Warmer than you might think."))
                }
            }
        }
    }
}
