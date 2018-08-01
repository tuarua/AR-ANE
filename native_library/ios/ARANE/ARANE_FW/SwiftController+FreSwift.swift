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
        functionsToSet["\(prefix)initScene3D"] = initScene3D
        functionsToSet["\(prefix)disposeScene3D"] = disposeScene3D
        functionsToSet["\(prefix)setScene3DProp"] = setScene3DProp
        functionsToSet["\(prefix)getNodeFromAnchor"] = getNodeFromAnchor
        functionsToSet["\(prefix)getAnchorFromNode"] = getAnchorFromNode
        functionsToSet["\(prefix)isNodeInsidePointOfView"] = isNodeInsidePointOfView
        functionsToSet["\(prefix)getCameraPosition"] = getCameraPosition
        functionsToSet["\(prefix)hitTest3D"] = hitTest3D
        functionsToSet["\(prefix)hitTest"] = hitTest
        functionsToSet["\(prefix)appendToLog"] = appendToLog
        functionsToSet["\(prefix)displayLogging"] = displayLogging
        functionsToSet["\(prefix)setDebugOptions"] = setDebugOptions
        functionsToSet["\(prefix)addChildNode"] = addChildNode
        functionsToSet["\(prefix)setChildNodeProp"] = setChildNodeProp
        functionsToSet["\(prefix)removeFromParentNode"] = removeFromParentNode
        functionsToSet["\(prefix)removeChildNodes"] = removeChildNodes
        functionsToSet["\(prefix)getChildNode"] = getChildNode
        functionsToSet["\(prefix)addModel"] = addModel
        functionsToSet["\(prefix)setGeometryProp"] = setGeometryProp
        functionsToSet["\(prefix)setMaterialProp"] = setMaterialProp
        functionsToSet["\(prefix)setMaterialPropertyProp"] = setMaterialPropertyProp
        functionsToSet["\(prefix)setLightProp"] = setLightProp
        functionsToSet["\(prefix)runSession"] = runSession
        functionsToSet["\(prefix)pauseSession"] = pauseSession
        functionsToSet["\(prefix)setWorldOriginSession"] = setWorldOriginSession
        functionsToSet["\(prefix)addAnchor"] = addAnchor
        functionsToSet["\(prefix)removeAnchor"] = removeAnchor
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
        self.context = FreContextSwift.init(freContext: ctx)
    }
    
    @objc func applicationDidFinishLaunching(_ notification: Notification) {
        
    }
    
    @objc public func onLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidFinishLaunching),
                                               name: NSNotification.Name.UIApplicationDidFinishLaunching, object: nil)
        
    }
    
}
