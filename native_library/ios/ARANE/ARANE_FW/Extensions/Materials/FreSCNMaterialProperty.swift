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
            let freContents = rv["contents"] else { return nil }
        let fre = FreObjectSwift(rv)
        self.init()
        switch freContents.type {
        case .bitmapdata:
            self.contents = UIImage(freObject: freContents)
        case .string:
            self.contents = String(freContents)
        case .int, .number:
            self.contents = UIColor(freContents)
        default:
            return nil
        }

        self.intensity = fre.intensity
        self.magnificationFilter = SCNFilterMode(rawValue: fre.magnificationFilter) ?? .linear
        self.minificationFilter = SCNFilterMode(rawValue: fre.minificationFilter) ?? .linear
        self.mipFilter = SCNFilterMode(rawValue: fre.mipFilter) ?? .nearest
        self.wrapS = SCNWrapMode(rawValue: fre.wrapS) ?? .clamp
        self.wrapT = SCNWrapMode(rawValue: fre.wrapT) ?? .clamp
        self.mappingChannel = fre.mappingChannel
        self.maxAnisotropy = fre.maxAnisotropy
    }
    
    func setProp(name: String, value: FREObject, queue: DispatchQueue) {
        switch name {
        case "contents":
            switch value.type {
            case .bitmapdata:
                let img = UIImage(freObject: value)
                DispatchQueue.main.async {
                    queue.async {
                        self.contents = img
                    }
                }
            case .string:
                if let file = String(value) {
                    DispatchQueue.main.async {
                        queue.async {
                            self.contents = file
                        }
                    }
                }
            case .int, .number:
                let color = UIColor(value)
                DispatchQueue.main.async {
                    queue.async {
                        self.contents = color
                    }
                }
            default:
                return
            }
        case "intensity":
            self.intensity = CGFloat(value) ?? self.intensity
        case "minificationFilter":
            if let minificationFilter = Int(value) {
                self.minificationFilter = SCNFilterMode(rawValue: minificationFilter) ?? self.minificationFilter
            }
        case "magnificationFilter":
            if let magnificationFilter = Int(value) {
                self.magnificationFilter = SCNFilterMode(rawValue: magnificationFilter) ?? self.magnificationFilter
            }
        case "mipFilter":
            if let mipFilter = Int(value) {
                self.mipFilter = SCNFilterMode(rawValue: mipFilter) ?? self.mipFilter
            }
        case "wrapS":
            if let wrapS = Int(value) {
                self.wrapS = SCNWrapMode(rawValue: wrapS) ?? self.wrapS
            }
        case "wrapT":
            if let wrapT = Int(value) {
                self.wrapT = SCNWrapMode(rawValue: wrapT) ?? self.wrapT
            }
        case "mappingChannel":
            self.mappingChannel = Int(value) ?? 0
        case "maxAnisotropy":
            self.maxAnisotropy = CGFloat(value) ?? 1.0
        default:
            break
        }
    }
    
    func toFREObject(materialName: String?, materialType: String?, nodeName: String? ) -> FREObject? {
        guard let fre = FreObjectSwift(className: "com.tuarua.arkit.materials.MaterialProperty",
                                       args: materialName, materialType) else {
            return nil
        }
        
        fre.intensity = intensity
        fre.minificationFilter = minificationFilter.rawValue
        fre.magnificationFilter = magnificationFilter.rawValue
        fre.mipFilter = mipFilter.rawValue
        fre.wrapS = wrapS.rawValue
        fre.wrapT = wrapT.rawValue
        fre.mappingChannel = mappingChannel
        fre.maxAnisotropy = maxAnisotropy
        
        if self.contents is UIColor,
            let clr = self.contents as? UIColor {
            fre.contents = clr.toFREObject()
        } else if self.contents is String,
            let file = self.contents as? String {
            var f = file
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: Bundle.main.bundleURL.absoluteString + file) {
                f = "art.scnassets/" + file
            }
            fre.contents = f
        }
        fre.nodeName = nodeName
        return fre.rawValue
    }
    
    func copy(from: SCNMaterialProperty) {
        self.intensity = from.intensity
        self.magnificationFilter = from.magnificationFilter
        self.minificationFilter = from.minificationFilter
        self.mipFilter = from.mipFilter
        self.wrapS = from.wrapS
        self.wrapT = from.wrapT
        self.mappingChannel = from.mappingChannel
        self.maxAnisotropy = from.maxAnisotropy
        self.contents = from.contents
    }
    
}
