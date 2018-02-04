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

class Scene3DVC: UIViewController, FreSwiftController {
    var TAG: String? = "Scene3DVC"
    var context: FreContextSwift!
    private var sceneView: AR3DView!
    private var viewPort: CGRect = CGRect.zero
    var planeDetection: Bool = false
    private var anchors: [String: ARAnchor] = Dictionary()
    private var models: [String: SCNNode] = Dictionary()
    private var actions: [String: SCNAction] = Dictionary()
    var listeners: [String] = []
    private var lastNodeRef: SCNNode? //used for fast access to last node referenced in AIR
    public weak var physicsDelegate: PhysicsDelegate!
    
    var focusSquare = FocusSquare()
    
    var screenCenter: CGPoint {
        let bounds = sceneView.bounds
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    /// A serial queue used to coordinate adding or removing nodes from the scene.
    let updateQueue = DispatchQueue(label: "com.tuarua.ARANE.serialSceneKitQueue")
    
    convenience init(context: FreContextSwift, frame: CGRect, arview: AR3DView,
                     listeners: [String], physicsListeners: [String]) {
        self.init()
        self.context = context
        self.viewPort = frame
        self.sceneView = arview
        self.listeners = listeners
        self.physicsDelegate = PhysicsDelegate.init(context: context, listeners: physicsListeners)
    }
    
    func setDebugOptions(options: [String]) {
        var debugOptions: SCNDebugOptions = []
        for option in options {
            debugOptions.formUnion(SCNDebugOptions(rawValue: UInt(option)!))
        }
        sceneView.debugOptions = debugOptions
    }
    
    // MARK: - Session
    
    func runSession(configuration: ARWorldTrackingConfiguration, options: [Int]) {
        planeDetection = configuration.planeDetection.rawValue > 0
        var runOptions: ARSession.RunOptions = []
        for i in options {
            runOptions.formUnion(ARSession.RunOptions(rawValue: UInt(i)))
        }
        //sceneView.session.delegate = (self as! ARSessionDelegate)
        sceneView.session.run(configuration, options: runOptions)
    }
    
    func pauseSession() {
        sceneView.session.pause()
    }
    
    // MARK: - Anchor
    
    func addAnchor(anchor: ARAnchor) {
        sceneView.session.add(anchor: anchor)
        anchors[anchor.identifier.uuidString] = anchor
    }
    
    func removeAnchor(id: String) {
        guard let anchor = anchors[id] else { return }
        sceneView.session.remove(anchor: anchor)
    }
    
    // MARK: - Nodes
    
    private func findNode(withName: String, recursively: Bool = true) -> SCNNode? {
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
    
    func removeFromParentNode(nodeName: String) {
        if lastNodeRef?.name != nodeName {
            guard let node = findNode(withName: nodeName)
                else { return }
            lastNodeRef = node
        }
        lastNodeRef?.removeFromParentNode()
    }
    
    func removeChildNodes(nodeName: String) {
        if lastNodeRef?.name != nodeName {
            guard let node = findNode(withName: nodeName)
                else { return }
            lastNodeRef = node
        }
        lastNodeRef?.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
    }
    
    func setChildNodeProp(nodeName: String, propName: String, value: FREObject) {
        if lastNodeRef?.name != nodeName {
            guard let node = findNode(withName: nodeName)
                else { return }
            lastNodeRef = node
        }
        //trace("setChildNodeProp nodeName: \(nodeName) propName: \(propName)")
        lastNodeRef?.setProp(name: propName, value: value)
    }
    
    func getChildNode(parentName: String?, nodeName: String) -> SCNNode? {
        if lastNodeRef?.name != nodeName {
            var parentNode: SCNNode?
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
    
    func addModel(url: String, nodeName: String?, flatten: Bool) -> SCNNode? {
        if let scene = SCNScene(named: url) {
            if let nodeName = nodeName,
                let node = scene.rootNode.childNode(withName: nodeName, recursively: false) {
                if flatten {
                    let flattened = node.flattenedClone()
                    models[nodeName] = flattened
                    return flattened
                } else {
                    models[nodeName] = node
                    return node
                } 
            } else {
                if scene.rootNode.childNodes.count > 0 {
                    let node = scene.rootNode.childNodes[0]
                    if let nodeName = node.name {
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
            }
        }
        return nil
    }
    
    func getModel(modelName: String) -> SCNNode? {
        return models[modelName]
    }
    
    func setLightProp(nodeName: String, propName: String, value: FREObject) {
        guard let node = findNode(withName: nodeName),
            let light = node.light
            else {
                return }
        light.setProp(name: propName, value: value)
    }
    
    func setMaterialProp(name: String, nodeName: String, propName: String, value: FREObject) {
        guard let node = findNode(withName: nodeName)
            else { return }
        if let mat = node.geometry?.material(named: name) {
            mat.setProp(name: propName, value: value)
        }
    }
    
    func setMaterialPropertyProp(id: String, nodeName: String, type: String, propName: String, value: FREObject) {
        // TODO handle lightingEnvironment
        
        guard let node = findNode(withName: nodeName)
            else { return }
        if let mat = node.geometry?.material(named: id) {
            mat.setMaterialPropertyProp(type: type, name: propName, value: value)
        } else if let mat = node.geometry?.firstMaterial {
            mat.name = id
            mat.setMaterialPropertyProp(type: type, name: propName, value: value)
        }
    }
    
    func setGeometryProp(type: String, nodeName: String, propName: String, value: FREObject) {
        if lastNodeRef?.name != nodeName {
            guard let node = findNode(withName: nodeName)
                else { return }
            lastNodeRef = node
        }
        switch type {
        case "box":
            //trace("node: \(nodeName) - setting property \(propName) of box to \(value.value.debugDescription)")
            if let geom: SCNBox = lastNodeRef?.geometry as? SCNBox {
                geom.setProp(name: propName, value: value)
            }
        case "sphere":
            if let geom: SCNSphere = lastNodeRef?.geometry as? SCNSphere {
                geom.setProp(name: propName, value: value)
            }
        case "capsule":
            if let geom: SCNCapsule = lastNodeRef?.geometry as? SCNCapsule {
                geom.setProp(name: propName, value: value)
            }
        case "cone":
            if let geom: SCNCone = lastNodeRef?.geometry as? SCNCone {
                geom.setProp(name: propName, value: value)
            }
        case "cylinder":
            if let geom: SCNCylinder = lastNodeRef?.geometry as? SCNCylinder {
                geom.setProp(name: propName, value: value)
            }
        case "plane":
            if let geom: SCNPlane = lastNodeRef?.geometry as? SCNPlane {
                geom.setProp(name: propName, value: value)
            }
        case "pyramid":
            if let geom: SCNPyramid = lastNodeRef?.geometry as? SCNPyramid {
                geom.setProp(name: propName, value: value)
            }
        case "torus":
            if let geom: SCNTorus = lastNodeRef?.geometry as? SCNTorus {
                geom.setProp(name: propName, value: value)
            }
        case "tube":
            if let geom: SCNTube = lastNodeRef?.geometry as? SCNTube {
                geom.setProp(name: propName, value: value)
            }
        case "text":
            if let geom: SCNText = lastNodeRef?.geometry as? SCNText {
                geom.setProp(name: propName, value: value)
            }
        case "geometry":
            //trace("node: \(nodeName) - setting property \(propName) of geometry to \(value.value.debugDescription)")
            if let geom: SCNGeometry = lastNodeRef?.geometry {
                geom.setModelProp(name: propName, value: value)
            }
        case "shape":
            if let geom: SCNShape = lastNodeRef?.geometry as? SCNShape {
                geom.setProp(name: propName, value: value)
            }
        default:
            break
        }
    }
    
    func setScene3DProp(name: String, value: FREObject) {
        sceneView.setProp(name: name, value: value)
    }
    
    func getCameraPointOfView() -> SCNVector3? {
        guard let pointOfView = sceneView.pointOfView else { return nil}
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        return orientation + location
    }
    
    func isNodeInsidePointOfView(nodeName: String) -> Bool {
        if lastNodeRef?.name != nodeName {
            guard let node = findNode(withName: nodeName)
                else { return false }
            lastNodeRef = node
        }
        if let nde = lastNodeRef {
            return sceneView.isNode(nde, insideFrustumOf: sceneView.pointOfView!)
        }
        return false
    }
    
    // MARK: - Hit Test
    
    func hitTest3D(touchPoint: CGPoint, types: [Int]) -> ARHitTestResult? {
        var typeSet: ARHitTestResult.ResultType = []
        for i in types {
            typeSet.formUnion(ARHitTestResult.ResultType(rawValue: UInt(i)))
        }
        let result = sceneView.hitTest(touchPoint, types: typeSet)
        if result.isEmpty {
            return nil
        }
        return result.first
    }
    
    func hitTest(touchPoint: CGPoint, options: [SCNHitTestOption: Any]?) -> SCNHitTestResult? {
        let result = sceneView.hitTest(touchPoint, options: options)
        if result.isEmpty {
            return nil
        }
        return result.first
    }
    
    // MARK: - Actions
    
    func createAction(id: String, timingMode: Int) {
        let action = SCNAction()
        if let mode = SCNActionTimingMode(rawValue: timingMode) {
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
        case "unhide":
            actions[id] = SCNAction.unhide()
        case "repeatForever":
            actions[id] = SCNAction.repeatForever(action)
        case "rotateBy":
            if let x = args[0] as? CGFloat,
                let y = args[1] as? CGFloat,
                let z = args[2] as? CGFloat,
                let duration = args[3] as? Double {
                actions[id] = SCNAction.rotateBy(x: x, y: y, z: z, duration: duration)
            }
        case "moveBy":
            if let to = args[0] as? SCNVector3,
                let duration = args[1] as? Double {
                actions[id] = SCNAction.move(by: to, duration: duration)
            }
        case "moveTo":
            if let to = args[0] as? SCNVector3,
                let duration = args[1] as? Double {
                actions[id] = SCNAction.move(to: to, duration: duration)
            }
        case "scaleBy":
            if let scale = args[0] as? CGFloat,
                let duration = args[1] as? Double {
                actions[id] = SCNAction.scale(by: scale, duration: duration)
            }
        case "scaleTo":
            if let scale = args[0] as? CGFloat,
                let duration = args[1] as? Double {
                actions[id] = SCNAction.scale(to: scale, duration: duration)
            }
        default:
            break
        }
    }
    
    func setActionProp(id: String, propName: String, value: FREObject) {
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
    
    func applyPhysicsTorque(torque: SCNVector4, asImpulse: Bool, nodeName: String) {
        guard let node = findNode(withName: nodeName),
            let physicsBody = node.physicsBody
            else { return }
        physicsBody.applyTorque(torque, asImpulse: asImpulse)
    }
    
    // MARK: - AS Event Listeners
    
    func addEventListener(type: String) {
        listeners.append(type)
    }
    
    func removeEventListener(type: String) {
        listeners = listeners.filter({ $0 != type })
    }
    
    // MARK: - Focus Square
    
    func updateFocusSquare() {
        // let isObjectVisible = virtualObjectLoader.loadedObjects.contains { object in
            // return sceneView.isNode(object, insideFrustumOf: sceneView.pointOfView!)
        // }
        
        // if isObjectVisible {
            // focusSquare.hide()
        // } else {
            focusSquare.unhide()
            // statusViewController.scheduleMessage("TRY MOVING LEFT OR RIGHT",
        // inSeconds: 5.0, messageType: .focusSquare)
        // }
        
        //sceneView.isNode(<#T##node: SCNNode##SCNNode#>, insideFrustumOf: <#T##SCNNode#>)
        
        // We should always have a valid world position unless the sceen is just being initialized.
        guard let (worldPosition, planeAnchor, _) = sceneView.worldPosition(
            fromScreenPosition: screenCenter, objectPosition: focusSquare.lastPosition
            ) else {
            updateQueue.async {
                self.focusSquare.state = .initializing
                self.sceneView.pointOfView?.addChildNode(self.focusSquare)
            }
            // addObjectButton.isHidden = true
            return
        }
        
        updateQueue.async {
            self.sceneView.scene.rootNode.addChildNode(self.focusSquare)
            let camera = self.sceneView.session.currentFrame?.camera
            
            if let planeAnchor = planeAnchor {
                self.focusSquare.state = .planeDetected(anchorPosition: worldPosition,
                                                        planeAnchor: planeAnchor,
                                                        camera: camera)
            } else {
                self.focusSquare.state = .featuresDetected(anchorPosition: worldPosition, camera: camera)
            }
        }
        // addObjectButton.isHidden = false
        // statusViewController.cancelScheduledMessage(for: .focusSquare)
    }
    
    func dispose() {
        sceneView.removeFromSuperview()
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        pauseSession()
    }
    
    // MARK: - Delegate methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = viewPort
        self.view.addSubview(sceneView)
        sceneView.delegate = self
        sceneView.scene.physicsWorld.contactDelegate = physicsDelegate
        sceneView.scene.rootNode.addChildNode(focusSquare)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Prevent the screen from being dimmed to avoid interuppting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pauseSession()
    }
}
