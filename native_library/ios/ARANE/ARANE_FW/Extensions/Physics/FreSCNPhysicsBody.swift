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
        guard let rv = freObject else { return nil }
        let fre = FreObjectSwift(rv)
        
        guard let typeRawValue = Int(rv["type"]),
            let type = SCNPhysicsBodyType(rawValue: typeRawValue)
            else { return nil }
        let physicsShape = SCNPhysicsShape(fre.physicsShape)
        self.init(type: type, shape: physicsShape)
        
        guard fre.isDefault == false else { return } //don't go further if we are using default values
        
        if let angularVelocity: SCNVector4 = fre.angularVelocity {
            self.angularVelocity = angularVelocity
        }
        if let angularVelocityFactor: SCNVector3 = fre.angularVelocityFactor {
            self.angularVelocityFactor = angularVelocityFactor
        }

        if let velocity: SCNVector3 = fre.velocity {
            self.velocity = velocity
        }
        if let velocityFactor: SCNVector3 = fre.velocityFactor {
            self.velocityFactor = velocityFactor
        }

        if let momentOfInertia: SCNVector3 = fre.momentOfInertia {
            self.momentOfInertia = momentOfInertia
        }

        self.allowsResting = fre.allowsResting
        self.angularDamping = fre.angularDamping
        self.mass = fre.mass
        self.usesDefaultMomentOfInertia = fre.usesDefaultMomentOfInertia
        self.charge = fre.charge
        self.friction = fre.friction
        self.restitution = fre.restitution
        self.rollingFriction = fre.rollingFriction
        self.damping = fre.damping
        self.isAffectedByGravity = fre.isAffectedByGravity
        self.collisionBitMask = fre.collisionBitMask
        self.categoryBitMask = fre.categoryBitMask
        self.contactTestBitMask = fre.contactTestBitMask
        
        if #available(iOS 12.0, *) {
            self.continuousCollisionDetectionThreshold = fre.continuousCollisionDetectionThreshold
            if let centerOfMassOffset: SCNVector3 = fre.centerOfMassOffset {
                self.centerOfMassOffset = centerOfMassOffset
            }
            self.linearRestingThreshold = fre.linearRestingThreshold
            self.angularRestingThreshold = fre.angularRestingThreshold
        }
    }
    
    func toFREObject() -> FREObject? {
        guard let fre = FreObjectSwift(className: "com.tuarua.arane.physics.PhysicsBody",
                                       args: self.type.rawValue, self.physicsShape?.toFREObject()) else {
            return nil
        }
        fre.allowsResting = allowsResting
        fre.mass = mass
        fre.angularDamping = angularDamping
        fre.usesDefaultMomentOfInertia = usesDefaultMomentOfInertia
        fre.charge = charge
        fre.friction = friction
        fre.restitution = restitution
        fre.rollingFriction = rollingFriction
        fre.damping = damping
        fre.isAffectedByGravity = isAffectedByGravity
        fre.angularVelocity = angularVelocity
        fre.angularVelocityFactor = angularVelocityFactor
        fre.momentOfInertia = momentOfInertia
        fre.velocity = velocity
        fre.velocityFactor = velocityFactor
        fre.collisionBitMask = collisionBitMask
        fre.categoryBitMask = categoryBitMask
        fre.contactTestBitMask = contactTestBitMask
        
        if #available(iOS 12.0, *) {
            fre.continuousCollisionDetectionThreshold = continuousCollisionDetectionThreshold
            fre.centerOfMassOffset = centerOfMassOffset
            fre.linearRestingThreshold = linearRestingThreshold
            fre.angularRestingThreshold = angularRestingThreshold
        }
        
        return fre.rawValue
    }
    
}
