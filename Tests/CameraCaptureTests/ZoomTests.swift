import XCTest
@testable import CameraCapture

class ZoomTests: XCTestCase {
    
    let system = System()
    
    func testWhenNoCameraIsSelected_ThenZoomFails() {
        do {
            try system.camera.zoom(to: 2)
        } catch let error as ZoomError {
            XCTAssertEqual(error, .noSelectedCamera)
            return
        } catch {
            XCTFail("Expecting ZoomError.")
            return
        }
        
        XCTFail("Expecting error.")
    }
    
    func testWhenCameraIsSelected_AndZoomWithinBoundariesOfDevice_ThenZoomIsSuccesful() {
        system.dataSource.selectedCameraToReturn = Device(id: "1",
                                                          type: .tripleCamera,
                                                          position: .back,
                                                          hasFlash: false,
                                                          isFlashOn: true,
                                                          zoomOptions: [],
                                                          currentZoom: 1.0,
                                                          maxZoom: 10,
                                                          minZoom: 0.5)
        
        try? system.camera.zoom(to: 2)
        
        XCTAssertEqual(system.zoomController.zoomValue, 4)
    }
    
    func testWhenZoomIsSuccesful_ThenObserversAreNotified() {
        let zoomObserver = SpyZoomObserver()
        
        system.dataSource.selectedCameraToReturn = Device(id: "1",
                                                          type: .tripleCamera,
                                                          position: .back,
                                                          hasFlash: false,
                                                          isFlashOn: true,
                                                          zoomOptions: [],
                                                          currentZoom: 1.0,
                                                          maxZoom: 10,
                                                          minZoom: 0.5)
        system.camera.add(zoomObserver: zoomObserver)
        try? system.camera.zoom(to: 2)
        
        XCTAssertEqual(zoomObserver.magnificationValue, 2)
    }
    
    func testWhenCameraIsSelected_AndZoomBelowMinimumZoom_ThenZoomReturnError() {
        system.dataSource.selectedCameraToReturn = Device(id: "1",
                                                          type: .tripleCamera,
                                                          position: .back,
                                                          hasFlash: false,
                                                          isFlashOn: true,
                                                          zoomOptions: [],
                                                          currentZoom: 1.0,
                                                          maxZoom: 10,
                                                          minZoom: 0.5)
        
        do {
            try system.camera.zoom(to: 0.4)
        } catch let error as ZoomError {
            XCTAssertEqual(error, .zoomOutsideOfBounds)
            return
        } catch {
            XCTFail("Expecting ZoomError.")
            return
        }
        
        XCTFail("Expecting error.")
    }
    
    func testWhenCameraIsSelected_AndZoomIsAboveMaximumZoom_ThenZoomReturnError() {
        system.dataSource.selectedCameraToReturn = Device(id: "1",
                                                          type: .tripleCamera,
                                                          position: .back,
                                                          hasFlash: false,
                                                          isFlashOn: true,
                                                          zoomOptions: [],
                                                          currentZoom: 1.0,
                                                          maxZoom: 10,
                                                          minZoom: 0.5)
        
        do {
            try system.camera.zoom(to: 11)
        } catch let error as ZoomError {
            XCTAssertEqual(error, .zoomOutsideOfBounds)
            return
        } catch {
            XCTFail("Expecting ZoomError.")
            return
        }
        
        XCTFail("Expecting error.")
    }
    
    func testWhenZoomFails_AndZoomErrorIsThrown_ThenZoomErrorIsReturned() {
        system.zoomController.errorToThrow = ZoomError.zoomOutsideOfBounds
        system.dataSource.selectedCameraToReturn = Device(id: "1",
                                                          type: .tripleCamera,
                                                          position: .back,
                                                          hasFlash: false,
                                                          isFlashOn: true,
                                                          zoomOptions: [],
                                                          currentZoom: 1.0,
                                                          maxZoom: 10,
                                                          minZoom: 0.5)
        
        do {
            try system.camera.zoom(to: 3)
        } catch let error as ZoomError {
            XCTAssertEqual(error, .zoomOutsideOfBounds)
            return
        } catch {
            XCTFail("Expecting ZoomError.")
            return
        }
        
        XCTFail("Expecting error.")
    }
    
    func testWhenZoomFails_AndUnknownErrorIsReturned_ThenUnknownZoomErrorIsReturned() {
        system.zoomController.errorToThrow = FakeError.fakeError
        system.dataSource.selectedCameraToReturn = Device(id: "1",
                                                          type: .tripleCamera,
                                                          position: .back,
                                                          hasFlash: false,
                                                          isFlashOn: true,
                                                          zoomOptions: [],
                                                          currentZoom: 1.0,
                                                          maxZoom: 10,
                                                          minZoom: 0.5)
        
        do {
            try system.camera.zoom(to: 3)
        } catch let error as ZoomError {
            XCTAssertEqual(error, .unknownError)
            return
        } catch {
            XCTFail("Expecting ZoomError.")
            return
        }
        
        XCTFail("Expecting error.")
    }
    
    func testWhenUserZoomsInOnView_AndDeviceIsSelected_ThenZoomIsSuccesful() {
        system.dataSource.selectedCameraToReturn = Device(id: "1",
                                                          type: .tripleCamera,
                                                          position: .back,
                                                          hasFlash: false,
                                                          isFlashOn: true,
                                                          zoomOptions: [],
                                                          currentZoom: 1.0,
                                                          maxZoom: 10,
                                                          minZoom: 0.5)
        
        system.presenter.didZoomTo(2.4)
        
        XCTAssertEqual(system.zoomController.zoomValue, 4.8)
    }
    
    func testWhenUserZoomsInOnView_AndDeviceIsntSelected_ThenZoomIsSuccesful() {
        system.presenter.didZoomTo(2.4)
        
        XCTAssertEqual(system.zoomController.zoomValue, 0)
    }
}

enum FakeError: Error {
    case fakeError
}

class SpyZoomObserver: ZoomObserver {
    var magnificationValue: Double = 0
    func didUpdateZoom(to magnification: Double) {
        self.magnificationValue = magnification
    }
}

class SpyZoomController: ZoomController {
    
    var zoomValue: Double = 0
    var errorToThrow: Error?
    
    func zoom(to value: Double) throws {
        if let errorToThrow = errorToThrow {
            throw errorToThrow
        }
        zoomValue = value
    }
}
