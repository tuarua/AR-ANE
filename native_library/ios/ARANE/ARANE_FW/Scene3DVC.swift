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

class Scene3DVC: UIViewController, ARSCNViewDelegate, ARSessionDelegate, FreSwiftController {
    var TAG: String? = "Scene3DVC"
    var context: FreContextSwift!
    private var sceneView: ARSCNView!
    private var viewPort: CGRect = CGRect.zero
    private var planeDetection:Bool = false
    private var anchors: Dictionary<String, ARAnchor> = Dictionary()
    private var models: Dictionary<String, SCNNode> = Dictionary()
    private var actions: Dictionary<String, SCNAction> = Dictionary()
    private var tapGestureRecogniser:UITapGestureRecognizer?
    private var swipeGestureRecognisers:[UISwipeGestureRecognizer] = []
    private var asListeners: Array<String> = []
    
    private var lastNodeRef:SCNNode? //used for fast access to last node with manipulated from AIR
    
    convenience init(context: FreContextSwift, frame: CGRect, arview: ARSCNView, asListeners:Array<String>) {
        self.init()
        self.context = context
        self.viewPort = frame
        self.sceneView = arview
        self.asListeners = asListeners
    }
    
   
    
    func setDebugOptions(options: Array<String>) {
        var debugOptions:SCNDebugOptions = []
        for option in options {
            debugOptions.formUnion(SCNDebugOptions.init(rawValue: UInt(option)!))
        }
        sceneView.debugOptions = debugOptions
    }
    
    // MARK: - Session
    
    func runSession(configuration: ARWorldTrackingConfiguration, options: Array<Int>) {
        planeDetection = configuration.planeDetection.rawValue > 0
        var runOptions:ARSession.RunOptions = []
        for i in options {
            runOptions.formUnion(ARSession.RunOptions.init(rawValue: UInt(i)))
        }
        //sceneView.session.delegate = (self as! ARSessionDelegate)
        sceneView.session.run(configuration, options: runOptions)
    }
    
    func pauseSession() {
        sceneView.session.pause()
    }
    
    // MARK: - Anchor
    
    func addAnchor(anchor:ARAnchor) {
        sceneView.session.add(anchor: anchor)
        anchors[anchor.identifier.uuidString] = anchor
    }
    
    func removeAnchor(id:String) {
        guard let anchor = anchors[id] else { return }
        sceneView.session.remove(anchor: anchor)
    }
    
    // MARK: - Nodes
    
    private func findNode(withName:String, recursively:Bool = true) -> SCNNode? {
        return sceneView.scene.rootNode.childNode(withName: withName, recursively: true)
    }

    func addChildNode(parentName: String?, node: SCNNode) {
        lastNodeRef = node
        if let nodeName = parentName,
            let pNode = findNode(withName: nodeName) {
            pNode.addChildNode(node)
        } else {
            //trace("adding childNode to root", node.debugDescription)
            sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    func removeFromParentNode(nodeName:String) {
        if lastNodeRef?.name != nodeName {
            guard let node = findNode(withName: nodeName)
                else { return }
            lastNodeRef = node
        }
        lastNodeRef?.removeFromParentNode()
    }
    
    func removeChildNodes(nodeName:String) {
        if lastNodeRef?.name != nodeName {
            guard let node = findNode(withName: nodeName)
                else { return }
            lastNodeRef = node
        }
        lastNodeRef?.enumerateChildNodes{ (childNode, _) in
            childNode.removeFromParentNode()
        }
    }
    
    func setChildNodeProp(nodeName:String, propName: String, value: FREObject) {
        if lastNodeRef?.name != nodeName {
            guard let node = findNode(withName: nodeName)
                else { return }
            lastNodeRef = node
        }
        //trace("setChildNodeProp nodeName: \(nodeName) propName: \(propName)")
        lastNodeRef?.setProp(name: propName, value: value)
    }
    
    func getChildNode(parentName:String?, nodeName:String) -> SCNNode? {
        if lastNodeRef?.name != nodeName {
            var parentNode:SCNNode?
            if parentName == "sceneRoot" || parentName == nil {
                parentNode = sceneView.scene.rootNode
            } else {
                if let pn = parentName {
                    parentNode = findNode(withName: pn)
                }
            }
            lastNodeRef = parentNode?.childNode(withName: nodeName, recursively: true)
            return lastNodeRef
        }
        return lastNodeRef
        
    }
    
    func addModel(url: String, nodeName: String?, flatten:Bool) -> SCNNode? {
        if let scene = SCNScene.init(named: url) {
            if let nodeName = nodeName,
                let node = scene.rootNode.childNode(withName: nodeName, recursively: true) {
                if flatten {
                    let flattened = node.flattenedClone()
                    models[nodeName] = flattened
                    return flattened
                } else {
                    models[nodeName] = node
                    return node
                } 
            }
        }
        return nil
    }
    
    func getModel(modelName:String) -> SCNNode? {
        return models[modelName]
    }
    
    func setLightProp(nodeName:String, propName: String, value: FREObject) {
        guard let node = findNode(withName: nodeName),
            let light = node.light
            else {
                return }
        light.setProp(name: propName, value: value)
    }
    
    func setMaterialProp(name:String, nodeName:String, propName: String, value: FREObject) {
        guard let node = findNode(withName: nodeName)
            else { return }
        if let mat = node.geometry?.material(named: name) {
            mat.setProp(name: propName, value: value)
        }
    }
    
    func setMaterialPropertyProp(id:String, nodeName:String, type:String, propName: String, value: FREObject) {
        trace("setMaterialPropertyProp id: \(id) nodeName: \(nodeName) type: \(type) propName: \(propName)")
        
        //handle lightingEnvironment
        
        guard let node = findNode(withName: nodeName)
            else { return }
        if let mat = node.geometry?.material(named: id) {
            mat.setMaterialPropertyProp(type: type, name: propName, value: value)
        } else if let mat = node.geometry?.firstMaterial {
            mat.name = id
            mat.setMaterialPropertyProp(type: type, name: propName, value: value)
        }
    }
    
    func setGeometryProp(type:String, nodeName:String, propName:String, value:FREObject) {
        if lastNodeRef?.name != nodeName {
            guard let node = findNode(withName: nodeName)
                else { return }
            lastNodeRef = node
        }
        switch type {
        case "box":
            //trace("node: \(nodeName) - setting property \(propName) of box to \(value.value.debugDescription)")
            if let geom:SCNBox = lastNodeRef?.geometry as? SCNBox {
                geom.setProp(name: propName, value: value)
            }
            break
        case "sphere":
            if let geom:SCNSphere = lastNodeRef?.geometry as? SCNSphere {
                geom.setProp(name: propName, value: value)
            }
            break
        case "capsule":
            if let geom:SCNCapsule = lastNodeRef?.geometry as? SCNCapsule {
                geom.setProp(name: propName, value: value)
            }
            break
        case "cone":
            if let geom:SCNCone = lastNodeRef?.geometry as? SCNCone {
                geom.setProp(name: propName, value: value)
            }
            break
        case "cylinder":
            if let geom:SCNCylinder = lastNodeRef?.geometry as? SCNCylinder {
                geom.setProp(name: propName, value: value)
            }
            break
        case "plane":
            if let geom:SCNPlane = lastNodeRef?.geometry as? SCNPlane {
                geom.setProp(name: propName, value: value)
            }
            break
        case "pyramid":
            if let geom:SCNPyramid = lastNodeRef?.geometry as? SCNPyramid {
                geom.setProp(name: propName, value: value)
            }
            break
        case "torus":
            if let geom:SCNTorus = lastNodeRef?.geometry as? SCNTorus {
                geom.setProp(name: propName, value: value)
            }
            break
        case "tube":
            if let geom:SCNTube = lastNodeRef?.geometry as? SCNTube {
                geom.setProp(name: propName, value: value)
            }
            break
        case "text":
            if let geom:SCNText = lastNodeRef?.geometry as? SCNText {
                geom.setProp(name: propName, value: value)
            }
            break
        case "geometry":
            trace("node: \(nodeName) - setting property \(propName) of geometry to \(value.value.debugDescription)")
            if let geom:SCNGeometry = lastNodeRef?.geometry {
                geom.setModelProp(name: propName, value: value)
            }
            break
        case "shape":
            if let geom:SCNShape = lastNodeRef?.geometry as? SCNShape {
                geom.setProp(name: propName, value: value)
            }
            break
        default:
            break
        }
    }
    
    func setScene3DProp(name: String, value: FREObject) {
        sceneView.setProp(name: name, value: value)
    }
    
    // MARK: - Hit Test
    
    func hitTest3D(touchPoint: CGPoint, types: Array<Int>) -> ARHitTestResult? {
        var typeSet:ARHitTestResult.ResultType = []
        for i in types {
            typeSet.formUnion(ARHitTestResult.ResultType.init(rawValue: UInt(i)))
        }
        if let hitTestResult = sceneView.hitTest(touchPoint, types: typeSet).first {
            return hitTestResult
        }
        return nil
    }
    
    // TODO fine tune HitTestOptions
    func hitTest(touchPoint: CGPoint, options:[SCNHitTestOption : Any]?) -> SCNHitTestResult? {
        if let hitTestResult = sceneView.hitTest(touchPoint, options: options).first {
            return hitTestResult
        }
        return nil
    }
    
    // MARK: - Actions
    
    func createAction(id: String, timingMode:Int) {
        let action = SCNAction.init()
        if let mode = SCNActionTimingMode.init(rawValue: timingMode) {
            action.timingMode = mode
        }
        actions[id] = action
    }
    
    func performAction(id: String, type: String, args: Any?...) {
        guard let action = actions[id]
            else { return }
        switch type {
        case "hide":
            actions[id] = SCNAction.hide()
            break
        case "unhide":
            actions[id] = SCNAction.unhide()
            break
        case "repeatForever":
            actions[id] = SCNAction.repeatForever(action)
            break
        case "rotateBy":
            if let x = args[0] as? CGFloat,
                let y = args[1] as? CGFloat,
                let z = args[2] as? CGFloat,
                let duration = args[3] as? Double {
                actions[id] = SCNAction.rotateBy(x: x, y: y, z: z, duration: duration)
            }
            break
        case "moveBy":
            if let to = args[0] as? SCNVector3,
                let duration = args[1] as? Double {
                actions[id] = SCNAction.move(by: to, duration: duration)
            }
            break
        case "moveTo":
            if let to = args[0] as? SCNVector3,
                let duration = args[1] as? Double {
                actions[id] = SCNAction.move(to: to, duration: duration)
            }
            break
        case "scaleBy":
            if let scale = args[0] as? CGFloat,
                let duration = args[1] as? Double {
                actions[id] = SCNAction.scale(by: scale, duration: duration)
            }
            break
        case "scaleTo":
            if let scale = args[0] as? CGFloat,
                let duration = args[1] as? Double {
                actions[id] = SCNAction.scale(to: scale, duration: duration)
            }
            break
        default:
            break
        }
    }
    
    func setActionProp(id:String, propName: String, value: FREObject){
        guard let action = actions[id]
            else { return }
        action.setProp(name: propName, value: value)
    }
    
    func runAction(id: String, nodeName: String) {
        guard let action = actions[id], let node = findNode(withName: nodeName)
            else { return }
        node.runAction(action)
    }
    
    func removeAllActions(nodeName: String) {
        guard let node = findNode(withName: nodeName)
            else { return }
        node.removeAllActions()
    }
    
    // MARK: - Physics
    
    func applyPhysicsForce(direction: SCNVector3, at: SCNVector3?, asImpulse: Bool, nodeName: String) {
        guard let node = findNode(withName: nodeName),
        let physicsBody = node.physicsBody
            else { return }
        if let at = at {
            physicsBody.applyForce(direction, at: at, asImpulse: asImpulse)
        } else {
            physicsBody.applyForce(direction, asImpulse: asImpulse)
        }
    }
    
    func applyPhysicsTorque(torque: SCNVector4,asImpulse: Bool, nodeName: String) {
        guard let node = findNode(withName: nodeName),
            let physicsBody = node.physicsBody
            else { return }
        physicsBody.applyTorque(torque, asImpulse: asImpulse)
    }
    
    // MARK: - AS Event Listeners
    
    func addEventListener(type: String) {
        asListeners.append(type)
        if type == AREvent.ON_SCENE3D_TAP {
            addTapGesture()
        }
        if type == AREvent.ON_SCENE3D_SWIPE_LEFT {
            addSwipeGestures(direction: .left)
        }
        if type == AREvent.ON_SCENE3D_SWIPE_RIGHT {
            addSwipeGestures(direction: .right)
        }
        if type == AREvent.ON_SCENE3D_SWIPE_UP {
            addSwipeGestures(direction: .up)
        }
        if type == AREvent.ON_SCENE3D_SWIPE_DOWN {
            addSwipeGestures(direction: .down)
        }
    }
    
    func removeEventListener(type: String) {
        asListeners = asListeners.filter({ $0 != type })
        if type == AREvent.ON_SCENE3D_TAP {
            removeTapGesture()
        }
        if type == AREvent.ON_SCENE3D_SWIPE_LEFT {
            removeSwipeGestures(direction: .left)
        }
        if type == AREvent.ON_SCENE3D_SWIPE_RIGHT {
            removeSwipeGestures(direction: .right)
        }
        if type == AREvent.ON_SCENE3D_SWIPE_UP {
            removeSwipeGestures(direction: .up)
        }
        if type == AREvent.ON_SCENE3D_SWIPE_DOWN {
            removeSwipeGestures(direction: .down)
        }
    }
    
    // MARK: - Gestures

    func addTapGesture() {
        tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(didTapAt(_:)))
        self.sceneView.addGestureRecognizer(tapGestureRecogniser!)
    }
    
    func removeTapGesture() {
        if let tg = tapGestureRecogniser {
            self.sceneView.removeGestureRecognizer(tg)
        }
    }
    
    //https://github.com/alexyu2000/SwipeGestureDemo/blob/master/SwipeGestureDemo/ViewController.swift
    func addSwipeGestures(direction: UISwipeGestureRecognizerDirection) {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeAt(_:)))
        gesture.direction = direction
        self.sceneView.addGestureRecognizer(gesture)
        swipeGestureRecognisers.append(gesture)
    }
    
    func removeSwipeGestures(direction: UISwipeGestureRecognizerDirection) {
        var cnt = 0
        for gesture in swipeGestureRecognisers {
            if gesture.direction == direction {
                self.sceneView.removeGestureRecognizer(gesture)
                swipeGestureRecognisers.remove(at: cnt)
                break
            }
            cnt = cnt + 1
        }
    }
    
    @objc internal func didSwipeAt(_ recogniser: UISwipeGestureRecognizer) {
        let touchPoint = recogniser.location(in: sceneView)
        var props = [String: Any]()
        props["x"] = touchPoint.x
        props["y"] = touchPoint.y
        props["direction"] = recogniser.direction.rawValue
        props["phase"] = recogniser.state.rawValue
        let json = JSON(props)
        var eventName:String = ""
        switch recogniser.direction {
        case .up:
            eventName = AREvent.ON_SCENE3D_SWIPE_UP
            break
        case .down:
            eventName = AREvent.ON_SCENE3D_SWIPE_DOWN
            break
        case .left:
            eventName = AREvent.ON_SCENE3D_SWIPE_LEFT
            break
        case .right:
            eventName = AREvent.ON_SCENE3D_SWIPE_RIGHT
            break
        default:
            break
        }
        sendEvent(name: eventName, value: json.description)
    }
    
    @objc internal func didTapAt(_ recogniser: UITapGestureRecognizer) {
        guard asListeners.contains(AREvent.ON_SCENE3D_TAP)
            else { return }
        let touchPoint = recogniser.location(in: sceneView)
        var props = [String: Any]()
        props["x"] = touchPoint.x
        props["y"] = touchPoint.y
        let json = JSON(props)
        sendEvent(name: AREvent.ON_SCENE3D_TAP, value: json.description)
    }
    
    
    // MARK: - Delegate methods
    
    deinit {
        //
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = viewPort
        self.view.addSubview(sceneView)
        sceneView.delegate = self
        if asListeners.contains(AREvent.ON_SCENE3D_TAP) {
           addTapGesture()
        }
        if asListeners.contains(AREvent.ON_SCENE3D_SWIPE_LEFT) {
            addSwipeGestures(direction: .left)
        }
        if asListeners.contains(AREvent.ON_SCENE3D_SWIPE_RIGHT) {
            addSwipeGestures(direction: .right)
        }
        if asListeners.contains(AREvent.ON_SCENE3D_SWIPE_UP) {
            addSwipeGestures(direction: .up)
        }
        if asListeners.contains(AREvent.ON_SCENE3D_SWIPE_DOWN) {
            addSwipeGestures(direction: .down)
        }
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//        guard let estimate = self.sceneView.session.currentFrame?.lightEstimate else {
//            return
//        }
//        // A value of 1000 is considered neutral, lighting environment intensity normalizes
//        // 1.0 to neutral so we need to scale the ambientIntensity value
//        let intensity = estimate.ambientIntensity / 1000.0
//        self.sceneView.scene.lightingEnvironment.intensity = intensity
//    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard asListeners.contains(AREvent.ON_PLANE_DETECTED), planeDetection,
            let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        
        node.name = UUID().uuidString
        var props = [String: Any]()
        props["anchor"] = [
            "alignment":0,
            "id":planeAnchor.identifier.uuidString,
            "center":["x":planeAnchor.center.x, "y":planeAnchor.center.y, "z":planeAnchor.center.z],
            "extent":["x":planeAnchor.extent.x, "y":planeAnchor.extent.y, "z":planeAnchor.extent.z],
            "transform":planeAnchor.transformAsArray
        ]
        props["node"] = ["id":node.name]
        let json = JSON(props)
        sendEvent(name: AREvent.ON_PLANE_DETECTED, value: json.description)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        //TODO
        guard asListeners.contains(AREvent.ON_PLANE_UPDATED),
            let planeAnchor = anchor as? ARPlaneAnchor
            else { return }
        var props = [String: Any]()
        props["anchor"] = [
            "alignment":0,
            "id":planeAnchor.identifier.uuidString,
            "center":["x":planeAnchor.center.x, "y":planeAnchor.center.y, "z":planeAnchor.center.z],
            "extent":["x":planeAnchor.extent.x, "y":planeAnchor.extent.y, "z":planeAnchor.extent.z],
            "transform":planeAnchor.transformAsArray
        ]
        props["nodeName"] = node.name
        let json = JSON(props)
        sendEvent(name: AREvent.ON_PLANE_UPDATED, value: json.description)
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
         //TODO
        
    }
    
    
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        guard asListeners.contains(AREvent.ON_CAMERA_TRACKING_STATE_CHANGE)
            else { return }
        var props = [String: Any]()
        switch camera.trackingState {
        case .notAvailable:
            props["state"] = 0
            props["reason"] = -1
            break
        case .normal:
            props["state"] = 1
            props["reason"] = -1
            break
        case .limited(let reason):
            props["state"] = 2
            switch reason {
            case .initializing:
                props["reason"] = 0
                break
            case .excessiveMotion:
                props["reason"] = 1
                break
            case .insufficientFeatures:
                props["reason"] = 2
                break
            }
            break
        }
        let json = JSON(props)
        sendEvent(name: AREvent.ON_CAMERA_TRACKING_STATE_CHANGE, value: json.description)
    }
    
    func dispose() {
        sceneView.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pauseSession()
    }
}

