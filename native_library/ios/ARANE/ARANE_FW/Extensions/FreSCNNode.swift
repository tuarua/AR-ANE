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
            let position = SCNVector3(rv["position"]),
            let id = String(rv["id"]),
            let scale = SCNVector3(rv["scale"]),
            let eulerAngles = SCNVector3(rv["eulerAngles"]),
            let visible = Bool(rv["visible"]),
            let freAlpha:FREObject = rv["alpha"],
            let opacity = CGFloat.init(freAlpha)
            else {
                return nil
        }
        self.init()
        self.position = position
        self.scale = scale
        self.eulerAngles = eulerAngles
        self.isHidden = !visible
        self.name = id
        self.opacity = opacity
        
        if let freTransform = rv["transform"],
            let transform = SCNMatrix4.init(freTransform) {
            self.transform = transform
        }
        
        if let freLight = rv["light"],
            let light = SCNLight.init(freLight) {
            self.light = light
        }
        
        do {
            if let freGeom:FREObject = rv["geometry"],
                let aneUtils = try FREObject.init(className: "com.tuarua.fre.ANEUtils"),
                let classType = try aneUtils.call(method: "getClassType", args: freGeom),
                let asType = String(classType)?.lowercased() {
                let asTypeName = asType.split(separator: ":").last
                if asTypeName == "pyramid" {
                    self.geometry = SCNPyramid.init(freGeom)
                } else if asTypeName == "box" {
                    self.geometry = SCNBox.init(freGeom)
                } else if asTypeName == "capsule" {
                    self.geometry = SCNCapsule.init(freGeom)
                } else if asTypeName == "cone" {
                    self.geometry = SCNCone.init(freGeom)
                } else if asTypeName == "cylinder" {
                    self.geometry = SCNCylinder.init(freGeom)
                } else if asTypeName == "plane" {
                    self.geometry = SCNPlane.init(freGeom)
                } else if asTypeName == "pyramid" {
                    self.geometry = SCNPyramid.init(freGeom)
                } else if asTypeName == "sphere" {
                    self.geometry = SCNSphere.init(freGeom)
                } else if asTypeName == "torus" {
                    self.geometry = SCNTorus.init(freGeom)
                } else if asTypeName == "tube" {
                    self.geometry = SCNTube.init(freGeom)
                } else if asTypeName == "model" {
                    if let scene = SCNScene.init(freGeom) {
                        if let freNodeName:FREObject = freGeom["nodeName"],
                            let nodeName = String(freNodeName),
                            let node = scene.rootNode.childNode(withName: nodeName, recursively: true) {
                            self.addChildNode(node)
                        } else {
                            self.addChildNode(scene.rootNode.childNodes[0])
                        }
                    }
                }
            }
        } catch {
        }
    }
    
    func setProp(name:String, value:FREObject) {
        //TODO light
        switch name {
        case "position":
            self.position = SCNVector3(value) ?? self.position
            break
        case "scale":
            self.scale = SCNVector3(value) ?? self.scale
            break
        case "eulerAngles":
            self.eulerAngles = SCNVector3(value) ?? self.eulerAngles
            break
        case "visible":
            if let visible = Bool(value) {
                self.isHidden = !visible
            }
            break
        case "opacity":
            self.opacity = CGFloat(value) ?? self.opacity
            break
        case "transform":
            if let transform = SCNMatrix4(value)  {
                self.transform = transform
            }
            break
        default:
            break
        }
    }
    
}
