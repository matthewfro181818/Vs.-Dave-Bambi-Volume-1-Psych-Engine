-- Converted from DB v1.0.6 HXC
class RapEvents extends SongModule
{
    public function new()
    {
        super('rapEvents', 0, 'vs-dave-rap');
    }

    function onPressSeven(e:ScriptEvent)
    {
        FreeplayState.unlockSong('vs-dave-rap-two');

        var targetSong:Song = SongRegistry.instance.fetchEntry('vs-dave-rap-two');
        var currentVariation = game.currentVariation;

        FreeplayState.unlockSong('vs-dave-rap-two');

        FlxG.switchState(() -> new PlayState({targetSong: targetSong, targetVariation: currentVariation}));
        e.cancel();
    }

    function onStepHit(e:ConductorScriptEvent)
    {
        switch (e.step)
        {
            case 64, 322:
                FlxG.camera.flash();
        }
    }
}