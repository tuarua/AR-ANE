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
import ARKit

@available(iOS 13.0, *)
public extension ARRaycastResult {
    func toFREObject() -> FREObject? {
        guard let fre = FreObjectSwift(className: "com.tuarua.arkit.raycast.RaycastResult") else {
            return nil
        }
        fre.worldTransform = worldTransform.toFREObject()
        fre.target = target.rawValue
        fre.targetAlignment = targetAlignment.rawValue
        fre.anchor = anchor?.toFREObject()
        return fre.rawValue
    }
}

@available(iOS 13.0, *)
public extension Array where Element == ARRaycastResult {
    func toFREObject() -> FREObject? {
        return FREArray(className: "com.tuarua.arkit.raycast.RaycastResult",
                             length: self.count, fixed: true,
                             items: self.compactMap { $0.toFREObject() })?.rawValue
    }
}
