package com.tuarua.arane.events {
import flash.events.Event;

public class CameraTrackingEvent extends Event {
    public static const ON_STATE_CHANGE:String = "ArKit.OnCameraTrackingStateChange";
    public var state:int;
    public var reason:int;
    public function CameraTrackingEvent(type:String, state:int = 0, reason:int = -1, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.state = state;
        this.reason = reason;
    }

    public override function clone():Event {
        return new CameraTrackingEvent(type, this.state, this.reason, bubbles, cancelable);
    }

    public override function toString():String {
        return formatToString("CameraTrackingEvent", "state", "reason", "type", "bubbles", "cancelable");
    }
}
}
