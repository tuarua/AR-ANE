/* Copyright 2018 Tua Rua Ltd.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 Additional Terms
 No part, or derivative of this Air Native Extensions's code is permitted
 to be sold as the basis of a commercially packaged Air Native Extension which
 undertakes the same purpose as this software. That is an ARKit wrapper for iOS.
 All Rights Reserved. Tua Rua Ltd.
 */

package com.tuarua {
import com.tuarua.arane.AR2DView;
import com.tuarua.arane.AR3DView;
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public class ARANE extends EventDispatcher {
    private static var _isSupported:Boolean = false;
    private static var _arkit:ARANE;
    private var _view2D:AR2DView;
    private var _view3D:AR3DView;
    private var _iosVersion:Number;
    private static var _displayLogging:Boolean = false;

    /** @private */
    public function ARANE() {
        if (_arkit) {
            throw new Error(ARANEContext.NAME + "ARANE is a singleton, use .arkit");
        }
        if (ARANEContext.context) {
            var theRet:* = ARANEContext.context.call("init", _displayLogging);
            if (theRet is ANEError) {
                throw theRet as ANEError;
            }
            _isSupported = theRet;
        }
        _view2D = new AR2DView();
        _view3D = new AR3DView();
        _arkit = this;
    }

    override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0,
                                              useWeakReference:Boolean = false):void {
        super.addEventListener(type, listener, useCapture, priority, useWeakReference);
        if (_isSupported) {
            ARANEContext.context.call("addEventListener", type);
        } else {
            trace("You need to init before adding EventListeners");
        }
    }

    public function appendDebug(message:String):void {
        ARANEContext.context.call("appendToLog", message);
    }

    /** Disposes the ANE. */
    public static function dispose():void {
        if (ARANEContext.context) {
            ARANEContext.dispose();
        }
    }

    /** The ANE instance. */
    public static function get arkit():ARANE {
        if (!_arkit) {
            new ARANE();
        }
        return _arkit;
    }

    public function get view2D():AR2DView {
        return _view2D;
    }

    public function get view3D():AR3DView {
        return _view3D;
    }

    /** Whether to display debug box for this ANE. */
    public static function set displayLogging(value:Boolean):void {
        _displayLogging = value;
        if (ARANEContext.context && _arkit) {
            ARANEContext.context.call("displayLogging", value);
        }
    }

    /** Requests permissions for this ANE. */
    public function requestPermissions():void {
        if (ARANEContext.context) {
            ARANEContext.context.call("requestPermissions");
        }
    }

    /** Returns the device iOS version, eg 11.2 */
    public function get iosVersion():Number {
        if (_iosVersion > 0) return _iosVersion;
        if (ARANEContext.context) {
            var theRet:* = ARANEContext.context.call("getIosVersion");
            if (theRet is ANEError) return 0;
            _iosVersion = theRet as Number;
        }
        return _iosVersion;
    }

    /** Whether this ANE is supported on the current version of iOS. */
    public function get isSupported():Boolean {
        return _isSupported;
    }
}
}
