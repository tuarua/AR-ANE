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

package com.tuarua.arkit.animation {
import com.tuarua.ARANEContext;
import com.tuarua.fre.ANEError;

import flash.geom.Vector3D;

public class Action {
    private var _id:String;
//    private var _duration:Number;
//    private var _speed:Number;
    private var _timingMode:int = ActionTimingMode.linear;

    /** Creates a new Action. */
    public function Action() {
        _id = ARANEContext.context.call("createGUID") as String;
        var ret:* = ARANEContext.context.call("action_create", _id, _timingMode);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Creates an action that hides a node */
    public function hide():void {
        var ret:* = ARANEContext.context.call("action_perform", _id, "hide");
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Creates an action that unhides a node */
    public function unhide():void {
        var ret:* = ARANEContext.context.call("action_perform", _id, "unhide");
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Creates an action that rotates the node by a relative value in radian. */
    public function rotateBy(x:Number, y:Number, z:Number, duration:Number):void {
        var ret:* = ARANEContext.context.call("action_perform", _id, "rotateBy", x, y, z, duration);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Creates an action that moves a node relative to its current position. */
    public function moveBy(value:Vector3D, duration:Number):void {
        var ret:* = ARANEContext.context.call("action_perform", _id, "moveBy", value, duration);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Creates an action that moves a node to a new position. */
    public function moveTo(value:Vector3D, duration:Number):void {
        var ret:* = ARANEContext.context.call("action_perform", _id, "moveTo", value, duration);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Creates an action that changes the x, y and z scale values of a node by a relative value. */
    public function scaleBy(value:Number, duration:Number):void {
        var ret:* = ARANEContext.context.call("action_perform", _id, "scaleBy", value, duration);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Creates an action that changes the x, y and z scale values of a node. */
    public function scaleTo(value:Number, duration:Number):void {
        var ret:* = ARANEContext.context.call("action_perform", _id, "scaleTo", value, duration);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Creates an action that repeats another action forever. */
    public function repeatForever():void {
        var ret:* = ARANEContext.context.call("action_perform", _id, "repeatForever");
        if (ret is ANEError) throw ret as ANEError;
    }

    /*
    //TODO
    public function sequence(actions:Vector.<Action>):Action {
        var ret:* = ARANEContext.context.call("action_perform", _id, "sequence", actions);
        if (ret is ANEError) throw ret as ANEError;
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

    /** The timing mode used to execute an action. */
    public function set timingMode(value:int):void {
        _timingMode = value;
        setANEvalue("timingMode", value);
    }

    /** @private */
    public function get id():String {
        return _id;
    }

    /** @private */
    private function setANEvalue(name:String, value:*):void {
        var ret:* = ARANEContext.context.call("action_setProp", _id, name, value);
        if (ret is ANEError) throw ret as ANEError;
    }


}
}
