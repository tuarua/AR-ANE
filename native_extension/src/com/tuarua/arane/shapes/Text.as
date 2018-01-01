package com.tuarua.arane.shapes {

public class Text extends Geometry {
    private static const TYPE:String = "text";
    private var _string:String;
    private var _extrusionDepth:Number;
    private var _flatness:Number;
    private var _chamferRadius:Number;

    public function Text(string:String, extrusionDepth:Number) {
        super();
        this._string = string;
        this._extrusionDepth = extrusionDepth;
    }

    public function get string():String {
        return _string;
    }

    public function set string(value:String):void {
        _string = value;
        setANEvalue(TYPE, "string", value);
    }

    public function get extrusionDepth():Number {
        return _extrusionDepth;
    }

    public function set extrusionDepth(value:Number):void {
        _extrusionDepth = value;
        setANEvalue(TYPE, "extrusionDepth", value);
    }

    public function get flatness():Number {
        return _flatness;
    }

    public function set flatness(value:Number):void {
        _flatness = value;
        setANEvalue(TYPE, "flatness", value);
    }

    public function get chamferRadius():Number {
        return _chamferRadius;
    }

    public function set chamferRadius(value:Number):void {
        _chamferRadius = value;
        setANEvalue(TYPE, "chamferRadius", value);
    }
}
}
