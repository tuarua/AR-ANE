/* Copyright 2017 Tua Rua Ltd.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 Additional Terms
 No part, or derivative of this Air Native Extensions's code is permitted
 to be sold as the basis of a commercially packaged Air Native Extension which
 undertakes the same purpose as this software. That is an ARKit wrapper for iOS.
 All Rights Reserved. Tua Rua Ltd.
 */

import UIKit
import FreSwift
import ARKit

class GestureController: FreSwiftController {
    static var TAG: String = "GestureController"
    var context: FreContextSwift!
    private var sceneView: ARSCNView!
    private var airView: UIView?
    private var listeners: [String] = []
    private var tapGestureRecogniser: UITapGestureRecognizer?
    private var pinchGestureRecogniser: UIPinchGestureRecognizer?
    private var swipeGestureRecognisers: [UISwipeGestureRecognizer] = []
    private var longPressGestureRecogniser: UILongPressGestureRecognizer?
    
    convenience init(context: FreContextSwift, sceneView: ARSCNView, airView: UIView?, listeners: [String]) {
        self.init()
        self.context = context
        self.sceneView = sceneView
        self.airView = airView
        self.listeners = listeners
        
        if self.listeners.contains(GestureEvent.SCENE3D_TAP) {
            addTapGesture()
        }
        if listeners.contains(GestureEvent.SCENE3D_PINCH) {
            addPinchGesture()
        }
        if self.listeners.contains(GestureEvent.SCENE3D_SWIPE_LEFT) {
            addSwipeGestures(direction: .left)
        }
        if self.listeners.contains(GestureEvent.SCENE3D_SWIPE_RIGHT) {
            addSwipeGestures(direction: .right)
        }
        if self.listeners.contains(GestureEvent.SCENE3D_SWIPE_UP) {
            addSwipeGestures(direction: .up)
        }
        if self.listeners.contains(GestureEvent.SCENE3D_SWIPE_DOWN) {
            addSwipeGestures(direction: .down)
        }
        if self.listeners.contains(GestureEvent.SCENE3D_LONG_PRESS) {
            addLongPressGesture()
        }
        
    }
    
    func addEventListener(type: String) {
        listeners.append(type)
        switch type {
        case GestureEvent.SCENE3D_TAP:
            addTapGesture()
        case GestureEvent.SCENE3D_PINCH:
            addPinchGesture()
        case GestureEvent.SCENE3D_SWIPE_LEFT:
            addSwipeGestures(direction: .left)
        case GestureEvent.SCENE3D_SWIPE_RIGHT:
            addSwipeGestures(direction: .right)
        case GestureEvent.SCENE3D_SWIPE_UP:
            addSwipeGestures(direction: .up)
        case GestureEvent.SCENE3D_SWIPE_DOWN:
            addSwipeGestures(direction: .down)
        case GestureEvent.SCENE3D_LONG_PRESS:
            addLongPressGesture()
        default:
            break
        }
    }
    
    func removeEventListener(type: String) {
        listeners = listeners.filter({ $0 != type })
        switch type {
        case GestureEvent.SCENE3D_TAP:
            removeTapGesture()
        case GestureEvent.SCENE3D_PINCH:
            removePinchGesture()
        case GestureEvent.SCENE3D_SWIPE_LEFT:
            removeSwipeGestures(direction: .left)
        case GestureEvent.SCENE3D_SWIPE_RIGHT:
            removeSwipeGestures(direction: .right)
        case GestureEvent.SCENE3D_SWIPE_UP:
            removeSwipeGestures(direction: .up)
        case GestureEvent.SCENE3D_SWIPE_DOWN:
            removeSwipeGestures(direction: .down)
        case GestureEvent.SCENE3D_LONG_PRESS:
            removeLongPressGesture()
        default:
            break
        }
    }
    
    // MARK: - Tap
    
    func addTapGesture() {
        tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(didTapAt(_:)))
        guard let recog = tapGestureRecogniser else { return }
        sceneView.addGestureRecognizer(recog)
        airView?.addGestureRecognizer(recog)
    }
    
    func removeTapGesture() {
        guard let recog = tapGestureRecogniser else { return }
        sceneView.removeGestureRecognizer(recog)
        airView?.removeGestureRecognizer(recog)
    }
    
    @objc internal func didTapAt(_ recogniser: UITapGestureRecognizer) {
        guard listeners.contains(GestureEvent.SCENE3D_TAP)
            else { return }
        let touchPoint = recogniser.location(in: sceneView)
        trace(touchPoint.debugDescription)
        var props = [String: Any]()
        props["x"] = touchPoint.x
        props["y"] = touchPoint.y
        dispatchEvent(name: GestureEvent.SCENE3D_TAP, value: JSON(props).description)
    }
    
    // MARK: - Swipe
    
    func addSwipeGestures(direction: UISwipeGestureRecognizer.Direction) {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeAt(_:)))
        gesture.direction = direction
        sceneView.addGestureRecognizer(gesture)
        airView?.addGestureRecognizer(gesture)
        swipeGestureRecognisers.append(gesture)
    }
    
    func removeSwipeGestures(direction: UISwipeGestureRecognizer.Direction) {
        var cnt = 0
        for gesture in swipeGestureRecognisers {
            if gesture.direction == direction {
                sceneView.removeGestureRecognizer(gesture)
                swipeGestureRecognisers.remove(at: cnt)
                break
            }
            cnt += 1
        }
    }
    
    @objc internal func didSwipeAt(_ recogniser: UISwipeGestureRecognizer) {
        let touchPoint = recogniser.location(in: sceneView)
        var props = [String: Any]()
        props["x"] = touchPoint.x
        props["y"] = touchPoint.y
        props["direction"] = recogniser.direction.rawValue
        props["phase"] = recogniser.state.rawValue
        var eventName: String = ""
        switch recogniser.direction {
        case .up:
            eventName = GestureEvent.SCENE3D_SWIPE_UP
        case .down:
            eventName = GestureEvent.SCENE3D_SWIPE_DOWN
        case .left:
            eventName = GestureEvent.SCENE3D_SWIPE_LEFT
        case .right:
            eventName = GestureEvent.SCENE3D_SWIPE_RIGHT
        default:
            break
        }
        dispatchEvent(name: eventName, value: JSON(props).description)
    }
    
    // MARK: - Pinch
    
    func addPinchGesture() {
        pinchGestureRecogniser = UIPinchGestureRecognizer(target: self, action: #selector(didPinchAt(_:)))
        guard let recog = pinchGestureRecogniser else { return }
        sceneView.addGestureRecognizer(recog)
        airView?.addGestureRecognizer(recog)
    }
    
    func removePinchGesture() {
        guard let recog = pinchGestureRecogniser else { return }
        sceneView.removeGestureRecognizer(recog)
        airView?.removeGestureRecognizer(recog)
    }
    
    @objc internal func didPinchAt(_ recogniser: UIPinchGestureRecognizer) {
        guard listeners.contains(GestureEvent.SCENE3D_PINCH)
            else { return }
        let touchPoint = recogniser.location(in: sceneView)
        var props = [String: Any]()
        props["x"] = touchPoint.x
        props["y"] = touchPoint.y
        props["scale"] = recogniser.scale
        props["velocity"] = recogniser.velocity
        props["phase"] = recogniser.state.rawValue
        dispatchEvent(name: GestureEvent.SCENE3D_PINCH, value: JSON(props).description)
    }
    
    // MARK: - Long Press
    
    func addLongPressGesture() {
        longPressGestureRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressAt(_:)))
        guard let recog = longPressGestureRecogniser else { return }
        sceneView.addGestureRecognizer(recog)
        airView?.addGestureRecognizer(recog)
    }
    
    func removeLongPressGesture() {
        guard let recog = longPressGestureRecogniser else { return }
        sceneView.removeGestureRecognizer(recog)
        airView?.removeGestureRecognizer(recog)
    }
    
    func dispose() {
        removeTapGesture()
        removePinchGesture()
        removeSwipeGestures(direction: .left)
        removeSwipeGestures(direction: .right)
        removeSwipeGestures(direction: .up)
        removeSwipeGestures(direction: .down)
        removeLongPressGesture()
    }
    
    @objc internal func didLongPressAt(_ recogniser: UILongPressGestureRecognizer) {
        guard listeners.contains(GestureEvent.SCENE3D_LONG_PRESS)
            else { return }
        let touchPoint = recogniser.location(in: sceneView)
        var props = [String: Any]()
        props["x"] = touchPoint.x
        props["y"] = touchPoint.y
        props["phase"] = recogniser.state.rawValue
        dispatchEvent(name: GestureEvent.SCENE3D_LONG_PRESS, value: JSON(props).description)
    }

}
