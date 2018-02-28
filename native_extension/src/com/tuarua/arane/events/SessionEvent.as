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

public class SessionEvent extends Event {
    public static const ERROR:String = "ArKit.OnSessionError";
    public static const INTERRUPTED:String = "ArKit.OnSessionInterrupted";
    public static const INTERRUPTION_ENDED:String = "ArKit.OnSessionInterruptionEnded";

    public var error:String;

    public function SessionEvent(type:String, error:String = null, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.error = error;
    }

    public override function clone():Event {
        return new SessionEvent(type, this.error, bubbles, cancelable);
    }

    public override function toString():String {
        return formatToString("SessionEvent", "error", "type", "bubbles", "cancelable");
    }
}
}
