-- Converted from DB v1.0.6 HXC
import flixel.math.FlxBasePoint;
import play.camera.FollowType;
import play.ui.CountdownStep;
import play.stage.ScriptedStage;

class KabungaEvents extends SongModule
{
    var lazychartshader:RuntimeShader;

    var pos:FlxBasePoint = FlxBasePoint.get(298, 131);
    var exbungoLand:ScriptedStage;
    var skullBody:FlxSprite;

    function new()
    {
        super('kabungaEvents', 0, 'kabunga');
    }

    function onCreatePost(e:ScriptEvent)
    {
        exbungoLand = game.currentStage;

        skullBody = new FlxSprite().loadGraphic(Paths.image('backgrounds/exbungo/skullbody'));
        skullBody.setGraphicSize(game.boyfriend.width);
        skullBody.updateHitbox();
        skullBody.x = game.boyfriend.x + (game.boyfriend.width - skullBody.width) / 2;
        skullBody.y = game.boyfriend.y + (game.boyfriend.height - skullBody.height) / 2;
        skullBody.alpha = 0.01;
        game.add(skullBody);
    }

    function onCreateUI(e:ScriptEvent)
    {
        lazychartshader = new RuntimeShader(Paths.frag('glitchEffect'));
        lazychartshader.setFloat('uWaveAmplitude', 0.03);
        lazychartshader.setFloat('uTime', 0);
        lazychartshader.setFloat('uFrequency', 5);
        lazychartshader.setFloat('uSpeed', 1);
        lazychartshader.setFloat('uAlpha', 1);
        lazychartshader.setBool('enableAlpha', false);

        game.camHUD.filters = [new ShaderFilter(lazychartshader)];
    }

    function onUpdate(e:UpdateScriptEvent)
    {
        lazychartshader.setFloat('uTime', lazychartshader.getFloat('uTime') + e.elapsed);
    }

    function onStepHit(e:ConductorScriptEvent)
    {
        switch (e.step)
        {
            case 15:
                FlxTween.linearMotion(game.dad, game.dad.x, game.dad.y, 25, 3000, 20, true, {
                    onUpdate: (t:FlxTween) -> {
                        game.ZoomCam(true);
                    }
                });
            case 272:
                game.camGame.followType = FollowType.INSTANT;
            case 528:
                var skull = exbungoLand.scriptGet('skull');
                FlxTween.tween(skull, {alpha: 1}, 1);

                skullBody.alpha = 1;
                game.boyfriend.visible = false;
                
                game.gf.canDance = false;
                game.gf.playAnim('sad', true);
                game.gf.animation.curAnim.looped = true;
            case 1321:
                game.dad.setPosition(pos.x, pos.y);
        }
    }
    
    function onCountdownTickPost(e:CountdownScriptEvent)
    {
        var sprite:FlxSprite = Countdown.countdownSpriteMap[e.step];
        if (sprite == null)
            return;
        
        sprite.scale.set(1.5, 1.5);
        sprite.updateHitbox();
        sprite.screenCenter();

        if (e.step != CountdownStep.GO)
        {
            FlxTween.tween(sprite.scale, {x: 3, y: 3}, Conductor.instance.crochet / 800);
            FlxTween.tween(sprite, {alpha: 0}, Conductor.instance.crochet / 800);
        }
    }


    function onPressSeven(e:ScriptEvent)
    {
        PlatformUtil.openURL("https://benjaminpants.github.io/muko_firefox/index.html"); // banger game
        Sys.exit(0);

        e.cancel();
    }
}