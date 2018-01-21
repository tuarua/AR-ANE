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
package com.tuarua.arane.events {
import flash.events.Event;
import flash.geom.Point;

public class SwipeGestureEvent extends Event {
    public static const LEFT:String = "ArKit.OnScene3dSwipeLeft";
    public static const RIGHT:String = "ArKit.OnScene3dSwipeRight";
    public static const UP:String = "ArKit.OnScene3dSwipeUp";
    public static const DOWN:String = "ArKit.OnScene3dSwipeDown";

    public var location:Point;
    public var direction:uint;
    public var phase:uint;

    public function SwipeGestureEvent(type:String, direction:uint, phase:uint, location:Point = null, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.direction = direction;
        this.phase = phase;
        this.location = location;
    }

    public override function clone():Event {
        return new TapEvent(type, this.location, bubbles, cancelable);
    }

    public override function toString():String {
        return formatToString("SwipeGestureEvent", "direction", "phase", "location", "type", "bubbles", "cancelable");
    }

}
}
