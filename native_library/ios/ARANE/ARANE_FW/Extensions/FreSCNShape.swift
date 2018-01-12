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
import PocketSVG

public extension SCNShape {
    convenience init?(_ freObject: FREObject?) {
        guard
            let rv = freObject,
            let url = String(rv["url"]),
            let extrusionDepth = CGFloat(rv["extrusionDepth"]),
            let subdivisionLevel = Int(rv["subdivisionLevel"]),
            let chamferRadius = CGFloat(rv["chamferRadius"]),
            let flatness = CGFloat(rv["flatness"]),
            let chamferMode = Int(rv["chamferMode"])
            else {
                return nil
        }
        let paths = SVGBezierPath.pathsFromSVG(at: URL.init(fileURLWithPath: url))
        var fullPath:SVGBezierPath?
        for path in paths {
            if fullPath == nil {
                fullPath = path
            } else {
                fullPath?.append(path)
            }
        }
        self.init()
        
        self.path = fullPath
        self.path?.flatness = flatness
        self.extrusionDepth = extrusionDepth
        self.chamferRadius = chamferRadius
        if let cm = SCNChamferMode.init(rawValue: chamferMode) {
          self.chamferMode = cm
        }
        
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
        case "extrusionDepth":
            self.extrusionDepth = CGFloat(value) ?? self.extrusionDepth
            break
        case "chamferRadius":
            self.chamferRadius = CGFloat(value) ?? self.chamferRadius
            break
        case "flatness":
            if let p = self.path, let v = CGFloat(value) {
                p.flatness = v
            }
            break
        case "chamferMode":
            if let cm = Int(value), let v = SCNChamferMode.init(rawValue: cm) {
                self.chamferMode = v
            }
            if let chamferMode = Int(value) {
                self.chamferMode = SCNChamferMode.init(rawValue: chamferMode) ?? self.chamferMode
            }
            break
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
    
    func toFREObject(nodeName:String?) -> FREObject? {
        do {
            let ret = try FREObject(className: "com.tuarua.arane.shapes.Shape")
            try ret?.setProp(name: "extrusionDepth", value: self.extrusionDepth.toFREObject())
            try ret?.setProp(name: "chamferRadius", value: self.chamferRadius.toFREObject())
            try ret?.setProp(name: "flatness", value: self.path?.flatness.toFREObject())
            try ret?.setProp(name: "chamferMode", value: self.chamferMode.rawValue.toFREObject())
            try ret?.setProp(name: "subdivisionLevel", value: self.subdivisionLevel.toFREObject())
            if materials.count > 0 {
                try ret?.setProp(name: "materials", value: materials.toFREObject(nodeName: nodeName))
            }
            //make sure to set this last as it triggers setANEvalue otherwise
            try ret?.setProp(name: "nodeName", value: nodeName)
            return ret
        } catch {
        }
        return nil
    }
    
}
