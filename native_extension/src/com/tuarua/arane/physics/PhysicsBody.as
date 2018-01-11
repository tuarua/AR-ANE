package com.tuarua.arane.physics {
import flash.geom.Vector3D;
[RemoteClass(alias="com.tuarua.arane.physics.PhysicsBody")]
public class PhysicsBody {
    private var _type:int = PhysicsBodyType.static;
    private var _physicsShape:PhysicsShape;
    private var _angularDamping:Number = 0;
    private var _angularVelocity:Vector3D;
    private var _angularVelocityFactor:Vector3D;
    private var _momentOfInertia:Vector3D;
    private var _velocity:Vector3D;
    private var _velocityFactor:Vector3D;
    private var _mass:Number = 0;
    private var _usesDefaultMomentOfInertia:Boolean = false;
    private var _charge:Number = 0;
    private var _friction:Number = 0.5;
    private var _restitution:Number = 0.5;
    private var _rollingFriction:Number = 0;
    private var _damping:Number = 0.1;
    private var _allowsResting:Boolean = false;
    private var _isAffectedByGravity:Boolean = true;

    public function PhysicsBody(type:int, physicsShape:PhysicsShape) {
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
}
}
