-- Converted from DB v1.0.6 HXC
class MasterEvents extends SongModule
{
    var screenShader:RuntimeShader;
    var shakeCam:Bool;

    function new()
    {
        super('masterEvents', 0, 'master');
    }

    function onCreate(e:ScriptEvent)
    {
        if (PlayStatePlaylist.isStoryMode)
        {    
            game.startCallback = () -> {
                game.beginStartDialogue('master');
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
        health = 0;
        e.cancel();
    }

    function onStepHit(e:ConductorScriptEvent)
    {
        switch (e.step)
        {
            case 128:
                game.defaultCamZoom = 0.7;
            case 252, 512:
                game.defaultCamZoom = 0.4;
                shakeCam = false;
                enablePulse(false);
                enablePulseAmplitude(false);
            case 256:
                game.defaultCamZoom = 0.8;
            case 380:
                game.defaultCamZoom = 0.5;
            case 384:
                game.defaultCamZoom = 1;
                shakeCam = true;
                enablePulse(true);
                fadePulse(true);
            case 508:
                game.defaultCamZoom = 1.2;
            case 560:
                game.dad.canDance = false;
                game.dad.playAnim('die', true);
                SoundController.play(Paths.sound('dead'), 1);
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