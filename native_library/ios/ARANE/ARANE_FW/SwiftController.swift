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


public class SwiftController: NSObject, ARSCNViewDelegate, FreSwiftMainController {
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
    
    //private var userView: UIView?

    // Must have this function. It exposes the methods to our entry ObjC.
    @objc public func getFunctions(prefix: String) -> Array<String> {

        functionsToSet["\(prefix)init"] = initController
        functionsToSet["\(prefix)initScene3D"] = initScene3D
        functionsToSet["\(prefix)disposeScene3D"] = disposeScene3D
        functionsToSet["\(prefix)setScene3DProp"] = setScene3DProp
        
        functionsToSet["\(prefix)appendToLog"] = appendToLog
        functionsToSet["\(prefix)displayLogging"] = displayLogging
        functionsToSet["\(prefix)setDebugOptions"] = setDebugOptions

        functionsToSet["\(prefix)addChildNode"] = addChildNode
        functionsToSet["\(prefix)setChildNodeProp"] = setChildNodeProp
        functionsToSet["\(prefix)removeFromParentNode"] = removeFromParentNode
        
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

        var arr: Array<String> = []
        for key in functionsToSet.keys {
            arr.append(key)
        }
        return arr
    }
    
    // https://github.com/sriscode/Arkit-PlaneDetect-PlaceObject/blob/master/ArkitPlaneDetect%26PlaceObject/ViewController.swift

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
        appendToLog("setDebugOptions")
        guard argc > 0,
            let vc = viewController,
            let options = Array<String>(argv[0])
          else {
            return ArgCountError.init(message: "setDebugOptions").getError(#file, #line, #column)
        }
        vc.setDebugOptions(options: options)
        return nil
    }

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

    func initScene3D(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        appendToLog("initScene3D")
        guard argc > 5,
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
            let inFRE1 = argv[1]
            else {
                return ArgCountError.init(message: "setScene3DProp").getError(#file, #line, #column)
        }
        vc.setScene3DProp(name: name, value: inFRE1)
        return nil
    }

    func addChildNode(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
              let inFRE1 = argv[1]
          else {
            return ArgCountError.init(message: "addChildNode").getError(#file, #line, #column)
        }
        let parentId = String(argv[0])
        guard let vc = viewController,
              let node = SCNNode.init(inFRE1) else {
            return nil
        }
        vc.addChildNode(parentId: parentId, node: node)
        return nil
    }
    
    func removeFromParentNode(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let vc = viewController,
            let id = String(argv[0])
            else {
                return ArgCountError.init(message: "removeFromParentNode").getError(#file, #line, #column)
        }
        vc.removeFromParentNode(id: id)
        return nil
    }
    
    func setChildNodeProp(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let vc = viewController,
            let id = String(argv[0]),
            let name = String(argv[1]),
            let freValue = argv[2]
            else {
                return ArgCountError.init(message: "setChildNodeProp").getError(#file, #line, #column)
        }
        vc.setChildNodeProp(id: id, name: name, value: freValue)
        
        return nil
    }
    
    func setMaterialProp(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 3,
            let vc = viewController,
            let id = String(argv[0]),
            let nodeId = String(argv[1]),
            let name = String(argv[2]),
            let freValue = argv[3]
            else {
                return ArgCountError.init(message: "setMaterialProp").getError(#file, #line, #column)
        }
        vc.setMaterialProp(id: id, nodeId: nodeId, name: name, value: freValue)
        return nil
    }
    
    func setMaterialPropertyProp(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 4,
            let vc = viewController,
            let id = String(argv[0]),
            let nodeId = String(argv[1]),
            let type = String(argv[2]),
            let name = String(argv[3]),
            let freValue = argv[4]
            else {
                return ArgCountError.init(message: "setMaterialPropertyProp").getError(#file, #line, #column)
        }
        vc.setMaterialPropertyProp(id:id, nodeId: nodeId, type: type, name: name, value: freValue)
        return nil
    }
    
    func setLightProp(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let vc = viewController,
            let nodeId = String(argv[0]),
            let name = String(argv[1]),
            let freValue = argv[2]
            else {
                return ArgCountError.init(message: "setLightProp").getError(#file, #line, #column)
        }

        vc.setLightProp(nodeId:nodeId, name: name, value: freValue)
        return nil
    }
    
    func setGeometryProp(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 3,
            let vc = viewController,
            let type = String(argv[0]),
            let nodeId = String(argv[1]),
            let name = String(argv[2]),
            let freValue = argv[3]
            else {
                return ArgCountError.init(message: "setGeometryProp").getError(#file, #line, #column)
        }
        vc.setGeometryProp(type:type, nodeId:nodeId, name: name, value: freValue)
        return nil
    }

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
