package com.tuarua.arane.display {
import flash.display.BitmapData;

public class NativeImage extends NativeDisplayObject {
    public var bitmapData:BitmapData;
    public function NativeImage(bitmapData:BitmapData) {
        this.bitmapData = bitmapData;
        this.type = IMAGE_TYPE;
    }
}
}
