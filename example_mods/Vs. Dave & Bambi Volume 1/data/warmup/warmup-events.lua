-- Converted from DB v1.0.6 HXC
class WarmupEvents extends SongModule
{
    public function new()
    {
        super('warmupEvents', 0, 'warmup');
    }

    function onCameraMove(e:CameraScriptEvent) 
    {
        if (e.isOpponent) {
            FlxTween.tween(game, {defaultCamZoom: 1}, (Conductor.instance.crochet / 700 * game.gf.danceSnap), {ease: FlxEase.backInOut});
        } else {
            FlxTween.tween(game, {defaultCamZoom: 0.9}, (Conductor.instance.crochet / 700 * game.gf.danceSnap), {ease: FlxEase.backInOut});
        }
    }
}