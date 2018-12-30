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

package com.tuarua.arane.physics {
import com.tuarua.ARANEContext;
import com.tuarua.fre.ANEError;

import flash.geom.Vector3D;

[RemoteClass(alias="com.tuarua.arane.physics.PhysicsBody")]
public class PhysicsBody {
    public var nodeName:String;
    private var _isDefault:Boolean = true;
    private var _type:int = PhysicsBodyType.static;
    private var _physicsShape:PhysicsShape;
    private var _angularDamping:Number = 0;
    private var _angularVelocity:Vector3D;
    private var _angularVelocityFactor:Vector3D;
    private var _momentOfInertia:Vector3D;
    private var _velocity:Vector3D;
    private var _velocityFactor:Vector3D;
    private var _mass:Number = 0;
    private var _usesDefaultMomentOfInertia:Boolean = true;
    private var _charge:Number = 0;
    private var _friction:Number = 0.5;
    private var _restitution:Number = 0.5;
    private var _rollingFriction:Number = 0;
    private var _damping:Number = 0.1;
    private var _allowsResting:Boolean = false;
    private var _isAffectedByGravity:Boolean = true;
    private var _collisionBitMask:int = -1;
    private var _categoryBitMask:int = 1; //1=default, 2 is static
    private var _contactTestBitMask:int = 0;
    private var _continuousCollisionDetectionThreshold: Number = 0;
    private var _centerOfMassOffset: Vector3D = new Vector3D();
    private var _linearRestingThreshold: Number = 0.1;
    private var _angularRestingThreshold: Number = 0.1;


    /** The SCNPhysicsBody class describes the physics properties (such as mass, friction...) of a node.
     *
     * @param type Specifies the type of the receiver.
     * @param physicsShape Specifies the physics shape of the receiver. Leaving this null will let the
     * system decide and use the most efficients bounding representation of the actual geometry.
     */
    public function PhysicsBody(type:int, physicsShape:PhysicsShape = null) {
        this._type = type;
        if (type == PhysicsBodyType.dynamic) {
            this._mass = 1;
        }
        if (type == PhysicsBodyType.static) {
            this._categoryBitMask = 2;
        }
        this._physicsShape = physicsShape;
    }

    /** Creates an instance of a static body with default properties. */
    public static function static():PhysicsBody {
        return new PhysicsBody(PhysicsBodyType.static);
    }

    /** Creates an instance of a dynamic body with default properties. */
    public static function dynamic():PhysicsBody {
        return new PhysicsBody(PhysicsBodyType.dynamic);
    }

    /** Creates an instance of a kinematic body with default properties. */
    public static function kinematic():PhysicsBody {
        return new PhysicsBody(PhysicsBodyType.kinematic);
    }

    /** The physics shape of the receiver. */
    public function get physicsShape():PhysicsShape {
        return _physicsShape;
    }

    /** The type of the receiver. */
    public function get type():int {
        return _type;
    }

    /** Specifies a factor applied on the rotation on each axis that results from the physics simulation
     * before applying it to the node. */
    public function get angularVelocityFactor():Vector3D {
        return _angularVelocityFactor;
    }

    public function set angularVelocityFactor(value:Vector3D):void {
        _isDefault = false;
        _angularVelocityFactor = value;
    }

    /** Specifies the moment of inertia of the body as a vector in 3D. Disable usesDefaultMomentOfInertia for
     * this value to be used instead of the default moment of inertia that is calculated from the shape geometry. */
    public function get momentOfInertia():Vector3D {
        return _momentOfInertia;
    }

    public function set momentOfInertia(value:Vector3D):void {
        _isDefault = false;
        _momentOfInertia = value;
    }

    /** Permits to disable the use of the default moment of inertia in favor of the one stored in momentOfInertia. */
    public function get usesDefaultMomentOfInertia():Boolean {
        return _usesDefaultMomentOfInertia;
    }

    public function set usesDefaultMomentOfInertia(value:Boolean):void {
        _isDefault = false;
        _usesDefaultMomentOfInertia = value;
    }

    /** Specifies the charge on the body. Charge determines the degree to which a body is affected by
     * electric and magnetic fields. Note that this is a unitless quantity, it is up to the developer to
     * set charge and field strength appropriately.
     * @default 0.0 */
    public function get charge():Number {
        return _charge;
    }

    public function set charge(value:Number):void {
        _isDefault = false;
        _charge = value;
    }

    /** Specifies the force resisting the relative motion of solid sliding against each other.
     * @default 0.5 */
    public function get friction():Number {
        return _friction;
    }

    public function set friction(value:Number):void {
        _isDefault = false;
        _friction = value;
    }

    /** Specifies the restitution of collisions.
     * @default 0.5 */
    public function get restitution():Number {
        return _restitution;
    }

    public function set restitution(value:Number):void {
        _isDefault = false;
        _restitution = value;
    }

    /** Specifies the force resisting the relative motion of solid rolling against each other.
     * @default 0 */
    public function get rollingFriction():Number {
        return _rollingFriction;
    }

    public function set rollingFriction(value:Number):void {
        _isDefault = false;
        _rollingFriction = value;
    }

    /** Specifies the damping factor of the receiver. Optionally reduce the body's linear velocity each
     * frame to simulate fluid/air friction. Value should be zero or greater.
     * @default 0.1 */
    public function get damping():Number {
        return _damping;
    }

    public function set damping(value:Number):void {
        _isDefault = false;
        _damping = value;
    }

    /** Specifies the linear velocity of the receiver. */
    public function get velocity():Vector3D {
        return _velocity;
    }

    public function set velocity(value:Vector3D):void {
        _isDefault = false;
        _velocity = value;
    }

    /** Specifies a factor applied on the translation that results from the physics simulation before
     * applying it to the node. */
    public function get velocityFactor():Vector3D {
        return _velocityFactor;
    }

    public function set velocityFactor(value:Vector3D):void {
        _isDefault = false;
        _velocityFactor = value;
    }

    /** Specifies if the receiver can be set at rest. */
    public function get allowsResting():Boolean {
        return _allowsResting;
    }

    public function set allowsResting(value:Boolean):void {
        _isDefault = false;
        _allowsResting = value;
    }

    /** If set to true this node will be affected by gravity.
     * @default true */
    public function get isAffectedByGravity():Boolean {
        return _isAffectedByGravity;
    }

    public function set isAffectedByGravity(value:Boolean):void {
        _isDefault = false;
        _isAffectedByGravity = value;
    }

    /** Specifies the angular damping of the receiver. Optionally reduce the body's angular velocity each
     * frame to simulate rotational friction. (0.0 - 1.0).
     * @default 0.1 */
    public function get angularDamping():Number {
        return _angularDamping;
    }

    public function set angularDamping(value:Number):void {
        _isDefault = false;
        _angularDamping = value;
    }

    /** Specifies a factor applied on the translation that results from the physics simulation before
     * applying it to the node. */
    public function get angularVelocity():Vector3D {
        return _angularVelocity;
    }

    public function set angularVelocity(value:Vector3D):void {
        _isDefault = false;
        _angularVelocity = value;
    }

    /** Specifies the Mass of the body in kilogram.
     * @default 1 for dynamic bodies, 0 for static bodies */
    public function get mass():Number {
        return _mass;
    }

    public function set mass(value:Number):void {
        _isDefault = false;
        _mass = value;
    }

    /** @private */
    public function get isDefault():Boolean {
        return _isDefault;
    }

    /** A mask that defines which categories of bodies cause intersection notifications with this physics body.
     * @default 0. */
    public function get contactTestBitMask():int {
        return _contactTestBitMask;
    }

    public function set contactTestBitMask(value:int):void {
        _isDefault = false;
        _contactTestBitMask = value;
    }

    /** Defines what logical 'categories' of bodies this body responds to collisions with.
     * @default to all bits set (all categories) */
    public function get collisionBitMask():int {
        return _collisionBitMask;
    }

    public function set collisionBitMask(value:int):void {
        _isDefault = false;
        _collisionBitMask = value;
    }

    /** Defines what logical 'categories' this body belongs too. */
    public function get categoryBitMask():int {
        return _categoryBitMask;
    }

    public function set categoryBitMask(value:int):void {
        _isDefault = false;
        _categoryBitMask = value;
    }

    /** Applies a linear force with the specified position and direction. The position is relative to the
     * node that owns the physics body.
     *
     * @param direction
     * @param asImpulse
     * @param at
     */
    public function applyForce(direction:Vector3D, asImpulse:Boolean, at:Vector3D = null):void {
        if (nodeName) {
            var theRet:* = ARANEContext.context.call("physics_applyForce", direction, asImpulse, at, nodeName);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

    /** Applies an angular force (torque).
     *
     * @param torque
     * @param asImpulse If impulse is set to true then the force is applied for just
     * one frame, otherwise it applies a continuous force. The torque is specified as an axis angle.
     */
    public function applyTorque(torque:Vector3D, asImpulse:Boolean):void {
        if (nodeName) {
            var theRet:* = ARANEContext.context.call("physics_applyTorque", torque, asImpulse, nodeName);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

    /** Clears the forces applied one the receiver.*/
    public function clearAllForces():void {
        if (nodeName) {
            var theRet:* = ARANEContext.context.call("physics_clearAllForces", nodeName);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }


    /** Reset the physical transform to the node's model transform.*/
    public function resetTransform():void {
        if (nodeName) {
            var theRet:* = ARANEContext.context.call("physics_resetTransform", nodeName);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }


    /** Sets a physics body at rest (or not). iOS 12.0+.*/
    public function setResting(resting:Boolean):void {
        if (nodeName) {
            var theRet:* = ARANEContext.context.call("physics_setResting", resting, nodeName);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

    /** Use discrete collision detection if the body’s distance traveled in one step is at or below this threshold,
     * or continuous collision detection otherwise. Defaults to zero, indicating that continuous collision detection is
     * always disabled. iOS 12.0+
     * @default 0.0
     */
    public function get continuousCollisionDetectionThreshold():Number {
        return _continuousCollisionDetectionThreshold;
    }

    public function set continuousCollisionDetectionThreshold(value:Number):void {
        _continuousCollisionDetectionThreshold = value;
    }

    /** Specifies an offset for the center of mass of the body. Defaults to (0,0,0). iOS 12.0+
     * @default (0,0,0)
     */
    public function get centerOfMassOffset():Vector3D {
        return _centerOfMassOffset;
    }

    public function set centerOfMassOffset(value:Vector3D):void {
        _centerOfMassOffset = value;
    }

    /** Linear velocity threshold under which the body may be considered resting. iOS 12.0+
     * @default 0.1
     */
    public function get linearRestingThreshold():Number {
        return _linearRestingThreshold;
    }

    public function set linearRestingThreshold(value:Number):void {
        _linearRestingThreshold = value;
    }

    /** Angular velocity threshold under which the body may be considered resting. iOS 12.0+
     * @default 0.1
     */
    public function get angularRestingThreshold():Number {
        return _angularRestingThreshold;
    }

    public function set angularRestingThreshold(value:Number):void {
        _angularRestingThreshold = value;
    }
}
}
