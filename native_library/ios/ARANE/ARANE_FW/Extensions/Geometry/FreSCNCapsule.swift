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

public extension SCNCapsule {
    convenience init?(_ freObject: FREObject?) {
        guard
            let rv = freObject,
            let capRadius = CGFloat(rv["capRadius"]),
            let height = CGFloat(rv["height"]),
            let radialSegmentCount = Int(rv["radialSegmentCount"]),
            let heightSegmentCount = Int(rv["heightSegmentCount"]),
            let subdivisionLevel = Int(rv["subdivisionLevel"]),
            let capSegmentCount = Int(rv["capSegmentCount"])
            else {
                return nil
        }
        
        self.init()
        
        self.capRadius = capRadius
        self.height = height
        self.radialSegmentCount = radialSegmentCount
        self.heightSegmentCount = heightSegmentCount
        self.capSegmentCount = capSegmentCount
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
        case "capRadius":
            self.capRadius = CGFloat(value) ?? self.capRadius
        case "height":
            self.height = CGFloat(value) ?? self.height
        case "radialSegmentCount":
            self.radialSegmentCount = Int(value) ?? self.radialSegmentCount
        case "heightSegmentCount":
            self.heightSegmentCount = Int(value) ?? self.heightSegmentCount
        case "capSegmentCount":
            self.capSegmentCount = Int(value) ?? self.capSegmentCount
        case "subdivisionLevel":
            self.subdivisionLevel = Int(value) ?? self.subdivisionLevel
        case "materials":
            applyMaterials(value)
        default:
            break
        }
    }
    
    func toFREObject(nodeName: String?) -> FREObject? {
        do {
            let ret = try FREObject(className: "com.tuarua.arane.shapes.Capsule")
            try ret?.setProp(name: "capRadius", value: self.capRadius.toFREObject())
            try ret?.setProp(name: "height", value: self.height.toFREObject())
            try ret?.setProp(name: "radialSegmentCount", value: self.radialSegmentCount.toFREObject())
            try ret?.setProp(name: "heightSegmentCount", value: self.heightSegmentCount.toFREObject())
            try ret?.setProp(name: "capSegmentCount", value: self.capSegmentCount.toFREObject())
            try ret?.setProp(name: "subdivisionLevel", value: self.subdivisionLevel.toFREObject())
            if materials.count > 0 {
                try ret?.setProp(name: "materials", value: materials.toFREObject(nodeName: nodeName))
            }
            //make sure to set this last as it triggers setANEvalue otherwise
            try ret?.setProp(name: "nodeName", value: nodeName)
            return ret
        } catch {
        }
        return nil
    }
    
}
