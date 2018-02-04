package com.tuarua.arane {
public class FocusSquare {
    private var _primaryColor:uint;
    private var _fillColor:uint;
    private var _enabled:Boolean;

    public function FocusSquare(primaryColor:uint = 0xFFFFCC00, fillColor:uint = 0xFFFFEC69) {
        this._primaryColor = primaryColor;
        this._fillColor = fillColor;
    }

    public function get primaryColor():uint {
        return _primaryColor;
    }

    public function get fillColor():uint {
        return _fillColor;
    }

    public function show():void {

    }

    public function hide():void {

    }

    public function get enabled():Boolean {
        return _enabled;
    }

    public function set enabled(value:Boolean):void {
        _enabled = value;
    }
}
}