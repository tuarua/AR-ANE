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

public extension SCNText {
    convenience init?(_ freObject: FREObject?) {
        guard
            let rv = freObject,
            let string = String(rv["string"]),
            let extrusionDepth = CGFloat(rv["extrusionDepth"]),
            let flatness = CGFloat(rv["flatness"]),
            let subdivisionLevel = Int(rv["subdivisionLevel"]),
            let chamferRadius = CGFloat(rv["chamferRadius"])
            else {
                return nil
        }
        self.init()
        self.string = string
        self.extrusionDepth = extrusionDepth
        self.flatness = flatness
        self.chamferRadius = chamferRadius
        self.subdivisionLevel = subdivisionLevel
        applyMaterials(rv["materials"])
    }
    
    func applyMaterials(_ value: FREObject?) {
        guard let freMaterials = value else { return }
        let freArray: FREArray = FREArray(freMaterials)
        guard freArray.length > 0 else { return }
        var mats = [SCNMaterial](repeating: SCNMaterial(), count: Int(freArray.length))
        for i in 0..<freArray.length {
            if let mat = SCNMaterial(freArray[i]) {
                mats[Int(i)] = mat
            }
        }
        self.materials = mats
    }
    
    func setProp(name: String, value: FREObject) {
        switch name {
        case "string":
            self.string = String(value) ?? self.string
        case "extrusionDepth":
            self.extrusionDepth = CGFloat(value) ?? self.extrusionDepth
        case "flatness":
            self.flatness = CGFloat(value) ?? self.flatness
        case "chamferRadius":
            self.chamferRadius = CGFloat(value) ?? self.chamferRadius
        case "subdivisionLevel":
            self.subdivisionLevel = Int(value) ?? self.subdivisionLevel
        case "materials":
            applyMaterials(value)
        default:
            break
        }
    }
    
    @objc override func toFREObject(nodeName: String?) -> FREObject? {
        guard let fre = FreObjectSwift(className: "com.tuarua.arkit.shapes.Text") else {
            return nil
        }
        fre.extrusionDepth = extrusionDepth
        fre.chamferRadius = chamferRadius
        fre.flatness = flatness
        if let string = self.string as? String {
            fre.string = string
        }
        fre.subdivisionLevel = subdivisionLevel
        if materials.count > 0 {
            fre.materials = materials.toFREObject(nodeName: nodeName)
        }
        fre.nodeName = nodeName
        return fre.rawValue
    }
    
}
