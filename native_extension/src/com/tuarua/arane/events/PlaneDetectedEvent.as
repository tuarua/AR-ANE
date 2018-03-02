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
import com.tuarua.arane.Node;
import com.tuarua.arane.PlaneAnchor;

import flash.events.Event;

public class PlaneDetectedEvent extends Event {
    public static const PLANE_DETECTED:String = "ArKit.OnPlaneDetected";
    public var anchor:PlaneAnchor;
    public var node:Node;

    public function PlaneDetectedEvent(type:String, anchor:PlaneAnchor = null, node:Node = null,
                                       bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.anchor = anchor;
        this.node = node;
    }

    public override function clone():Event {
        return new PlaneDetectedEvent(type, this.anchor, this.node, bubbles, cancelable);
    }

    public override function toString():String {
        return formatToString("PlaneDetectedEvent", "anchor", "node", "type", "bubbles", "cancelable");
    }
}
}
