/* Copyright 2018 Tua Rua Ltd.
 
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

extension Scene3DVC: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        guard listeners.contains(PhysicsEvent.CONTACT_DID_END)
            else { return }
        var props: [String: Any] = Dictionary()
        props["collisionImpulse"] = contact.collisionImpulse
        props["penetrationDistance"] = contact.penetrationDistance
        props["sweepTestFraction"] = contact.sweepTestFraction
        props["contactNormal"] = ["x": contact.contactNormal.x,
                                  "y": contact.contactNormal.y,
                                  "z": contact.contactNormal.z]
        props["contactPoint"] = ["x": contact.contactPoint.x,
                                 "y": contact.contactPoint.y,
                                 "z": contact.contactPoint.z]
        props["nodeNameA"] = contact.nodeA.name
        props["nodeNameB"] = contact.nodeB.name
        props["categoryBitMaskA"] = contact.nodeA.physicsBody?.categoryBitMask
        props["categoryBitMaskB"] = contact.nodeB.physicsBody?.categoryBitMask
        let json = JSON(props)
        sendEvent(name: PhysicsEvent.CONTACT_DID_END, value: json.description)
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        guard listeners.contains(PhysicsEvent.CONTACT_DID_BEGIN)
            else { return }
        var props: [String: Any] = Dictionary()
        props["collisionImpulse"] = contact.collisionImpulse
        props["penetrationDistance"] = contact.penetrationDistance
        props["sweepTestFraction"] = contact.sweepTestFraction
        props["contactNormal"] = ["x": contact.contactNormal.x,
                                  "y": contact.contactNormal.y,
                                  "z": contact.contactNormal.z]
        props["contactPoint"] = ["x": contact.contactPoint.x,
                                 "y": contact.contactPoint.y,
                                 "z": contact.contactPoint.z]
        props["nodeNameA"] = contact.nodeA.name
        props["nodeNameB"] = contact.nodeB.name
        props["categoryBitMaskA"] = contact.nodeA.physicsBody?.categoryBitMask
        props["categoryBitMaskB"] = contact.nodeB.physicsBody?.categoryBitMask
        let json = JSON(props)
        sendEvent(name: PhysicsEvent.CONTACT_DID_BEGIN, value: json.description)
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
        
    }
}
