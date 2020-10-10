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

package com.tuarua.arkit.events {
import flash.events.Event;

public class GeoTrackingEvent extends Event {
    public static const STATE_CHANGED:String = "ArKit.OnGeoTrackingStateChange";
    public var accuracy:int;
    public var state:int;
    public var stateReason:int;

    public function GeoTrackingEvent(type:String, accuracy:int = 0, state:int = 0, stateReason:int = -1, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.accuracy = accuracy;
        this.state = state;
        this.stateReason = stateReason;
    }

    public override function clone():Event {
        return new GeoTrackingEvent(type, this.accuracy, this.state, this.stateReason, bubbles, cancelable);
    }

    public override function toString():String {
        return formatToString("GeoTrackingEvent", "accuracy", "state", "stateReason", "type", "bubbles", "cancelable");
    }
}
}
