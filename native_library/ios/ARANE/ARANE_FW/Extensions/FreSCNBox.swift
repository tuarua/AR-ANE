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
        guard let rv = freObject,
            let freSpecularColor:FREObject = rv["specularColor"],
            let freDiffuseColor:FREObject = rv["diffuseColor"],
            let freWidth:FREObject = rv["width"],
            let freHeight:FREObject = rv["height"],
            let freLength:FREObject = rv["length"],
            let freChamferRadius:FREObject = rv["chamferRadius"],
            let freWidthSegmentCount:FREObject = rv["widthSegmentCount"],
            let freHeightSegmentCount:FREObject = rv["heightSegmentCount"],
            let freLengthSegmentCount:FREObject = rv["lengthSegmentCount"],
            let freChamferSegmentCount:FREObject = rv["chamferSegmentCount"]
            
            else {
                return nil
        }
        
        guard
            let width = CGFloat(freWidth),
            let height = CGFloat(freHeight),
            let length = CGFloat(freLength),
            let chamferRadius = CGFloat(freChamferRadius),
            let widthSegmentCount = Int(freWidthSegmentCount),
            let heightSegmentCount = Int(freHeightSegmentCount),
            let lengthSegmentCount = Int(freLengthSegmentCount),
            let chamferSegmentCount = Int(freChamferSegmentCount)
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
        
        self.firstMaterial?.specular.contents = UIColor(freObject: freSpecularColor)
        self.firstMaterial?.diffuse.contents = UIColor(freObject: freDiffuseColor)
    }
    
    func setProp(name:String, value:FREObject) {
        switch name {
        case "width":
            self.width = CGFloat(value) ?? self.width
            break
        case "height":
            self.height = CGFloat(value) ?? self.height
            break
        case "length":
            self.length = CGFloat(value) ?? self.length
            break
        case "chamferRadius":
            self.chamferRadius = CGFloat(value) ?? self.chamferRadius
            break
        case "widthSegmentCount":
            self.widthSegmentCount = Int(value) ?? self.widthSegmentCount
            break
        case "heightSegmentCount":
            self.heightSegmentCount = Int(value) ?? self.heightSegmentCount
            break
        case "lengthSegmentCount":
            self.lengthSegmentCount = Int(value) ?? self.lengthSegmentCount
            break
        case "chamferSegmentCount":
            self.chamferSegmentCount = Int(value) ?? self.chamferSegmentCount
            break
        default:
            break
        }
    }
    
}
