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

package com.tuarua.arane.animation {
import com.tuarua.ARANEContext;
import com.tuarua.fre.ANEError;

public class Transaction {
    private static var _animationDuration:Number = 0.25;
    private static var _disableActions:Boolean = false;
    public static function begin():void {
        var theRet:* = ARANEContext.context.call("beginTransaction");
        if (theRet is ANEError) throw theRet as ANEError;
    }
    public static function commit():void {
        var theRet:* = ARANEContext.context.call("commitTransaction");
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public static function get animationDuration():Number {
        return _animationDuration;
    }

    public static function set animationDuration(value:Number):void {
        _animationDuration = value;
        setANEvalue("animationDuration", value);
    }

    private static function setANEvalue(name:String, value:*):void {
        var theRet:* = ARANEContext.context.call("setTransactionProp", name, value);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public static function get disableActions():Boolean {
        return _disableActions;
    }

    public static function set disableActions(value:Boolean):void {
        _disableActions = value;
        setANEvalue("disableActions", value);
    }
}
}
