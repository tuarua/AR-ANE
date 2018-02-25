package {

import flash.desktop.NativeApplication;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.text.TextField;

import starling.core.Starling;
import starling.events.Event;
import starling.events.ResizeEvent;

import utils.ScreenSetup;

[SWF(width="320", height="480", frameRate="60", backgroundColor="#FFFFFF")]
public class Main extends Sprite {
    private var _starling:Starling;
    public function Main() {

        var screen:ScreenSetup = new ScreenSetup(
                stage.fullScreenWidth, stage.fullScreenHeight, [1, 2]);

        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;

        _starling = new Starling(StarlingRoot, stage, screen.viewPort);
        _starling.stage.stageWidth = screen.stageWidth;
        _starling.stage.stageHeight = screen.stageHeight;
        // _starling.showStatsAt("right", "bottom");

        _starling.skipUnchangedFrames = true;
        _starling.addEventListener(starling.events.Event.ROOT_CREATED, function ():void {
            var game:StarlingRoot = _starling.root as StarlingRoot;
            game.start();

            stage.addEventListener(ResizeEvent.RESIZE, onResize);
        });

        _starling.start();


        NativeApplication.nativeApplication.addEventListener(
                flash.events.Event.ACTIVATE, function (e:*):void {
                    _starling.start();
                });
        NativeApplication.nativeApplication.addEventListener(
                flash.events.Event.DEACTIVATE, function (e:*):void {
                    _starling.stop(true);
                });

    }

    private function onResize(e:flash.events.Event):void {
    }


}
}
