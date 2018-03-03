package com.tuarua.arane.physics {
import flash.geom.Vector3D;

public class PhysicsWorld {

    public function PhysicsWorld() {
    }

    private var _isDefault:Boolean = true;
    private var _gravity:Vector3D = new Vector3D(0, -9.8, 0);
    private var _speed:Number = 1;
    private var _timeStep:Number = 1 / 60;


    /** The time step of the physics simulation.
     * @default 1/60 */
    public function get timeStep():Number {
        return _timeStep;
    }

    public function set timeStep(value:Number):void {
        _isDefault = false;
        _timeStep = value;
    }

    /** A global 3D vector specifying the field force acceleration due to gravity. The unit is meter per second.
     * @default {0, -9.8, 0}. */
    public function get gravity():Vector3D {
        return _gravity;
    }

    public function set gravity(value:Vector3D):void {
        _isDefault = false;
        _gravity = value;
    }

    /** A speed multiplier applied to the physics simulation.
     * The speed can be reduced to slowdown the simulation, but beware that increasing the speed factor
     * will decrease the accuracy of the simulation.
     * @default 1.0
     */
    public function get speed():Number {
        return _speed;
    }

    public function set speed(value:Number):void {
        _isDefault = false;
        _speed = value;
    }

    /** @private */
    public function get isDefault():Boolean {
        return _isDefault;
    }
}
}