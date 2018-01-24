package com.tuarua.arane.permissions {

import flash.events.Event;

public class PermissionEvent extends Event {
    public static const ON_STATUS:String = "Permission.OnStatus";
    public var status:int;

    public function PermissionEvent(type:String, status:int = 0, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.status = status;
    }

    public override function clone():Event {
        return new PermissionEvent(type, this.status, bubbles, cancelable);
    }

    public override function toString():String {
        return formatToString("PermissionEvent", "status", "type", "bubbles", "cancelable");
    }
}
}
