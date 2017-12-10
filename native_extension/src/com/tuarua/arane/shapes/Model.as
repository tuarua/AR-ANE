package com.tuarua.arane.shapes {

public class Model extends Geometry {
    private static const TYPE:String = "model";
    private var _url:String;
    private var _nodeName:String;

    public function Model(url:String, nodeName:String = null) {
        super();
        this._url = url;
        this._nodeName = nodeName;
    }

    public function get url():String {
        return _url;
    }

    public function get nodeName():String {
        return _nodeName;
    }

    public function set nodeName(value:String):void {
        _nodeName = value;
    }
}
}
