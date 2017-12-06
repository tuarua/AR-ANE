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

public extension SCNTube {
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject,
            let freSpecularColor = try? rv.getProp(name: "specularColor"),
            let freDiffuseColor = try? rv.getProp(name: "diffuseColor"),
            let freInnerRadius:FREObject = rv["innerRadius"],
            let freOuterRadius:FREObject = rv["outerRadius"],
            let freHeight:FREObject = rv["height"],
            let freRadialSegmentCount:FREObject = rv["radialSegmentCount"],
            let freHeightSegmentCount:FREObject = rv["heightSegmentCount"]
            else {
                return nil
        }
        
        guard
            let innerRadius = CGFloat(freInnerRadius),
            let outerRadius = CGFloat(freOuterRadius),
            let height = CGFloat(freHeight),
            let radialSegmentCount = Int(freRadialSegmentCount),
            let heightSegmentCount = Int(freHeightSegmentCount)
            else {
                return nil
        }
        
        self.init()
        
        self.height = height
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
        self.radialSegmentCount = radialSegmentCount
        self.heightSegmentCount = heightSegmentCount
        
        self.firstMaterial?.specular.contents = UIColor(freObject: freSpecularColor)
        self.firstMaterial?.diffuse.contents = UIColor(freObject: freDiffuseColor)
    }
    
}
