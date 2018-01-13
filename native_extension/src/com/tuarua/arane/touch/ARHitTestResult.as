package com.tuarua.arane.touch {
import com.tuarua.arane.Anchor;
import flash.geom.Matrix3D;
[RemoteClass(alias="com.tuarua.arane.touch.ARHitTestResult")]
public class ARHitTestResult {
    private var _type:int;
    private var _distance:Number;
    private var _localTransform:Matrix3D;
    private var _worldTransform:Matrix3D;
    private var _anchor:Anchor;

    public function ARHitTestResult(type:int, distance:Number, localTransform:Matrix3D, worldTransform:Matrix3D,
                                    anchor:Anchor = null) {
        _type = type;
        _distance = distance;
        _localTransform = localTransform;
        _worldTransform = worldTransform;
        _anchor = anchor;
    }

    public function get type():int {
        return _type;
    }

    public function set type(value:int):void {
        _type = value;
    }

    public function get distance():Number {
        return _distance;
    }

    public function set distance(value:Number):void {
        _distance = value;
    }

    public function get localTransform():Matrix3D {
        return _localTransform;
    }

    public function set localTransform(value:Matrix3D):void {
        _localTransform = value;
    }

    public function get worldTransform():Matrix3D {
        return _worldTransform;
    }

    public function set worldTransform(value:Matrix3D):void {
        _worldTransform = value;
    }

    public function get anchor():Anchor {
        return _anchor;
    }

    public function set anchor(value:Anchor):void {
        _anchor = value;
    }
}
}