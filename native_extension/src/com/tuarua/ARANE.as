/* Copyright 2017 Tua Rua Ltd.

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
import com.tuarua.arane.ARScene2D;
import com.tuarua.arane.ARScene3D;
import com.tuarua.arane.display.NativeDisplayObject;
import com.tuarua.arane.events.PlaneDetectedEvent;
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public class ARANE extends EventDispatcher {
    private static var _isSupported:Boolean = false;
    private static var _arkit:ARANE;
    private var _scene2D:ARScene2D;
    private var _scene3D:ARScene3D;
    private static var _displayLogging:Boolean = false;

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
        _scene2D = new ARScene2D();
        _scene3D = new ARScene3D();
        _arkit = this;
        ARANEContext.dispatcher.addEventListener(PlaneDetectedEvent.ON_PLANE_DETECTED, onContextEvent);
    }

    private function onContextEvent(event:PlaneDetectedEvent):void {
        this.dispatchEvent(event);
    }

    //noinspection JSMethodCanBeStatic
    public function appendDebug(message:String):void {
        ARANEContext.context.call("appendToLog", message);
    }

    public static function dispose():void {
        if (ARANEContext.context) {
            ARANEContext.dispose();
        }
    }

    public static function get arkit():ARANE {
        if (!_arkit) {
            new ARANE();
        }
        return _arkit;
    }

    public function get scene2D():ARScene2D {
        return _scene2D;
    }

    public function get scene3D():ARScene3D {
        return _scene3D;
    }

    public static function set displayLogging(value:Boolean):void {
        _displayLogging = value;
        if (ARANEContext.context && _arkit) {
            ARANEContext.context.call("displayLogging", value);
        }
    }

    //noinspection JSMethodCanBeStatic
    public function addChild(nativeDisplayObject:NativeDisplayObject):void {
        if (ARANEContext.context) {
            try {
                ARANEContext.context.call("addNativeChild", nativeDisplayObject);
                nativeDisplayObject.isAdded = true;
            } catch (e:Error) {
                trace(e.message);
            }
        }
    }

    //noinspection JSMethodCanBeStatic
    public function get isSupported():Boolean {
        return _isSupported;
    }
}
}
