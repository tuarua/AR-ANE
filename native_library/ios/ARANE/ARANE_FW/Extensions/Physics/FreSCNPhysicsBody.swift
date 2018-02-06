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

public extension SCNPhysicsBody {
    convenience init?(_ freObject: FREObject?) {
        guard
            let rv = freObject,
            let typeRawValue = Int(rv["type"]),
            let type = SCNPhysicsBodyType(rawValue: typeRawValue)
            else {
                return nil
        }
        let physicsShape = SCNPhysicsShape(rv["physicsShape"])
        self.init(type: type, shape: physicsShape)
        
        guard Bool(rv["isDefault"]) == false else { return} //don't go further if we are using default values
        
        guard
            let angularDamping = CGFloat(rv["angularDamping"]),
            let mass = CGFloat(rv["mass"]),
            let usesDefaultMomentOfInertia = Bool(rv["usesDefaultMomentOfInertia"]),
            let charge = CGFloat(rv["charge"]),
            let friction = CGFloat(rv["friction"]),
            let restitution = CGFloat(rv["restitution"]),
            let rollingFriction = CGFloat(rv["rollingFriction"]),
            let damping = CGFloat(rv["damping"]),
            let allowsResting = Bool(rv["allowsResting"]),
            let isAffectedByGravity = Bool(rv["isAffectedByGravity"]),
            let collisionBitMask = Int(rv["collisionBitMask"]),
            let categoryBitMask = Int(rv["categoryBitMask"]),
            let contactTestBitMask = Int(rv["contactTestBitMask"])
            else {
                return
        }
        
        if let angularVelocity = SCNVector4(rv["angularVelocity"]) {
            self.angularVelocity = angularVelocity
        }
        if let angularVelocityFactor = SCNVector3(rv["angularVelocityFactor"]) {
            self.angularVelocityFactor = angularVelocityFactor
        }

        if let velocity = SCNVector3(rv["velocity"]) {
            self.velocity = velocity
        }
        if let velocityFactor = SCNVector3(rv["velocityFactor"]) {
            self.velocityFactor = velocityFactor
        }

        if let momentOfInertia = SCNVector3(rv["momentOfInertia"]) {
            self.momentOfInertia = momentOfInertia
        }

        self.allowsResting = allowsResting
        self.angularDamping = angularDamping
        self.mass = mass
        self.usesDefaultMomentOfInertia = usesDefaultMomentOfInertia
        self.charge = charge
        self.friction = friction
        self.restitution = restitution
        self.rollingFriction = rollingFriction
        self.damping = damping
        self.isAffectedByGravity = isAffectedByGravity
        self.collisionBitMask = collisionBitMask
        self.categoryBitMask = categoryBitMask
        self.contactTestBitMask = contactTestBitMask

    }
    
    func toFREObject() -> FREObject? {
        do {
            let ret = try FREObject(className: "com.tuarua.arane.physics.PhysicsBody",
                                    args: self.type.rawValue, self.physicsShape?.toFREObject())
            try ret?.setProp(name: "allowsResting", value: self.allowsResting.toFREObject())
            try ret?.setProp(name: "mass", value: self.mass.toFREObject())
            try ret?.setProp(name: "angularDamping", value: self.angularDamping.toFREObject())
            try ret?.setProp(name: "usesDefaultMomentOfInertia", value: self.usesDefaultMomentOfInertia.toFREObject())
            try ret?.setProp(name: "charge", value: self.charge.toFREObject())
            try ret?.setProp(name: "friction", value: self.friction.toFREObject())
            try ret?.setProp(name: "restitution", value: self.restitution.toFREObject())
            try ret?.setProp(name: "rollingFriction", value: self.rollingFriction.toFREObject())
            try ret?.setProp(name: "damping", value: self.damping.toFREObject())
            try ret?.setProp(name: "isAffectedByGravity", value: self.isAffectedByGravity.toFREObject())
            try ret?.setProp(name: "angularVelocity", value: self.angularVelocity.toFREObject())
            try ret?.setProp(name: "angularVelocityFactor", value: self.angularVelocityFactor.toFREObject())
            try ret?.setProp(name: "momentOfInertia", value: self.momentOfInertia.toFREObject())
            try ret?.setProp(name: "velocity", value: self.velocity.toFREObject())
            try ret?.setProp(name: "velocityFactor", value: self.velocityFactor.toFREObject())
            try ret?.setProp(name: "collisionBitMask", value: self.collisionBitMask.toFREObject())
            try ret?.setProp(name: "categoryBitMask", value: self.categoryBitMask.toFREObject())
            try ret?.setProp(name: "contactTestBitMask", value: self.contactTestBitMask.toFREObject())
            
            return ret
        } catch {
        }
        return nil
    }
    
}
