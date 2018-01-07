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

public extension SCNSphere {
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject,
            let radius = CGFloat(rv["radius"]),
            let segmentCount = Int(rv["segmentCount"]),
            let subdivisionLevel = Int(rv["subdivisionLevel"]),
            let isGeodesic = Bool(rv["isGeodesic"])
            else {
                return nil
        }
        
        self.init()
        self.radius = radius
        self.segmentCount = segmentCount
        self.isGeodesic = isGeodesic
        self.subdivisionLevel = subdivisionLevel
        
        if let freMaterials = rv["materials"] {
            let freArray = FREArray.init(freMaterials)
            for i in 0..<freArray.length {
                if let freMat = freArray[i], let mat = SCNMaterial.init(freMat) {
                    self.materials[Int(i)] = mat
                }
            }
        }
    }
    
    func setProp(name:String, value:FREObject) {
        switch name {
        case "radius":
            self.radius = CGFloat(value) ?? self.radius
            break
        case "segmentCount":
            self.segmentCount = Int(value) ?? self.segmentCount
            break
        case "isGeodesic":
            self.isGeodesic = Bool(value) ?? self.isGeodesic
            break
        case "subdivisionLevel":
            self.subdivisionLevel = Int(value) ?? self.subdivisionLevel
            break
        default:
            break
        }
    }
    
}
