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
import com.tuarua.arane.Node;
import com.tuarua.arane.PlaneAnchor;
import com.tuarua.arane.events.CameraTrackingEvent;
import com.tuarua.arane.events.PlaneDetectedEvent;
import com.tuarua.arane.events.PlaneUpdatedEvent;
import com.tuarua.arane.events.SwipeGestureEvent;
import com.tuarua.arane.events.TapEvent;

import flash.events.EventDispatcher;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.geom.Matrix3D;
import flash.geom.Point;
import flash.geom.Vector3D;

public class ARANEContext {
    internal static const NAME:String = "ARANE";
    internal static const TRACE:String = "TRACE";
    public static var removedNodeMap:Vector.<String> = new Vector.<String>();
    private static var _context:ExtensionContext;
    private static var argsAsJSON:Object;

    public function ARANEContext() {
    }

    public static function get context():ExtensionContext {
        if (_context == null) {
            try {
                _context = ExtensionContext.createExtensionContext("com.tuarua." + NAME, null);
                if (_context == null) {
                    throw new Error("ANE " + NAME + " not created properly.  Future calls will fail.");
                }
                _context.addEventListener(StatusEvent.STATUS, gotEvent);
            } catch (e:Error) {
                trace("[" + NAME + "] ANE not loaded properly.  Future calls will fail.");
            }
        }
        return _context;
    }

    private static function gotEvent(event:StatusEvent):void {
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case PlaneDetectedEvent.ON_PLANE_DETECTED:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    var anchor:PlaneAnchor = new PlaneAnchor(argsAsJSON.anchor.id);
                    anchor.alignment = argsAsJSON.anchor.alignment;
                    anchor.center = new Vector3D(argsAsJSON.anchor.center.x, argsAsJSON.anchor.center.y, argsAsJSON.anchor.center.z);
                    anchor.extent = new Vector3D(argsAsJSON.anchor.extent.x, argsAsJSON.anchor.extent.y, argsAsJSON.anchor.extent.z);
                    if (argsAsJSON.anchor.transform && argsAsJSON.anchor.transform.length > 0) {
                        var numVec:Vector.<Number> = new Vector.<Number>();
                        for each (var n:Number in argsAsJSON.anchor.transform) {
                            numVec.push(n);
                        }
                        anchor.transform = new Matrix3D(numVec);
                    }
                    var node:Node = new Node(null, argsAsJSON.node.id);
                    node.isAdded = true;
                    ARANE.arkit.dispatchEvent(new PlaneDetectedEvent(event.level, anchor, node));
                } catch (e:Error) {
                    trace(e.message);
                }
                break;
            case PlaneUpdatedEvent.ON_PLANE_UPDATED:
                break;
            case TapEvent.ON_TAP:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    var location:Point = new Point(argsAsJSON.x, argsAsJSON.y);
                    ARANE.arkit.dispatchEvent(new TapEvent(event.level, location));
                } catch (e:Error) {
                    trace(e.message);
                }
                break;
            case SwipeGestureEvent.LEFT:
            case SwipeGestureEvent.RIGHT:
            case SwipeGestureEvent.UP:
            case SwipeGestureEvent.DOWN:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    var location_b:Point = new Point(argsAsJSON.x, argsAsJSON.y);
                    ARANE.arkit.dispatchEvent(new SwipeGestureEvent(event.level, argsAsJSON.direction, argsAsJSON.phase, location_b));
                } catch (e:Error) {
                    trace(e.message);
                }
                break;
            case CameraTrackingEvent.ON_STATE_CHANGE:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    ARANE.arkit.dispatchEvent(new CameraTrackingEvent(event.level, argsAsJSON.state, argsAsJSON.reason));
                } catch (e:Error) {
                    trace(e.message);
                }
                break;
        }
    }

    public static function dispose():void {
        if (!_context) {
            return;
        }
        trace("[" + NAME + "] Unloading ANE...");
        _context.removeEventListener(StatusEvent.STATUS, gotEvent);
        _context.dispose();
        _context = null;
    }
}
}
