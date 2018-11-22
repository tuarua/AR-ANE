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
        guard let rv = freObject else { return nil }
        let fre = FreObjectSwift(rv)
        self.init()
        capRadius = fre.capRadius
        height = fre.height
        radialSegmentCount = fre.radialSegmentCount
        heightSegmentCount = fre.heightSegmentCount
        capSegmentCount = fre.capSegmentCount
        subdivisionLevel = fre.subdivisionLevel
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
    
    @objc override func toFREObject(nodeName: String?) -> FREObject? {
        guard let fre = FreObjectSwift(className: "com.tuarua.arane.shapes.Capsule") else {
            return nil
        }
        fre.capRadius = capRadius
        fre.height = height
        fre.radialSegmentCount = radialSegmentCount
        fre.heightSegmentCount = heightSegmentCount
        fre.capSegmentCount = capSegmentCount
        fre.subdivisionLevel = subdivisionLevel
        if materials.count > 0 {
            fre.materials = materials.toFREObject(nodeName: nodeName)
        }
        fre.nodeName = nodeName
        return fre.rawValue
    }
    
}
