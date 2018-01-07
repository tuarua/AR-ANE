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

public extension SCNGeometry {
    
    func setModelProp(name:String, value:FREObject) {
        switch name {
        case "subdivisionLevel":
            self.subdivisionLevel = Int(value) ?? self.subdivisionLevel
            break
        case "materials":
            let freArray = FREArray.init(value)
            for i in 0..<freArray.length {
                if let mat = SCNMaterial.init(freArray[i]) {
                    self.materials[Int(i)] = mat
                }
            }
            break
        default:
            break
        }
    }
    
    func toFREObject(nodeName:String? ) -> FREObject? {
        do {
            let ret = try FREObject(className: "com.tuarua.arane.shapes.Geometry", args: "geometry")
            try ret?.setProp(name: "nodeName", value: nodeName)
            try ret?.setProp(name: "subdivisionLevel", value: self.subdivisionLevel)
            if materials.count > 0 {
                let freArray = try FREArray.init(className: "Vector.<com.tuarua.arane.materials.Material>", args: materials.count)
                var cnt:UInt = 0
                for material in self.materials {
                    if let freMat = material.toFREObject(nodeName: nodeName) {
                        try freArray.set(index: cnt, value: freMat)
                        cnt = cnt + 1
                    }
                }
                try ret?.setProp(name: "materials", value: freArray)
            }
            return ret
        } catch {
        }
        return nil
    }
}
