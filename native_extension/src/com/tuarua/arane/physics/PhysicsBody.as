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

package com.tuarua.arane.physics {
import com.tuarua.ARANEContext;
import com.tuarua.fre.ANEError;

import flash.geom.Vector3D;

[RemoteClass(alias="com.tuarua.arane.physics.PhysicsBody")]
public class PhysicsBody {
    public var nodeName:String;
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

    public function PhysicsBody(type:int, physicsShape:PhysicsShape = null) {
        this._type = type;
        if (type == PhysicsBodyType.dynamic) {
            this._mass = 1;
        }
        this._physicsShape = physicsShape;
    }

    public function get angularDamping():Number {
        return _angularDamping;
    }

    public function get angularVelocity():Vector3D {
        return _angularVelocity;
    }

    public function get physicsShape():PhysicsShape {
        return _physicsShape;
    }

    public function get type():int {
        return _type;
    }

    public function get angularVelocityFactor():Vector3D {
        return _angularVelocityFactor;
    }

    public function get momentOfInertia():Vector3D {
        return _momentOfInertia;
    }

    public function get mass():Number {
        return _mass;
    }

    public function get usesDefaultMomentOfInertia():Boolean {
        return _usesDefaultMomentOfInertia;
    }

    public function get charge():Number {
        return _charge;
    }

    public function get friction():Number {
        return _friction;
    }

    public function get restitution():Number {
        return _restitution;
    }

    public function get rollingFriction():Number {
        return _rollingFriction;
    }

    public function get damping():Number {
        return _damping;
    }

    public function get velocity():Vector3D {
        return _velocity;
    }

    public function set angularDamping(value:Number):void {
        _angularDamping = value;
    }

    public function set angularVelocity(value:Vector3D):void {
        _angularVelocity = value;
    }

    public function set angularVelocityFactor(value:Vector3D):void {
        _angularVelocityFactor = value;
    }

    public function set momentOfInertia(value:Vector3D):void {
        _momentOfInertia = value;
    }

    public function set mass(value:Number):void {
        _mass = value;
    }

    public function set usesDefaultMomentOfInertia(value:Boolean):void {
        _usesDefaultMomentOfInertia = value;
    }

    public function set charge(value:Number):void {
        _charge = value;
    }

    public function set friction(value:Number):void {
        _friction = value;
    }

    public function set restitution(value:Number):void {
        _restitution = value;
    }

    public function set rollingFriction(value:Number):void {
        _rollingFriction = value;
    }

    public function set damping(value:Number):void {
        _damping = value;
    }

    public function set velocity(value:Vector3D):void {
        _velocity = value;
    }

    public function get velocityFactor():Vector3D {
        return _velocityFactor;
    }

    public function set velocityFactor(value:Vector3D):void {
        _velocityFactor = value;
    }

    public function get allowsResting():Boolean {
        return _allowsResting;
    }

    public function set allowsResting(value:Boolean):void {
        _allowsResting = value;
    }

    public function get isAffectedByGravity():Boolean {
        return _isAffectedByGravity;
    }

    public function set isAffectedByGravity(value:Boolean):void {
        _isAffectedByGravity = value;
    }

    public function applyForce(direction:Vector3D, asImpulse:Boolean, at:Vector3D = null):void {
        if (nodeName) {
            var theRet:* = ARANEContext.context.call("applyPhysicsForce", direction, asImpulse, at, nodeName);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

    public function applyTorque(torque:Vector3D, asImpulse:Boolean):void {
        if (nodeName) {
            var theRet:* = ARANEContext.context.call("applyPhysicsTorque", torque, asImpulse, nodeName);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }
}
}
