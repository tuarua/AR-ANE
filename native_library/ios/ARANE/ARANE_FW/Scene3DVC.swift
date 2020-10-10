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
import SwiftyJSON

class Scene3DVC: UIViewController, FreSwiftController {
    static var TAG = "Scene3DVC"
    var context: FreContextSwift!
    private var sceneView: AR3DView!
    private var viewPort = CGRect.zero
    var hasPlaneDetection = false
    private var anchors = [String: ARAnchor]()
    var planeAnchors = [String: ARAnchor]()
    private var models = [String: SCNNode]()
    private var actions = [String: SCNAction]()
    private var vehicles = [String: SCNPhysicsVehicle]()
    var listeners: [String] = []
    private var lastNodeRef: SCNNode? //used for fast access to last node referenced in AIR
    
    var focusSquare: FocusSquare?
    var focusSquareEnabled = false
    var screenCenter: CGPoint {
        let bounds = sceneView.bounds
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private var session: ARSession {
        return sceneView.session
    }
    
    private var _lastRaycastResult: Any?
    @available(iOS 13.0, *)
    var lastTrackedRaycast: [ARRaycastResult] {
        return _lastRaycastResult as? [ARRaycastResult] ?? []
    }
    
    private var _trackedRaycasts: [String: Any?]?
    @available(iOS 13.0, *)
    var trackedRaycasts: [String: ARTrackedRaycast?] {
        return _trackedRaycasts as? [String: ARTrackedRaycast?] ?? [:]
    }
    
    private var _coachingOverlay: Any?
    @available(iOS 13.0, *)
    var coachingOverlay: ARCoachingOverlayView? {
        return _coachingOverlay as? ARCoachingOverlayView
    }
    
    /// A serial queue used to coordinate adding or removing nodes from the scene.
    let updateQueue = DispatchQueue(label: "com.tuarua.arkit.serialSceneKitQueue")
    
    convenience init(context: FreContextSwift, frame: CGRect, arview: AR3DView,
                     listeners: [String], focusSquareSettings: FocusSquareSettings?) {
        self.init()
        self.context = context
        self.viewPort = frame
        self.sceneView = arview
        self.listeners = listeners
        
        if let focusSquareSettings = focusSquareSettings {
            focusSquare = FocusSquare(primaryColor: focusSquareSettings.primaryColor,
                                      fillColor: focusSquareSettings.fillColor)
            focusSquareEnabled = focusSquareSettings.enabled
        }
    }
    
    func ar3dview_debugOptions(options: [String]) {
        var debugOptions: SCNDebugOptions = []
        for option in options {
            debugOptions.formUnion(SCNDebugOptions(rawValue: UInt(option)!))
        }
        sceneView.debugOptions = debugOptions
    }
    
    // MARK: - Session
    
    func session_run(configuration: ARWorldTrackingConfiguration, options: [Int]) {
        hasPlaneDetection = configuration.planeDetection.rawValue > 0
        var runOptions: ARSession.RunOptions = []
        for i in options {
            runOptions.formUnion(ARSession.RunOptions(rawValue: UInt(i)))
        }
        session.run(configuration, options: runOptions)
    }
    
    @available(iOS 12.0, *)
    func session_run(configuration: ARObjectScanningConfiguration, options: [Int]) {
        hasPlaneDetection = configuration.planeDetection.rawValue > 0
        var runOptions: ARSession.RunOptions = []
        for i in options {
            runOptions.formUnion(ARSession.RunOptions(rawValue: UInt(i)))
        }
        session.run(configuration, options: runOptions)
    }
    
    @available(iOS 12.0, *)
    func session_run(configuration: ARImageTrackingConfiguration, options: [Int]) {
        hasPlaneDetection = false
        var runOptions: ARSession.RunOptions = []
        for i in options {
            runOptions.formUnion(ARSession.RunOptions(rawValue: UInt(i)))
        }
        session.run(configuration, options: runOptions)
    }
    
    @available(iOS 13.0, *)
    func session_run(configuration: ARPositionalTrackingConfiguration, options: [Int]) {
        hasPlaneDetection = false
        var runOptions: ARSession.RunOptions = []
        for i in options {
            runOptions.formUnion(ARSession.RunOptions(rawValue: UInt(i)))
        }
        session.run(configuration, options: runOptions)
    }
    
    @available(iOS 13.0, *)
    func session_run(configuration: ARBodyTrackingConfiguration, options: [Int]) {
        hasPlaneDetection = false
        var runOptions: ARSession.RunOptions = []
        for i in options {
            runOptions.formUnion(ARSession.RunOptions(rawValue: UInt(i)))
        }
        session.run(configuration, options: runOptions)
    }
     
    func session_pause() {
        session.pause()
    }
    
    @available(iOS 11.3, *)
    func session_setWorldOrigin(relativeTransform: matrix_float4x4) {
        session.setWorldOrigin(relativeTransform: relativeTransform)
    }
    
    @available(iOS 12.0, *)
    func session_saveCurrentWorldMap(callbackId: String, url: URL) {
        // https://appcoda.com/arkit-persistence/
        session.getCurrentWorldMap { map, error in
            var props = [String: Any]()
            props["callbackId"] = callbackId
            
            if let err = error {
                var errDict = [String: Any]()
                errDict["text"] = err.localizedDescription
                errDict["id"] = 0
                props["error"] = errDict
                self.dispatchEvent(name: AREvent.ON_CURRENT_WORLDMAP, value: JSON(props).description)
                return
            }
            
            guard let map = map else { return }
            do {
                try self.archiveARWorldMap(worldMapURL: url, worldMap: map)
            } catch let e {
                var errDict = [String: Any]()
                errDict["text"] = e.localizedDescription
                errDict["id"] = 0
                props["error"] = errDict
            }
            self.dispatchEvent(name: AREvent.ON_CURRENT_WORLDMAP, value: JSON(props).description)
        }
    }
    
    @available(iOS 12.0, *)
    func session_createReferenceObject(transform: simd_float4x4, center: simd_float3, extent: simd_float3,
                                       callbackId: String) {
        session.createReferenceObject(transform: transform,
                                      center: center, extent: extent) { _, error in
            var props = [String: Any]()
            props["callbackId"] = callbackId
            if let err = error {
                props["error"] = ["text": err.localizedDescription, "id": 0]
            }
            self.dispatchEvent(name: AREvent.ON_REFERENCE_OBJECT, value: JSON(props).description)
        }
    }
    
    @available(iOS 14.0, *)
    func session_geoLocation(position: simd_float3, callbackId: String) {
        session.getGeoLocation(forPoint: position) { (coordinate, altitude, error) in
            var props = [String: Any]()
            props["callbackId"] = callbackId
            props["coordinate"] = ["latitude": coordinate.latitude,
                                   "longitude": coordinate.longitude]
            props["altitude"] = altitude
            
            if let err = error {
                props["error"] = ["text": err.localizedDescription, "id": 0]
            }
            self.dispatchEvent(name: AREvent.ON_GET_GEO_LOCATION, value: JSON(props).description)
        }
    }
    
    // MARK: - WorldMap
    @available(iOS 12.0, *)
    private func archiveARWorldMap(worldMapURL: URL, worldMap: ARWorldMap) throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: worldMap, requiringSecureCoding: true)
        try data.write(to: worldMapURL, options: [.atomic])
    }
    
    // MARK: - Anchor
    
    func session_add(anchor: ARAnchor) {
        session.add(anchor: anchor)
        anchors[anchor.identifier.uuidString] = anchor
    }
    
    func session_remove(id: String) {
        guard let anchor = anchors[id] else { return }
        session.remove(anchor: anchor)
        anchors.removeValue(forKey: id)
    }
    
    @available(iOS 13.0, *)
    func session_identifier() -> String {
        return session.identifier.uuidString
    }
    
    @available(iOS 13.0, *)
    func session_raycast(query: ARRaycastQuery) -> [ARRaycastResult] {
        return session.raycast(query)
    }
    
    @available(iOS 13.0, *)
    func session_trackedRaycast(query: ARRaycastQuery, callbackId: String) -> ARTrackedRaycast? {
        let ret = session.trackedRaycast(query) { result in
            self._lastRaycastResult = result
            self.dispatchEvent(name: AREvent.ON_TRACKED_RAYCAST, value: callbackId)
        }
        _trackedRaycasts?[callbackId] = ret
        return ret
    }
    
    // MARK: - Nodes
    
    private func findNode(withName: String, recursively: Bool = true) -> SCNNode? {
        return sceneView.scene.rootNode.childNode(withName: withName, recursively: true)
    }

    func node_addChildNode(parentName: String?, node: SCNNode) {
        lastNodeRef = node
        updateQueue.async {
            if let nodeName = parentName,
                let pNode = self.findNode(withName: nodeName) {
                    pNode.addChildNode(node)
            } else {
                self.sceneView.scene.rootNode.addChildNode(node)
            }
        }
    }
    
    func node_removeFromParentNode(nodeName: String) {
        if lastNodeRef?.name != nodeName {
            guard let node = findNode(withName: nodeName)
                else { return }
            lastNodeRef = node
        }
        lastNodeRef?.removeFromParentNode()
    }
    
    func node_removeChildren(nodeName: String) {
        if lastNodeRef?.name != nodeName {
            guard let node = findNode(withName: nodeName)
                else { return }
            lastNodeRef = node
        }
        lastNodeRef?.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
    }
    
    func node_setProp(nodeName: String, propName: String, value: FREObject) {
        if lastNodeRef?.name != nodeName {
            guard let node = findNode(withName: nodeName)
                else { return }
            lastNodeRef = node
        }
        lastNodeRef?.setProp(name: propName, value: value)
    }
    
    func node_childNode(parentName: String?, nodeName: String) -> SCNNode? {
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
                let node = scene.rootNode
                let nodeName = node.name ?? UUID().uuidString
                node.name = nodeName
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
    
    func getModel(modelName: String) -> SCNNode? {
        return models[modelName]
    }
    
    func light_setProp(nodeName: String, propName: String, value: FREObject) {
        guard let node = findNode(withName: nodeName),
            let light = node.light
            else {
                return }
        light.setProp(name: propName, value: value)
    }
    
    func material_setProp(name: String, nodeName: String, propName: String, value: FREObject) {
        guard let node = findNode(withName: nodeName)
            else { return }
        if let mat = node.geometry?.material(named: name) {
            mat.setProp(name: propName, value: value)
        }
    }
    
    func materialProperty_setProp(id: String, nodeName: String, type: String, propName: String, value: FREObject) {
        guard let node = findNode(withName: nodeName)
            else { return }
        if let mat = node.geometry?.material(named: id) {
            mat.setMaterialPropertyProp(type: type, name: propName, value: value, queue: updateQueue)
        } else if let mat = node.geometry?.firstMaterial {
            mat.name = id
            mat.setMaterialPropertyProp(type: type, name: propName, value: value, queue: updateQueue)
        }
    }
    
    func geometry_setProp(type: String, nodeName: String, propName: String, value: FREObject) {
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
    
    func ar3dview_setProp(name: String, value: FREObject) {
        sceneView.setProp(name: name, value: value)
    }
    
    func ar3dview_node(id: String) -> SCNNode? {
        guard let anchor = planeAnchors[id] else { return nil }
        return sceneView.node(for: anchor)
    }
    
    func camera_position() -> SCNVector3? {
        guard let pointOfView = sceneView.pointOfView else { return nil}
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        return orientation + location
    }
    
    func ar3dview_isNodeInsidePointOfView(nodeName: String) -> Bool {
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
    
    func ar3dview_hitTest3D(touchPoint: CGPoint, types: [Int]) -> ARHitTestResult? {
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
    
    func ar3dview_hitTest(touchPoint: CGPoint, options: [SCNHitTestOption: Any]?) -> SCNHitTestResult? {
        let result = sceneView.hitTest(touchPoint, options: options)
        if result.isEmpty {
            return nil
        }
        return result.first
    }
    
    @available(iOS 13.0, *)
    func ar3dview_raycastQuery(from: CGPoint, allowing: ARRaycastQuery.Target,
                               alignment: ARRaycastQuery.TargetAlignment) -> ARRaycastQuery? {
        return sceneView.raycastQuery(from: from, allowing: allowing, alignment: alignment)
    }
    
    // MARK: - Actions
    
    func action_create(id: String, timingMode: Int) {
        let action = SCNAction()
        if let mode = SCNActionTimingMode(rawValue: timingMode) {
            action.timingMode = mode
        }
        actions[id] = action
    }

    func action_perform(id: String, type: String, args: Any?...) {
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
    
    func action_setProp(id: String, propName: String, value: FREObject) {
        guard let action = actions[id]
            else { return }
        action.setProp(name: propName, value: value)
    }
    
    func node_runAction(id: String, nodeName: String) {
        guard let action = actions[id], let node = findNode(withName: nodeName)
            else { return }
        node.runAction(action)
    }
    
    func node_removeAllActions(nodeName: String) {
        guard let node = findNode(withName: nodeName)
            else { return }
        node.removeAllActions()
    }
    
    // MARK: - Physics
    
    func physics_applyForce(direction: SCNVector3, at: SCNVector3?, asImpulse: Bool, nodeName: String) {
        guard let node = findNode(withName: nodeName),
        let physicsBody = node.physicsBody
            else { return }
        if let at = at {
            physicsBody.applyForce(direction, at: at, asImpulse: asImpulse)
        } else {
            physicsBody.applyForce(direction, asImpulse: asImpulse)
        }
    }
    
    func physics_applyTorque(torque: SCNVector4, asImpulse: Bool, nodeName: String) {
        guard let node = findNode(withName: nodeName),
            let physicsBody = node.physicsBody
            else { return }
        physicsBody.applyTorque(torque, asImpulse: asImpulse)
    }
    
    func physics_clearAllForces(nodeName: String) {
        guard let node = findNode(withName: nodeName),
            let physicsBody = node.physicsBody
            else { return }
        physicsBody.clearAllForces()
    }
    
    func physics_resetTransform(nodeName: String) {
        guard let node = findNode(withName: nodeName),
            let physicsBody = node.physicsBody
            else { return }
        physicsBody.resetTransform()
    }
    
    @available(iOS 12.0, *)
    func physics_setResting(resting: Bool, nodeName: String) {
        guard let node = findNode(withName: nodeName),
            let physicsBody = node.physicsBody
            else { return }
        physicsBody.setResting(resting)
    }
    
    func physicsWorld_addBehaviour(behavior: SCNPhysicsBehavior) {
        sceneView.scene.physicsWorld.addBehavior(behavior)
    }
    
    // MARK: Physics Vehicle
    
    func vehicle_create(vehicle: SCNPhysicsVehicle) -> String {
        let id = UUID().uuidString
        vehicles[id] = vehicle
        return id
    }
    
    func vehicle_speedInKilometersPerHour(id: String) -> CGFloat? {
        return vehicles[id]?.speedInKilometersPerHour
    }
    
    func vehicle_applyEngineForce(id: String, value: CGFloat, forWheelAt: Int) {
        vehicles[id]?.applyEngineForce(value, forWheelAt: forWheelAt)
    }
    
    func vehicle_applyBrakingForce(id: String, value: CGFloat, forWheelAt: Int) {
        vehicles[id]?.applyBrakingForce(value, forWheelAt: forWheelAt)
    }
    
    func vehicle_setSteeringAngle(id: String, value: CGFloat, forWheelAt: Int) {
        trace(vehicles[id].debugDescription)
        trace(value, forWheelAt)
        vehicles[id]?.setSteeringAngle(value, forWheelAt: forWheelAt)
    }
    
    // MARK: - AS Event Listeners
    
    func addEventListener(type: String) {
        listeners.append(type)
    }
    
    func removeEventListener(type: String) {
        listeners = listeners.filter({ $0 != type })
    }
    
    // MARK: - Coaching Overlay
    
    @available(iOS 13.0, *)
    func coaching_create(goal: ARCoachingOverlayView.Goal) {
        _coachingOverlay = ARCoachingOverlayView()
        guard let coachingOverlay = self.coachingOverlay else { return }
        coachingOverlay.session = session
        coachingOverlay.delegate = self
        coachingOverlay.goal = goal
        
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        sceneView.addSubview(coachingOverlay)
        
        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            coachingOverlay.widthAnchor.constraint(equalTo: view.widthAnchor),
            coachingOverlay.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])
    }
    
    @available(iOS 13.0, *)
    func coaching_activatesAutomatically(value: Bool) {
        coachingOverlay?.activatesAutomatically = value
    }
    
    @available(iOS 13.0, *)
    func coaching_setActive(active: Bool, animated: Bool) {
        coachingOverlay?.setActive(active, animated: animated)
    }
    
    // MARK: - Focus Square
    
    func updateFocusSquare() {
        guard let focusSquare = focusSquare else {
            return
        }
        // We should always have a valid world position unless the sceen is just being initialized.
        guard let (worldPosition, planeAnchor, _) = sceneView.worldPosition(
            fromScreenPosition: screenCenter, objectPosition: focusSquare.lastPosition
            ) else {
            updateQueue.async {
                focusSquare.state = .initializing
                self.sceneView.pointOfView?.addChildNode(focusSquare)
            }
            return
        }
        
        updateQueue.async {
            self.sceneView.scene.rootNode.addChildNode(focusSquare)
            let camera = self.session.currentFrame?.camera
            if let planeAnchor = planeAnchor {
                focusSquare.state = .planeDetected(anchorPosition: worldPosition,
                                                        planeAnchor: planeAnchor,
                                                        camera: camera)
            } else {
                focusSquare.state = .featuresDetected(anchorPosition: worldPosition, camera: camera)
            }
        }
    }
    
    func showFocusSquare() {
        focusSquare?.unhide()
    }
    
    func hideFocusSquare() {
        focusSquare?.hide()
    }
    
    func enableFocusSquare(enable: Bool) {
        guard let focusSquare = focusSquare else {
            return
        }
        focusSquareEnabled = enable
        if focusSquareEnabled {
            if let _ = sceneView.scene.rootNode.childNode(withName: "focusSquare", recursively: false) {
                return
            }
            sceneView.scene.rootNode.addChildNode(focusSquare)
        } else {
            focusSquare.removeFromParentNode()
        }
    }
    
    func getFocusSquarePosition() -> simd_float3? {
        guard let focusSquare = focusSquare,
            let focusSquarePosition = focusSquare.lastPosition,
            let cameraTransform = session.currentFrame?.camera.transform else {
            return nil
        }
        
        let cameraWorldPosition = cameraTransform.translation
        var positionOffsetFromCamera = focusSquarePosition - cameraWorldPosition
        
        // Limit the distance of the object from the camera to a maximum of 10 meters.
        if simd_length(positionOffsetFromCamera) > 10 {
            positionOffsetFromCamera = simd_normalize(positionOffsetFromCamera)
            positionOffsetFromCamera *= 10
        }
        
        return cameraWorldPosition + positionOffsetFromCamera
    }
    
    func dispose() {
        sceneView.removeFromSuperview()
        self.view.removeFromSuperview()
        self.removeFromParent()
        session_pause()
    }
    
    // MARK: - View overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = viewPort
        self.view.addSubview(sceneView)
        sceneView.delegate = self
        sceneView.scene.physicsWorld.contactDelegate = self
        if focusSquareEnabled, let focusSquare = focusSquare {
            sceneView.scene.rootNode.addChildNode(focusSquare)
        }
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
        session_pause()
    }
}
