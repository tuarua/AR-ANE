package views {
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Align;

public class SimpleButton extends Sprite {
    public function SimpleButton(text:String, w:int = 200) {
        super();
        var bg:Quad = new Quad(w, 38, 0x337AB7);
        var lbl:TextField = new TextField(w, 32, text);
        lbl.format.setTo(Fonts.NAME, 13, 0xFFFFFF, Align.CENTER);
        lbl.x = 0;
        lbl.y = 4;
        lbl.batchable = true;
        lbl.touchable = false;

        this.addChild(bg);
        this.addChild(lbl);
    }
}
}