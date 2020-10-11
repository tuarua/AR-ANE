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
            let name = String(rv["name"]),
            let scale = SCNVector3(rv["scale"]),
            let eulerAngles = SCNVector3(rv["eulerAngles"]),
            let visible = Bool(rv["visible"]),
            let castsShadow = Bool(rv["castsShadow"]),
            let categoryBitMask = Int(rv["categoryBitMask"]),
            let opacity = CGFloat(rv["alpha"])
            else {
                return nil
        }
        self.init()
        self.name = name
        
        self.scale = scale
        self.eulerAngles = eulerAngles
        self.isHidden = !visible
        self.opacity = opacity
        self.categoryBitMask = categoryBitMask
        
        if let freLight = rv["light"],
            let light = SCNLight(freLight) {
            self.light = light
        }
        
        if let freTransform = rv["transform"],
            let transform = SCNMatrix4(freTransform) {
            self.transform = transform
        }
        
        self.castsShadow = castsShadow
        self.position = position
    
        if let freGeom: FREObject = rv["geometry"],
            let aneUtils = FREObject(className: "com.tuarua.fre.ANEUtils"),
            let classType = aneUtils.call(method: "getClassType", args: freGeom),
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
                self.geometry = SCNPlane(freGeom)
            } else if asTypeName == "pyramid" {
                self.geometry = SCNPyramid(freGeom)
            } else if asTypeName == "sphere" {
                self.geometry = SCNSphere(freGeom)
            } else if asTypeName == "torus" {
                self.geometry = SCNTorus(freGeom)
            } else if asTypeName == "tube" {
                self.geometry = SCNTube(freGeom)
            } else if asTypeName == "shape" {
                self.geometry = SCNShape(freGeom)
            } else if asTypeName == "text" {
                self.geometry = SCNText(freGeom)
            }
        }
        
        if let freChildNodes: FREObject = rv["childNodes"] {
            let freArrChildNodes = FREArray(freChildNodes)
            for i in 0..<freArrChildNodes.length {
                if let freChildNode: FREObject = freArrChildNodes[i],
                    let childNode = SCNNode(freChildNode) {
                    self.addChildNode(childNode)
                }
            }
        }
        
        if let physicsBody = SCNPhysicsBody(rv["physicsBody"]) {
            self.physicsBody = physicsBody
        }
        
    }
    
    func setProp(name: String, value: FREObject) {
        switch name {
        case "position":
            self.position = SCNVector3(value) ?? self.position
        case "scale":
            self.scale = SCNVector3(value) ?? self.scale
        case "categoryBitMask":
            self.categoryBitMask = Int(value) ?? self.categoryBitMask
        case "eulerAngles":
            self.eulerAngles = SCNVector3(value) ?? self.eulerAngles
        case "visible":
            if let visible = Bool(value) {
                self.isHidden = !visible
            }
        case "castsShadow":
            if let castsShadow = Bool(value) {
                self.castsShadow = castsShadow
            }
        case "opacity":
            self.opacity = CGFloat(value) ?? self.opacity
        case "transform":
            if let transform = SCNMatrix4(value) {
                self.transform = transform
            }
        case "light":
            if let light = SCNLight(value) {
                self.light = light
            }
        case "physicsBody":
            if let physicsBody = SCNPhysicsBody(value) {
                self.physicsBody = physicsBody
            }
        default:
            break
        }
    }
    
    func toFREObject() -> FREObject? {
        guard let fre = FreObjectSwift(className: "com.tuarua.arkit.Node", args: nil, self.name) else {
            return nil
        }
        
        fre.parentName = parent?.name
        fre.position = position
        fre.scale = scale
        fre.eulerAngles = eulerAngles
        fre.transform = transform.toFREObject()
        fre.alpha = opacity
        fre.visible = !self.isHidden
        fre.castsShadow = castsShadow
        fre.categoryBitMask = categoryBitMask
        
        if let geometry = self.geometry as? SCNBox {
            fre.geometry = geometry.toFREObject(nodeName: self.name)
        } else if let geometry = self.geometry as? SCNPyramid {
            fre.geometry = geometry.toFREObject(nodeName: self.name)
        } else if let geometry = self.geometry as? SCNTube {
            fre.geometry = geometry.toFREObject(nodeName: self.name)
        } else if let geometry = self.geometry as? SCNTorus {
            fre.geometry = geometry.toFREObject(nodeName: self.name)
        } else if let geometry = self.geometry as? SCNSphere {
            fre.geometry = geometry.toFREObject(nodeName: self.name)
        } else if let geometry = self.geometry as? SCNPlane {
            fre.geometry = geometry.toFREObject(nodeName: self.name)
        } else if let geometry = self.geometry as? SCNCylinder {
            fre.geometry = geometry.toFREObject(nodeName: self.name)
        } else if let geometry = self.geometry as? SCNCone {
            fre.geometry = geometry.toFREObject(nodeName: self.name)
        } else if let geometry = self.geometry as? SCNCapsule {
            fre.geometry = geometry.toFREObject(nodeName: self.name)
        } else if let geometry = self.geometry as? SCNShape {
            fre.geometry = geometry.toFREObject(nodeName: self.name)
        } else if let geometry = self.geometry as? SCNText {
            fre.geometry = geometry.toFREObject(nodeName: self.name)
        } else if let geometry = self.geometry {
           fre.geometry = geometry.toFREObject(nodeName: self.name)
        }
        
        var cnt: UInt = 0
        if self.childNodes.count > 0 {
            if let freArray = FREArray(className: "com.tuarua.arkit.Node",
                                         length: self.childNodes.count,
                                         fixed: true) {
                for child in self.childNodes {
                    if var freNode = child.toFREObject() {
                        freNode["parentName"] = self.name?.toFREObject()
                        freArray[cnt] = freNode
                        cnt += 1
                    }
                }
                fre.childNodes = freArray.rawValue
            }
            
        }
        
        if let physicsBody = self.physicsBody {
            fre.physicsBody = physicsBody.toFREObject()
        }
        if let light = self.light {
            fre.light = light.toFREObject()
        }
        return fre.rawValue
    }
    
    func copyFromModel(_ freObject: FREObject?, _ isDAE: Bool = false) {
        guard let rv = freObject,
            let position = SCNVector3(rv["position"]),
            let name = String(rv["name"]),
            let scale = SCNVector3(rv["scale"]),
            let eulerAngles = SCNVector3(rv["eulerAngles"]),
            let visible = Bool(rv["visible"]),
            let categoryBitMask = Int(rv["categoryBitMask"]),
            let freAlpha = rv["alpha"],
            let opacity = CGFloat(freAlpha)
            else {
                return
        }
        
        if let freGeometry = rv["geometry"], let geometry = self.geometry {
            if let subdivisionLevel = Int(freGeometry["subdivisionLevel"]) {
                geometry.subdivisionLevel = subdivisionLevel
            }
            
            if !isDAE, let freMaterials = freGeometry["materials"] {
                let freArray: FREArray = FREArray(freMaterials)
                if freArray.length > 0 {
                    var mats = [SCNMaterial](repeating: SCNMaterial(), count: Int(freArray.length))
                    for i in 0..<freArray.length {
                        if let freMat: FREObject = freArray[i], let mat = SCNMaterial(freMat) {
                            mats[Int(i)] = mat
                        }
                    }
                    geometry.materials = mats
                }
            }
        }

        if let freChildNodes = rv["childNodes"] {
            let freArrChildNodes = FREArray(freChildNodes)
            for i in 0..<freArrChildNodes.length {
                if let freChildNode: FREObject = freArrChildNodes[i],
                    let nodeName = String(freChildNode["name"]),
                    let childNode = self.childNode(withName: nodeName, recursively: true) {
                    childNode.copyFromModel(freChildNode, isDAE)
                }
            }
        }
        
        if let frePhysicsBody = rv["physicsBody"] {
            self.physicsBody = SCNPhysicsBody(frePhysicsBody)
        }
        
        //order is important: scale, transform then position
        self.scale = scale
        self.eulerAngles = eulerAngles
        self.isHidden = !visible
        self.name = name
        self.opacity = opacity
        self.categoryBitMask = categoryBitMask

        if let freLight = rv["light"],
            let light = SCNLight(freLight) {
            self.light = light
        }
        if !isDAE, let freTransform = rv["transform"],
            let transform = SCNMatrix4(freTransform) {
            self.transform = transform
        }
        
        self.position = position
        
    }
    
}
