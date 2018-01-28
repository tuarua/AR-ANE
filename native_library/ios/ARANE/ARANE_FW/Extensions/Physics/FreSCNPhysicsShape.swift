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

public extension SCNPhysicsShape {
    convenience init?(_ freObject: FREObject?) {
        guard
            let rv = freObject
            else {
                return nil
        }
        
        var geometry:SCNGeometry?
        do {
            if let freGeom:FREObject = rv["geometry"],
                let aneUtils = try FREObject.init(className: "com.tuarua.fre.ANEUtils"),
                let classType = try aneUtils.call(method: "getClassType", args: freGeom),
                let asType = String(classType)?.lowercased() {
                let asTypeName = asType.split(separator: ":").last
                if asTypeName == "pyramid" {
                    geometry = SCNPyramid(freGeom)
                } else if asTypeName == "box" {
                    geometry = SCNBox(freGeom)
                } else if asTypeName == "capsule" {
                    geometry = SCNCapsule(freGeom)
                } else if asTypeName == "cone" {
                    geometry = SCNCone(freGeom)
                } else if asTypeName == "cylinder" {
                    geometry = SCNCylinder(freGeom)
                } else if asTypeName == "plane" {
                    geometry = SCNPlane(freGeom)
                } else if asTypeName == "pyramid" {
                    geometry = SCNPyramid(freGeom)
                } else if asTypeName == "sphere" {
                    geometry = SCNSphere(freGeom)
                } else if asTypeName == "torus" {
                    geometry = SCNTorus(freGeom)
                } else if asTypeName == "tube" {
                    geometry = SCNTube(freGeom)
                } else if asTypeName == "shape" {
                    geometry = SCNShape(freGeom)
                } else if asTypeName == "text" {
                    geometry = SCNText(freGeom)
                }
            }
        } catch {
        }
        var dict:[SCNPhysicsShape.Option : Any]? = nil
        if let freOptions = rv["options"],
            let type = String(freOptions["type"]),
            let keepAsCompound = Bool(freOptions["keepAsCompound"]),
            let scale = SCNVector3(freOptions["scale"])
            {
            var d = [SCNPhysicsShape.Option : Any]()
            d[SCNPhysicsShape.Option.type] = type
            d[SCNPhysicsShape.Option.keepAsCompound] = keepAsCompound
            d[SCNPhysicsShape.Option.scale] = scale
            dict = d
        }
        
        guard let geom = geometry else { return nil }
        self.init(geometry: geom, options: dict)
    }
    
    func toFREObject() -> FREObject? {
        var freGeometry:FREObject? = nil
        if let geometry = self.sourceObject as? SCNBox {
            freGeometry = geometry.toFREObject(nodeName: nil)
        } else if let geometry = self.sourceObject as? SCNPyramid {
            freGeometry = geometry.toFREObject(nodeName: nil)
        } else if let geometry = self.sourceObject as? SCNTube {
            freGeometry = geometry.toFREObject(nodeName: nil)
        } else if let geometry = self.sourceObject as? SCNTorus {
            freGeometry = geometry.toFREObject(nodeName: nil)
        } else if let geometry = self.sourceObject as? SCNSphere {
            freGeometry = geometry.toFREObject(nodeName: nil)
        } else if let geometry = self.sourceObject as? SCNPlane {
            freGeometry = geometry.toFREObject(nodeName: nil)
        } else if let geometry = self.sourceObject as? SCNCylinder {
            freGeometry = geometry.toFREObject(nodeName: nil)
        } else if let geometry = self.sourceObject as? SCNCone {
            freGeometry = geometry.toFREObject(nodeName: nil)
        } else if let geometry = self.sourceObject as? SCNCapsule {
            freGeometry = geometry.toFREObject(nodeName: nil)
        } else if let geometry = self.sourceObject as? SCNShape {
            freGeometry = geometry.toFREObject(nodeName: nil)
        } else if let geometry = self.sourceObject as? SCNText {
            freGeometry = geometry.toFREObject(nodeName: nil)
        } else if let geometry = self.sourceObject as? SCNGeometry {
            freGeometry = geometry.toBaseFREObject(nodeName: nil)
        }
        
        do {
            let ret = try FREObject(className: "com.tuarua.arane.physics.PhysicsShape", args: freGeometry)
            return ret
        } catch {
        }
        
        return nil
    }
    
    
}
