-- Converted from DB v1.0.6 HXC
import flixel.math.FlxBasePoint;

class RoofsEvents extends SongModule
{
    public function new()
    {
        super('roofsEvents', 1, 'roofs');
    }

    function onStepHit(e:ConductorScriptEvent)
    {
        switch (e.step)
        {
            case 12:
                FlxTween.tween(game, {defaultCamZoom: game.defaultCamZoom + 0.2}, (Conductor.instance.stepCrochet / 1000) * 2, {ease: FlxEase.backInOut});
            case 16:
                game.defaultCamZoom = 0.7;
            case 72:
                game.defaultCamZoom += 0.1;
            case 76:
                game.defaultCamZoom += 0.1;
            case 80:
                game.camGame.overrideFollowPoint = null;
            case 256:
                game.defaultCamZoom += 0.1;
            case 259, 262:
                game.defaultCamZoom += 0.05;
            case 266:
                FlxTween.tween(game, {defaultCamZoom: 0.7}, (Conductor.instance.stepCrochet / 1250) * 2, {ease: FlxEase.backInOut});
            case 384:
                game.defaultCamZoom = 0.9;
            case 396:
                game.camGame.overrideFollowPoint = new FlxBasePoint(game.gf.cameraFocusPoint.x, game.gf.cameraFocusPoint.y);
            case 400:
                game.defaultCamZoom = 0.6;
            case 448, 832:
                game.defaultCamZoom += 0.2;
            case 464, 848:
                game.defaultCamZoom -= 0.1;
            case 496, 880:
                game.defaultCamZoom += 0.1;
            case 512:
                FlxG.camera.zoom = game.defaultCamZoom = 1;
            case 528:
                game.dad.canSing = false;
                game.dad.canDance = false;
                game.dad.playAnim('talk', true);
                
                game.camGame.overrideFollowPoint = null;
                game.defaultCamZoom = 0.9;
            case 652:
                FlxTween.tween(game, {defaultCamZoom: 0.7}, (Conductor.instance.stepCrochet / 1250) * 4, {ease: FlxEase.elasticInOut});
            case 656:
                game.dad.canSing = true;
                game.dad.canDance = true;
                game.dad.dance(true);
            case 688:
                FlxTween.tween(game, {defaultCamZoom: 0.6}, (Conductor.instance.stepCrochet / 1250) * 2, {ease: FlxEase.elasticOut});
            case 720:
                game.defaultCamZoom = 0.9;
            case 768:
                game.camGame.lockTarget = true;
                game.defaultCamZoom = 0.8;
            case 771, 774:
                game.defaultCamZoom -= 0.05;
            case 776:
                FlxTween.tween(game.camGame.followPoint, {x: game.gf.cameraFocusPoint.x, y: game.gf.cameraFocusPoint.y}, (Conductor.instance.stepCrochet * 2) / 1250, {
                    ease: FlxEase.expoIn,
                    onComplete: (t:FlxTween) -> {
                        game.camGame.overrideFollowPoint = new FlxBasePoint(game.camGame.followPoint.x, game.camGame.followPoint.y);
                    }
                });
            case 780:
                game.defaultCamZoom = 1;
            case 784:
                game.defaultCamZoom = 0.7;
            case 918:
                game.camGame.lockTarget = false;
                game.camGame.overrideFollowPoint = null;
        }
    }
}