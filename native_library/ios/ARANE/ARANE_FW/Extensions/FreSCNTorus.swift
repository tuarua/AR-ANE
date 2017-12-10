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

public extension SCNTorus {
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject,
            let freRingRadius:FREObject = rv["ringRadius"],
            let frePipeRadius:FREObject = rv["pipeRadius"],
            let freRingSegmentCount:FREObject = rv["ringSegmentCount"],
            let frePipeSegmentCount:FREObject = rv["pipeSegmentCount"]
            else {
                return nil
        }
        
        guard
            let ringRadius = CGFloat(freRingRadius),
            let pipeRadius = CGFloat(frePipeRadius),
            let ringSegmentCount = Int(freRingSegmentCount),
            let pipeSegmentCount = Int(frePipeSegmentCount)
            else {
                return nil
        }
        
        self.init()
        
        self.ringRadius = ringRadius
        self.pipeRadius = pipeRadius
        self.ringSegmentCount = ringSegmentCount
        self.pipeSegmentCount = pipeSegmentCount
        
        if let freMaterials:FREObject = rv["materials"] {
            let freArray:FREArray = FREArray.init(freMaterials)
            for i in 0..<freArray.length {
                if let freMat = freArray[i], let mat = SCNMaterial.init(freMat) {
                    self.materials[Int(i)] = mat
                }
            }
        }
        
    }
    
    func setProp(name:String, value:FREObject) {
        switch name {
        case "ringRadius":
            self.ringRadius = CGFloat(value) ?? self.ringRadius
            break
        case "pipeRadius":
            self.pipeRadius = CGFloat(value) ?? self.pipeRadius
            break
        case "ringSegmentCount":
            self.ringSegmentCount = Int(value) ?? self.ringSegmentCount
            break
        case "pipeSegmentCount":
            self.pipeSegmentCount = Int(value) ?? self.pipeSegmentCount
            break
        default:
            break
        }
    }
    
}
