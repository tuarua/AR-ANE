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

public class SwiftController: NSObject, FreSwiftMainController {
    public var TAG: String? = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    private var viewController: Scene3DVC? = nil
    private var logBox: UITextView?
    private var userChildren: Dictionary<String, Any> = Dictionary()
    
    private enum FreNativeType: Int {
        case image
        case button
        case sprite
    }
    
    // MARK: - FreSwift Required

    // Must have this function. It exposes the methods to our entry ObjC.
    @objc public func getFunctions(prefix: String) -> Array<String> {
        functionsToSet["\(prefix)init"] = initController
        functionsToSet["\(prefix)initScene3D"] = initScene3D
        functionsToSet["\(prefix)disposeScene3D"] = disposeScene3D
        functionsToSet["\(prefix)setScene3DProp"] = setScene3DProp
        functionsToSet["\(prefix)hitTest3D"] = hitTest3D
        functionsToSet["\(prefix)hitTest"] = hitTest
        functionsToSet["\(prefix)appendToLog"] = appendToLog
        functionsToSet["\(prefix)displayLogging"] = displayLogging
        functionsToSet["\(prefix)setDebugOptions"] = setDebugOptions
        functionsToSet["\(prefix)addChildNode"] = addChildNode
        functionsToSet["\(prefix)setChildNodeProp"] = setChildNodeProp
        functionsToSet["\(prefix)removeFromParentNode"] = removeFromParentNode
        functionsToSet["\(prefix)getChildNode"] = getChildNode
        functionsToSet["\(prefix)addModel"] = addModel
        functionsToSet["\(prefix)setGeometryProp"] = setGeometryProp
        functionsToSet["\(prefix)setMaterialProp"] = setMaterialProp
        functionsToSet["\(prefix)setMaterialPropertyProp"] = setMaterialPropertyProp
        functionsToSet["\(prefix)setLightProp"] = setLightProp
        functionsToSet["\(prefix)runSession"] = runSession
        functionsToSet["\(prefix)pauseSession"] = pauseSession
        functionsToSet["\(prefix)addAnchor"] = addAnchor
        functionsToSet["\(prefix)removeAnchor"] = removeAnchor
        functionsToSet["\(prefix)addNativeChild"] = addNativeChild
        functionsToSet["\(prefix)updateNativeChild"] = updateNativeChild
        functionsToSet["\(prefix)beginTransaction"] = beginTransaction
        functionsToSet["\(prefix)commitTransaction"] = commitTransaction
        functionsToSet["\(prefix)setTransactionProp"] = setTransactionProp
        functionsToSet["\(prefix)createAction"] = createAction
        functionsToSet["\(prefix)performAction"] = performAction
        functionsToSet["\(prefix)runAction"] = runAction
        functionsToSet["\(prefix)removeAllActions"] = removeAllActions
        functionsToSet["\(prefix)setActionProp"] = setActionProp
        functionsToSet["\(prefix)applyPhysicsForce"] = applyPhysicsForce
        functionsToSet["\(prefix)applyPhysicsTorque"] = applyPhysicsTorque
        
        
        var arr: Array<String> = []
        for key in functionsToSet.keys {
            arr.append(key)
        }
        return arr
    }
    
    // MARK: - Logging
    
    func displayLogging(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let lgBx = logBox,
            let visible = Bool(argv[0])
            else {
                return ArgCountError.init(message: "appendToLog").getError(#file, #line, #column)
        }
        lgBx.isHidden = !visible
        return nil
    }
    
    func appendToLog(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let lgBx = logBox,
            let text = String(argv[0])
            else {
                return ArgCountError.init(message: "appendToLog").getError(#file, #line, #column)
        }
        trace(text)
        
        lgBx.text = lgBx.text + "\n" + text;
        let bottom = lgBx.contentSize.height - lgBx.bounds.size.height
        lgBx.setContentOffset(CGPoint(x: 0, y: bottom), animated: false)
        return nil
    }
    
    func appendToLog(_ text: String) {
        trace(text)
        guard let lgBx = logBox else {
            return
        }
        lgBx.text = lgBx.text + "\n" + text;
        let bottom = lgBx.contentSize.height - lgBx.bounds.size.height
        lgBx.setContentOffset(CGPoint(x: 0, y: bottom), animated: false)
    }
    
     // MARK: - Init
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let rootVC = UIApplication.shared.keyWindow?.rootViewController,
            let displayLogging = Bool(argv[0])
            else {
                return ArgCountError.init(message: "initController").getError(#file, #line, #column)
        }
        
        logBox = UITextView.init(frame: rootVC.view.bounds.insetBy(dx: 50.0, dy: 50.0))
        if let lgBx = logBox {
            lgBx.isEditable = false
            lgBx.isSelectable = false
            lgBx.backgroundColor = UIColor.clear
            lgBx.textColor = UIColor.green
            lgBx.text = "Logging:"
            lgBx.isHidden = !displayLogging
            lgBx.isUserInteractionEnabled = false
            rootVC.view.addSubview(lgBx)
        }
        
        return ARWorldTrackingConfiguration.isSupported.toFREObject()
    }
    
    
    func addNativeChild(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let rootVC = UIApplication.shared.keyWindow?.rootViewController,
            let child = argv[0]
            else {
                return ArgCountError.init(message: "addNativeChild").getError(#file, #line, #column)
        }
        
        do {
            guard let id = try String(child.getProp(name: "id")),
                let t = try Int(child.getProp(name: "type")),
                let type: FreNativeType = FreNativeType(rawValue: t)
                else {
                    return nil
            }
            
            switch type {
            case FreNativeType.image:
                let nativeImage = try FreNativeImage.init(freObject: child, id: id)
                rootVC.view.addSubview(nativeImage)
                userChildren[id] = nativeImage
                break
            case FreNativeType.button:
                let nativeButton = try FreNativeButton.init(ctx:context, freObject: child, id: id)
                rootVC.view.addSubview(nativeButton)
                userChildren[id] = nativeButton
                break
            default:
                break
            }
            
        } catch {
        }
        return nil
    }
    
    func updateNativeChild(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("updateNativeChild")
        // TOOD
        return nil
    }
    
    func setDebugOptions(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let options = Array<String>(argv[0])
            else {
                return ArgCountError.init(message: "setDebugOptions").getError(#file, #line, #column)
        }
        vc.setDebugOptions(options: options)
        return nil
    }
    
    // MARK: - Session
    
    func runSession(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        appendToLog("runSession")
        guard argc > 1,
            let configuration = ARWorldTrackingConfiguration.init(argv[0]),
            let options  = Array<Int>(argv[1]),
            let vc = viewController
            else {
                return ArgCountError.init(message: "runSession").getError(#file, #line, #column)
        }
        vc.runSession(configuration: configuration, options: options)
        return nil
    }
    
    func pauseSession(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        appendToLog("pauseSession")
        guard
            let vc = viewController
            else {
                return ArgCountError.init(message: "pauseSession").getError(#file, #line, #column)
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
                return ArgCountError.init(message: "addAnchor").getError(#file, #line, #column)
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
                return ArgCountError.init(message: "removeAnchor").getError(#file, #line, #column)
        }
        vc.removeAnchor(id: id)
        appendToLog("removeAnchor \(id)")
        return nil
    }
    
    // MARK: - Scene
    
    func initScene3D(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        appendToLog("initScene3D")
        guard argc > 7,
            let options = Array<String>(argv[1]),
            let autoenablesDefaultLighting = Bool(argv[2]),
            let automaticallyUpdatesLighting = Bool(argv[3]),
            let showsStatistics = Bool(argv[4]),
            let antialiasingMode = UInt(argv[5])
            else {
                return ArgCountError.init(message: "initScene3D").getError(#file, #line, #column)
        }
        
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            var frame: CGRect = rootVC.view.bounds
            if let frme = CGRect(argv[0]) {
                frame = frme
            }
            
            let sceneView = ARSCNView.init(frame: rootVC.view.bounds)
            sceneView.antialiasingMode = SCNAntialiasingMode.init(rawValue: antialiasingMode) ?? .none
            
            var debugOptions:SCNDebugOptions = []
            for option in options {
                debugOptions.formUnion(SCNDebugOptions.init(rawValue: UInt(option)!))
            }
            sceneView.debugOptions = debugOptions
            
            //sceneView.scene.background.contents = UIColor.clear //to clear camera
            
            sceneView.autoenablesDefaultLighting = autoenablesDefaultLighting
            sceneView.automaticallyUpdatesLighting = automaticallyUpdatesLighting
            sceneView.showsStatistics = showsStatistics
            
            if let lightingEnvironment = SCNMaterialProperty.init(argv[6]) {
                trace("lightingEnvironment",lightingEnvironment.debugDescription)
                //to copy values to sceneView.scene.lightingEnvironment
            }
            
            if let frePhysicsWorld = argv[7],
                let gravity = SCNVector3(frePhysicsWorld["gravity"]),
                let speed = CGFloat(frePhysicsWorld["speed"]),
                let timeStep = Double(frePhysicsWorld["timeStep"]) {
                sceneView.scene.physicsWorld.gravity = gravity
                sceneView.scene.physicsWorld.speed = speed
                sceneView.scene.physicsWorld.timeStep = timeStep
            }
            
            viewController = Scene3DVC.init(context: context, frame: frame, arview: sceneView)
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
        if let vc = viewController,
            let view = vc.view {
            vc.pauseSession()
            view.removeFromSuperview()
            vc.removeFromParentViewController()
        }
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
                return ArgCountError.init(message: "setScene3DProp").getError(#file, #line, #column)
        }
        vc.setScene3DProp(name: name, value: freValue)
        return nil
    }
    
    func hitTest3D(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let touchPoint = CGPoint(argv[0]),
            let types = Array<Int>(argv[1]),
            let vc = viewController
            else {
                return ArgCountError.init(message: "hitTestScene3D").getError(#file, #line, #column)
        }
        return vc.hitTest3D(touchPoint: touchPoint, types: types)?.toFREObject(context)
    }
    
    func hitTest(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let touchPoint = CGPoint(argv[0]),
            let vc = viewController
            else {
                return ArgCountError.init(message: "hitTestScene3D").getError(#file, #line, #column)
        }
        var dict:[SCNHitTestOption : Any]? = nil
        if let freOptions = argv[1],
            let searchMode = Int(freOptions["searchMode"]),
            let backFaceCulling = Bool(freOptions["backFaceCulling"]),
            let clipToZRange = Bool(freOptions["clipToZRange"]),
            let boundingBoxOnly = Bool(freOptions["boundingBoxOnly"]),
            let ignoreChildNodes = Bool(freOptions["ignoreChildNodes"]),
            let ignoreHiddenNodes = Bool(freOptions["ignoreHiddenNodes"]) {
            var d = [SCNHitTestOption : Any]()
            d[SCNHitTestOption.backFaceCulling] = backFaceCulling
            d[SCNHitTestOption.clipToZRange] = clipToZRange
            d[SCNHitTestOption.boundingBoxOnly] = boundingBoxOnly
            d[SCNHitTestOption.ignoreChildNodes] = ignoreChildNodes
            d[SCNHitTestOption.ignoreHiddenNodes] = ignoreHiddenNodes
            d[SCNHitTestOption.searchMode] = searchMode
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
                return ArgCountError.init(message: "addChildNode").getError(#file, #line, #column)
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
        if let node = SCNNode.init(nodeFre) {
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
                return ArgCountError.init(message: "removeFromParentNode").getError(#file, #line, #column)
        }
        vc.removeFromParentNode(name: name)
        return nil
    }
    
    func setChildNodeProp(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let vc = viewController,
            let nodeName = String(argv[0]),
            let propName = String(argv[1]),
            let freValue = argv[2]
            else {
                return ArgCountError.init(message: "setChildNodeProp").getError(#file, #line, #column)
        }
        vc.setChildNodeProp(nodeName: nodeName, propName: propName, value: freValue)
        
        return nil
    }
    
    func getChildNode(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let vc = viewController,
            let nodeName = String(argv[1])
            else {
                return ArgCountError.init(message: "getChildNode").getError(#file, #line, #column)
        }
        let parentName = String(argv[0])
        trace("getChildNode", "parentName:", parentName ?? "", "nodeName:", nodeName)
        if let node = vc.getChildNode(parentName: parentName, nodeName: nodeName) {
            return node.toFREObject()
        }
        return nil
    }
    
    func addModel(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let vc = viewController,
            let url = String(argv[0])
            else {
                return ArgCountError.init(message: "addModel").getError(#file, #line, #column)
        }
        let nodeName = String(argv[1])
        if let node = vc.addModel(url: url, nodeName: nodeName) {
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
                return ArgCountError.init(message: "setGeometryProp").getError(#file, #line, #column)
        }
        vc.setGeometryProp(type:type, nodeName:nodeName, propName: propName, value: freValue)
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
                return ArgCountError.init(message: "setMaterialProp").getError(#file, #line, #column)
        }
        vc.setMaterialProp(name: id, nodeName: nodeName, propName: propName, value: freValue)
        return nil
    }
    
    func setMaterialPropertyProp(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("setMaterialPropertyProp")
        guard argc > 4,
            let vc = viewController,
            let id = String(argv[0]),
            let nodeName = String(argv[1]),
            let type = String(argv[2]),
            let propName = String(argv[3]),
            let freValue = argv[4]
            else {
                return ArgCountError.init(message: "setMaterialPropertyProp").getError(#file, #line, #column)
        }
        vc.setMaterialPropertyProp(id:id, nodeName: nodeName, type: type, propName: propName, value: freValue)
        return nil
    }
    
    func setLightProp(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let vc = viewController,
            let nodeName = String(argv[0]),
            let propName = String(argv[1]),
            let freValue = argv[2]
            else {
                return ArgCountError.init(message: "setLightProp").getError(#file, #line, #column)
        }
        
        vc.setLightProp(nodeName:nodeName, propName: propName, value: freValue)
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
                return ArgCountError.init(message: "setTransactionProp").getError(#file, #line, #column)
        }
        switch propName {
        case "animationDuration":
            if let animationDuration = Double(freValue) {
                SCNTransaction.animationDuration = animationDuration
            }
            break
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
                return ArgCountError.init(message: "createAction").getError(#file, #line, #column)
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
                return ArgCountError.init(message: "performAction").getError(#file, #line, #column)
        }
        switch type {
        case "hide":
            fallthrough
        case "unhide":
            fallthrough
        case "repeatForever":
            vc.performAction(id: id, type: type)
            break
        case "rotateBy":
            if let x = CGFloat(argv[2]),
                let y = CGFloat(argv[3]),
                let z = CGFloat(argv[4]),
                let duration = Double(argv[5]) {
                vc.performAction(id: id, type: type, args: x, y, z, duration)
            }
            break
        case "moveBy":
            fallthrough
        case "moveTo":
            if let value = SCNVector3(argv[2]),
                let duration = Double(argv[3]) {
                vc.performAction(id: id, type: type, args: value, duration)
            }
            break
        case "scaleBy":
            fallthrough
        case "scaleTo":
            if let scale = CGFloat(argv[2]),
                let duration = Double(argv[3]) {
                vc.performAction(id: id, type: type, args: scale, duration)
            }
            break
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
                return ArgCountError.init(message: "runAction").getError(#file, #line, #column)
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
                return ArgCountError.init(message: "setActionProp").getError(#file, #line, #column)
        }
        vc.setActionProp(id:id, propName: propName, value: freValue)
        return nil
    }
    
    func removeAllActions(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("removeAllActions")
        guard argc > 0,
            let vc = viewController,
            let nodeName = String(argv[0])
            else {
                return ArgCountError.init(message: "removeAllActions").getError(#file, #line, #column)
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
                return ArgCountError.init(message: "applyPhysicsForce").getError(#file, #line, #column)
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
                return ArgCountError.init(message: "applyPhysicsTorque").getError(#file, #line, #column)
        }
        vc.applyPhysicsTorque(torque: torque, asImpulse: asImpulse, nodeName: nodeName)
        return nil
    }
    
    
    // MARK: - FreSwift Required
    
    // Must have these 3 functions.
    //Exposes the methods to our entry ObjC.
    @objc public func callSwiftFunction(name: String, ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if let fm = functionsToSet[name] {
            return fm(ctx, argc, argv)
        }
        return nil
    }
    
    //Here we set our FREContext
    @objc public func setFREContext(ctx: FREContext) {
        self.context = FreContextSwift.init(freContext: ctx)
    }
    
    
    @objc func applicationDidFinishLaunching(_ notification: Notification) {
        
    }
    
    @objc public func onLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidFinishLaunching),
                                               name: NSNotification.Name.UIApplicationDidFinishLaunching, object: nil)
        
    }
    
    
}
