package com.tuarua.arkit {
import com.tuarua.ARANEContext;
import com.tuarua.fre.ANEError;

import flash.geom.Vector3D;

public class FocusSquare {
    private var _isInited:Boolean = false;
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
        initCheck();
        var ret:* = ARANEContext.context.call("showFocusSquare");
        if (ret is ANEError) throw ret as ANEError;
    }

    public function hide():void {
        initCheck();
        var ret:* = ARANEContext.context.call("hideFocusSquare");
        if (ret is ANEError) throw ret as ANEError;
    }

    public function get enabled():Boolean {
        return _enabled;
    }

    public function set enabled(value:Boolean):void {
        if (_enabled == value) return;
        _enabled = value;
        if (_isInited) {
            var ret:* = ARANEContext.context.call("enableFocusSquare", value);
            if (ret is ANEError) throw ret as ANEError;
        }
    }

    public function get position():Vector3D {
        initCheck();
        var ret:* = ARANEContext.context.call("getFocusSquarePosition");
        if (ret is ANEError) throw ret as ANEError;
        return ret as Vector3D;
    }

    public function set primaryColor(value:uint):void {
        _primaryColor = value;
    }

    public function set fillColor(value:uint):void {
        _fillColor = value;
    }

    public function set isInited(value:Boolean):void {
        _isInited = value;
    }

    /** @private */
    private function initCheck():void {
        if (!_isInited) {
            throw new Error("You need to init first");
        }
    }
}
}