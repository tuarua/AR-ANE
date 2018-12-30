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

import Foundation
import FreSwift

extension SwiftController: FreSwiftMainController {
    // Must have this function. It exposes the methods to our entry ObjC.
    @objc public func getFunctions(prefix: String) -> [String] {
        functionsToSet["\(prefix)init"] = initController
        functionsToSet["\(prefix)createGUID"] = createGUID
        functionsToSet["\(prefix)getIosVersion"] = getIosVersion
        functionsToSet["\(prefix)appendToLog"] = appendToLog
        functionsToSet["\(prefix)displayLogging"] = displayLogging
        
        functionsToSet["\(prefix)ar3dview_init"] = ar3dview_init
        functionsToSet["\(prefix)ar3dview_dispose"] = ar3dview_dispose
        functionsToSet["\(prefix)ar3dview_setProp"] = ar3dview_setProp
        functionsToSet["\(prefix)ar3dview_node"] = ar3dview_node
        functionsToSet["\(prefix)ar3dview_debugOptions"] = ar3dview_debugOptions
        functionsToSet["\(prefix)ar3dview_isNodeInsidePointOfView"] = ar3dview_isNodeInsidePointOfView
        functionsToSet["\(prefix)ar3dview_hitTest3D"] = ar3dview_hitTest3D
        functionsToSet["\(prefix)ar3dview_hitTest"] = ar3dview_hitTest
        functionsToSet["\(prefix)camera_position"] = camera_position

        functionsToSet["\(prefix)addModel"] = addModel
        
        functionsToSet["\(prefix)geometry_setProp"] = geometry_setProp
        functionsToSet["\(prefix)material_setProp"] = material_setProp
        functionsToSet["\(prefix)materialProperty_setProp"] = materialProperty_setProp
        functionsToSet["\(prefix)light_setProp"] = light_setProp
        
        functionsToSet["\(prefix)session_run"] = session_run
        functionsToSet["\(prefix)session_pause"] = session_pause
        functionsToSet["\(prefix)session_setWorldOrigin"] = session_setWorldOrigin
        functionsToSet["\(prefix)session_saveCurrentWorldMap"] = session_saveCurrentWorldMap
        functionsToSet["\(prefix)session_createReferenceObject"] = session_createReferenceObject
        functionsToSet["\(prefix)session_add"] = session_add
        functionsToSet["\(prefix)session_remove"] = session_remove
        
        functionsToSet["\(prefix)transaction_begin"] = transaction_begin
        functionsToSet["\(prefix)transaction_commit"] = transaction_commit
        functionsToSet["\(prefix)transaction_setProp"] = transaction_setProp
        
        functionsToSet["\(prefix)action_create"] = action_create
        functionsToSet["\(prefix)action_perform"] = action_perform
        functionsToSet["\(prefix)action_setProp"] = action_setProp
        
        functionsToSet["\(prefix)node_runAction"] = node_runAction
        functionsToSet["\(prefix)node_removeAllActions"] = node_removeAllActions
        functionsToSet["\(prefix)node_removeChildren"] = node_removeChildren
        functionsToSet["\(prefix)node_removeFromParentNode"] = node_removeFromParentNode
        functionsToSet["\(prefix)node_addChildNode"] = node_addChildNode
        functionsToSet["\(prefix)node_childNode"] = node_childNode
        functionsToSet["\(prefix)node_setProp"] = node_setProp
        
        functionsToSet["\(prefix)physics_applyForce"] = physics_applyForce
        functionsToSet["\(prefix)physics_applyTorque"] = physics_applyTorque
        functionsToSet["\(prefix)physics_clearAllForces"] = physics_clearAllForces
        functionsToSet["\(prefix)physics_resetTransform"] = physics_resetTransform
        functionsToSet["\(prefix)physics_setResting"] = physics_setResting
        functionsToSet["\(prefix)planeAnchor_isClassificationSupported"] = planeAnchor_isClassificationSupported
        
        functionsToSet["\(prefix)addEventListener"] = addEventListener
        functionsToSet["\(prefix)removeEventListener"] = removeEventListener
        functionsToSet["\(prefix)requestPermissions"] = requestPermissions
        functionsToSet["\(prefix)showFocusSquare"] = showFocusSquare
        functionsToSet["\(prefix)hideFocusSquare"] = hideFocusSquare
        functionsToSet["\(prefix)enableFocusSquare"] = enableFocusSquare
        functionsToSet["\(prefix)getFocusSquarePosition"] = getFocusSquarePosition

        var arr: [String] = []
        for key in functionsToSet.keys {
            arr.append(key)
        }
        return arr
    }

    @objc public func dispose() {
        UIApplication.shared.isIdleTimerDisabled = false
        NotificationCenter.default.removeObserver(self)
        viewController?.dispose()
        viewController = nil
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
        self.context = FreContextSwift(freContext: ctx)
        // Turn on FreSwift logging
        FreSwiftLogger.shared.context = context
    }
    
    @objc func applicationDidFinishLaunching(_ notification: Notification) {
        
    }
    
    @objc public func onLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidFinishLaunching),
                                               name: UIApplication.didFinishLaunchingNotification, object: nil)
        
    }
    
}
