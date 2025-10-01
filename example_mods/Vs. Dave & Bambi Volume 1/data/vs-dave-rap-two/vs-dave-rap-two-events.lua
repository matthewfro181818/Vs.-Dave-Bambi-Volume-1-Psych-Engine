-- Converted from DB v1.0.6 HXC
class RapTwoEvents extends SongModule
{
    public function new()
    {
        super('rapTwoEvents', 0, 'vs-dave-rap-two');
    }

    function onStepHit(e:ConductorScriptEvent)
    {
        switch (e.step)
        {
            case 62, 351:
                FlxG.camera.flash();
        }
    }
}