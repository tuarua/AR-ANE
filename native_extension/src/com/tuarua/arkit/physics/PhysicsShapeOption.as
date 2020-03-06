package com.tuarua.arkit.physics {
import flash.geom.Vector3D;

public class PhysicsShapeOption {
    private var _type:String = PhysicsShapeType.convexHull;
    private var _keepAsCompound:Boolean = true;
    private var _scale:Vector3D = new Vector3D(1, 1, 1);

    /**
     * @param type
     * @param keepAsCompound
     * @param scale
     */
    public function PhysicsShapeOption(type:String = null, keepAsCompound:Boolean = true, scale:Vector3D = null) {
        this._type = type ? type : this._type;
        this._keepAsCompound = keepAsCompound;
        this._scale = scale ? scale : this._scale;
    }

    /** type */
    public function get type():String {
        return _type;
    }

    /** keepAsCompound */
    public function get keepAsCompound():Boolean {
        return _keepAsCompound;
    }

    /** scale */
    public function get scale():Vector3D {
        return _scale;
    }
}
}