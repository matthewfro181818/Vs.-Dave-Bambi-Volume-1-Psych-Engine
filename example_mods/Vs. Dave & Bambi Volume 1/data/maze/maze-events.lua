-- Converted from DB v1.0.6 HXC
class MazeEvents extends SongModule
{
    var black:FlxSprite;

    public function new()
    {
        super('mazeEvents', 0, 'maze');
    }

    function onCreatePost(e:ScriptEvent)
    {
        if (PlayStatePlaylist.isStoryMode)
            game.health -= 0.2;
    }
    
    function onStepHit(e:ConductorScriptEvent)
    {
        switch (e.step)
        {
            case 466:
                game.defaultCamZoom += 0.2;
                FlxG.camera.flash(FlxColor.WHITE, 0.5);
                black = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
                black.scale.set(FlxG.width * 2, FlxG.height * 2);
                black.updateHitbox();
                black.screenCenter();
                black.alpha = 0;
                game.add(black);
                FlxTween.tween(black, {alpha: 0.6}, 1);
                game.makeInvisibleNotes(true);
            case 510:
                game.makeInvisibleNotes(false);
            case 528:
                game.defaultCamZoom = 0.8;
                black.alpha = 0;
                FlxG.camera.flash();
            case 832:
                game.defaultCamZoom += 0.2;
                FlxTween.tween(black, {alpha: 0.4}, 1);
            case 838:
                game.makeInvisibleNotes(true);
            case 902:
                game.makeInvisibleNotes(false);
            case 908:
                FlxTween.tween(black, {alpha: 1}, (Conductor.instance.stepCrochet / 1000) * 4);
            case 912:
                FlxTween.tween(black, {alpha: 0.6}, 1);
            case 1168:
                FlxTween.tween(black, {alpha: 0}, 1);
            case 1232:
                FlxG.camera.flash();
        }
    }
}