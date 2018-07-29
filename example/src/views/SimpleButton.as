package views {
import starling.core.Starling;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.utils.Align;

public class SimpleButton extends Sprite {
    private var highlight:Quad;
    public function SimpleButton(text:String, w:int = 200) {
        super();
        highlight = new Quad(w, 38, 0xFFFFFF);
        var bg:Quad = new Quad(w, 36, 0x337AB7);
        var line:Quad = new Quad(w, 2, 0x2E6BA1);
        var lbl:TextField = new TextField(w, 32, text);
        lbl.format.setTo(Fonts.NAME, 13, 0xFFFFFF, Align.CENTER);
        lbl.x = 0;
        lbl.y = 4;
        lbl.batchable = true;
        lbl.touchable = false;
        line.y = 36;
        this.addChild(bg);
        this.addChild(line);
        this.addChild(lbl);
        highlight.alpha = 0;
        this.addChild(highlight);
        this.addEventListener(TouchEvent.TOUCH, onClick);
    }

    private function onClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(this);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            Starling.juggler.tween(highlight, 0.1, {
                repeatCount: 2,
                alpha: 0.25,
                reverse: true
            });
        }
    }

}
}