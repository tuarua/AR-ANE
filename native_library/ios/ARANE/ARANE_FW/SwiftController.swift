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
    public static var TAG: String = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    internal var viewController: Scene3DVC?
    private var logBox: LogBox?
    private var hasLogBox = false
    private var userChildren = [String: Any]()
    private var arListeners: [String] = []
    private var gestureListeners: [String] = []
    private var gestureController: GestureController?
    
    // MARK: - Common
    
    public func requestPermissions(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        let pc = PermissionController(context: context)
        pc.requestPermissions()
        return nil
    }
    
    func createGUID(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UUID().uuidString.toFREObject()
    }
    
    func getIosVersion(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return (UIDevice.current.systemVersion as NSString).floatValue.toFREObject()
    }
    
    // MARK: - Logging
    
    func displayLogging(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let lgBx = logBox,
            let display = Bool(argv[0])
            else { return FreArgError().getError()
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
            else { return FreArgError().getError()
        }
        trace(text)
        lgBx.setText(value: text)
        return nil
    }
    
    func appendToLog(_ text: String) {
        guard hasLogBox else { return }
        trace(text)
        guard let lgBx = logBox else { return }
        lgBx.setText(value: text)
    }
    
    // MARK: - Init
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let rootVC = UIApplication.shared.keyWindow?.rootViewController,
            let displayLogging = Bool(argv[0])
            else { return FreArgError().getError()
        }
        UIApplication.shared.isIdleTimerDisabled = true
        hasLogBox = displayLogging
        logBox = LogBox(frame: rootVC.view.bounds.insetBy(dx: 75.0, dy: 75.0), displayLogging: hasLogBox)
        if let lgBx = logBox {
             rootVC.view.addSubview(lgBx)
        }
        return ARWorldTrackingConfiguration.isSupported.toFREObject()
    }
    
    func ar3dview_debugOptions(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let options = [String](argv[0])
            else { return FreArgError().getError()
        }
        vc.ar3dview_debugOptions(options: options)
        return nil
    }
    
    // MARK: - Session
    
    func session_run(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let options = [Int](argv[1]),
            let vc = viewController
            else { return FreArgError().getError()
        }
        if argv[0]?.className == "com.tuarua.arane::WorldTrackingConfiguration",
            let configuration = ARWorldTrackingConfiguration(argv[0]) {
            appendToLog(configuration.debugDescription)
            vc.session_run(configuration: configuration, options: options)
        } else if argv[0]?.className == "com.tuarua.arane::ImageTrackingConfiguration", #available(iOS 12.0, *),
            let configuration = ARImageTrackingConfiguration(argv[0]) {
            appendToLog(configuration.debugDescription)
            vc.session_run(configuration: configuration, options: options)
        } else if argv[0]?.className == "com.tuarua.arane::ObjectScanningConfiguration", #available(iOS 12.0, *),
            let configuration = ARObjectScanningConfiguration(argv[0]) {
            appendToLog(configuration.debugDescription)
            vc.session_run(configuration: configuration, options: options)
        } else if argv[0]?.className == "com.tuarua.arane::PositionalTrackingConfiguration", #available(iOS 13.0, *),
            let configuration = ARPositionalTrackingConfiguration(argv[0]) {
            appendToLog(configuration.debugDescription)
            vc.session_run(configuration: configuration, options: options)
        } else if argv[0]?.className == "com.tuarua.arane::BodyTrackingConfiguration", #available(iOS 13.0, *),
            let configuration = ARBodyTrackingConfiguration(argv[0]) {
            appendToLog(configuration.debugDescription)
            vc.session_run(configuration: configuration, options: options)
        }
        return nil
    }
    
    func session_pause(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard let vc = viewController
            else { return FreArgError().getError()
        }
        vc.session_pause()
        return nil
    }
    
    func session_setWorldOrigin(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if #available(iOS 11.3, *) {
            guard argc > 0,
                let vc = viewController,
                let relativeTransform = matrix_float4x4(argv[0])
                else { return FreArgError().getError()
            }
            vc.session_setWorldOrigin(relativeTransform: relativeTransform)
        } else {
            warning("This requires iOS 11.3")
        }
        return nil
    }
    
    func session_saveCurrentWorldMap(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if #available(iOS 12.0, *) {
            guard argc > 1,
                let vc = viewController,
                let urlStr = String(argv[0]),
                let url = URL(safe: urlStr),
                let eventId = String(argv[1])
                else { return FreArgError().getError()
            }
            vc.session_saveCurrentWorldMap(eventId: eventId, url: url)
        } else {
            warning("This requires iOS 12.0")
        }
        return nil
    }
    
    func session_createReferenceObject(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if #available(iOS 12.0, *) {
            guard argc > 3,
                let vc = viewController,
                let transform = simd_float4x4(argv[0]),
                let center = simd_float3(argv[1]),
                let extent = simd_float3(argv[2]),
                let eventId = String(argv[3])
                else { return FreArgError().getError()
            }
            vc.session_createReferenceObject(transform: transform, center: center, extent: extent, eventId: eventId)
        } else {
            warning("This requires iOS 12.0")
        }
        return nil
    }
    
    // MARK: - Anchors
    
    func session_add(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let anchor = ARAnchor(argv[0])
            else { return FreArgError().getError()
        }
        vc.session_add(anchor: anchor)
        return anchor.identifier.uuidString.toFREObject()
    }
    
    func session_remove(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let id = String(argv[0])
            else { return FreArgError().getError()
        }
        vc.session_remove(id: id)
        return nil
    }
    
    func session_identifier(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if #available(iOS 13.0, *) {
            guard argc > 0,
                let vc = viewController
                else { return FreArgError().getError()
            }
            return vc.session_identifier().toFREObject()
        } else {
            warning("This requires iOS 13.0")
        }
        return nil
    }
    
    func session_raycast(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if #available(iOS 13.0, *) {
            guard argc > 0,
                let vc = viewController,
                let query = ARRaycastQuery(argv[0])
                else { return FreArgError().getError()
            }
            return vc.session_raycast(query: query).toFREObject()
        } else {
            warning("This requires iOS 13.0")
        }
        return nil
    }
    
    func session_trackedRaycast(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if #available(iOS 13.0, *) {
            guard argc > 1,
                let vc = viewController,
                let query = ARRaycastQuery(argv[0]),
                let eventId = String(argv[1])
                else { return FreArgError().getError()
            }
            return vc.session_trackedRaycast(query: query, eventId: eventId)?.toFREObject(eventId)
        } else {
            warning("This requires iOS 13.0")
        }
        return nil
    }
    
    func session_lastTrackedRaycast(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if #available(iOS 13.0, *) {
            return viewController?.lastTrackedRaycast.toFREObject()
        } else {
            warning("This requires iOS 13.0")
        }
        return nil
    }
    
    func raycast_stopTracking(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let id = String(argv[0])
            else { return FreArgError().getError()
        }
        if #available(iOS 13.0, *) {
            vc.trackedRaycasts[id]??.stopTracking()
        } else {
            warning("This requires iOS 13.0")
        }
        return nil
    }
    
    // MARK: - Scene
    
    func ar3dview_init(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 10,
            let debugOptionsArr = [String](argv[1]),
            let autoenablesDefaultLighting = Bool(argv[2]),
            let automaticallyUpdatesLighting = Bool(argv[3]),
            let showsStatistics = Bool(argv[4]),
            let antialiasingMode = UInt(argv[5]),
            let focusSquareSettings = FocusSquareSettings(argv[9]),
            let rootVC = UIApplication.shared.keyWindow?.rootViewController
            else { return FreArgError().getError()
        }
        
        var mask: CGImage?
        if let freMask = argv[10] {
            let asBitmapData = FreBitmapDataSwift(freObject: freMask)
            defer {
                asBitmapData.releaseData()
            }
            if let cgimg = asBitmapData.asCGImage() {
                mask = cgimg
            }
        }
        
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
        
        gestureController = GestureController(context: context,
                                              sceneView: sceneView,
                                              airView: (mask != nil) ? rootVC.view : nil,
                                              listeners: gestureListeners)
        viewController = Scene3DVC(context: context,
                                   frame: frame,
                                   arview: sceneView,
                                   listeners: arListeners,
                                   focusSquareSettings: focusSquareSettings)
        
        guard let vc = viewController, let view = vc.view else { return nil }

        if let mask = mask {
            let newLayer = CALayer()
            newLayer.backgroundColor = UIColor.clear.cgColor
            newLayer.frame = CGRect(x: 0,
                                    y: 0,
                                    width: rootVC.view.frame.width,
                                    height: rootVC.view.frame.height)
            
            newLayer.contents = mask
            for sv in rootVC.view.subviews {
                if sv.debugDescription.starts(with: "<CTStageView") && sv.layer is CAEAGLLayer {
                    sv.layer.mask = newLayer
                    sv.layer.masksToBounds = true
                }
            }
            // insert under AIR subView
            rootVC.view.insertSubview(view, at: 0)
        } else {
            rootVC.view.addSubview(view)
        }
        
        if let dt = logBox {
            rootVC.view.bringSubviewToFront(dt)
        }
    
        return nil
    }

    func ar3dview_dispose(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        for sv in UIApplication.shared.keyWindow?.rootViewController?.view.subviews ?? [] {
            if sv.debugDescription.starts(with: "<CTStageView") && sv.layer is CAEAGLLayer {
                sv.layer.mask = nil
            }
        }
        if let vc = viewController {
            vc.dispose()
            vc.removeFromParent()
        }
        viewController = nil
        gestureController?.dispose()
        gestureController = nil
        if let dt = logBox {
            dt.removeFromSuperview()
        }
        return nil
    }
    
    func ar3dview_setProp(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let vc = viewController,
            let name = String(argv[0]),
            let freValue = argv[1]
            else { return FreArgError().getError()
        }
        vc.ar3dview_setProp(name: name, value: freValue)
        return nil
    }
    
    func ar3dview_node(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let id = String(argv[0])
            else { return FreArgError().getError()
        }
        return vc.ar3dview_node(id: id)?.toFREObject()
    }
    
    func ar3dview_isNodeInsidePointOfView(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let nodeName = String(argv[0])
            else { return FreArgError().getError()
        }
        return vc.ar3dview_isNodeInsidePointOfView(nodeName: nodeName).toFREObject()
    }
    
    func camera_position(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard let vc = viewController
            else { return FreArgError().getError()
        }
        return vc.camera_position()?.toFREObject()
    }
    
    func ar3dview_hitTest3D(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let touchPoint = CGPoint(argv[0]),
            let types = [Int](argv[1]),
            let vc = viewController
            else { return FreArgError().getError()
        }
        return vc.ar3dview_hitTest3D(touchPoint: touchPoint, types: types)?.toFREObject(context)
    }
    
    func ar3dview_hitTest(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let touchPoint = CGPoint(argv[0]),
            let vc = viewController
            else { return FreArgError().getError()
        }
        var dict: [SCNHitTestOption: Any]?
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
        return vc.ar3dview_hitTest(touchPoint: touchPoint, options: dict)?.toFREObject()
    }
    
    func ar3dview_raycastQuery(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if #available(iOS 13.0, *) {
            guard argc > 2,
                let from = CGPoint(argv[0]),
                let allowingI = Int(argv[1]),
                let allowing = ARRaycastQuery.Target(rawValue: allowingI),
                let alignmentI = Int(argv[2]),
                let alignment = ARRaycastQuery.TargetAlignment(rawValue: alignmentI),
                let vc = viewController
                else {
                    return FreArgError(message: "ar3dview_raycastQuery").getError()
            }
            return vc.ar3dview_raycastQuery(from: from, allowing: allowing, alignment: alignment)?.toFREObject()
        } else {
            warning("This requires iOS 13.0")
        }
        return nil
    }
    
    // MARK: - Nodes and Geometry
    
    func node_addChildNode(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let nodeFre = argv[1],
            let isModel = Bool(nodeFre["isModel"]),
            let isDAE = Bool(nodeFre["isDAE"]),
            let vc = viewController
            else { return FreArgError().getError()
        }
        let parentName = String(argv[0])
        if isModel {
            if let nodeName = String(nodeFre["name"]), let model = vc.getModel(modelName: nodeName) {
                model.copyFromModel(nodeFre, isDAE)
                vc.node_addChildNode(parentName: parentName, node: model)
                return nil
            }
            return nil
        }
        if let node = SCNNode(nodeFre) {
            vc.node_addChildNode(parentName: parentName, node: node)
        } else {
            warning("node not created")
        }
        return nil
    }
    
    func node_removeFromParentNode(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let name = String(argv[0])
            else { return FreArgError().getError()
        }
        vc.node_removeFromParentNode(nodeName: name)
        return nil
    }
    
    func node_removeChildren(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let name = String(argv[0])
            else { return FreArgError().getError()
        }
        vc.node_removeChildren(nodeName: name)
        return nil
    }
    
    func node_setProp(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let vc = viewController,
            let nodeName = String(argv[0]),
            let propName = String(argv[1]),
            let freValue = argv[2]
            else { return FreArgError().getError()
        }
        vc.node_setProp(nodeName: nodeName, propName: propName, value: freValue)
        
        return nil
    }
    
    func node_childNode(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let vc = viewController,
            let nodeName = String(argv[1])
            else { return FreArgError().getError()
        }
        let parentName = String(argv[0])
        if let node = vc.node_childNode(parentName: parentName, nodeName: nodeName) {
            return node.toFREObject()
        }
        return nil
    }
    
    func addModel(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let vc = viewController,
            let url = String(argv[0]),
            let flatten = Bool(argv[2])
            else { return FreArgError().getError()
        }
        let nodeName = String(argv[1])
        
        if let node = vc.addModel(url: url, nodeName: nodeName, flatten: flatten) {
            return node.toFREObject() // construct full node with geometry mats etc
        }
        return nil
    }
    
    func geometry_setProp(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 3,
            let vc = viewController,
            let type = String(argv[0]),
            let nodeName = String(argv[1]),
            let propName = String(argv[2]),
            let freValue = argv[3]
            else { return FreArgError().getError()
        }
        vc.geometry_setProp(type: type, nodeName: nodeName, propName: propName, value: freValue)
        return nil
    }
    
    // MARK: - Materials
    
    func material_setProp(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 3,
            let vc = viewController,
            let id = String(argv[0]),
            let nodeName = String(argv[1]),
            let propName = String(argv[2]),
            let freValue = argv[3]
            else { return FreArgError().getError()
        }
        vc.material_setProp(name: id, nodeName: nodeName, propName: propName, value: freValue)
        return nil
    }
    
    func materialProperty_setProp(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 4,
            let vc = viewController,
            let id = String(argv[0]),
            let nodeName = String(argv[1]),
            let type = String(argv[2]),
            let propName = String(argv[3]),
            let freValue = argv[4]
            else { return FreArgError().getError()
        }
        vc.materialProperty_setProp(id: id, nodeName: nodeName, type: type, propName: propName, value: freValue)
        return nil
    }
    
    func light_setProp(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let vc = viewController,
            let nodeName = String(argv[0]),
            let propName = String(argv[1]),
            let freValue = argv[2]
            else { return FreArgError().getError()
        }
        
        vc.light_setProp(nodeName: nodeName, propName: propName, value: freValue)
        return nil
    }
    
    // MARK: - Transactions
    
    func transaction_begin(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        SCNTransaction.begin()
        return nil
    }
    
    func transaction_commit(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        SCNTransaction.commit()
        return nil
    }
    
    func transaction_setProp(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let propName = String(argv[0]),
            let freValue = argv[1]
            else { return FreArgError().getError()
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
    
    func action_create(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let vc = viewController,
            let id = String(argv[0]),
            let timingMode = Int(argv[1])
            else { return FreArgError().getError()
        }
        vc.action_create(id: id, timingMode: timingMode)
        return nil
    }
    
    func action_perform(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let id = String(argv[0]),
            let type = String(argv[1])
            else { return FreArgError().getError()
        }
        switch type {
        case "hide", "unhide", "repeatForever":
            vc.action_perform(id: id, type: type)
        case "rotateBy":
            if let x = CGFloat(argv[2]),
                let y = CGFloat(argv[3]),
                let z = CGFloat(argv[4]),
                let duration = Double(argv[5]) {
                vc.action_perform(id: id, type: type, args: x, y, z, duration)
            }
        case "moveBy", "moveTo":
            if let value = SCNVector3(argv[2]),
                let duration = Double(argv[3]) {
                vc.action_perform(id: id, type: type, args: value, duration)
            }
        case "scaleBy", "scaleTo":
            if let scale = CGFloat(argv[2]),
                let duration = Double(argv[3]) {
                vc.action_perform(id: id, type: type, args: scale, duration)
            }
        default:
            break
        }
        return nil
    }
    
    func node_runAction(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let id = String(argv[0]),
            let nodeName = String(argv[1])
            else { return FreArgError().getError()
        }
        vc.node_runAction(id: id, nodeName: nodeName)
        return nil
    }
    
    func action_setProp(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let vc = viewController,
            let id = String(argv[0]),
            let propName = String(argv[1]),
            let freValue = argv[2]
            else { return FreArgError().getError()
        }
        vc.action_setProp(id: id, propName: propName, value: freValue)
        return nil
    }
    
    func node_removeAllActions(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let nodeName = String(argv[0])
            else { return FreArgError().getError()
        }
        vc.node_removeAllActions(nodeName: nodeName)
        return nil
    }
    
    // MARK: - Physics
    
    func physics_applyForce(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 3,
            let vc = viewController,
            let direction = SCNVector3(argv[0]),
            let asImpulse = Bool(argv[1]),
            let nodeName = String(argv[3])
            else { return FreArgError().getError()
        }
        let at = SCNVector3(argv[2])
        vc.physics_applyForce(direction: direction, at: at, asImpulse: asImpulse, nodeName: nodeName)
        return nil
    }
    
    func physics_applyTorque(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let vc = viewController,
            let torque = SCNVector4(argv[0]),
            let asImpulse = Bool(argv[1]),
            let nodeName = String(argv[2])
            else { return FreArgError().getError()
        }
        vc.physics_applyTorque(torque: torque, asImpulse: asImpulse, nodeName: nodeName)
        return nil
    }
    
    func physics_clearAllForces(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let nodeName = String(argv[0])
            else { return FreArgError().getError()
        }
        vc.physics_clearAllForces(nodeName: nodeName)
        return nil
    }
    
    func physics_resetTransform(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let nodeName = String(argv[0])
            else { return FreArgError().getError()
        }
        vc.physics_resetTransform(nodeName: nodeName)
        return nil
    }
    
    func physics_setResting(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if #available(iOS 12.0, *) {
            guard argc > 0,
                let vc = viewController,
                let resting = Bool(argv[0]),
                let nodeName = String(argv[1])
                else { return FreArgError().getError()
            }
            vc.physics_setResting(resting: resting, nodeName: nodeName)
        } else {
            warning("This requires iOS 12.0")
        }
        return nil
    }
    
    func planeAnchor_isClassificationSupported(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if #available(iOS 12.0, *) {
            return ARPlaneAnchor.isClassificationSupported.toFREObject()
        }
        return false.toFREObject()
    }
    
    func physicsWorld_addBehaviour(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard let vc = viewController,
            let behavior = SCNPhysicsVehicle.init(argv[0])
            else { return FreArgError().getError()
        }
        vc.physicsWorld_addBehaviour(behavior: behavior)
        return nil
    }
    
    // MARK: - Physics Vehicle
    
    func vehicle_create(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("vehicle_create")
        guard let vc = viewController, let vehicle = SCNPhysicsVehicle(argv[0])
            else { return FreArgError().getError()
        }
        trace(vehicle.debugDescription)
        return vc.vehicle_create(vehicle: vehicle).toFREObject()
    }
    
    func vehicle_speedInKilometersPerHour(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard let vc = viewController, let id = String(argv[0])
            else { return FreArgError().getError()
        }
        return vc.vehicle_speedInKilometersPerHour(id: id)?.toFREObject()
    }
    
    func vehicle_applyEngineForce(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard let vc = viewController,
            let id = String(argv[0]),
            let value = CGFloat(argv[1]),
            let forWheelAt = Int(argv[2])
            else { return FreArgError().getError()
        }
        vc.vehicle_applyEngineForce(id: id, value: value, forWheelAt: forWheelAt)
        return nil
    }
    
    func vehicle_setSteeringAngle(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard let vc = viewController,
            let id = String(argv[0]),
            let value = CGFloat(argv[1]),
            let forWheelAt = Int(argv[2])
            else { return FreArgError().getError()
        }
        vc.vehicle_setSteeringAngle(id: id, value: value, forWheelAt: forWheelAt)
        return nil
    }
    
    func vehicle_applyBrakingForce(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard let vc = viewController,
            let id = String(argv[0]),
            let value = CGFloat(argv[1]),
            let forWheelAt = Int(argv[2])
            else { return FreArgError().getError()
        }
        vc.vehicle_applyBrakingForce(id: id, value: value, forWheelAt: forWheelAt)
        return nil
    }
    
    // MARK: - Coaching
    
    func coaching_create(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if #available(iOS 13.0, *) {
            guard argc > 0,
                let vc = viewController,
                let goalI = Int(argv[0]),
                let goal = ARCoachingOverlayView.Goal(rawValue: goalI)
                else { return FreArgError().getError()
            }
            vc.coaching_create(goal: goal)
        } else {
            warning("This requires iOS 13.0")
        }
        return nil
    }
    
    func coaching_activatesAutomatically(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if #available(iOS 13.0, *) {
            guard argc > 0,
                let vc = viewController,
                let activatesAutomatically = Bool(argv[0])
                else { return FreArgError().getError()
            }
            vc.coaching_activatesAutomatically(value: activatesAutomatically)
        } else {
            warning("This requires iOS 13.0")
        }
        return nil
    }
    
    func coaching_setActive(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if #available(iOS 13.0, *) {
            guard argc > 1,
                let vc = viewController,
                let active = Bool(argv[0]),
                let animated = Bool(argv[1])
                else { return FreArgError().getError()
            }
            vc.coaching_setActive(active: active, animated: animated)
        } else {
            warning("This requires iOS 13.0")
        }
        return nil
    }
    
    // MARK: - AS Event Listeners
    
    func addEventListener(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let type = String(argv[0]) else { return FreArgError().getError()
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
            let type = String(argv[0]) else { return FreArgError().getError()
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
            else { return FreArgError().getError()
        }
        vc.showFocusSquare()
        return nil
    }
    
    func hideFocusSquare(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard let vc = viewController
            else { return FreArgError().getError()
        }
        vc.hideFocusSquare()
        return nil
    }
    
    func enableFocusSquare(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let enable = Bool(argv[0])
            else { return FreArgError().getError()
        }
        vc.enableFocusSquare(enable: enable)
        return nil
    }
    
    func getFocusSquarePosition(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard let vc = viewController
            else { return FreArgError().getError()
        }
        return vc.getFocusSquarePosition()?.toFREObject()
    }
    
    func supportsUserFaceTracking(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if #available(iOS 13.0, *) {
            return ARWorldTrackingConfiguration.supportsUserFaceTracking.toFREObject()
        } 
        return false.toFREObject()
    }
    
}
