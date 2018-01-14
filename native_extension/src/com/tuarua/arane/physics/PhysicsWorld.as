package com.tuarua.arane.physics {
import flash.geom.Vector3D;

public class PhysicsWorld {
    // A global 3D vector specifying the field force acceleration due to gravity. The unit is meter per second. Default is {0, -9.8, 0}.
    private var _gravity:Vector3D = new Vector3D(0, -9.8, 0);
    // A speed multiplier applied to the physics simulation. Default is 1.0.
    // The speed can be reduced to slowdown the simulation, but beware that increasing the speed factor will decrease the accuracy of the simulation.
    private var _speed:Number = 1;
    // The time step of the physics simulation. Default is 1/60s (60 Hz).
    private var _timeStep:Number = 1 / 60;

    public function PhysicsWorld() {
    }

    public function get speed():Number {
        return _speed;
    }

    public function get timeStep():Number {
        return _timeStep;
    }

    public function get gravity():Vector3D {
        return _gravity;
    }

    public function set gravity(value:Vector3D):void {
        _gravity = value;
    }

    public function set speed(value:Number):void {
        _speed = value;
    }

    public function set timeStep(value:Number):void {
        _timeStep = value;
    }
}
}