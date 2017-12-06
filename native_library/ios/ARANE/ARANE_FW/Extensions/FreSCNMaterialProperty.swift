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

public extension SCNMaterialProperty {
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject,
            let freContents:FREObject = rv["contents"],
            let freIntensity:FREObject = rv["intensity"],
            let freMinificationFilter:FREObject = rv["minificationFilter"],
            let freMagnificationFilter:FREObject = rv["magnificationFilter"],
            let freMipFilter:FREObject = rv["mipFilter"],
            let freWrapS:FREObject = rv["wrapS"],
            let freWrapT:FREObject = rv["wrapT"],
            let freMappingChannel:FREObject = rv["mappingChannel"],
            let freMaxAnisotropy:FREObject = rv["maxAnisotropy"]
            else {
                return nil
        }
        
        guard
            let intensity = CGFloat.init(freIntensity),
            let minificationFilter = Int(freMinificationFilter),
            let magnificationFilter = Int(freMagnificationFilter),
            let wrapS = Int(freWrapS),
            let wrapT = Int(freWrapT),
            let mappingChannel = Int(freMappingChannel),
            let maxAnisotropy = CGFloat(freMaxAnisotropy),
            let mipFilter = Int(freMipFilter)
            else {
                return nil
        }
        self.init()
        switch freContents.type {
        case .bitmapdata:
            break
        default:
            //assume uint for color
            break
        }
        //self.contents = contents // TODO  will need to make sure it can handle uint for colours and itmapdata
        
        self.intensity = intensity
        self.magnificationFilter = SCNFilterMode.init(rawValue: magnificationFilter) ?? .linear
        self.minificationFilter = SCNFilterMode.init(rawValue: minificationFilter) ?? .linear
        self.mipFilter = SCNFilterMode.init(rawValue: mipFilter) ?? .nearest
        self.wrapS = SCNWrapMode.init(rawValue: wrapS) ?? .clamp
        self.wrapT = SCNWrapMode.init(rawValue: wrapT) ?? .clamp
        self.mappingChannel = mappingChannel
        self.maxAnisotropy = maxAnisotropy
    }
}
