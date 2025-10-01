-- Converted from DB v1.0.6 HXC
import ui.terminal.TerminalFunnyMessageState;
class SupernovaeEvent extends SongModule
{
    var screenShader:RuntimeShader;
    var shakeCam:Bool;

    public function new()
    {
        super('supernovaeEvents', 0, 'supernovae');
    }

    function onCreate(e:ScriptEvent)
    {
        if (PlayStatePlaylist.isStoryMode)
        {    
            game.startCallback = () -> {
                game.beginStartDialogue('supernovae');
            }
        }

        screenShader = new RuntimeShader(Paths.frag('pulseEffect'));
        screenShader.setFloat('uWaveAmplitude', 0);
        screenShader.setFloat('uFrequency', 1);
        screenShader.setFloat('uSpeed', 1);
        screenShader.setFloat('uTime', 0);
        screenShader.setBool('uEnabled', false);
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
		FlxG.switchState(new TerminalFunnyMessageState());
		e.cancel();
	}
	
    function onStepHit(e:ConductorScriptEvent)
    {
        switch (e.step)
        {
            case 60:
                game.dad.playAnim('hey', true);
            case 64:
                game.defaultCamZoom = 1;
            case 192:
                game.defaultCamZoom = 0.9;
            case 320 | 768:
                game.defaultCamZoom = 1.1;
            case 444:
                game.defaultCamZoom = 0.6;
            case 448 | 960 | 1344:
                game.defaultCamZoom = 0.8;
            case 896 | 1152:
                game.defaultCamZoom = 1.2;
            case 1024:
                game.defaultCamZoom = 1;
                shakeCam = true;
                enablePulse(true);
                enablePulseAmplitude(true);
                FlxTween.linearMotion(game.dad, game.dad.x, game.dad.y, 25, -50, 75, true);
            case 1280:
                FlxTween.cancelTweensOf(game.dad);
                FlxTween.linearMotion(game.dad, game.dad.x, game.dad.y, 50, 280, 50, true);
                
                shakeCam = false;
                fadePulse(false);
                game.defaultCamZoom = 1;
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

    function enablePulse(enabled:Bool)
    {
        var isEnabled:Bool = enabled;
        if (!Preferences.flashingLights)
            isEnabled = false;
        
        FlxG.camera.filters = isEnabled ? [new ShaderFilter(screenShader)] : [];
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