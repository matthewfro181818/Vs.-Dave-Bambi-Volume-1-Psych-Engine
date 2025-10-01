-- Converted from DB v1.0.6 HXC
class CornTheftEvents extends SongModule
{
    var black:FlxSprite;
    var cutscene:FlxVideo;

    public function new()
    {
        super('cornTheftEvents', 0, 'corn-theft');
    }

    override function onCreate(e:ScriptEvent)
    {
        if (PlayStatePlaylist.isStoryMode)
        {
            game.startCallback = () -> {
                game.beginStartDialogue('corn-theft');
            }
            
            if (Preferences.cutscenes)
            {
                cutscene = VideoManager.playVideo(Paths.video('mazeCutscene'), game.nextSong);
                cutscene.alpha = 0.0;
                cutscene.volume = 0.0;
                cutscene.onOpening.add(() -> {
                    cutscene.pause();
                });
                game.endCallback = function()
                {
                    cutscene.time = 0.0;
                    cutscene.onVolumeChange(FlxG.sound.muted ? 0.0 : FlxG.sound.volume);
                    cutscene.alpha = 1.0;
                    cutscene.resume();
                }
            }
        }
    }
    function onStepHit(e:ConductorScriptEvent)
    {
        switch (e.step)
        {
            case 668:
                game.defaultCamZoom += 0.1;
            case 784:
                game.defaultCamZoom += 0.1;
            case 848:
                game.defaultCamZoom -= 0.2;
            case 916:
                FlxG.camera.flash();
            case 935:
                game.defaultCamZoom += 0.2;
                
                black = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
                black.scale.set(FlxG.width * 2, FlxG.height * 2);
                black.updateHitbox();
                black.screenCenter();
                black.alpha = 0;
                game.add(black);
                game.makeInvisibleNotes(true);
                FlxTween.tween(black, {alpha: 0.6}, 1);
            case 1033:
                FlxTween.tween(game.dad, {alpha: 0}, (Conductor.instance.stepCrochet / 1250) * 6);
                FlxTween.tween(black, {alpha: 0}, (Conductor.instance.stepCrochet / 1250) * 6);
                FlxTween.num(game.defaultCamZoom, game.defaultCamZoom + 0.2, (Conductor.instance.stepCrochet / 1000) * 6, {}, function(newValue:Float) {
                    game.defaultCamZoom = newValue;
                });
                game.makeInvisibleNotes(false);
            case 1040:
                FlxTween.cancelTweensOf(game.dad);
                game.dad.alpha = 1;

                game.defaultCamZoom = 0.8; 
                game.remove(black);
                FlxG.camera.flash();
            }
    }
}