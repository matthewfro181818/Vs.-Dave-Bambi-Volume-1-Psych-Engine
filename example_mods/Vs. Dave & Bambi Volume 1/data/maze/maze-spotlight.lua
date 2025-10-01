-- Converted from DB v1.0.6 HXC
import flixel.math.FlxBasePoint;

class MazeSpotlight extends SongModule
{
    var spotlightElapsed:Float = 0;
    var spotLight:FlxSprite = null;
    var spotLightPart:Bool;
    var spotLightScaler:Float = 1.3;
    var lastSinger:Character;

    public function new()
    {
        super('mazeSpotlight', 0, 'maze');
    }

    override function onCreate(e:ScriptEvent)
    {
        Preloader.cacheImage(Paths.imagePath('spotLight'));
    }

    function onUpdate(elapsed)
    {
        if (spotLightPart) {
            spotlightElapsed += e.elapsed;
            spotLight.angle = Math.sin(spotlightElapsed * 2) * 3;
        }
    }

    function onStepHit()
    {
        switch (e.step) 
        {
            case 912:
                if (!spotLightPart && spotLight == null)
                {
                    spotLightPart = true;
                    game.defaultCamZoom -= 0.1;
                    FlxG.camera.flash(FlxColor.WHITE, 0.5);
                    
                    spotLight = new FlxSprite().loadGraphic(Paths.image('spotLight'));
                    spotLight.blend = BlendMode.ADD;
                    spotLight.setGraphicSize(Std.int(spotLight.width * (game.dad.width / spotLight.width) * spotLightScaler));
                    spotLight.updateHitbox();
                    spotLight.origin.set(spotLight.origin.x, spotLight.origin.y - (spotLight.frameHeight / 2));
                    game.add(spotLight);
                    
                    spotLight.x = game.dad.x + (game.dad.width - spotLight.width) / 2;
                    spotLight.y = game.dad.getMidpoint().y - (spotLight.height / 2);
                    updateSpotlight(false);
                }
            case 1168:
                spotLightPart = false;
                FlxTween.tween(spotLight, {alpha: 0}, 1, {onComplete: function(tween:FlxTween) {
                    game.remove(spotLight);
                }});
        }
    }

    function onBeatHit(e:ConductorScriptEvent)
    {
        if (e.beat % 4 == 0 && spotLightPart && spotLight != null)
        {
            var currentSection = game.currentChart.notes[Conductor.instance.curMeasure];
            updateSpotlight(currentSection.mustHitSection);
        }
    }

    function updateSpotlight(bfSinging:Bool)
    {
        var curSinger = bfSinging ? game.boyfriend : game.dad;

        if (lastSinger != curSinger)
        {
            game.gf.canDance = false;
            bfSinging ? game.gf.playAnim("singRIGHT", true) : game.gf.playAnim("singLEFT", true);
            game.gf.animation.onFinish.addOnce(function(anim:String) {
                game.gf.canDance = true;
            });

            var targetPosition = FlxBasePoint.get();
            targetPosition.x = curSinger.x + (curSinger.width - spotLight.width) / 2;
            targetPosition.y = curSinger.getMidpoint().y - (spotLight.height / 2);
                
            FlxTween.tween(spotLight, {x: targetPosition.x, y: targetPosition.y}, 0.66, {ease: FlxEase.circOut});
            lastSinger = curSinger;
        }
    }
}