import XCTest
@testable import SwiftZulipAPI

class StreamsTests: XCTestCase {
    func testGetAll() {
        guard let zulip = getZulip() else {
            XCTFail("Zulip could not be configured.")
            return
        }

        let expectations = [
            expectation(description: "`Streams.getAll`"),
            expectation(
                description: "`Streams.getAll` `includePublic: false`"
            ),
            expectation(
                description: "`Streams.getAll` `includeSubscribed: false`"
            ),
            expectation(
                description: "`Streams.getAll` `includeDefault: true`"
            ),
            expectation(
                description: "`Streams.getAll` `includeAllActive: true`"
            ),
        ]

        zulip.streams().getAll(
            callback: { (streams, error) in
                XCTAssertNotNil(
                    streams,
                    "`Streams.getAll` is not successful"
                )
                XCTAssertNil(
                    error,
                    "`Streams.getAll` errors: "
                        + String(describing: error)
                )
                expectations[0].fulfill()
            }
        )
        zulip.streams().getAll(
            includePublic: false,
            callback: { (streams, error) in
                XCTAssertNotNil(
                    streams,
                    "`Streams.getAll` `includePublic: false` is not successful"
                )
                XCTAssertNil(
                    error,
                    "`Streams.getAll` `includePublic: false` errors: "
                        + String(describing: error)
                )
                expectations[1].fulfill()
            }
        )
        zulip.streams().getAll(
            includeSubscribed: false,
            callback: { (streams, error) in
                XCTAssertNotNil(
                    streams,
                    "`Streams.getAll` `includeSubscribed: false` is not "
                        + "successful"
                )
                XCTAssertNil(
                    error,
                    "`Streams.getAll` `includeSubscribed: false` errors: "
                        + String(describing: error)
                )
                expectations[2].fulfill()
            }
        )
        zulip.streams().getAll(
            includeDefault: true,
            callback: { (streams, error) in
                XCTAssertNotNil(
                    streams,
                    "`Streams.getAll` `includeDefault: true` is not successful"
                )
                XCTAssertNil(
                    error,
                    "`Streams.getAll` `includeDefault: true` errors: "
                        + String(describing: error)
                )
                expectations[3].fulfill()
            }
        )
        zulip.streams().getAll(
            includeAllActive: true,
            callback: { (streams, error) in
                /*
                    There should be an error because the test user is not an
                    admin.
                 */
                XCTAssertNil(
                    streams,
                    "`Streams.getAll` `includeAllActive: true` is successful: "
                        + String(describing: streams)
                )
                XCTAssertNotNil(
                    error,
                    "`Streams.getAll` `includeAllActive: true` does not error."
                )
                expectations[4].fulfill()
            }
        )

        wait(for: expectations, timeout: 60)
    }

    func testGetID() {
        guard let zulip = getZulip() else {
            XCTFail("Zulip could not be configured.")
            return
        }

        let expectations = [
            expectation(description: "`Streams.getID`"),
        ]

        zulip.streams().getID(
            name: "zulip-swift-tests",
            callback: { (id, error) in
                XCTAssertNotNil(
                    id,
                    "`Streams.getID` is not successful"
                )
                XCTAssertNil(
                    error,
                    "`Streams.getID` errors: "
                        + String(describing: error)
                )

                XCTAssertEqual(
                    224,
                    id,
                    "`Streams.getID` did not get the correct ID."
                )

                expectations[0].fulfill()
            }
        )

        wait(for: expectations, timeout: 60)
    }

    func testGetSubscribed() {
        guard let zulip = getZulip() else {
            XCTFail("Zulip could not be configured.")
            return
        }

        let expectations = [
            expectation(description: "`Streams.getSubscribed`"),
        ]

        zulip.streams().getSubscribed(
            callback: { (streams, error) in
                XCTAssertNotNil(
                    streams,
                    "`Streams.getSubscribed` is not successful"
                )
                XCTAssertNil(
                    error,
                    "`Streams.getSubscribed` errors: "
                        + String(describing: error)
                )


                expectations[0].fulfill()
            }
        )

        wait(for: expectations, timeout: 60)
    }

    func testSubscribe() {
        guard let zulip = getZulip() else {
            XCTFail("Zulip could not be configured.")
            return
        }

        let expectations = [expectation(description: "`Streams.subscribe`")]

        zulip.streams().subscribe(
            streams: [["name": "zulip-swift-tests"]],
            callback: { (subscribed, alreadySubscribed, unauthorized, error) in
                XCTAssert(
                    subscribed != nil
                        || alreadySubscribed != nil
                        || unauthorized != nil,
                    "`Streams.subscribe` is not successful"
                )
                XCTAssertNil(
                    error,
                    "`Streams.subscribe` errors: "
                        + String(describing: error)
                )
                expectations[0].fulfill()
            }
        )

        wait(for: expectations, timeout: 60)
    }

    func testUnsubscribe() {
        guard let zulip = getZulip() else {
            XCTFail("Zulip could not be configured.")
            return
        }

        let expectations = [expectation(description: "`Streams.unsubscribe`")]

        zulip.streams().unsubscribe(
            streamNames: ["zulip-swift-tests"],
            callback: { (unsubscribed, notSubscribed, error) in
                XCTAssert(
                    unsubscribed != nil || notSubscribed != nil,
                    "`Streams.unsubscribe` is not successful"
                )
                XCTAssertNil(
                    error,
                    "`Streams.unsubscribe` errors: "
                        + String(describing: error)
                )
                expectations[0].fulfill()
            }
        )

        wait(for: expectations, timeout: 60)
    }
}
