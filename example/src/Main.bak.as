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

[SWF(width="320", height="480", frameRate="60", backgroundColor="#336699")]
public class Main extends Sprite {
    private var _starling:Starling;

    private var hasActivated:Boolean = false;
    private var textField:TextField;
    public function Main() {
//        textField = new TextField();
//        textField.text = "Hello, World";
//        addChild(textField);
//
//        this.addEventListener(Event.ACTIVATE, onActivated);


        var screen:ScreenSetup = new ScreenSetup(
                stage.fullScreenWidth, stage.fullScreenHeight, [1, 2]);

        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;

        _starling = new Starling(StarlingRoot, stage, screen.viewPort);
        _starling.stage.stageWidth = screen.stageWidth;
        _starling.stage.stageHeight = screen.stageHeight;
        _starling.showStatsAt("right", "bottom");

        _starling.skipUnchangedFrames = false;
        _starling.addEventListener(starling.events.Event.ROOT_CREATED, function ():void {
            //loadAssets(screen.assetScale, startGame);

            var game:StarlingRoot = _starling.root as StarlingRoot;
            game.start(null);

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
        var game:StarlingRoot = _starling.root as StarlingRoot;
        game.onResize(stage.stageWidth, stage.stageHeight);
    }


}
}
