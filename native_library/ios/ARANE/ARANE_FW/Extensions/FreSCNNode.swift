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
            let opacity = CGFloat.init(rv["alpha"])
            else {
                return nil
        }
        self.init()
        
        self.scale = scale
        self.eulerAngles = eulerAngles
        self.isHidden = !visible
        self.name = name
        self.opacity = opacity
        
        if let freLight = rv["light"],
            let light = SCNLight.init(freLight) {
            self.light = light
        }
        
        if let freTransform = rv["transform"],
            let transform = SCNMatrix4.init(freTransform) {
            self.transform = transform
        }
        
        self.position = position
    
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
                } else if asTypeName == "shape" {
                    self.geometry = SCNShape.init(freGeom)
                } else if asTypeName == "text" {
                    self.geometry = SCNText.init(freGeom)
                }
            }
        } catch {
        }
        
        if let freChildNodes = rv["childNodes"] {
            let freArrChildNodes = FREArray.init(freChildNodes)
            for i in 0..<freArrChildNodes.length {
                if let freChildNode = freArrChildNodes[i],
                    let childNode = SCNNode.init(freChildNode){
                    self.addChildNode(childNode)
                }
            }
        }
        
        if let physicsBody = SCNPhysicsBody(rv["physicsBody"], self.geometry) {
            self.physicsBody = physicsBody
        }
        
    }
    
    func setProp(name:String, value:FREObject) {
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
        case "light":
            if let light = SCNLight.init(value) {
                self.light = light
            }
            break
        case "physicsBody":
            if let physicsBody = SCNPhysicsBody(value, self.geometry) {
                self.physicsBody = physicsBody
            }
            break
        default:
            break
        }
    }
    
    func toFREObject() -> FREObject? {
        do {
            let ret = try FREObject(className: "com.tuarua.arane.Node", args: nil, self.name)
            try ret?.setProp(name: "position", value: self.position.toFREObject())
            try ret?.setProp(name: "scale", value: self.scale.toFREObject())
            try ret?.setProp(name: "eulerAngles", value: self.eulerAngles.toFREObject())
            try ret?.setProp(name: "transform", value: self.transform.toFREObject())
            try ret?.setProp(name: "alpha", value: self.opacity.toFREObject())
            let visible = !self.isHidden
            try ret?.setProp(name: "visible", value: visible.toFREObject())
            
            if let geometry = self.geometry as? SCNBox {
                try ret?.setProp(name: "geometry", value: geometry.toFREObject(nodeName: self.name))
            } else if let geometry = self.geometry as? SCNPyramid {
                try ret?.setProp(name: "geometry", value: geometry.toFREObject(nodeName: self.name))
            } else if let geometry = self.geometry as? SCNTube {
                try ret?.setProp(name: "geometry", value: geometry.toFREObject(nodeName: self.name))
            } else if let geometry = self.geometry as? SCNTorus {
                try ret?.setProp(name: "geometry", value: geometry.toFREObject(nodeName: self.name))
            } else if let geometry = self.geometry as? SCNSphere {
                try ret?.setProp(name: "geometry", value: geometry.toFREObject(nodeName: self.name))
            } else if let geometry = self.geometry as? SCNPlane {
                try ret?.setProp(name: "geometry", value: geometry.toFREObject(nodeName: self.name))
            } else if let geometry = self.geometry as? SCNCylinder {
                try ret?.setProp(name: "geometry", value: geometry.toFREObject(nodeName: self.name))
            } else if let geometry = self.geometry as? SCNCone {
                try ret?.setProp(name: "geometry", value: geometry.toFREObject(nodeName: self.name))
            } else if let geometry = self.geometry as? SCNCapsule {
                try ret?.setProp(name: "geometry", value: geometry.toFREObject(nodeName: self.name))
            } else if let geometry = self.geometry as? SCNShape {
                try ret?.setProp(name: "geometry", value: geometry.toFREObject(nodeName: self.name))
            } else if let geometry = self.geometry as? SCNText {
                try ret?.setProp(name: "geometry", value: geometry.toFREObject(nodeName: self.name))
            } else if let geometry = self.geometry {
                try ret?.setProp(name: "geometry", value: geometry.toBaseFREObject(nodeName: self.name))
            }

            if self.childNodes.count > 0 {
                let freArray = try FREArray.init(className: "Vector.<com.tuarua.arane.Node>", args: self.childNodes.count)
                var cnt:UInt = 0
                for child in self.childNodes {
                    if let freNode = child.toFREObject() {
                        try freNode.setProp(name: "parentName", value: self.name)
                        try freArray.set(index: cnt, value: freNode)
                        cnt = cnt + 1
                    }
                }
                try ret?.setProp(name: "childNodes", value: freArray)
            }
            
            if let physicsBody = self.physicsBody {
                try ret?.setProp(name: "physicsBody", value: physicsBody.toFREObject())
            }
            
            if let light = self.light {
                try ret?.setProp(name: "light", value: light.toFREObject())
            }

            return ret
        } catch {
        }
        return nil
    }
    
    func copyFromModel(_ freObject: FREObject?, _ isDAE:Bool = false) {
        guard let rv = freObject,
            let position = SCNVector3(rv["position"]),
            let name = String(rv["name"]),
            let scale = SCNVector3(rv["scale"]),
            let eulerAngles = SCNVector3(rv["eulerAngles"]),
            let visible = Bool(rv["visible"]),
            let freAlpha:FREObject = rv["alpha"],
            let opacity = CGFloat.init(freAlpha)
            else {
                return
        }
        
        if let freGeometry = rv["geometry"], let geometry = self.geometry {
            if let subdivisionLevel = Int(freGeometry["subdivisionLevel"]) {
                geometry.subdivisionLevel = subdivisionLevel
            }
            
            if !isDAE, let freMaterials = freGeometry["materials"] {
                let freArray:FREArray = FREArray.init(freMaterials)
                if freArray.length > 0 {
                    var mats = [SCNMaterial](repeating: SCNMaterial(), count: Int(freArray.length))
                    for i in 0..<freArray.length {
                        if let freMat = freArray[i], let mat = SCNMaterial.init(freMat) {
                            mats[Int(i)] = mat
                        }
                    }
                    geometry.materials = mats
                }
            }
            
        }

        if let freChildNodes = rv["childNodes"] {
            let freArrChildNodes = FREArray.init(freChildNodes)
            for i in 0..<freArrChildNodes.length {
                if let freChildNode = freArrChildNodes[i],
                    let nodeName = String(freChildNode["name"]),
                    let childNode = self.childNode(withName: nodeName, recursively: true) {
                    childNode.copyFromModel(freChildNode, isDAE)
                }
            }
        }
        
        //order is important: scale, transform then position
        self.scale = scale
        self.eulerAngles = eulerAngles
        self.isHidden = !visible
        self.name = name
        self.opacity = opacity

        if let freLight = rv["light"],
            let light = SCNLight.init(freLight) {
            self.light = light
        }
        if !isDAE, let freTransform = rv["transform"],
            let transform = SCNMatrix4.init(freTransform) {
            self.transform = transform
        }
        
        self.position = position
        
    }
    
    
    
}
