package com.tuarua.arane.events {
import com.tuarua.arane.Node;
import com.tuarua.arane.PlaneAnchor;

import flash.events.Event;

public class PlaneDetectedEvent extends Event {
    public static const ON_PLANE_DETECTED:String = "ArKit.OnPlaneDetected";
    public var anchor:PlaneAnchor;
    public var node:Node;

    //noinspection ReservedWordAsName
    public function PlaneDetectedEvent(type:String, anchor:PlaneAnchor = null, node:Node = null, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.anchor = anchor;
        this.node = node;
    }

    public override function clone():Event {
        return new PlaneDetectedEvent(type, this.anchor, this.node, bubbles, cancelable);
    }

    public override function toString():String {
        return formatToString("AREvent", "anchor", "node", "type", "bubbles", "cancelable");
    }
}
}
