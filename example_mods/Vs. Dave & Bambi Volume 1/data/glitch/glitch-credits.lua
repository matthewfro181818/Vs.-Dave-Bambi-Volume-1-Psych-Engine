-- Converted from DB v1.0.6 HXC
import flixel.text.FlxTextBorderStyle;

class GlitchCredits extends SongModule
{
    var credits:FlxText;

    function new()
    {
        super('glitchCredits', 1, 'glitch');
    }

    function onCreateUI(e:ScriptEvent)
    {	
        credits = new FlxText(4, game.healthBar.y + 50, 0, LanguageManager.getTextString('glitch_credit'), 16);
        credits.setFormat(Paths.font('comic.ttf'), 16, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        credits.scrollFactor.set();
        credits.borderSize = 1.25;
        credits.antialiasing = true;
        credits.cameras = [game.camHUD];
        game.add(credits);
    }
}