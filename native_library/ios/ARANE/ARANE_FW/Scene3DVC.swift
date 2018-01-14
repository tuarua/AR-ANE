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
    
    convenience init(context: FreContextSwift, frame: CGRect, arview: ARSCNView) {
        self.init()
        self.context = context
        self.viewPort = frame
        self.sceneView = arview
    }
    
    @objc internal func didTapAt(_ recogniser: UITapGestureRecognizer) {
        trace("did Tap at")
        let touchPoint = recogniser.location(in: sceneView)
        var props = [String: Any]()
        props["x"] = touchPoint.x
        props["y"] = touchPoint.y
        let json = JSON(props)
        sendEvent(name: AREvent.ON_SCENE3D_TAP, value: json.description)
    }
    
    func getModel(modelName:String) -> SCNNode? {
        return models[modelName]
    }
    
    // TODO
    func setupCamera() {
        guard let camera = sceneView.pointOfView?.camera else {
            trace("Expected a valid `pointOfView` from the scene.")
            return
        }
        
        /*
         Enable HDR camera settings for the most realistic appearance
         with environmental lighting and physically based materials.
         */
        camera.wantsHDR = true
        camera.exposureOffset = -1
        camera.minimumExposure = -1
        camera.maximumExposure = 3
        
        trace(camera.debugDescription)
        
    }
    
    
    
    func setDebugOptions(options: Array<String>) {
        var debugOptions:SCNDebugOptions = []
        for option in options {
            debugOptions.formUnion(SCNDebugOptions.init(rawValue: UInt(option)!))
        }
        sceneView.debugOptions = debugOptions
    }
    
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
    
    func addAnchor(anchor:ARAnchor) {
        sceneView.session.add(anchor: anchor)
        anchors[anchor.identifier.uuidString] = anchor
    }
    
    func removeAnchor(id:String) {
        guard let anchor = anchors[id] else { return }
        sceneView.session.remove(anchor: anchor)
    }
    
    func addChildNode(parentName: String?, node: SCNNode) {
        if let pId = parentName,
            let pNode = sceneView.scene.rootNode.childNode(withName: pId, recursively: true) {
            pNode.addChildNode(node)
        } else {
        
            trace("adding childNode to root", node.debugDescription)
            sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    func removeFromParentNode(name:String) {
        guard let node = sceneView.scene.rootNode.childNode(withName: name, recursively: true)
            else { return }
        node.removeFromParentNode()
    }
    
    func setChildNodeProp(nodeName:String, propName: String, value: FREObject) {
        guard let node = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true)
            else { return }
        trace("setChildNodeProp nodeName: \(nodeName) propName: \(propName)")
        node.setProp(name: propName, value: value)
    }
    
    func getChildNode(parentName:String?, nodeName:String) -> SCNNode? {
        var parentNode:SCNNode?
        if parentName == "root" {
            parentNode = sceneView.scene.rootNode
        } else {
            if let pn = parentName {
                parentNode = sceneView.scene.rootNode.childNode(withName: pn, recursively: true)
            }
        }
        return parentNode?.childNode(withName: nodeName, recursively: true)
    }
    
    func addModel(url: String, nodeName: String?) -> SCNNode? {
        if let scene = SCNScene.init(named: url) {
            if let nodeName = nodeName,
                let node = scene.rootNode.childNode(withName: nodeName, recursively: true) {
                models[nodeName] = node
                return node
            }
        }
        return nil
    }
    
    func setLightProp(nodeName:String, propName: String, value: FREObject) {
        guard let node = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true),
            let light = node.light
            else {
                return }
        light.setProp(name: propName, value: value)
    }
    
    func setMaterialProp(name:String, nodeName:String, propName: String, value: FREObject) {
        guard let node = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true)
            else { return }
        if let mat = node.geometry?.material(named: name) {
            mat.setProp(name: propName, value: value)
        }
    }
    
    func setMaterialPropertyProp(id:String, nodeName:String, type:String, propName: String, value: FREObject) {
        trace("setMaterialPropertyProp id: \(id) nodeName: \(nodeName) type: \(type) propName: \(propName)")
        guard let node = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true)
            else { return }
        if let mat = node.geometry?.material(named: id) {
            mat.setMaterialPropertyProp(type: type, name: propName, value: value)
        } else if let mat = node.geometry?.firstMaterial {
            mat.name = id
            mat.setMaterialPropertyProp(type: type, name: propName, value: value)
        }
    }
    
    func setGeometryProp(type:String, nodeName:String, propName:String, value:FREObject) {
        guard let node = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true)
            else { return }
        
        switch type {
        case "box":
            trace("node: \(nodeName) - setting property \(propName) of box to \(value.value.debugDescription)")
            if let geom:SCNBox = node.geometry as? SCNBox {
                geom.setProp(name: propName, value: value)
            }
            break
        case "sphere":
            trace("node: \(nodeName) - setting property \(propName) of sphere to \(value.value.debugDescription)")
            if let geom:SCNSphere = node.geometry as? SCNSphere {
                geom.setProp(name: propName, value: value)
            }
            break
        case "capsule":
            trace("node: \(nodeName) - setting property \(propName) of capsule to \(value.value.debugDescription)")
            if let geom:SCNCapsule = node.geometry as? SCNCapsule {
                geom.setProp(name: propName, value: value)
            }
            break
        case "cone":
            trace("node: \(nodeName) - setting property \(propName) of cone to \(value.value.debugDescription)")
            if let geom:SCNCone = node.geometry as? SCNCone {
                geom.setProp(name: propName, value: value)
            }
            break
        case "cylinder":
            trace("node: \(nodeName) - setting property \(propName) of cylinder to \(value.value.debugDescription)")
            if let geom:SCNCylinder = node.geometry as? SCNCylinder {
                geom.setProp(name: propName, value: value)
            }
            break
        case "plane":
            trace("node: \(nodeName) - setting property \(propName) of plane to \(value.value.debugDescription)")
            if let geom:SCNPlane = node.geometry as? SCNPlane {
                geom.setProp(name: propName, value: value)
            }
            break
        case "pyramid":
            trace("node: \(nodeName) - setting property \(propName) of pyramid to \(value.value.debugDescription)")
            if let geom:SCNPyramid = node.geometry as? SCNPyramid {
                geom.setProp(name: propName, value: value)
            }
            break
        case "torus":
            trace("node: \(nodeName) - setting property \(propName) of torus to \(value.value.debugDescription)")
            if let geom:SCNTorus = node.geometry as? SCNTorus {
                geom.setProp(name: propName, value: value)
            }
            break
        case "tube":
            trace("node: \(nodeName) - setting property \(propName) of tube to \(value.value.debugDescription)")
            if let geom:SCNTube = node.geometry as? SCNTube {
                geom.setProp(name: propName, value: value)
            }
            break
        case "text":
            trace("node: \(nodeName) - setting property \(propName) of text to \(value.value.debugDescription)")
            if let geom:SCNText = node.geometry as? SCNText {
                geom.setProp(name: propName, value: value)
            }
            break
        case "geometry":
            trace("node: \(nodeName) - setting property \(propName) of geometry to \(value.value.debugDescription)")
            if let geom:SCNGeometry = node.geometry {
                geom.setModelProp(name: propName, value: value)
            }
            break
        case "shape":
            trace("node: \(nodeName) - setting property \(propName) of shape to \(value.value.debugDescription)")
            if let geom:SCNShape = node.geometry as? SCNShape {
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
        guard let action = actions[id], let node = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true)
            else { return }
        node.runAction(action)
    }
    
    func removeAllActions(nodeName: String) {
        guard let node = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true)
            else { return }
        node.removeAllActions()
    }
    
    // MARK: - Physics
    
    func applyPhysicsForce(direction: SCNVector3, at: SCNVector3?, asImpulse: Bool, nodeName: String) {
        guard let node = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true),
        let physicsBody = node.physicsBody
            else { return }
        if let at = at {
            physicsBody.applyForce(direction, at: at, asImpulse: asImpulse)
        } else {
            physicsBody.applyForce(direction, asImpulse: asImpulse)
        }
    }
    
    func applyPhysicsTorque(torque: SCNVector4,asImpulse: Bool, nodeName: String) {
        guard let node = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true),
            let physicsBody = node.physicsBody
            else { return }
        physicsBody.applyTorque(torque, asImpulse: asImpulse)
    }
    
    // MARK: - Delegate methods
    
    deinit {
        //
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(didTapAt(_:)))
        self.sceneView.addGestureRecognizer(tapGestureRecogniser!)
        
        self.view.frame = viewPort
        self.view.addSubview(sceneView)
        sceneView.delegate = self
        
        // setupCamera()
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard planeDetection, let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        node.name = UUID().uuidString
        var props = [String: Any]()
        props["anchor"] = [
            "alignment":0,
            "id":planeAnchor.identifier.uuidString,
            "center":["x":planeAnchor.center.x,"y":planeAnchor.center.y,"z":planeAnchor.center.z],
            "extent":["x":planeAnchor.extent.x,"y":planeAnchor.extent.y,"z":planeAnchor.extent.z],
            "transform":planeAnchor.transformAsArray
        ]
        props["node"] = ["id":node.name]
        let json = JSON(props)
        sendEvent(name: AREvent.ON_PLANE_DETECTED, value: json.description)
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        guard let planeAnchor = anchor as?  ARPlaneAnchor,
//            var planeNode = node.childNodes.first,
//            let plane = planeNode.geometry as? SCNPlane
//            else { return }
//
//        trace("************UPDATE************")
//        trace("type", planeNode.physicsBody?.type.rawValue)
//        trace("******************************")
//    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        trace(camera.trackingState)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pauseSession()
    }
}

