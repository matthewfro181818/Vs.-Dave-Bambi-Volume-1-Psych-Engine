-- Converted from DB v1.0.6 HXC
class BlockedEvents extends SongModule
{
    var blockedShader:RuntimeShader;
    var black:FlxSprite;
    var fastCamZooms:Bool;

    public function new()
    {
        super('blockedEvents', 0, 'blocked');
    }

    override function onCreate(e:ScriptEvent)
    {
        if (PlayStatePlaylist.isStoryMode)
        {
            game.startCallback = () -> {
                game.beginStartDialogue('blocked');
            }
        }
        blockedShader = new RuntimeShader(Paths.frag('blockedGlitchEffect'));
        blockedShader.setFloat('time', 0);
    }

    function onUpdate(elapsed)
    {
        blockedShader.setFloat('time', blockedShader.getFloat('time') + e.elapsed);
    }

    function onStepHit()
    {
        switch (e.step)
        {
            case 128:
                FlxG.camera.flash(FlxColor.WHITE, 0.5);
                black = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
                black.scale.set(FlxG.width * 2, FlxG.height * 2);
                black.updateHitbox();
                black.screenCenter();
                black.alpha = 0;
                game.add(black);
                
                game.defaultCamZoom += 0.1;
                game.makeInvisibleNotes(true);
                FlxTween.tween(black, {alpha: 0.6}, 1);
            case 254:
                fastCamZooms = true;
            case 256:
                game.defaultCamZoom -= 0.1;
                FlxG.camera.flash();
                FlxTween.tween(black, {alpha: 0}, 1);
                game.makeInvisibleNotes(false);
            case 384:
                fastCamZooms = false;
            case 640:
                FlxG.camera.flash();
                game.camHUD.alpha = 0;
                black.alpha = 0.6;
                game.defaultCamZoom += 0.1;
            case 768:
                game.camHUD.alpha = 1;
                fastCamZooms = true;
                game.defaultCamZoom -= 0.1;
                FlxG.camera.flash();
                black.alpha = 0;
            case 1023:
                fastCamZooms = false;
            case 1028:
                game.makeInvisibleNotes(true);
            case 1136:
                game.makeInvisibleNotes(false);
            case 1152:
                FlxTween.tween(black, {alpha: 0.4}, 1);
                game.defaultCamZoom += 0.3;
            case 1200:
                game.camHUD.filters = [new ShaderFilter(blockedShader)];
                FlxTween.tween(black, {alpha: 0.7}, (Conductor.instance.stepCrochet / 1000) * 8);
            case 1216:
                fastCamZooms = true;
                game.defaultCamZoom -= 0.3;
                game.camHUD.filters = [];
                FlxG.camera.flash(FlxColor.WHITE, 0.5);
                game.remove(black);
            case 1535:
                fastCamZooms = false;
        }
    }

    function onBeatHit()
    {
        if (fastCamZooms && e.beat > 63 && game.camZooming)
        {
            FlxG.camera.zoom += 0.025;
            game.camHUD.zoom += 0.045;
        }
    }
}