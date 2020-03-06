package com.tuarua.arkit.physics {
import flash.geom.Vector3D;

public class PhysicsContact {
    private var _collisionImpulse:Number = 0;
    private var _penetrationDistance:Number = 0;
    private var _sweepTestFraction:Number = 0;
    private var _nodeNameA:String;
    private var _nodeNameB:String;
    private var _categoryBitMaskA:uint;
    private var _categoryBitMaskB:uint;
    private var _contactNormal:Vector3D;
    private var _contactPoint:Vector3D;


    /** @private */
    public function PhysicsContact(collisionImpulse:Number, penetrationDistance:Number, sweepTestFraction:Number,
                                   nodeNameA:String, nodeNameB:String, categoryBitMaskA:uint, categoryBitMaskB:uint,
                                   contactNormal:Vector3D, contactPoint:Vector3D) {
        this._collisionImpulse = collisionImpulse;
        this._penetrationDistance = penetrationDistance;
        this._sweepTestFraction = sweepTestFraction;
        this._nodeNameA = nodeNameA;
        this._nodeNameB = nodeNameB;
        this._categoryBitMaskA = categoryBitMaskA;
        this._categoryBitMaskB = categoryBitMaskB;
        this._contactNormal = contactNormal;
        this._contactPoint = contactPoint;
    }

    /** the collision impulse on nodeA */
    public function get collisionImpulse():Number {
        return _collisionImpulse;
    }

    public function get penetrationDistance():Number {
        return _penetrationDistance;
    }

    /** Value between 0 and 1 giving the relative position of the physic shape when performing a convex
     * sweep test. */
    public function get sweepTestFraction():Number {
        return _sweepTestFraction;
    }

    public function get nodeNameA():String {
        return _nodeNameA;
    }

    public function get nodeNameB():String {
        return _nodeNameB;
    }

    public function get categoryBitMaskA():uint {
        return _categoryBitMaskA;
    }

    public function get categoryBitMaskB():uint {
        return _categoryBitMaskB;
    }

    public function get contactNormal():Vector3D {
        return _contactNormal;
    }

    public function get contactPoint():Vector3D {
        return _contactPoint;
    }
}
}

