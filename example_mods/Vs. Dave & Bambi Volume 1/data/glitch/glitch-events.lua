-- Converted from DB v1.0.6 HXC
import flixel.addons.display.FlxBackdrop;

class GlitchEvents extends SongModule
{
    var screenShader:RuntimeShader;
    var shakeCam:Bool;
    
    var meme:FlxBackdrop;

    function new()
    {
        super('glitchEvents', 0, 'glitch');
    }

    function onCreate(e:ScriptEvent)
    {
        if (PlayStatePlaylist.isStoryMode)
        {    
            game.startCallback = () -> {
                game.beginStartDialogue('glitch');
            }
        }
        game.endCallback = function () {
            game.canPause = false;
            glitchCutscene();
        }
        screenShader = new RuntimeShader(Paths.frag('pulseEffect'));
        screenShader.setFloat('uWaveAmplitude', 0);
        screenShader.setFloat('uFrequency', 1);
        screenShader.setFloat('uSpeed', 1);
        screenShader.setFloat('uTime', 0);
        screenShader.setBool('uEnabled', true);
    }

    function onCreatePost(e:ScriptEvent)
    {
        meme = new FlxBackdrop(Paths.image('backgrounds/daveHouse/MEME'), 0x10);
        meme.setPosition(-50, 275);
        meme.scrollFactor.set(0.2, 0);
        meme.zIndex = 15;
        meme.alpha = 0.0;
        game.currentStage.add(meme);
    }

    function onUpdate(e:UpdateScriptEvent)
    {
        screenShader.setFloat('uTime', screenShader.getFloat('uTime') + e.elapsed);

        if (shakeCam && Preferences.flashingLights)
		{
			FlxG.camera.shake(0.010, 0.010);
		}
    }

    function onPressSeven(e:ScriptEvent)
    {
        PlayStatePlaylist.isStoryMode = false;
        PlayStatePlaylist.songList = [];
        
        var targetSong = SongRegistry.instance.fetchEntry('kabunga'); // lol you loser
        FreeplayState.unlockSong('kabunga');

        FlxG.switchState(() -> new PlayState({targetSong: targetSong, targetVariation: ''}));
        
        e.cancel();
    }

    function onStepHit(e:ConductorScriptEvent)
    {
        switch (e.step)
        {
            case 15:
                game.dad.playAnim('hey', true);
            case 16, 719, 1167:
                game.defaultCamZoom = 1;
            case 80, 335, 588, 1103:
                game.defaultCamZoom = 0.8;
            case 584, 1039:
                game.defaultCamZoom = 1.2;
            case 272, 975:
                game.defaultCamZoom = 1.1;
            case 464:
                game.defaultCamZoom = 1;
                FlxTween.linearMotion(game.dad, game.dad.x, game.dad.y, 25, -1800, 100, true);
            case 848:
                shakeCam = false;
                fadePulse(false);

                game.crazyZooming = false;
                game.defaultCamZoom = 1;
                FlxTween.tween(meme, {alpha: 1}, 1);
                meme.velocity.y -= 300;
            case 132, 612, 740, 771, 836:
                shakeCam = true;
                enablePulse(true);
                enablePulseAmplitude(true);
                game.crazyZooming = true;
                game.defaultCamZoom = 1.2;
            case 144, 624, 752, 784:
                shakeCam = false;
                fadePulse(false);

                game.crazyZooming = false;
                game.defaultCamZoom = 0.8;
            case 1231:
                game.defaultCamZoom = 0.8;
                
                FlxTween.cancelTweensOf(meme);
                FlxTween.cancelTweensOf(game.dad);

                FlxTween.tween(meme, {alpha: 0}, 1);
                FlxTween.linearMotion(game.dad, game.dad.x, game.dad.y, 50, 300, 1, true);
        }
    }

    override function onPreferenceChanged(e:PreferenceScriptEvent)
    {
        switch (e.preference)
        {
            case 'flashingLights':
                enablePulse(e.value);
        }
    }

    function glitchCutscene()
    {
        game.vocals.volume = 0;
        FlxG.sound.music.volume = 0;
        
        var marcello:FlxSprite = new FlxSprite(game.dad.x, game.dad.y);
        marcello.frames = Paths.getSparrowAtlas('characters/joke/cutscene');
        marcello.animation.addByPrefix('throw_phone', 'bambi0', 24, false);
        marcello.flipX = true;
        marcello.color = Stage.nightColor;
        game.add(marcello);
        marcello.antialiasing = true;
        
        game.dad.visible = false;
        
        FlxG.sound.play(Paths.sound('break_phone'), 1, false, null, true);
        game.boyfriend.playAnim('hit', true);
        new FlxTimer().start(5.5, function(e:FlxTimer)
        {
            marcello.animation.play("throw_phone");
            new FlxTimer().start(5.5, function(timer:FlxTimer)
            {
                if (PlayStatePlaylist.isStoryMode) {
                    SoundController?.music?.stop();
                    game.nextSong();
                } else {
                    SoundController?.music?.stop();
                    SoundController.playMusic(Paths.music('freakyMenu'));
                    FlxG.switchState(new FreeplayState());
                }
            });
        });
    }
    
    function enablePulse(enabled:Bool)
    {
        var isEnabled:Bool = enabled;
        if (!Preferences.flashingLights)
            isEnabled = false;
        
        game.camGame.filters = isEnabled ? [new ShaderFilter(screenShader)] : [];
    }

    function fadePulse(in:Bool) 
    {
        if (in) {
            FlxTween.num(0, 1, 2, {}, function(newValue:Float) {
                screenShader.setFloat('uWaveAmplitude', newValue);
            });
        } else {
            FlxTween.num(1, 0, 1, {
                onComplete: (t:FlxTween) -> {
                    enablePulse(false);
                }
            }, function(newValue:Float) {
                screenShader.setFloat('uWaveAmplitude', newValue);
            });
        }
    }

    function enablePulseAmplitude(enabled:Bool)
    {
        screenShader.setFloat('uWaveAmplitude', enabled ? 1 : 0);
    }
}