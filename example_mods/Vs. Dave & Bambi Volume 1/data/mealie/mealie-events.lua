-- Converted from DB v1.0.6 HXC
import play.camera.FollowType;
import flixel.math.FlxBasePoint;
import flixel.util.FlxGradient;
import play.notes.Strumline;
import play.character.CharacterType;

class MealieEvents extends SongModule
{
    var black:FlxSprite;
    var vignette:FlxSprite;

    var dave:Character;
    var bambi:Character;

    var daveStrumline:Strumline;

    var bambiVoicelines:FlxAtlasSprite;
    var voicelineAnimationOffsets:Map<String, Array<Float>> = [
        'liar' => [-376, 32],
        'blockYou' => [-328, 5],
        'phone' => [-35, -20],
        'holyShit' => [-50, -23],
        'sigh' => [-35, -18]
    ];

    var baseStrumsDaveY:Array<Float> = [];

    public function new()
    {
        super('mealieEvents', 0, 'mealie');
    }

    function onCreate(e:ScriptEvent)
    {
        // Adds a separate signal for changing the preference to make sure this happens AFTER calling PlayState's preference signal event.
        PlayState.instance.onPreferenceChangedPost.add(preferenceChanged);
    }

    function onCreatePost(e:ScriptEvent)
    {
        black = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
        black.scale.set(FlxG.width * 2, FlxG.height * 2);
        black.updateHitbox();
        black.scrollFactor.set();
        black.screenCenter();
        black.alpha = 0;
        game.add(black);
        
        vignette = new FlxSprite().loadGraphic(Paths.image('vignette'));
        vignette.screenCenter();
        vignette.scrollFactor.set();
        vignette.cameras = [game.camHUD];
        vignette.alpha = 0.0001;
        vignette.color = FlxColor.BLACK;
        game.add(vignette);
    }

    function onCreateUI(e:ScriptEvent)
    {
        var light:BGSprite = game.currentStage.getProp('light');
        
        bambiVoicelines = new FlxAtlasSprite(game.dad.x, game.dad.y, Paths.atlas('characters/bambi/bambi_mealieVoicelines', 'shared'));
        bambiVoicelines.addByPrefix('phone', 'bambi idiot', 24, false); 
        bambiVoicelines.addByPrefix('liar', 'focking liar moldy', 24, false);
        bambiVoicelines.addByPrefix('blockYou', 'igonna block youse', 24, false);
        bambiVoicelines.addByPrefix('holyShit', 'holyShit', 24, false);
        bambiVoicelines.addByPrefix('sigh', 'sigh', 24, false);
        bambiVoicelines.onStart.add((anim:String) -> 
        {
            var animOffsets:Array<Float> = voicelineAnimationOffsets.get(anim) ?? [0, 0];

            // Update this to make sure the original offsets happen also.
            bambiVoicelines.updateHitbox();

            bambiVoicelines.offset.x += animOffsets[0];
            bambiVoicelines.offset.y += animOffsets[1];
        });
        bambiVoicelines.playAnimation('sigh', true);
        bambiVoicelines.pause();
        bambiVoicelines.alpha = 0.001;
        bambiVoicelines.zIndex = light.zIndex - 1;
        game.currentStage.add(bambiVoicelines);

        dave = Character.create(game.dad.x - 350, game.dad.y, 'dave', CharacterType.OPPONENT);
        dave.alpha = 0.0001;
        dave.zIndex = game.dad.zIndex + 1;
        game.currentStage.addCharacter(dave, CharacterType.OPPONENT, dave.getPosition());

        dave.addCharAtlas('characters/dave/dave_mealie', [
            {name: 'surprised', prefix: 'surprised0', loop: false},
            {name: 'surprised-loop', prefix: 'surprisedloop0', loop: true}
        ], 'dave-mealie');
        
        generateDaveStrumline();
    }

    function onDestroy(e:ScriptEvent)
    {
        PlayState.instance.onPreferenceChangedPost.remove(preferenceChanged);
    }

    function onStepHit(e:ConductorScriptEvent)
    {
        var curStep:Int = e.step;

        switch (curStep)
        {
            case 112:
                FlxTween.tween(game.camHUD, {alpha: 0}, 0.5);
                FlxTween.tween(black, {alpha: 0.6}, 0.5);
                game.defaultCamZoom += 0.2;

                game.dad.visible = false;
                bambiVoicelines.alpha = 1.0;
                bambiVoicelines.playAnimation('blockYou', true);
            case 128:
                game.dad.visible = true;
                bambiVoicelines.visible = false;

                FlxTween.tween(game.camHUD, {alpha: 1}, 0.5, {ease: FlxEase.expoOut});
                FlxTween.tween(black, {alpha: 0}, 0.5);
                game.defaultCamZoom -= 0.1;
                
                game.camGameZoom.timeSnap = 1;
                game.camHUDZoom.timeSnap = 1;
                game.camHUDZoom.zoomValue = 0.05;
            case 156:
                game.camGame.removeTarget();
                
                var dadCamPosX = game.dad.cameraFocusPoint.x;
                var bfCamPosX = game.boyfriend.cameraFocusPoint.x;
                
                FlxTween.tween(game, {defaultCamZoom: game.defaultCamZoom + 0.2}, 0.25, {ease: FlxEase.backOut});
                FlxTween.tween(FlxG.camera.scroll, {x: FlxG.camera.scroll.x + (bfCamPosX - dadCamPosX)}, 0.5, {ease: FlxEase.backOut});
            case 192:
                game.camGame.setTarget();
                FlxTween.tween(game, {defaultCamZoom: game.defaultCamZoom - 0.2}, 0.25, {ease: FlxEase.sineIn});
            case 320:
                game.defaultCamZoom += 0.1;
            case 380:
                game.camHUDZoom.useSteps = true;
            case 384:
                game.camHUDZoom.useSteps = false;
                game.defaultCamZoom -= 0.2;
            case 512, 576:
                game.defaultCamZoom += 0.1;
            case 608:
                FlxTween.tween(black, {alpha: 0.4}, 0.5);
                
                game.camGameZoom.timeSnap = 4;
                game.camHUDZoom.timeSnap = 4;
            case 635:
                game.boyfriend.playAnim('hey', true);
                game.dad.playAnim('hey', true);
                game.gf.playAnim('cheer', true);
                
                FlxTween.tween(game, {defaultCamZoom: 1.1}, 0.1, {ease: FlxEase.backInOut});
                
                game.camGameZoom.canZoom = false;
                game.camHUDZoom.canZoom = false;
            case 640:
                FlxTween.tween(black, {alpha: 0}, 0.5);
                game.defaultCamZoom = 0.9;
                
                game.camGameZoom.canZoom = true;
                game.camGameZoom.zoomValue = 0.03;
                game.camGameZoom.timeSnap = 1;
                
                game.camHUDZoom.timeSnap = 1;
                game.camHUDZoom.canZoom = true;
            case 690:
                game.defaultCamZoom = 1;

                game.camGame.removeTarget();
                FlxG.camera.scroll.x -= 100;
            case 704:
                game.camGame.setTarget();
            case 752:
                FlxG.camera.zoom = game.defaultCamZoom += 0.2;
                
                game.camGame.removeTarget();
                FlxG.camera.scroll.x += 100;
            case 768:
                game.camGame.setTarget();
                game.defaultCamZoom = 0.9;
            case 784, 816:
                game.camGame.removeTarget();
                game.defaultCamZoom = FlxG.camera.zoom = 1;
            case 800:
                game.defaultCamZoom = 0.85;
            case 832:
                game.camGame.setTarget();
            case 896:
                game.defaultCamZoom = 0.8;
                
                game.camGameZoom.canZoom = false;
                game.camHUDZoom.canZoom = false;
                FlxTween.tween(black, {alpha: 0.4}, 0.5);
            case 922:
                game.defaultCamZoom = FlxG.camera.zoom = 1.3;
                
                game.camGame.removeTarget();
                FlxG.camera.scroll.x - 50;

                game.dad.visible = false;
                bambiVoicelines.visible = true;
                bambiVoicelines.playAnimation('sigh', true);
            case 928:
                game.dad.visible = true;
                bambiVoicelines.visible = false;
                game.camGame.setTarget();
                
                FlxTween.tween(game, {defaultCamZoom: 0.8}, Conductor.instance.stepCrochet / 1000, {ease: FlxEase.backIn});
                FlxTween.tween(black, {alpha: 0}, 0.5);
                
                game.camGameZoom.canZoom = true;
                game.camGameZoom.zoomValue = 0.075;
                game.camGameZoom.timeSnap = 4;
                
                game.camHUDZoom.canZoom = true;
                game.camHUDZoom.timeSnap = 2;
                game.camHUDZoom.zoomValue = 0.05;
            case 960:
                game.defaultCamZoom = 0.9;
            case 1066, 1120:
                game.defaultCamZoom += 0.1;
            case 1168, 1170, 1172, 1174, 1176, 1178:
                black.alpha += 0.1;
            case 1180:
                FlxTween.tween(black, {alpha: 1}, 0.5);
            case 1186:
                FlxTween.tween(black, {alpha: 0}, 0.5);
                game.defaultCamZoom = 1.1;

                game.camGame.camFollow.x = game.dad.cameraFocusPoint.x;
                FlxG.camera.focusOn(game.camGame.camFollow.getPosition());
                game.camGame.removeTarget();
                FlxTween.tween(FlxG.camera.scroll, {x: FlxG.camera.scroll.x - 50}, 0.5, {ease: FlxEase.expoOut});
            case 1200:
                game.defaultCamZoom = 0.9;
            case 1216, 1280:
                game.defaultCamZoom = 1;

                game.camGame.setTarget();
                game.camGame.followType = FollowType.INSTANT;
                
                FlxTween.tween(vignette, {alpha: 0.5}, 0.2);
            case 1248:
                FlxTween.tween(vignette, {alpha: 0}, 0.2);
            case 1296:
                FlxTween.tween(vignette, {alpha: 0.3}, 0.2);
                game.defaultCamZoom = 0.9;
            case 1312:
                game.camGame.followType = FollowType.LERP;
                FlxTween.tween(vignette, {alpha: 0}, 0.5);
                game.defaultCamZoom = 0.8;
            case 1376:
                game.defaultCamZoom = 1;
            case 1390:
                game.dad.visible = false;
                bambiVoicelines.visible = true;
                bambiVoicelines.playAnimation('phone', true);

                game.camGame.overrideFollowPoint = new FlxBasePoint(game.dad.cameraFocusPoint.x, game.dad.cameraFocusPoint.y);
            case 1412:
                bambiVoicelines.visible = false;
                
                game.dad.canDance = false;
                game.dad.visible = true;
                game.dad.playAnim('singThrow', true);
                game.dad.animation.onFinish.addOnce((anim:String) -> {
                    if (anim == 'singThrow') {
                        game.dad.canDance = true;
                    }
                });
            case 1426:
                game.dad.visible = false;

                bambiVoicelines.playAnimation('holyShit', true);
                bambiVoicelines.visible = true;
            case 1440:
                bambiVoicelines.visible = false;
                game.dad.visible = true;

                game.iconP2.char = 'the-duo';
                
                if (game.timer != null) {
                    game.timer.pieTimer.color = FlxColor.WHITE;
                    FlxGradient.overlayGradientOnFlxSprite(game.timer.pieTimer, game.timer.pieTimer.width, game.timer.pieTimer.height, [0xFF4965FF, 0xFF00B515], 1, 0, 1, 180);
                }
                
                game.healthBar.bar.createGradientBar([0xFF4965FF, 0xFF00B515], [game.boyfriend.characterColor], 1, 180);		
                game.healthBar.bar.updateBar();

                dave.x -= 500;
                dave.alpha = 1;
                FlxTween.tween(dave, {x: dave.x + 500}, 0.5, {
                    ease: FlxEase.expoOut, 
                    onComplete: function(t:FlxTween)
                    {
                        game.camGame.overrideFollowPoint = new FlxBasePoint(dave.cameraFocusPoint.x, dave.cameraFocusPoint.y);
                        game.camGame.setFollow(game.camGame.overrideFollowPoint.x, game.camGame.overrideFollowPoint.y);
                    }
                });
                FlxTween.tween(daveStrumline, {alpha: 0.3}, 0.5, {ease: FlxEase.quadOut});
                
                game.defaultCamZoom = 0.9;
                
                game.camGameZoom.timeSnap = 1;
                game.camHUDZoom.timeSnap = 1;
                game.camHUDZoom.zoomValue = 0.05;

                game.dadStrums.cameras = [game.camGame];
                game.dadStrums.scrollType = 'upscroll';

                for (i in 0...game.dadStrums.strums.members.length)
                {
                    game.dadStrums.strums.members[i].y = game.dadStrums.y + Strumline.UPSCROLL_Y;
                }
                FlxTween.tween(game.dadStrums, {x: 100, y: 300, alpha: 0.3}, 0.5, {ease: FlxEase.quadOut});
                FlxTween.tween(game.dadStrums.scrollFactor, {x: 1, y: 1}, 0.5, {ease: FlxEase.quadOut});
            case 1568:
                game.camGame.setFollow(dave.cameraFocusPoint.x, dave.cameraFocusPoint.y);
                game.camGame.focusOn(game.camGame.camFollow.getPosition());
            case 1632:
                game.camGame.setFollow(game.boyfriend.cameraFocusPoint.x, game.boyfriend.cameraFocusPoint.y);
                game.camGame.focusOn(game.camGame.camFollow.getPosition());
            case 1688:
                game.camGameZoom.canZoom = false;
                game.camHUDZoom.canZoom = false;
            case 1692:
                game.dad.canDance = false;
                game.dad.playAnim('hey', true);
                game.dad.animation.onFinish.addOnce((anim:String) ->  {
                    game.dad.canDance = true;
                });
                
                dave.canDance = false;
                dave.playAnim('hey', true);
                dave.animation.onFinish.addOnce((anim:String) ->  {
                    dave.canDance = true;
                });
                game.camGame.zoom = game.defaultCamZoom = 0.9;

                game.camGame.overrideFollowPoint = new FlxBasePoint(dave.cameraFocusPoint.x, dave.cameraFocusPoint.y);
                game.camGame.followType = FollowType.INSTANT;
            case 1696:
                game.camGame.overrideFollowPoint = null;
                game.camGame.followType = FollowType.LERP;
                game.defaultCamZoom = 1;
                
                game.dad.canDance = true;
                
                game.camGameZoom.canZoom = true;
                game.camHUDZoom.canZoom = true;
                game.camGame.setTarget();
            case 1888:
                FlxTween.tween(vignette, {alpha: 0.7}, 0.5);
                game.defaultCamZoom = 1.1;
            case 1952:
                game.defaultCamZoom = 0.9;
                
                FlxTween.tween(vignette, {alpha: 0.4}, 0.5);
                
                game.camHUDZoom.timeSnap = 4;
                game.camGameZoom.timeSnap = 4;
            case 2016:
                game.defaultCamZoom += 0.1;
            case 2080:
                FlxTween.tween(vignette, {alpha: 0}, 0.5);
                
                game.camHUDZoom.timeSnap = 1;
                game.camGameZoom.timeSnap = 1;
            case 2208:
                game.camHUDZoom.canZoom = false;
                game.camGameZoom.canZoom = false;
                game.defaultCamZoom = 0.9;
            case 2225:
                dave.canDance = false;
                dave.playAnim('surprised', true);
                dave.animation.onFinish.addOnce((anim:String) -> {
                    dave.playAnim('surprised-loop', true);
                });
                FlxTween.tween(dave, {x: dave.x - 20}, 0.5, {ease: FlxEase.quadOut});

                game.dad.visible = false;
                bambiVoicelines.visible = true;
                bambiVoicelines.playAnimation('liar', true);

                game.camGame.overrideFollowPoint = new FlxBasePoint(game.dad.cameraFocusPoint.x, game.dad.cameraFocusPoint.y);
        }
    }

    function onBeatHit(e:ConductorScriptEvent)
    {
        switch (e.beat)
        {
            case 392, 432, 456, 472:
                game.camGame.overrideFollowPoint = new FlxBasePoint(dave.cameraFocusPoint.x, dave.cameraFocusPoint.y);
                game.camGame.setFollow(game.camGame.overrideFollowPoint.x, game.camGame.overrideFollowPoint.y);
            case 376, 408, 440, 464, 488, 536:
                game.camGame.overrideFollowPoint = null;
                game.camGame.setFollow(game.camGame.followPoint.x, game.camGame.followPoint.y);
            case 520:
                game.camGame.overrideFollowPoint = dave.cameraFocusPoint;
                game.camGame.overrideFollowPoint.x += 100;

                game.camGame.setFollow(game.camGame.overrideFollowPoint.x, game.camGame.overrideFollowPoint.y);
        }
    }

    function preferenceChanged(preference:String, value:Any)
    {
        switch (preference)
        {
            case 'downscroll':
                // Force the strumlines to upscroll.
                daveStrumline.scrollType = 'upscroll';

                // Reset the positions of the strums since they were positioned on scroll type.
                for (i in 0...daveStrumline.strums.members.length)
                {
                    daveStrumline.strums.members[i].y = baseStrumsDaveY[i];
                }
                
                if (Conductor.instance.curStep > 1440)
                {
                    game.dadStrums.scrollType = 'upscroll';

                    for (i in 0...game.dadStrums.strums.members.length)
                    {
                        game.dadStrums.strums.members[i].y = game.dadStrums.y + Strumline.UPSCROLL_Y;
                    }
                }
        }
    }

    function generateDaveStrumline()
    {
        var daveChart:SongChartData = SongRegistry.instance.loadChartDataFile('mealie', '', 'dave');
        
        daveStrumline = new Strumline({isPlayer: false, noteStyle: dave.skins.get('noteSkin'), scrollType: 'upscroll'});
        daveStrumline.setPosition(-275, 200);
        daveStrumline.cameras = [game.camGame];
        daveStrumline.scrollFactor.set(1, 1);
        daveStrumline.alpha = 0.0001;
        game.add(daveStrumline);
        daveStrumline.onNoteSpawn.add(function(note:Note) {
            note.setCharacter(dave);
            if (note.sustainNote != null)
            {
                note.sustainNote.character = dave;
            }
        });
        daveStrumline.onNoteHit.add(function(note:Note) {
            game.opponentSing(dave, note);
        });
        daveStrumline.generateNotes(daveChart.notes);

        daveStrumline.forEachStrum((strum:StrumNote) ->
        {
            baseStrumsDaveY.push(strum.y);
        });
    }
}