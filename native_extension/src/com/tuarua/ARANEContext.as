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
import com.tuarua.arane.ImageAnchor;
import com.tuarua.arane.Node;
import com.tuarua.arane.ObjectAnchor;
import com.tuarua.arane.PlaneAnchor;
import com.tuarua.arane.events.CameraTrackingEvent;
import com.tuarua.arane.events.ImageDetectedEvent;
import com.tuarua.arane.events.LongPressEvent;
import com.tuarua.arane.events.ObjectDetectedEvent;
import com.tuarua.arane.events.PhysicsEvent;
import com.tuarua.arane.events.PinchGestureEvent;
import com.tuarua.arane.events.PlaneDetectedEvent;
import com.tuarua.arane.events.PlaneRemovedEvent;
import com.tuarua.arane.events.PlaneUpdatedEvent;
import com.tuarua.arane.events.SessionEvent;
import com.tuarua.arane.events.SwipeGestureEvent;
import com.tuarua.arane.events.TapEvent;
import com.tuarua.arane.permissions.PermissionEvent;
import com.tuarua.arane.physics.PhysicsContact;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.geom.Matrix3D;
import flash.geom.Point;
import flash.geom.Vector3D;
import flash.utils.Dictionary;
import flash.utils.setTimeout;

/** @private */
public class ARANEContext {
    internal static const NAME:String = "ARANE";
    internal static const TRACE:String = "TRACE";
    public static var removedNodeMap:Vector.<String> = new Vector.<String>();
    private static var _context:ExtensionContext;
    private static var argsAsJSON:Object;
    private static var lastPlaneAnchor:PlaneAnchor;
    private static var lastImageAnchor:ImageAnchor;
    private static var lastObjectAnchor:ObjectAnchor;
    public static var closures:Dictionary = new Dictionary();

    private static const ON_CURRENT_WORLDMAP:String = "ArKit.OnCurrentWorldMap";
    private static const ON_REFERENCE_OBJECT:String = "ArKit.OnReferenceObject";

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
        var err:Error;
        var closure:Function;
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case ON_CURRENT_WORLDMAP:
                argsAsJSON = JSON.parse(event.code);
                if (argsAsJSON.hasOwnProperty("error") && argsAsJSON.error) {
                    err = new Error(argsAsJSON.error.text, argsAsJSON.error.id);
                }
                closure = ARANEContext.closures[argsAsJSON.eventId];
                if (closure != null) {
                    closure.call(null, err);
                    delete ARANEContext.closures[argsAsJSON.eventId];
                }
                break;
            case ON_REFERENCE_OBJECT:
                argsAsJSON = JSON.parse(event.code);
                if (argsAsJSON.hasOwnProperty("error") && argsAsJSON.error) {
                    err = new Error(argsAsJSON.error.text, argsAsJSON.error.id);
                }
                closure = ARANEContext.closures[argsAsJSON.eventId];
                if (closure != null) {
                    closure.call(null, err);
                    delete ARANEContext.closures[argsAsJSON.eventId];
                }
                break;
            case PlaneDetectedEvent.PLANE_DETECTED:
            case PlaneUpdatedEvent.PLANE_UPDATED:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    var planeAnchor:PlaneAnchor = new PlaneAnchor(argsAsJSON.anchor.id);
                    planeAnchor.alignment = argsAsJSON.anchor.alignment;
                    planeAnchor.center = new Vector3D(
                            argsAsJSON.anchor.center.x,
                            argsAsJSON.anchor.center.y,
                            argsAsJSON.anchor.center.z);
                    planeAnchor.extent = new Vector3D(argsAsJSON.anchor.extent.x,
                            argsAsJSON.anchor.extent.y,
                            argsAsJSON.anchor.extent.z);
                    if (lastPlaneAnchor && lastPlaneAnchor.equals(planeAnchor)) return;
                    if (argsAsJSON.anchor.transform && argsAsJSON.anchor.transform.length > 0) {
                        var numVec_a:Vector.<Number> = new Vector.<Number>();
                        for each (var n:Number in argsAsJSON.anchor.transform) {
                            numVec_a.push(n);
                        }
                        planeAnchor.transform = new Matrix3D(numVec_a);
                    }
                    lastPlaneAnchor = planeAnchor;
                    if (event.level == PlaneDetectedEvent.PLANE_DETECTED) {
                        var node:Node = new Node(null, argsAsJSON.node.id);
                        node.isAdded = true;
                        ARANE.arkit.dispatchEvent(new PlaneDetectedEvent(event.level, planeAnchor, node));
                    } else {
                        ARANE.arkit.dispatchEvent(new PlaneUpdatedEvent(event.level, planeAnchor, argsAsJSON.nodeName));
                    }

                } catch (e:Error) {
                    trace(e.message);
                }
                break;
            case PlaneRemovedEvent.PLANE_REMOVED:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    ARANE.arkit.dispatchEvent(new PlaneRemovedEvent(event.level, argsAsJSON.nodeName));
                } catch (e:Error) {
                    trace(e.message);
                }
                break;
            case ImageDetectedEvent.IMAGE_DETECTED:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    var imageAnchor:ImageAnchor = new ImageAnchor(argsAsJSON.anchor.id);
                    imageAnchor.name = argsAsJSON.anchor.name;
                    imageAnchor.width = argsAsJSON.anchor.width;
                    imageAnchor.height = argsAsJSON.anchor.height;
                    if (lastImageAnchor && lastImageAnchor.equals(imageAnchor)) return;
                    if (argsAsJSON.anchor.transform && argsAsJSON.anchor.transform.length > 0) {
                        var numVec_b:Vector.<Number> = new Vector.<Number>();
                        for each (var n_b:Number in argsAsJSON.anchor.transform) {
                            numVec_b.push(n_b);
                        }
                        imageAnchor.transform = new Matrix3D(numVec_b);
                    }
                    lastImageAnchor = imageAnchor;
                    var node_b:Node = new Node(null, argsAsJSON.node.id);
                    node_b.isAdded = true;
                    ARANE.arkit.dispatchEvent(new ImageDetectedEvent(event.level, imageAnchor, node_b));
                } catch (e:Error) {
                    trace(e.message);
                }
                break;
            case ObjectDetectedEvent.OBJECT_DETECTED:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    var anchorJSON:Object = argsAsJSON.anchor;
                    var referenceObjectJSON:Object = anchorJSON.referenceObject;
                    var objectAnchor:ObjectAnchor = new ObjectAnchor(anchorJSON.id);
                    objectAnchor.referenceObject.name = referenceObjectJSON.name;
                    objectAnchor.referenceObject.center = new Vector3D(
                            referenceObjectJSON.center.x,
                            referenceObjectJSON.center.y,
                            referenceObjectJSON.center.z);
                    objectAnchor.referenceObject.extent = new Vector3D(
                            referenceObjectJSON.extent.x,
                            referenceObjectJSON.extent.y,
                            referenceObjectJSON.extent.z);
                    objectAnchor.referenceObject.scale = new Vector3D(
                            referenceObjectJSON.scale.x,
                            referenceObjectJSON.scale.y,
                            referenceObjectJSON.scale.z);

                    if (lastObjectAnchor && lastObjectAnchor.equals(objectAnchor)) return;
                    if (anchorJSON.transform && anchorJSON.transform.length > 0) {
                        var numVec_c:Vector.<Number> = new Vector.<Number>();
                        for each (var n_c:Number in anchorJSON.transform) {
                            numVec_c.push(n_c);
                        }
                        objectAnchor.transform = new Matrix3D(numVec_c);
                    }
                    lastObjectAnchor = objectAnchor;
                    var node_c:Node = new Node(null, argsAsJSON.node.id);
                    node_c.isAdded = true;
                    ARANE.arkit.dispatchEvent(new ObjectDetectedEvent(event.level, objectAnchor, node_c));
                } catch (e:Error) {
                    trace(e.message);
                    trace(e.getStackTrace());
                }
                break;

            case TapEvent.TAP:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    var location:Point = new Point(argsAsJSON.x, argsAsJSON.y);
                    ARANE.arkit.dispatchEvent(new TapEvent(event.level, location));
                } catch (e:Error) {
                    trace(e.message);
                }
                break;
            case LongPressEvent.LONG_PRESS:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    var location_d:Point = new Point(argsAsJSON.x, argsAsJSON.y);
                    ARANE.arkit.dispatchEvent(new LongPressEvent(event.level, argsAsJSON.phase, location_d));
                } catch (e:Error) {
                    trace(e.message);
                }
                break;
            case PinchGestureEvent.PINCH:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    var location_c:Point = new Point(argsAsJSON.x, argsAsJSON.y);
                    ARANE.arkit.dispatchEvent(new PinchGestureEvent(event.level, argsAsJSON.scale,
                            argsAsJSON.velocity, argsAsJSON.phase, location_c));
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
                    ARANE.arkit.dispatchEvent(new SwipeGestureEvent(event.level, argsAsJSON.direction,
                            argsAsJSON.phase, location_b));
                } catch (e:Error) {
                    trace(e.message);
                }
                break;
            case CameraTrackingEvent.STATE_CHANGED:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    ARANE.arkit.dispatchEvent(new CameraTrackingEvent(event.level, argsAsJSON.state, argsAsJSON.reason));
                } catch (e:Error) {
                    trace(e.message);
                }
                break;
            case PermissionEvent.STATUS_CHANGED:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    setTimeout(function ():void {
                        ARANE.arkit.dispatchEvent(new PermissionEvent(event.level, argsAsJSON.status));
                    }, (1 / 15)); //put a delay to prevent Stage3D Error #3768
                } catch (e:Error) {
                    trace(e.message);
                }
                break;
            case PhysicsEvent.CONTACT_DID_BEGIN:
            case PhysicsEvent.CONTACT_DID_END:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    ARANE.arkit.dispatchEvent(new PhysicsEvent(event.level, new PhysicsContact(
                            argsAsJSON.collisionImpulse,
                            argsAsJSON.penetrationDistance,
                            argsAsJSON.sweepTestFraction,
                            argsAsJSON.nodeNameA,
                            argsAsJSON.nodeNameB,
                            argsAsJSON.categoryBitMaskA,
                            argsAsJSON.categoryBitMaskB,
                            new Vector3D(argsAsJSON.contactNormal.x,
                                    argsAsJSON.contactNormal.y,
                                    argsAsJSON.contactNormal.z),
                            new Vector3D(argsAsJSON.contactPoint.x,
                                    argsAsJSON.contactPoint.y,
                                    argsAsJSON.contactPoint.z))
                    ));
                } catch (e:Error) {
                    trace(e.message);
                }
                break;
            case SessionEvent.ERROR:
            case SessionEvent.INTERRUPTED:
            case SessionEvent.INTERRUPTION_ENDED:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    ARANE.arkit.dispatchEvent(new SessionEvent(event.level, argsAsJSON.error));
                } catch (e:Error) {
                    trace(e.message);
                }
                break;
        }
    }

    public static function createEventId(listener:Function):String {
        var eventId:String;
        if (listener != null) {
            eventId = context.call("createGUID") as String;
            closures[eventId] = listener;
        }
        return eventId;
    }

    public static function dispose():void {
        if (_context == null) {
            return;
        }
        trace("[" + NAME + "] Unloading ANE...");
        _context.removeEventListener(StatusEvent.STATUS, gotEvent);
        _context.dispose();
        _context = null;
    }
}
}
