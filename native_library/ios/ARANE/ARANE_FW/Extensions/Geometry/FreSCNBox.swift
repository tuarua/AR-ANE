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

public extension SCNBox {
    convenience init?(_ freObject: FREObject?) {
        guard
            let rv = freObject,
            let width = CGFloat(rv["width"]),
            let height = CGFloat(rv["height"]),
            let length = CGFloat(rv["length"]),
            let chamferRadius = CGFloat(rv["chamferRadius"]),
            let widthSegmentCount = Int(rv["widthSegmentCount"]),
            let heightSegmentCount = Int(rv["heightSegmentCount"]),
            let lengthSegmentCount = Int(rv["lengthSegmentCount"]),
            let chamferSegmentCount = Int(rv["chamferSegmentCount"]),
            let subdivisionLevel = Int(rv["subdivisionLevel"])
            else {
                return nil
        }
        
        self.init()
        
        self.width = width
        self.height = height
        self.length = length
        self.widthSegmentCount = widthSegmentCount
        self.heightSegmentCount = heightSegmentCount
        self.lengthSegmentCount = lengthSegmentCount
        self.chamferRadius = chamferRadius
        self.chamferSegmentCount = chamferSegmentCount
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
        case "width":
            self.width = CGFloat(value) ?? self.width
        case "height":
            self.height = CGFloat(value) ?? self.height
        case "length":
            self.length = CGFloat(value) ?? self.length
        case "chamferRadius":
            self.chamferRadius = CGFloat(value) ?? self.chamferRadius
        case "widthSegmentCount":
            self.widthSegmentCount = Int(value) ?? self.widthSegmentCount
        case "heightSegmentCount":
            self.heightSegmentCount = Int(value) ?? self.heightSegmentCount
        case "lengthSegmentCount":
            self.lengthSegmentCount = Int(value) ?? self.lengthSegmentCount
        case "chamferSegmentCount":
            self.chamferSegmentCount = Int(value) ?? self.chamferSegmentCount
        case "subdivisionLevel":
            self.subdivisionLevel = Int(value) ?? self.subdivisionLevel
        case "materials":
            applyMaterials(value)
        default:
            break
        }
    }
    
    @objc override func toFREObject(nodeName: String?) -> FREObject? {
        do {
            let ret = try FREObject(className: "com.tuarua.arane.shapes.Box")
            try ret?.setProp(name: "width", value: self.width.toFREObject())
            try ret?.setProp(name: "length", value: self.length.toFREObject())
            try ret?.setProp(name: "chamferRadius", value: self.chamferRadius.toFREObject())
            try ret?.setProp(name: "widthSegmentCount", value: self.widthSegmentCount.toFREObject())
            try ret?.setProp(name: "heightSegmentCount", value: self.heightSegmentCount.toFREObject())
            try ret?.setProp(name: "lengthSegmentCount", value: self.lengthSegmentCount.toFREObject())
            try ret?.setProp(name: "chamferSegmentCount", value: self.chamferSegmentCount.toFREObject())
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
