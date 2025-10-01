-- Converted from DB v1.0.6 HXC

class BackseatGameover extends SongModule
{
    var blackScreen:FlxSprite;
    var gameOverVideo:FlxVideo;

    public function new()
    {
        super('backseatGameover', 0, 'backseat');
    }

    function onCreateUI(e:ScriptEvent)
    {
        blackScreen = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
        blackScreen.scale.set(FlxG.width * 3, FlxG.height * 3);
        blackScreen.scrollFactor.set();
        blackScreen.camera = game.camHUD;
        blackScreen.visible = false;
        game.add(blackScreen);

        gameOverVideo = VideoManager.playVideo(Paths.video('backseatGameover'));
        gameOverVideo.alpha = 0.0;
        gameOverVideo.volume = 0.0;

        gameOverVideo.onOpening.add(() -> {
            gameOverVideo.pause();
        });
    }
    
    function onGameOver(e:ScriptEvent)
    {

        blackScreen.visible = true;
        gameOverVideo.time = 0.0;
        gameOverVideo.onVolumeChange(FlxG.sound.muted ? 0.0 : FlxG.sound.volume);
        gameOverVideo.alpha = 0.0;
        gameOverVideo.resume();

        FlxTween.tween(gameOverVideo, {alpha: 1.0}, 1);
        
        gameOverVideo.onEndReached.add(() -> {
            FlxG.resetState();
        });
        
        e.cancel();
    }
}