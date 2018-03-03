package com.tuarua.arane.display {
import com.tuarua.ARANEContext;

import flash.display.BitmapData;
import flash.events.MouseEvent;
import flash.events.StatusEvent;

public class NativeButton extends NativeDisplayObject {
    public var bitmapData:BitmapData;
    public var listeners:Vector.<Object> = new <Object>[];
    private static const NATIVE_BUTTON_EVENT:String = "NativeButtonEvent";

    public function NativeButton(bitmapData:BitmapData) {
        this.bitmapData = bitmapData;
        this.type = BUTTON_TYPE;
        ARANEContext.context.addEventListener(StatusEvent.STATUS, gotNativeEvent);
    }

    public function addEventListener(type:String, listener:Function):void {
        var obj:Object = {type: type, listener: listener};
        listeners.push(obj);
    }

    private function gotNativeEvent(event:StatusEvent):void {
        var argsAsJSON:Object;
        switch (event.level) {
            case NATIVE_BUTTON_EVENT:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    for each (var listener:Object in listeners) {
                        if (argsAsJSON.id == _id && argsAsJSON.event == listener.type) {
                            var func:Function = listener.listener as Function;
                            func.call(null, new MouseEvent(listener.type));
                        }
                    }
                } catch (e:Error) {
                    trace("JSON decode error NativeButton", e.message);
                    break;
                }
                break;
        }
    }

}
}
