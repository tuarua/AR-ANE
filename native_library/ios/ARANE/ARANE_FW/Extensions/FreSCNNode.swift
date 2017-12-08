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

public extension SCNNode {
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject,
            let frePosition:FREObject = rv["position"],
            let freId:FREObject = rv["id"],
            let freScale:FREObject = rv["scale"],
            let freEulerAngles:FREObject = rv["eulerAngles"],
            let freVisible:FREObject = rv["visible"],
            let freAlpha:FREObject = rv["alpha"],
            let opacity = CGFloat.init(freAlpha)
            else {
                return nil
        }
        self.init()
        self.position = SCNVector3.init(frePosition) ?? SCNVector3.init()
        self.scale = SCNVector3.init(freScale) ?? SCNVector3.init()
        self.eulerAngles = SCNVector3.init(freEulerAngles) ?? SCNVector3.init()
        self.isHidden = Bool.init(freVisible) == false
        self.name = String(freId)
        self.opacity = opacity
        
        do {
            if let freGeom:FREObject = rv["geometry"],
                let aneUtils = try FREObject.init(className: "com.tuarua.fre.ANEUtils"),
                let classType = try aneUtils.call(method: "getClassType", args: freGeom),
                let asType = String(classType)?.lowercased() {
                let asTypeName = asType.split(separator: ":").last
                if asTypeName == "pyramid" {
                    self.geometry = SCNPyramid(freGeom)
                } else if asTypeName == "box" {
                    self.geometry = SCNBox(freGeom)
                } else if asTypeName == "capsule" {
                    self.geometry = SCNCapsule(freGeom)
                } else if asTypeName == "cone" {
                    self.geometry = SCNCone(freGeom)
                } else if asTypeName == "cylinder" {
                    self.geometry = SCNCylinder(freGeom)
                } else if asTypeName == "plane" {
                    self.geometry = SCNCylinder(freGeom)
                } else if asTypeName == "pyramid" {
                    self.geometry = SCNPyramid(freGeom)
                } else if asTypeName == "sphere" {
                    self.geometry = SCNSphere(freGeom)
                } else if asTypeName == "torus" {
                    self.geometry = SCNTorus(freGeom)
                } else if asTypeName == "tube" {
                    self.geometry = SCNTube(freGeom)
                }
            }
        } catch {
        }
    }
    
    func setProp(name:String, value:FREObject) {
        switch name {
        case "position":
            self.position = SCNVector3.init(value) ?? self.position
            break
        case "scale":
            self.scale = SCNVector3.init(value) ?? self.scale
            break
        case "eulerAngles":
            self.eulerAngles = SCNVector3.init(value) ?? self.eulerAngles
            break
        case "isHidden":
            self.isHidden = Bool(value) ?? self.isHidden
            break
        case "opacity":
            self.opacity = CGFloat.init(value) ?? self.opacity
            break
        default:
            break
        }
    }
    
}
