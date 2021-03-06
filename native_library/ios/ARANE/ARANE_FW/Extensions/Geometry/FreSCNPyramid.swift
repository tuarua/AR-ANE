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

public extension SCNPyramid {
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject else { return nil }
        let fre = FreObjectSwift(rv)
        self.init()
        width = fre.width
        height = fre.height
        length = fre.length
        widthSegmentCount = fre.widthSegmentCount
        heightSegmentCount = fre.heightSegmentCount
        lengthSegmentCount = fre.lengthSegmentCount
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
        case "width":
            self.width = CGFloat(value) ?? self.width
        case "height":
            self.height = CGFloat(value) ?? self.height
        case "length":
            self.length = CGFloat(value) ?? self.length
        case "widthSegmentCount":
            self.widthSegmentCount = Int(value) ?? self.widthSegmentCount
        case "heightSegmentCount":
            self.heightSegmentCount = Int(value) ?? self.heightSegmentCount
        case "lengthSegmentCount":
            self.lengthSegmentCount = Int(value) ?? self.lengthSegmentCount
        case "subdivisionLevel":
            self.subdivisionLevel = Int(value) ?? self.subdivisionLevel
        case "materials":
            applyMaterials(value)
        default:
            break
        }
    }
    
    @objc override func toFREObject(nodeName: String?) -> FREObject? {
        guard let fre = FreObjectSwift(className: "com.tuarua.arkit.shapes.Pyramid") else {
            return nil
        }
        fre.width = width
        fre.height = height
        fre.length = length
        fre.widthSegmentCount = widthSegmentCount
        fre.heightSegmentCount = heightSegmentCount
        fre.lengthSegmentCount = lengthSegmentCount
        fre.subdivisionLevel = subdivisionLevel
        if materials.count > 0 {
            fre.materials = materials.toFREObject(nodeName: nodeName)
        }
        fre.nodeName = nodeName
        return fre.rawValue
    }
    
}
