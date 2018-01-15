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
            let freContents = rv["contents"],
            let intensity = CGFloat(rv["intensity"]),
            let minificationFilter = Int(rv["minificationFilter"]),
            let magnificationFilter = Int(rv["magnificationFilter"]),
            let wrapS = Int(rv["wrapS"]),
            let wrapT = Int(rv["wrapT"]),
            let mappingChannel = Int(rv["mappingChannel"]),
            let maxAnisotropy = CGFloat(rv["maxAnisotropy"]),
            let mipFilter = Int(rv["mipFilter"])
            else {
                return nil
        }

        self.init()
        
        switch freContents.type {
        case .bitmapdata:
            self.contents = UIImage(freObject: freContents)
            break
        case .string:
            if let file = String(freContents) {
                if file.hasPrefix("/") {
                    self.contents = UIImage.init(contentsOfFile: file)
                } else {
                    self.contents = UIImage.init(named: file)
                }  
            }
            break
        case .int: fallthrough
        case .number:
            self.contents = UIColor(freObjectARGB: freContents)
            break
        default:
            return nil
        }
        
        self.intensity = intensity
        self.magnificationFilter = SCNFilterMode.init(rawValue: magnificationFilter) ?? .linear
        self.minificationFilter = SCNFilterMode.init(rawValue: minificationFilter) ?? .linear
        self.mipFilter = SCNFilterMode.init(rawValue: mipFilter) ?? .nearest
        self.wrapS = SCNWrapMode.init(rawValue: wrapS) ?? .clamp
        self.wrapT = SCNWrapMode.init(rawValue: wrapT) ?? .clamp
        self.mappingChannel = mappingChannel
        self.maxAnisotropy = maxAnisotropy
    }
    
    func setProp(name:String, value:FREObject) {
        switch name {
        case "contents":
            switch value.type {
            case .bitmapdata:
                self.contents = UIImage(freObject: value)
                break
            case .string:
                if let file = String(value) {
                    self.contents = UIImage(contentsOfFile: file)
                }
                break
            case .int: fallthrough
            case .number:
                self.contents = UIColor(freObjectARGB: value)
                break
            default:
                return
            }
            break
        case "intensity":
            self.intensity = CGFloat(value) ?? self.intensity
            break
        case "minificationFilter":
            if let minificationFilter = Int(value) {
                self.minificationFilter = SCNFilterMode.init(rawValue: minificationFilter) ?? self.minificationFilter
            }
            break
        case "magnificationFilter":
            if let magnificationFilter = Int(value) {
                self.magnificationFilter = SCNFilterMode.init(rawValue: magnificationFilter) ?? self.magnificationFilter
            }
            break
        case "mipFilter":
            if let mipFilter = Int(value) {
                self.mipFilter = SCNFilterMode.init(rawValue: mipFilter) ?? self.mipFilter
            }
            break
        case "wrapS":
            if let wrapS = Int(value) {
                self.wrapS = SCNWrapMode.init(rawValue: wrapS) ?? self.wrapS
            }
            break
        case "wrapT":
            if let wrapT = Int(value) {
                self.wrapT = SCNWrapMode.init(rawValue: wrapT) ?? self.wrapT
            }
            break
        case "mappingChannel":
            self.mappingChannel = Int(value) ?? 0
            break
        case "maxAnisotropy":
            self.maxAnisotropy = CGFloat(value) ?? 1.0
            break
        default:
            break
        }
    }
    
    func toFREObject(materialName:String?, materialType:String?, nodeName:String? ) -> FREObject? {
        do {
            let ret = try FREObject(className: "com.tuarua.arane.materials.MaterialProperty", args: materialName, materialType)
            try ret?.setProp(name: "intensity", value: self.intensity)
            try ret?.setProp(name: "minificationFilter", value: self.minificationFilter.rawValue)
            try ret?.setProp(name: "magnificationFilter", value: self.magnificationFilter.rawValue)
            try ret?.setProp(name: "mipFilter", value: self.mipFilter.rawValue)
            try ret?.setProp(name: "wrapS", value: self.wrapS.rawValue)
            try ret?.setProp(name: "wrapT", value: self.wrapT.rawValue)
            try ret?.setProp(name: "mappingChannel", value: self.mappingChannel)
            try ret?.setProp(name: "maxAnisotropy", value: self.maxAnisotropy)
            if self.contents is UIColor, let clr = self.contents as? UIColor { //only handles colours at the minute
                try ret?.setProp(name: "contents", value: clr.toFREObjectARGB())
            }
            //make sure to set this last as it triggers setANEvalue otherwise
            try ret?.setProp(name: "nodeName", value: nodeName)
            return ret
        } catch {
        }
        return nil
    }
    
}
