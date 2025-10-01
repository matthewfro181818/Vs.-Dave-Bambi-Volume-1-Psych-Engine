-- Converted from DB v1.0.6 HXC
import play.character.CharacterType;

class PolygonizedEvents extends SongModule
{
    var pre3dSkin:String;
    var screenShader:RuntimeShader = new RuntimeShader(Paths.frag('pulseEffect'));
    var targetPulseVal:Float = 1;
    var shapeNoteWarning:FlxSprite;
    var shakeCam:Bool;
    
    public function new()
    {
        super('polygonizedEvents', 0, 'polygonized');
    }

    override function onCreate(e:ScriptEvent)
    {
        if (PlayStatePlaylist.isStoryMode)
        {
            game.startCallback = () -> {
                game.beginStartDialogue('polygonized', game.startCountdown);
            }
        }

        game.shapeNoteSongs.push(game.currentSong.id);
        
        screenShader.setFloat('uWaveAmplitude', 0);
        screenShader.setFloat('uFrequency', 1);
        screenShader.setFloat('uSpeed', 1);
        screenShader.setFloat('uTime', 0);
        screenShader.setBool('uEnabled', false);
    }

    override function onCreateUI(e:ScriptEvent)
    {
        if (game.boyfriend.skins.exists('3d')) {
            Preloader.cacheCharacter(game.boyfriend.skins.get('3d'), CharacterType.PLAYER);
        }
        if (game.gf.skins.exists('3d')) {
            Preloader.cacheCharacter(game.gf.skins.get('3d'), CharacterType.GF);
        }
    }

    function onUpdate(elapsed)
    {
        screenShader.setFloat('uTime', screenShader.getFloat('uTime') + e.elapsed);

        if (shakeCam && Preferences.flashingLights)
		{
			FlxG.camera.shake(0.010, 0.010);
		}
    }

    override function onCountdownFinish(e:CountdownScriptEvent)
    {
        if (!Preferences.gimmickWarnings) return;
        
        shapeNoteWarning = new FlxSprite(0, FlxG.height * 2).loadGraphic(Paths.image('ui/warnings/shapeNoteWarning'));
        shapeNoteWarning.cameras = [game.camHUD];
        shapeNoteWarning.scrollFactor.set();
        shapeNoteWarning.antialiasing = false;
        shapeNoteWarning.alpha = 0;
        game.add(shapeNoteWarning);
        
        FlxTween.tween(shapeNoteWarning, {alpha: 1}, 1);
        FlxTween.tween(shapeNoteWarning, {y: 450}, 1, {ease: FlxEase.backOut, 
            onComplete: function(tween:FlxTween)
            {
                new FlxTimer().start(2, function(timer:FlxTimer)
                {
                    FlxTween.tween(shapeNoteWarning, {alpha: 0}, 1);
                    FlxTween.tween(shapeNoteWarning, {y: FlxG.height * 2}, 1, {
                        ease: FlxEase.backIn,
                        onComplete: function(tween:FlxTween)
                        {
                            game.remove(shapeNoteWarning);
                        }
                    });
                });
            }
        });
    }
    
    function onStepHit()
    {
        switch (e.step)
        {
            case 128, 640, 704, 1535:
                game.defaultCamZoom = 0.9;
            case 256, 768, 1468, 1596, 2048, 2144, 2428:
                game.defaultCamZoom = 0.7;
            case 688, 752, 1279, 1663, 2176:
                game.defaultCamZoom = 1;
            case 1019, 1471, 1599, 2064:
                game.defaultCamZoom = 0.8;
            case 1920:
                game.defaultCamZoom = 1.1;
            case 1024, 1312:
                game.defaultCamZoom = 1.1;
                game.crazyZooming = true;

                shakeCam = true;

                enablePulse(true);
                fadePulse(true);
                
                pre3dSkin = game.boyfriend.id;
                for (char in [game.boyfriend, game.gf])
                {
                    if (char.skins.exists('3d')) {
                        if (char == game.boyfriend) {
                            game.switchBF(char.skins.get('3d'), char.getPosition());
                        } else if (char == game.gf) {
                            game.switchGF(char.skins.get('3d'), char.getPosition());
                        }
                    }
                }
            case 1152, 1408:
                game.defaultCamZoom = 0.9;
                shakeCam = false;
                fadePulse(false);
                game.crazyZooming = false;
                if (game.boyfriend.id != pre3dSkin)
                {
                    game.switchBF(pre3dSkin, game.boyfriend.getPosition());
                    game.switchGF(game.boyfriend.skins.get('gfSkin'), game.gf.getPosition());
                }
        }
    }

    override function onPreferenceChanged(e:PreferenceScriptEvent)
    {
        switch (e.preference)
        {
            case 'gimmickWarnings':
                if (shapeNoteWarning != null) {
                    shapeNoteWarning.visible = e.value;
                }
            case 'flashingLights':
                enablePulse(e.value);
        }
    }

    function fadePulse(in:Bool) 
    {
        if (in) {
            FlxTween.num(0, targetPulseVal, 2, {}, function(newValue:Float) {
                screenShader.setFloat('uWaveAmplitude', newValue);
            });
        } else {
            FlxTween.num(targetPulseVal, 0, 1, {}, function(newValue:Float) {
                screenShader.setFloat('uWaveAmplitude', newValue);
            });
        }
    }

    function enablePulse(enabled:Bool)
    {
        var isEnabled:Bool = enabled;
        if (!Preferences.flashingLights)
            isEnabled = false;
        
        FlxG.camera.filters = isEnabled ? [new ShaderFilter(screenShader)] : [];
    }
}