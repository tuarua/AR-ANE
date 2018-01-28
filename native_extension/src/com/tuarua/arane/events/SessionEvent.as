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
