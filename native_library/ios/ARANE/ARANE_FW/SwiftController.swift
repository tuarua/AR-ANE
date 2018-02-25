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

import ARKit
import UIKit
import Foundation
import CoreImage
import FreSwift
import PocketSVG

public class SwiftController: NSObject {
    public var TAG: String? = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    internal var viewController: Scene3DVC?
    private var logBox: LogBox?
    private var hasLogBox: Bool = false
    private var userChildren: [String: Any] = Dictionary()
    private var arListeners: [String] = []
    private var gestureListeners: [String] = []
    private var gestureController: GestureController?
    
    public func requestPermissions(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        let pc = PermissionController(context: context)
        pc.requestPermissions()
        return nil
    }
    
    func createGUID(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UUID().uuidString.toFREObject()
    }
    
    // MARK: - Logging
    
    func displayLogging(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let lgBx = logBox,
            let display = Bool(argv[0])
            else {
                return ArgCountError(message: "appendToLog").getError(#file, #line, #column)
        }
        hasLogBox = display
        lgBx.isHidden = !display
        return nil
    }
    
    func appendToLog(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard hasLogBox else {
            return nil
        }
        guard argc > 0,
            let lgBx = logBox,
            let text = String(argv[0])
            else {
                return ArgCountError(message: "appendToLog").getError(#file, #line, #column)
        }
        trace(text)
        lgBx.setText(value: text)
        return nil
    }
    
    func appendToLog(_ text: String) {
        guard hasLogBox else {
            return
        }
        trace(text)
        guard let lgBx = logBox else {
            return
        }
        lgBx.setText(value: text)
    }
    
    // MARK: - Init
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let rootVC = UIApplication.shared.keyWindow?.rootViewController,
            let displayLogging = Bool(argv[0])
            else {
                return ArgCountError(message: "initController").getError(#file, #line, #column)
        }
        
        hasLogBox = displayLogging
        logBox = LogBox(frame: rootVC.view.bounds.insetBy(dx: 50.0, dy: 50.0), displayLogging: hasLogBox)
        if let lgBx = logBox {
             rootVC.view.addSubview(lgBx)
        }
        return ARWorldTrackingConfiguration.isSupported.toFREObject()
    }
    
    // MARK: - Native Button Overlays
    
    func addNativeChild(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let rootVC = UIApplication.shared.keyWindow?.rootViewController,
            let child = argv[0]
            else {
                return ArgCountError(message: "addNativeChild").getError(#file, #line, #column)
        }

        do {
            guard let id = String(child["id"]),
                let t = Int(child["type"]),
                let type: FreNativeType = FreNativeType(rawValue: t)
                else {
                    return nil
            }
            
            switch type {
            case FreNativeType.image:
                if userChildren.keys.contains(id) {
                    if let nativeImage = userChildren[id] as? FreNativeImage {
                       rootVC.view.addSubview(nativeImage)
                    }
                } else {
                    let nativeImage = try FreNativeImage(freObject: child, id: id)
                    userChildren[id] = nativeImage
                    rootVC.view.addSubview(nativeImage)
                }
            case FreNativeType.button:
                 if userChildren.keys.contains(id) {
                    if let nativeButton = userChildren[id] as? FreNativeButton {
                        rootVC.view.addSubview(nativeButton)
                    }
                 } else {
                    let nativeButton = try FreNativeButton(ctx: context, freObject: child, id: id)
                    userChildren[id] = nativeButton
                    rootVC.view.addSubview(nativeButton)
                 }
            default:
                break
            }
            
        } catch {
        }
        return nil
    }
    
    func updateNativeChild(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            userChildren.count > 0,
            let id = String(argv[0]),
            let propName = argv[1],
            let propVal = argv[2]
            else {
                return ArgCountError(message: "updateNativeChild").getError(#file, #line, #column)
        }
        if let child = userChildren[id] as? FreNativeImage {
            child.update(prop: propName, value: propVal)
        } else if let child = userChildren[id] as? FreNativeButton {
            child.update(prop: propName, value: propVal)
        }
        return nil
    }
    
    func removeNativeChild(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let id = String(argv[0])
            else {
                return ArgCountError(message: "removeNativeChild").getError(#file, #line, #column)
        }
        if let child = userChildren[id] {
            if let c = child as? FreNativeImage {
                c.removeFromSuperview()
            } else if let c = child as? FreNativeButton {
                c.removeFromSuperview()
            }
        }
        return nil
    }
    
    func setDebugOptions(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let options = [String](argv[0])
            else {
                return ArgCountError(message: "setDebugOptions").getError(#file, #line, #column)
        }
        vc.setDebugOptions(options: options)
        return nil
    }
    
    // MARK: - Session
    
    func runSession(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        appendToLog("runSession")
        guard argc > 1,
            let configuration = ARWorldTrackingConfiguration(argv[0]),
            let options  = [Int](argv[1]),
            let vc = viewController
            else {
                return ArgCountError(message: "runSession").getError(#file, #line, #column)
        }
        vc.runSession(configuration: configuration, options: options)
        return nil
    }
    
    func pauseSession(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        appendToLog("pauseSession")
        guard
            let vc = viewController
            else {
                return ArgCountError(message: "pauseSession").getError(#file, #line, #column)
        }
        
        vc.pauseSession()
        return nil
    }
    
    // MARK: - Anchors
    
    func addAnchor(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let anchor = ARAnchor(argv[0])
            else {
                return ArgCountError(message: "addAnchor").getError(#file, #line, #column)
        }
        vc.addAnchor(anchor: anchor)
        appendToLog("addAnchor \(anchor.identifier)")
        return anchor.identifier.uuidString.toFREObject()
    }
    
    func removeAnchor(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let id = String(argv[0])
            else {
                return ArgCountError(message: "removeAnchor").getError(#file, #line, #column)
        }
        vc.removeAnchor(id: id)
        appendToLog("removeAnchor \(id)")
        return nil
    }
    
    // MARK: - Scene
    
    func initScene3D(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        appendToLog("initScene3D")
        guard argc > 8,
            let debugOptionsArr = [String](argv[1]),
            let autoenablesDefaultLighting = Bool(argv[2]),
            let automaticallyUpdatesLighting = Bool(argv[3]),
            let showsStatistics = Bool(argv[4]),
            let antialiasingMode = UInt(argv[5]),
            let focusSquareSettings = FocusSquareSettings(argv[9])
            else {
                return ArgCountError(message: "initScene3D").getError(#file, #line, #column)
        }
        
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            var frame: CGRect = rootVC.view.bounds
            if let frme = CGRect(argv[0]) {
                frame = frme
            }

            let sceneView = AR3DView(frame: rootVC.view.bounds)
            sceneView.antialiasingMode = SCNAntialiasingMode(rawValue: antialiasingMode) ?? .none
            
            var debugOptions: SCNDebugOptions = []
            for option in debugOptionsArr {
                debugOptions.formUnion(SCNDebugOptions(rawValue: UInt(option)!))
            }
            sceneView.debugOptions = debugOptions
            
            //sceneView.scene.background.contents = UIColor.clear //to clear camera

            sceneView.autoenablesDefaultLighting = autoenablesDefaultLighting
            sceneView.automaticallyUpdatesLighting = automaticallyUpdatesLighting
            sceneView.showsStatistics = showsStatistics
            
            //appendToLog("Device: \(sceneView.device.debugDescription)")
            //appendToLog("renderingAPI: \(sceneView.renderingAPI)")

            if let freLightingEnvironment = argv[6],
                Bool(freLightingEnvironment["isDefault"]) == false,
                let lightingEnvironment = SCNMaterialProperty(freLightingEnvironment) {
                sceneView.scene.lightingEnvironment.copy(from: lightingEnvironment)
            }
            
            if let frePhysicsWorld = argv[7],
                Bool(frePhysicsWorld["isDefault"]) == false,
                let gravity = SCNVector3(frePhysicsWorld["gravity"]),
                let speed = CGFloat(frePhysicsWorld["speed"]),
                let timeStep = Double(frePhysicsWorld["timeStep"]) {
                sceneView.scene.physicsWorld.gravity = gravity
                sceneView.scene.physicsWorld.speed = speed
                sceneView.scene.physicsWorld.timeStep = timeStep
            }
            
            if let sceneCamera = sceneView.pointOfView?.camera,
                let freCamera = argv[8],
                Bool(freCamera["isDefault"]) == false,
                let camera = SCNCamera(freCamera) {
                sceneCamera.copy(from: camera)
            }
            
            gestureController = GestureController(context: context, arview: sceneView, listeners: gestureListeners)
            viewController = Scene3DVC(context: context, frame: frame, arview: sceneView, listeners: arListeners,
                                       focusSquareSettings: focusSquareSettings)
            if let vc = viewController, let view = vc.view {
                rootVC.view.addSubview(view)
                if let dt = logBox {
                    rootVC.view.bringSubview(toFront: dt)
                }
            }
        }
        
        return nil
    }
    
    func disposeScene3D(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if let vc = viewController {
            vc.dispose()
            vc.removeFromParentViewController()
        }
        viewController = nil
        gestureController = nil
        if let dt = logBox {
            dt.removeFromSuperview()
        }
        return nil
    }
    
    func setScene3DProp(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let vc = viewController,
            let name = String(argv[0]),
            let freValue = argv[1]
            else {
                return ArgCountError(message: "setScene3DProp").getError(#file, #line, #column)
        }
        vc.setScene3DProp(name: name, value: freValue)
        return nil
    }
    
    func isNodeInsidePointOfView(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let nodeName = String(argv[0])
            else {
                return ArgCountError(message: "isNodeInsidePointOfView").getError(#file, #line, #column)
        }
        return vc.isNodeInsidePointOfView(nodeName: nodeName).toFREObject()
    }
    
    func getCameraPosition(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard let vc = viewController
            else {
                return ArgCountError(message: "getCameraPointOfView").getError(#file, #line, #column)
        }
        return vc.getCameraPointOfView()?.toFREObject()
    }
    
    func hitTest3D(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let touchPoint = CGPoint(argv[0]),
            let types = [Int](argv[1]),
            let vc = viewController
            else {
                return ArgCountError(message: "hitTestScene3D").getError(#file, #line, #column)
        }
        return vc.hitTest3D(touchPoint: touchPoint, types: types)?.toFREObject(context)
    }
    
    func hitTest(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let touchPoint = CGPoint(argv[0]),
            let vc = viewController
            else {
                return ArgCountError(message: "hitTestScene3D").getError(#file, #line, #column)
        }
        var dict: [SCNHitTestOption: Any]? = nil
        if let freOptions = argv[1],
            let searchMode = Int(freOptions["searchMode"]),
            let backFaceCulling = Bool(freOptions["backFaceCulling"]),
            let clipToZRange = Bool(freOptions["clipToZRange"]),
            let boundingBoxOnly = Bool(freOptions["boundingBoxOnly"]),
            let ignoreChildNodes = Bool(freOptions["ignoreChildNodes"]),
            let categoryBitMask = Int(freOptions["categoryBitMask"]),
            let ignoreHiddenNodes = Bool(freOptions["ignoreHiddenNodes"]) {
            var d = [SCNHitTestOption: Any]()
            d[SCNHitTestOption.backFaceCulling] = backFaceCulling
            d[SCNHitTestOption.clipToZRange] = clipToZRange
            d[SCNHitTestOption.boundingBoxOnly] = boundingBoxOnly
            d[SCNHitTestOption.ignoreChildNodes] = ignoreChildNodes
            d[SCNHitTestOption.ignoreHiddenNodes] = ignoreHiddenNodes
            d[SCNHitTestOption.searchMode] = searchMode
            d[SCNHitTestOption.categoryBitMask] = categoryBitMask
            dict = d
        }
        return vc.hitTest(touchPoint: touchPoint, options: dict)?.toFREObject()
    }
    
    // MARK: - Nodes and Geometry
    
    func addChildNode(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let nodeFre = argv[1],
            let isModel = Bool(nodeFre["isModel"]),
            let isDAE = Bool(nodeFre["isDAE"]),
            let vc = viewController
            else {
                return ArgCountError(message: "addChildNode").getError(#file, #line, #column)
        }
        let parentName = String(argv[0])
        if isModel {
            if let nodeName = String(nodeFre["name"]), let model = vc.getModel(modelName: nodeName) {
                model.copyFromModel(nodeFre, isDAE)
                vc.addChildNode(parentName: parentName, node: model)
                return nil
            }
            return nil
        }
        if let node = SCNNode(nodeFre) {
            vc.addChildNode(parentName: parentName, node: node)
        } else {
            warning("node not created")
        }
        return nil
    }
    
    func removeFromParentNode(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let name = String(argv[0])
            else {
                return ArgCountError(message: "removeFromParentNode").getError(#file, #line, #column)
        }
        vc.removeFromParentNode(nodeName: name)
        return nil
    }
    
    func removeChildNodes(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let name = String(argv[0])
            else {
                return ArgCountError(message: "removeChildNodes").getError(#file, #line, #column)
        }
        vc.removeChildNodes(nodeName: name)
        return nil
    }
    
    func setChildNodeProp(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let vc = viewController,
            let nodeName = String(argv[0]),
            let propName = String(argv[1]),
            let freValue = argv[2]
            else {
                return ArgCountError(message: "setChildNodeProp").getError(#file, #line, #column)
        }
        vc.setChildNodeProp(nodeName: nodeName, propName: propName, value: freValue)
        
        return nil
    }
    
    func getChildNode(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let vc = viewController,
            let nodeName = String(argv[1])
            else {
                return ArgCountError(message: "getChildNode").getError(#file, #line, #column)
        }
        let parentName = String(argv[0])
        //trace("getChildNode", "parentName:", parentName ?? "", "nodeName:", nodeName)
        if let node = vc.getChildNode(parentName: parentName, nodeName: nodeName) {
            return node.toFREObject()
        }
        return nil
    }
    
    func addModel(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let vc = viewController,
            let url = String(argv[0]),
            let flatten = Bool(argv[2])
            else {
                return ArgCountError(message: "addModel").getError(#file, #line, #column)
        }
        let nodeName = String(argv[1])
        if let node = vc.addModel(url: url, nodeName: nodeName, flatten: flatten) {
            return node.toFREObject() // construct full node with geometry mats etc
        }
        return nil
    }
    
    func setGeometryProp(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 3,
            let vc = viewController,
            let type = String(argv[0]),
            let nodeName = String(argv[1]),
            let propName = String(argv[2]),
            let freValue = argv[3]
            else {
                return ArgCountError(message: "setGeometryProp").getError(#file, #line, #column)
        }
        vc.setGeometryProp(type: type, nodeName: nodeName, propName: propName, value: freValue)
        return nil
    }
    
    // MARK: - Materials
    
    func setMaterialProp(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 3,
            let vc = viewController,
            let id = String(argv[0]),
            let nodeName = String(argv[1]),
            let propName = String(argv[2]),
            let freValue = argv[3]
            else {
                return ArgCountError(message: "setMaterialProp").getError(#file, #line, #column)
        }
        vc.setMaterialProp(name: id, nodeName: nodeName, propName: propName, value: freValue)
        return nil
    }
    
    func setMaterialPropertyProp(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 4,
            let vc = viewController,
            let id = String(argv[0]),
            let nodeName = String(argv[1]),
            let type = String(argv[2]),
            let propName = String(argv[3]),
            let freValue = argv[4]
            else {
                return ArgCountError(message: "setMaterialPropertyProp").getError(#file, #line, #column)
        }
        vc.setMaterialPropertyProp(id: id, nodeName: nodeName, type: type, propName: propName, value: freValue)
        return nil
    }
    
    func setLightProp(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let vc = viewController,
            let nodeName = String(argv[0]),
            let propName = String(argv[1]),
            let freValue = argv[2]
            else {
                return ArgCountError(message: "setLightProp").getError(#file, #line, #column)
        }
        
        vc.setLightProp(nodeName: nodeName, propName: propName, value: freValue)
        return nil
    }
    
    // MARK: - Transactions
    
    func beginTransaction(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        SCNTransaction.begin()
        return nil
    }
    
    func commitTransaction(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        SCNTransaction.commit()
        return nil
    }
    
    func setTransactionProp(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let propName = String(argv[0]),
            let freValue = argv[1]
            else {
                return ArgCountError(message: "setTransactionProp").getError(#file, #line, #column)
        }
        switch propName {
        case "animationDuration":
            if let animationDuration = Double(freValue) {
                SCNTransaction.animationDuration = animationDuration
            }
        default:
            break
        }
        
        return nil
    }
    
    // MARK: - Actions
    
    func createAction(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let vc = viewController,
            let id = String(argv[0]),
            let timingMode = Int(argv[1])
            else {
                return ArgCountError(message: "createAction").getError(#file, #line, #column)
        }
        vc.createAction(id: id, timingMode: timingMode)
        return nil
    }
    
    func performAction(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let id = String(argv[0]),
            let type = String(argv[1])
            else {
                return ArgCountError(message: "performAction").getError(#file, #line, #column)
        }
        switch type {
        case "hide", "unhide", "repeatForever":
            vc.performAction(id: id, type: type)
        case "rotateBy":
            if let x = CGFloat(argv[2]),
                let y = CGFloat(argv[3]),
                let z = CGFloat(argv[4]),
                let duration = Double(argv[5]) {
                vc.performAction(id: id, type: type, args: x, y, z, duration)
            }
        case "moveBy", "moveTo":
            if let value = SCNVector3(argv[2]),
                let duration = Double(argv[3]) {
                vc.performAction(id: id, type: type, args: value, duration)
            }
        case "scaleBy", "scaleTo":
            if let scale = CGFloat(argv[2]),
                let duration = Double(argv[3]) {
                vc.performAction(id: id, type: type, args: scale, duration)
            }
        default:
            break
        }
        return nil
    }
    
    func runAction(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let id = String(argv[0]),
            let nodeName = String(argv[1])
            else {
                return ArgCountError(message: "runAction").getError(#file, #line, #column)
        }
        vc.runAction(id: id, nodeName: nodeName)
        return nil
    }
    
    func setActionProp(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let vc = viewController,
            let id = String(argv[0]),
            let propName = String(argv[1]),
            let freValue = argv[2]
            else {
                return ArgCountError(message: "setActionProp").getError(#file, #line, #column)
        }
        vc.setActionProp(id: id, propName: propName, value: freValue)
        return nil
    }
    
    func removeAllActions(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let nodeName = String(argv[0])
            else {
                return ArgCountError(message: "removeAllActions").getError(#file, #line, #column)
        }
        vc.removeAllActions(nodeName: nodeName)
        return nil
    }
    
    // MARK: - Physics
    
    func applyPhysicsForce(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 3,
            let vc = viewController,
            let direction = SCNVector3(argv[0]),
            let asImpulse = Bool(argv[1]),
            let nodeName = String(argv[3])
            else {
                return ArgCountError(message: "applyPhysicsForce").getError(#file, #line, #column)
        }
        let at = SCNVector3(argv[2])
        vc.applyPhysicsForce(direction: direction, at: at, asImpulse: asImpulse, nodeName: nodeName)
        return nil
    }
    
    func applyPhysicsTorque(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let vc = viewController,
            let torque = SCNVector4(argv[0]),
            let asImpulse = Bool(argv[1]),
            let nodeName = String(argv[2])
            else {
                return ArgCountError(message: "applyPhysicsTorque").getError(#file, #line, #column)
        }
        vc.applyPhysicsTorque(torque: torque, asImpulse: asImpulse, nodeName: nodeName)
        return nil
    }
    
    // MARK: - AS Event Listeners
    
    func addEventListener(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let type = String(argv[0]) else {
                return ArgCountError(message: "addEventListener").getError(#file, #line, #column)
        }
        switch type {
        case GestureEvent.SCENE3D_TAP,
             GestureEvent.SCENE3D_PINCH,
             GestureEvent.SCENE3D_SWIPE_LEFT,
             GestureEvent.SCENE3D_SWIPE_RIGHT,
             GestureEvent.SCENE3D_SWIPE_UP,
             GestureEvent.SCENE3D_SWIPE_DOWN,
             GestureEvent.SCENE3D_LONG_PRESS:
            if let gc = gestureController {
                gc.addEventListener(type: type)
                gestureListeners.removeAll()
            } else {
                gestureListeners.append(type)
            }
        default:
            if let vc = viewController {
                vc.addEventListener(type: type)
                arListeners.removeAll()
            } else {
                arListeners.append(type)
            }
        }

        return nil
    }
    
    func removeEventListener(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let type = String(argv[0]) else {
                return ArgCountError(message: "removeEventListener").getError(#file, #line, #column)
        }
        switch type {
        case GestureEvent.SCENE3D_TAP,
             GestureEvent.SCENE3D_PINCH,
             GestureEvent.SCENE3D_SWIPE_LEFT,
             GestureEvent.SCENE3D_SWIPE_RIGHT,
             GestureEvent.SCENE3D_SWIPE_UP,
             GestureEvent.SCENE3D_SWIPE_DOWN,
             GestureEvent.SCENE3D_LONG_PRESS:
            if let gc = gestureController {
                gc.removeEventListener(type: type)
            } else {
                gestureListeners = gestureListeners.filter({ $0 != type })
            }
        default:
            if let vc = viewController {
                vc.removeEventListener(type: type)
            } else {
                arListeners = arListeners.filter({ $0 != type })
                arListeners.removeAll()
            }
        }
        return nil
    }
    
    // MARK: - Focus Square
    
    func showFocusSquare(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard let vc = viewController
            else {
                return ArgCountError(message: "showFocusSquare").getError(#file, #line, #column)
        }
        vc.showFocusSquare()
        return nil
    }
    
    func hideFocusSquare(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard let vc = viewController
            else {
                return ArgCountError(message: "hideFocusSquare").getError(#file, #line, #column)
        }
        vc.hideFocusSquare()
        return nil
    }
    
    func enableFocusSquare(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let enable = Bool(argv[0])
            else {
                return ArgCountError(message: "enableFocusSquare").getError(#file, #line, #column)
        }
        vc.enableFocusSquare(enable: enable)
        return nil
    }
    
    func getFocusSquarePosition(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard let vc = viewController
            else {
                return ArgCountError(message: "getFocusSquarePosition").getError(#file, #line, #column)
        }
        return vc.getFocusSquarePosition()?.toFREObject()
    }
    
}
