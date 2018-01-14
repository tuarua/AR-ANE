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

package com.tuarua.arane.animation {
import com.tuarua.ARANEContext;
import com.tuarua.fre.ANEError;
import com.tuarua.utils.GUID;

import flash.geom.Vector3D;

public class Action {
    private var _id:String = GUID.create();
//    private var _duration:Number;
//    private var _speed:Number;
    private var _timingMode:int = ActionTimingMode.linear;

    public function Action() {
        //call into ANE to create action
        var theRet:* = ARANEContext.context.call("createAction", _id, _timingMode);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function hide():void {
        var theRet:* = ARANEContext.context.call("performAction", _id, "hide");
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function unhide():void {
        var theRet:* = ARANEContext.context.call("performAction", _id, "unhide");
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function rotateBy(x:Number, y:Number, z:Number, duration:Number):void {
        var theRet:* = ARANEContext.context.call("performAction", _id, "rotateBy", x, y, z, duration);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function moveBy(value:Vector3D, duration:Number):void {
        var theRet:* = ARANEContext.context.call("performAction", _id, "moveBy", value, duration);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function moveTo(value:Vector3D, duration:Number):void {
        var theRet:* = ARANEContext.context.call("performAction", _id, "moveTo", value, duration);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function scaleBy(value:Number, duration:Number):void {
        var theRet:* = ARANEContext.context.call("performAction", _id, "scaleBy", value, duration);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function scaleTo(value:Number, duration:Number):void {
        var theRet:* = ARANEContext.context.call("performAction", _id, "scaleTo", value, duration);
        if (theRet is ANEError) throw theRet as ANEError;
    }


    public function repeatForever():void {
        var theRet:* = ARANEContext.context.call("performAction", _id, "repeatForever");
        if (theRet is ANEError) throw theRet as ANEError;
    }

    /*
    //TODO
    public function sequence(actions:Vector.<Action>):Action {
        var theRet:* = ARANEContext.context.call("performAction", _id, "sequence", actions);
        if (theRet is ANEError) throw theRet as ANEError;
        return this;
    }*/

    /*public function get duration():Number {
        return _duration;
    }

    public function set duration(value:Number):void {
        _duration = value;
    }

    public function get speed():Number {
        return _speed;
    }

    public function set speed(value:Number):void {
        _speed = value;
    }*/

    public function get timingMode():int {
        return _timingMode;
    }

    public function set timingMode(value:int):void {
        _timingMode = value;
        setANEvalue("timingMode", value);
    }

    public function get id():String {
        return _id;
    }

    private function setANEvalue(name:String, value:*):void {
        var theRet:* = ARANEContext.context.call("setActionProp", _id, name, value);
        if (theRet is ANEError) throw theRet as ANEError;
    }


}
}
