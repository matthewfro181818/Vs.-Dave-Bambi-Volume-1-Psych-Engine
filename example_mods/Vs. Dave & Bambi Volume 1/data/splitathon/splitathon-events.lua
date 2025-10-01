-- Converted from DB v1.0.6 HXC
import flixel.FlxBasic;
import flixel.math.FlxBasePoint;
import flixel.util.FlxGradient;

import play.character.CharacterType;
import play.notes.StrumNote;
import play.ui.HealthIcon;

class SplitathonEvents extends SongModule
{
    var stupidx:Float = 0;
    var stupidy:Float = 0; // stupid velocities for cutscene
    var updatevels:Bool = false;
    var backgroundChar:Character;
    var BAMBICUTSCENEICONHURHURHUR:HealthIcon;
    var curExpression:String;

    var blackScreen:FlxSprite;
    var whiteScreen:FlxSprite;
    var vignette:FlxSprite;
    var loopCount:Int = 0;
    var loopTimer:FlxTimer;

    var baseStrumY:Array<Float> = [];

    public function new()
    {
        super('splitathonEvents', 0, 'splitathon');
    }

    function onCreate(e:ScriptEvent)
    {
        Preloader.cacheCharacter('bambi-splitathon', CharacterType.OPPONENT);
    }

    function onCreatePost()
    {
        game.dad.altDanceSuffix = '-alt';
        game.dad.altSingSuffix = '-alt';
        game.dad.dance(true);
    }

    function onCountdownStart(e:CountdownScriptEvent)
    {
        var ind:Int = 0;
        game.dadStrums.forEachStrum((strum:StrumNote) ->
        {
            FlxTween.cancelTweensOf(strum);
            strum.alpha = 0;
            strum.y += 10;
            baseStrumY[ind] = strum.y;
            ind += 1;
        });
        
        game.playerStrums.forEachStrum((strum:StrumNote) ->
        {
            FlxTween.cancelTweensOf(strum);
            strum.alpha = 0;
            strum.y += 10;
            baseStrumY[ind] = strum.y;
            ind += 1;
        });
    }

    function onSongStart(e:ScriptEvent)
    {
        game.camZooming = false;
        
        blackScreen = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
        blackScreen.scale.set(FlxG.width * 2, FlxG.height * 2);
        blackScreen.updateHitbox();
        blackScreen.scrollFactor.set();
        blackScreen.screenCenter();
        blackScreen.alpha = 0.0001;
        game.add(blackScreen);
        
        whiteScreen = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);
        whiteScreen.scale.set(FlxG.width * 2, FlxG.height * 2);
        whiteScreen.updateHitbox();
        whiteScreen.scrollFactor.set();
        whiteScreen.screenCenter();
        whiteScreen.alpha = 0.0001;
        game.add(whiteScreen);
        
        vignette = new FlxSprite().loadGraphic(Paths.image('vignette'));
        vignette.screenCenter();
        vignette.scrollFactor.set();
        vignette.cameras = [game.camHUD];
        vignette.alpha = 0.0001;
        vignette.color = FlxColor.BLACK;
        game.add(vignette);
    }

    function onUpdate(e:UpdateScriptEvent)
    {
        if (updatevels)
        {
            stupidx *= 0.98;
            stupidy += e.elapsed * 6;
            if (BAMBICUTSCENEICONHURHURHUR != null) {
                BAMBICUTSCENEICONHURHURHUR.x += stupidx;
                BAMBICUTSCENEICONHURHURHUR.y += stupidy;
            }
        }
    }

    function onDestroy(e:ScriptEvent)
    {
        if (blackScreen != null)
        {
            blackScreen.destroy();
            blackScreen = null;
        }

        if (whiteScreen != null)
        {
            whiteScreen.destroy();
            whiteScreen = null;
        }

        if (backgroundChar != null)
        {
            backgroundChar.destroy();
            backgroundChar = null;
        }
        
        if (BAMBICUTSCENEICONHURHURHUR != null)
        {
            BAMBICUTSCENEICONHURHURHUR.destroy();
            BAMBICUTSCENEICONHURHURHUR = null;
        }
    }

    function onStepHit(e:ConductorScriptEvent)
    {
        var curStep:Int = e.step;
        
        if ((curStep > 2975 && curStep < 3745 && curStep % 16 == 0)
            || ((curStep > 4351 && curStep < 4607 || curStep > 4735 && curStep < 4863) && curStep % 32 == 0)) {
            splitathonFlare(0.2, 0.01, (Conductor.instance.stepCrochet / 1250) * 8);
        }

        if (curStep > 5903 && curStep < 6128 || curStep > 6287 && curStep < 6640 || curStep > 6927 && curStep < 7408)
        {
            switch ((curStep - 16) % 32)
            {
                case 0:
                    if (Preferences.cameraShaking)
                    {   
                        game.camHUD.zoom += 0.03;
                        game.camGame.zoom += 0.1;
                    }
                    splitathonDuoFlare(0.005, 0.01, (Conductor.instance.stepCrochet / 1250) * 7);
                case 8:
                    if (Preferences.cameraShaking)
                    {   
                        game.camHUD.zoom += 0.03;
                        game.camGame.zoom += 0.075;
                    }
                    splitathonDuoFlare(0.001, 0.003, (Conductor.instance.stepCrochet / 1250) * 7);
            }
        }

        if (curStep > 6127 && curStep < 6161 || curStep > 6639 && curStep < 6673 || curStep > 7407 && curStep < 7441)
        {
            switch ((curStep - 16) % 32)
            {
                case 0:
                    if (Preferences.cameraShaking)
                    {
                        game.camHUD.zoom += 0.04;
                        game.camGame.zoom += 0.1;
                    }
                    splitathonDuoFlare(0.001, 0.003, (Conductor.instance.stepCrochet / 1250) * 7);
                case 4:
                    if (Preferences.cameraShaking)
                    {
                        game.camHUD.zoom += 0.02;
                        game.camGame.zoom += 0.1; 
                    }
                case 6:
                    if (Preferences.cameraShaking)
                    {
                        game.camHUD.zoom += 0.02;
                        game.camGame.zoom += 0.1;
                    }
                    splitathonDuoFlare(0.001, 0.003, (Conductor.instance.stepCrochet / 1250) * 7);
            }
            if ((curStep - 16) % 32 > 16 && (curStep - 16) % 2 == 0)
            {
                if (Preferences.cameraShaking)
                {
                    game.camHUD.zoom += 0.04;
                    game.camGame.zoom += 0.04;
                }
            }
        }

        switch (e.step)
        {
            case 124:
                var iterator:Int = 0;
                for (strumLine in [game.playerStrums, game.dadStrums])
                {
                    for (i in 0...strumLine.strums.length)
                    {
                        var spr = strumLine.strums.members[i];
                        
                        spr.y -= (Preferences.downscroll ? -300 : 300);
                        spr.alpha = 0;

                        FlxTween.tween(spr, {y: baseStrumY[i], alpha: 1}, 2, {ease: FlxEase.backOut, startDelay: i * 0.05});
                        FlxTween.angle(spr, -30 + (i * 10), 0, 2, {startDelay: iterator * 0.05});
                    }
                }
            case 128:
                game.camZooming = true;
            case 384:
                game.camGame.overrideFollowPoint = new FlxBasePoint(game.dad.cameraFocusPoint.x, game.dad.cameraFocusPoint.y);
                game.defaultCamZoom = 1.1;
                
                FlxG.camera.flash();
                blackScreen.alpha = 1;
                for (i in [game.healthBar, game.iconP1, game.iconP2, game.timer, game.accuracyDisplay, game.scoreDisplay, game.missesDisplay]) {
                    if (i != null) {
                        FlxTween.tween(i, {alpha: 0}, 0.5);
                    }
                }
                game.dadStrums.forEachStrum(function(spr:StrumNote) {
                    FlxTween.tween(spr, {alpha: 0}, 0.5);
                });
                game.dad.altDanceSuffix = '';
                game.dad.altSingSuffix = '';
            case 400:
                for (i in [game.healthBar, game.iconP1, game.iconP2, game.timer, game.accuracyDisplay, game.scoreDisplay, game.missesDisplay]) {
                    if (i != null) {
                        FlxTween.tween(i, {alpha: 1}, 0.5);
                    }
                }
                game.dadStrums.forEachStrum(function(spr:StrumNote) {
                    FlxTween.tween(spr, {alpha: 1}, 0.5);
                });
            case 408, 5640, 7720:
                loopCountTimer(4, (Conductor.instance.stepCrochet / 1100) * 2, function() {
                    blackScreen.alpha -= 0.22;
                });
            case 416, 7728:
                game.camHUD.flash();
                blackScreen.alpha = 0;
                game.crazyZooming = true;
                game.camGameZoom.zoomValue = 0.02;
                game.camHUDZoom.zoomValue = 0.04;
                
                if (curStep == 416) {
                    game.defaultCamZoom = 0.8;
                    game.camGame.overrideFollowPoint = null;
                }
                if (curStep == 7728) {
                    backgroundChar.altDanceSuffix = '-corn';
                    curExpression = '-corn';
                    backgroundChar.dance(true);

                    game.camGame.overrideFollowPoint = null;
                    game.defaultCamZoom = 0.8;
                }
            case 672, 7984:
                game.crazyZooming = false;
                game.camHUDZoom.zoomValue = 0.03;
                game.camGameZoom.zoomValue = 0.015;
                if (curStep == 7984) {
                    game.defaultCamZoom += 0.1;
                }
            case 928:
                game.defaultCamZoom += 0.2;
                FlxTween.tween(blackScreen, {alpha: 0.7}, 0.5, {ease: FlxEase.sineInOut});
                game.camHUDZoom.timeSnap = 8;
                game.camGameZoom.timeSnap = 8;
            case 1056:
                game.defaultCamZoom -= 0.1;
                FlxTween.tween(blackScreen, {alpha: 0.3}, 0.5, {ease: FlxEase.sineInOut});
                game.camHUDZoom.timeSnap = 2;
                game.camGameZoom.timeSnap = 2;
                game.camGameZoom.zoomValue = 0.04;
            case 1184:
                game.defaultCamZoom -= 0.1;
                game.camHUDZoom.timeSnap = 4;
                game.camGameZoom.timeSnap = 4;
                FlxTween.tween(blackScreen, {alpha: 0}, 0.5, {ease: FlxEase.circOut});
            case 1952:
                game.defaultCamZoom += 0.1;
                game.camHUDZoom.timeSnap = 8;
                game.camGameZoom.timeSnap = 8;
                game.camGameZoom.zoomValue = 0.015;
                FlxTween.tween(blackScreen, {alpha: 0.4}, 0.5, {ease: FlxEase.sineInOut});
            case 2208:
                game.defaultCamZoom -= 0.1;
                FlxTween.tween(blackScreen, {alpha: 0}, 0.5, {ease: FlxEase.sineInOut});
            case 2384:
                FlxTween.tween(whiteScreen, {alpha: 1}, (Conductor.instance.stepCrochet / 1000) * 80, {ease: FlxEase.quadIn});
            case 2464:
                FlxG.camera.flash();
                FlxTween.cancelTweensOf(whiteScreen);
                whiteScreen.alpha = 0;
                game.camHUDZoom.timeSnap = 8;
                game.camGameZoom.timeSnap = 8;
                game.defaultCamZoom += 0.25;
                
                blackScreen.alpha = 1;
                FlxTween.tween(blackScreen, {alpha: 0.25}, (Conductor.instance.stepCrochet / 1000) * 128, {ease: FlxEase.sineOut});
                FlxTween.tween(game, {defaultCamZoom: game.defaultCamZoom - 0.15}, (Conductor.instance.stepCrochet / 1000) * 128, {ease: FlxEase.sineInOut});
            case 2592:
                game.camHUDZoom.timeSnap = 2;
                game.camGameZoom.timeSnap = 2;
                game.camGameZoom.zoomValue = 0.05;
            case 2720:
                FlxTween.tween(blackScreen, {alpha: 0}, 0.25, {ease: FlxEase.sineOut});
                game.camHUDZoom.timeSnap = 4;
                game.camGameZoom.timeSnap = 4;
            case 2976:
                game.dad.altDanceSuffix = '-alt';
                game.dad.altSingSuffix = '-alt';
                game.defaultCamZoom -= 0.1;
                FlxTween.tween(blackScreen, {alpha: 0.3}, 0.5, {ease: FlxEase.sineInOut});
            case 3072:
                FlxTween.tween(whiteScreen, {alpha: 1}, (Conductor.instance.stepCrochet / 1000) * 20, {
                    ease: FlxEase.quadIn,
                    onComplete: function(tween:FlxTween) {
                        FlxTween.tween(whiteScreen, {alpha: 0.6}, (Conductor.instance.stepCrochet / 1000) * 12);
                    }
                });
            case 3104:
                game.defaultCamZoom -= 0.1;
                game.camHUD.flash(FlxColor.WHITE, 0.5);
                FlxTween.cancelTweensOf(whiteScreen);
                whiteScreen.alpha = 0;
                FlxTween.tween(blackScreen, {alpha: 0}, 1, {ease: FlxEase.sineInOut});
            case 3232:
                game.dad.altDanceSuffix = '';
                game.dad.altSingSuffix = '';

                game.camGame.overrideFollowPoint = new FlxBasePoint(game.dad.cameraFocusPoint.x, game.dad.cameraFocusPoint.y);
                game.camGame.overrideFollowPoint.x -= 100;
                game.camGame.overrideFollowPoint.y -= 50;
                
                game.defaultCamZoom = 1.15;
                for (i in [game.healthBar, game.iconP1, game.iconP2, game.accuracyDisplay, game.scoreDisplay, game.missesDisplay]) {
                    if (i != null) {
                        FlxTween.tween(i, {alpha: 0.4}, 0.5);
                    }
                }
                game.playerStrums.forEachStrum(function(spr:StrumNote) {
                    FlxTween.tween(spr, {alpha: 0.4}, 0.5);
                });
            case 3488:
                game.camGame.overrideFollowPoint = new FlxBasePoint(game.boyfriend.cameraFocusPoint.x, game.boyfriend.cameraFocusPoint.y);
                game.camGame.overrideFollowPoint.x += 100;

                game.dadStrums.forEachStrum(function(spr:StrumNote) {
                    FlxTween.tween(spr, {alpha: 0.4}, 0.5);
                });
                game.playerStrums.forEachStrum(function(spr:StrumNote) {
                    FlxTween.tween(spr, {alpha: 1}, 0.5);
                });
            case 3744:
                game.camGame.overrideFollowPoint = null;
                game.camZooming = false;
                game.camHUDZoom.timeSnap = 4;
                game.camGameZoom.timeSnap = 4;
                game.camGameZoom.zoomValue = 0.015;
                game.defaultCamZoom -= 0.15;
                for (i in [game.healthBar, game.iconP1, game.iconP2, game.accuracyDisplay, game.scoreDisplay, game.missesDisplay]) {
                    if (i != null) {
                        FlxTween.tween(i, {alpha: 1}, 0.5);
                    }
                }
                game.dadStrums.forEachStrum(function(spr:StrumNote) {
                    FlxTween.tween(spr, {alpha: 1}, 0.5);
                });
            case 3760:
                FlxTween.tween(game.camHUD, {alpha: 0}, 2, {ease: FlxEase.quadOut});
            case 4000:
                game.defaultCamZoom = 0.9;
            case 4032:
                game.forceFocusOnChar = true;
                game.focusOnDadGlobal = true;
            case 4095:
                throwThatBitchInThere('bambi-new', 'dave-splitathon');
            case 4096:
                game.camHUD.alpha = 1;
                FlxG.camera.flash();
                game.camZooming = true;
                
                var davePosition = game.dad.getPosition();
                addSplitathonChar('bambi-splitathon', FlxBasePoint.get(100, 450));
                splitathonExpression('dave', FlxBasePoint.get(davePosition.x, davePosition.y), false);

                backgroundChar.canDance = false;
                backgroundChar.playAnim('interrupted', true);
                FlxTween.tween(backgroundChar, {x: backgroundChar.x - 250, y: backgroundChar.y - 50}, 1, {
                    ease: FlxEase.quadOut,
                    onComplete: function(tween:FlxTween) {
                        new FlxTimer().start(0.5, function(timer:FlxTimer) {
                            backgroundChar.playAnim('toDisappointed', true);
                            
                            backgroundChar.animation.onFinish.addOnce((anim:String) -> {
                                backgroundChar.canDance = true;
                                backgroundChar.altDanceSuffix = '-dissapointed';
                                backgroundChar.dance(true);
                            });
                        });
                    }
                });

                game.forceFocusOnChar = false;
                game.focusOnDadGlobal = false;
            case 4156:
                FlxG.camera.zoom = 1.3;
                game.defaultCamZoom = 1.3;
            case 4160:
                game.defaultCamZoom = 1;
            case 4216:
                FlxG.camera.zoom = 0.8;
                game.defaultCamZoom = 0.8;
            case 4224:
                game.defaultCamZoom = 0.9;
            case 4284:
                FlxG.camera.zoom = 1.3;
                game.defaultCamZoom = 1.3;
            case 4288:
                game.defaultCamZoom = 0.8;
            case 4304:
                FlxTween.tween(whiteScreen, {alpha: 1}, (Conductor.instance.stepCrochet / 1000) * 48, {ease: FlxEase.quadIn});
            case 4320:
                loopCountTimer(8, (Conductor.instance.stepCrochet / 1000) * 4, function() {
                    FlxG.camera.zoom += 0.1;
                    game.defaultCamZoom += 0.1;
                    vignette.alpha += 0.125;
                });
            case 4352:
                FlxG.camera.flash();
                FlxTween.cancelTweensOf(whiteScreen);
                whiteScreen.alpha = 0;
                vignette.alpha = 0;
                game.defaultCamZoom = 0.8;

                game.camHUDZoom.timeSnap = 8;
                game.camGameZoom.timeSnap = 8;
                game.camGameZoom.zoomValue = 0.04;
            case 4608:
                game.defaultCamZoom = 0.8;
                game.camGameZoom.zoomValue = 0.015;
            case 4736:
                game.camGameZoom.zoomValue = 0.04;
            case 5584:
                FlxTween.tween(whiteScreen, {alpha: 1}, (Conductor.instance.stepCrochet / 1000) * 48, {ease: FlxEase.quadIn});
            case 4864:
                game.defaultCamZoom = 1;
                game.camGameZoom.zoomValue = 0.015;
                
                backgroundChar.canDance = false;
                backgroundChar.playAnim('toAmused', true);
                backgroundChar.animation.onFinish.addOnce((anim:String) -> {
                    backgroundChar.canDance = true;
                    backgroundChar.altDanceSuffix = '-amused';
                    backgroundChar.dance(true);
                });
            case 4992:
                game.camZooming = false;
            case 5120:
                game.camHUDZoom.timeSnap = 4;
                game.camGameZoom.timeSnap = 4;
                game.camZooming = true;
                game.defaultCamZoom = 0.8;
            case 5376:
                game.camZooming = false;
                FlxTween.tween(blackScreen, {alpha: 0.3}, 0.5);
                game.dadStrums.forEachStrum(function(spr:StrumNote) {
                    FlxTween.tween(spr, {alpha: 0}, 0.5);
                });
                game.defaultCamZoom = 1.1;
            case 5632:
                FlxTween.cancelTweensOf(whiteScreen);
                FlxTween.tween(whiteScreen, {alpha: 0}, (Conductor.instance.stepCrochet / 1000) * 4);
                blackScreen.alpha = 1;
            case 5648:
                game.defaultCamZoom = 1;
                game.camHUD.flash();
                blackScreen.alpha = 0;
                for (strumLine in [game.playerStrums, game.dadStrums]) {
                    strumLine.forEachStrum(function(spr:StrumNote) {
                        spr.alpha = 0;
                    });
                }
            case 5656, 5664, 5672, 5688, 5704, 5720, 5728, 5736, 5752, 5768:
                FlxTween.cancelTweensOf(game.camHUD);
                game.camHUD.alpha = 0.3;
                FlxTween.tween(game.camHUD, {alpha: 1}, 1, {ease: FlxEase.expoOut});
            case 5676, 5680, 5696, 5702, 5708, 5712, 5740, 5744, 5760, 5766, 5772:
                FlxTween.cancelTweensOf(blackScreen);
                blackScreen.alpha = 0.3;
                FlxTween.tween(blackScreen, {alpha: 0}, 0.5, {ease: FlxEase.expoOut});
            case 5776:
                game.defaultCamZoom = 0.9;
                
                for (strumLine in [game.playerStrums, game.dadStrums]) {
                    strumLine.forEachStrum(function(spr:StrumNote) {
                        FlxTween.tween(spr, {alpha: 1}, 0.5);
                    });
                }
                game.camZooming = true;
                
                backgroundChar.canDance = false;
                backgroundChar.playAnim('toHappy', true);
                backgroundChar.animation.onFinish.addOnce((anim:String) -> {
                    backgroundChar.canDance = true;
                    backgroundChar.altDanceSuffix = '-happy';
                    backgroundChar.dance(true);
                });
            case 5904:
                game.defaultCamZoom = 0.8;
            case 6032:
                game.defaultCamZoom = 1;
            case 6128:
                game.defaultCamZoom = 1.1;
            case 6160, 6672:
                game.defaultCamZoom = 0.9;
                game.camGame.flash(FlxColor.WHITE, 2);
                blackScreen.alpha = 1;
                FlxTween.tween(blackScreen, {alpha: 0}, (Conductor.instance.stepCrochet / 1000) * 64, {ease: FlxEase.sineIn});
            case 6224, 6736:
                FlxTween.tween(whiteScreen, {alpha: 1}, (Conductor.instance.stepCrochet / 1000) * 64, {ease: FlxEase.quadIn});
                expressionAdded = false;
            case 6288, 6800:
                blackScreen.cameras = [game.camGame];
                game.camHUD.flash();
                FlxTween.cancelTweensOf(whiteScreen);
                whiteScreen.alpha = 0;

                switch (curStep) {
                    case 6288:
                        game.defaultCamZoom = 0.8;
                        
                        var bambiPosition = game.dad.getPosition();
                        
                        addSplitathonChar('dave-splitathon', FlxBasePoint.get(120, 450));
                        splitathonExpression('bambi', FlxBasePoint.get(bambiPosition.x - 225, bambiPosition.y + 25), true);
                        expressionAdded = true;
                        
                        backgroundChar.altDanceSuffix = '-confused';
                        backgroundChar.dance(true);
                    case 6800:
                        game.dad.altDanceSuffix = '-alt';
                        game.dad.altSingSuffix = '-alt';
                        game.defaultCamZoom = 0.7;
                        vignette.alpha = 1;
                }
            case 6544:
                game.defaultCamZoom = 1;
            case 6832, 6864, 6896:
                FlxTween.tween(vignette, {alpha: vignette.alpha - 0.25}, 0.5, {ease: FlxEase.sineOut});
                game.defaultCamZoom += 0.1;
            case 6928:
                game.dad.altDanceSuffix = '';
                game.dad.altSingSuffix = '';
                
                game.camHUD.flash();
                FlxTween.cancelTweensOf(whiteScreen);
                whiteScreen.alpha = 0;
                vignette.alpha = 0;
                game.defaultCamZoom = 0.8;
                
                game.iconP2.char = 'the-duo';
                
                if (game.timer != null) {
                    game.timer.pieTimer.color = FlxColor.WHITE;
                    FlxGradient.overlayGradientOnFlxSprite(game.timer.pieTimer, game.timer.pieTimer.width, game.timer.pieTimer.height, [0xFF4965FF, 0xFF00B515], 1, 0, 1, 180);
                }
                
                game.healthBar.bar.createGradientBar([0xFF4965FF, 0xFF00B515], [game.boyfriend.characterColor], 1, 180);		
                game.healthBar.bar.updateBar();
            case 6960:
                backgroundChar.playAnim('confusedToIdle', true);
                backgroundChar.canDance = false;
                backgroundChar.animation.onFinish.addOnce((anim:String) -> 
                {
                    backgroundChar.canDance = true;
                    backgroundChar.altDanceSuffix = '';
                    backgroundChar.dance(true);
                });
            case 6992:
                game.defaultCamZoom = 1;
                switchSplitathonSinger();
            case 7056:
                game.defaultCamZoom = 0.9;
                switchSplitathonSinger();
            case 7248:
                switchSplitathonSinger();
            case 7328:
                switchSplitathonSinger();
            case 7376:
                game.defaultCamZoom = 1.1;
            case 7440:
                game.camZooming = false;
                FlxG.camera.flash(FlxColor.WHITE, 2);
                FlxTween.cancelTweensOf(whiteScreen);
                whiteScreen.alpha = 0;
                blackScreen.alpha = 1;
                FlxTween.tween(blackScreen, {alpha: 0}, (Conductor.instance.stepCrochet / 1000) * 128, {ease: FlxEase.sineOut});
            case 7456:
                FlxTween.tween(game.camHUD, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
            case 7696:
                FlxG.camera.flash();
                blackScreen.alpha = 1;
                game.defaultCamZoom = 0.6;
                game.camZooming = true;
                game.camGame.overrideFollowPoint = new FlxBasePoint(game.gf.cameraFocusPoint.x, game.gf.cameraFocusPoint.y);

                game.iconP2.char = game.dad.id;
                
                if (game.timer != null) {
                    FlxGradient.overlayGradientOnFlxSprite(game.timer.pieTimer, game.timer.pieTimer.width, game.timer.pieTimer.height, [FlxColor.WHITE], 1, 0, 1, 180);
                    game.timer.updatePieColor(game.dad.characterColor);
                }
                game.healthBar.updateColors(game.dad, game.boyfriend);
            case 7714:
                FlxTween.tween(game.camHUD, {alpha: 1}, 0.5);
            case 8116:
                game.dad.altDanceSuffix = '-alt';
                game.dad.altSingSuffix = '-alt';
            case 8240:
                game.defaultCamZoom = 0.7;
                game.camZooming = false;
                game.camGame.overrideFollowPoint = new FlxBasePoint(game.gf.cameraFocusPoint.x, game.gf.cameraFocusPoint.y);

            case 8256:
                
                FlxTween.tween(game.camHUD, {alpha: 0}, 2, {ease: FlxEase.quadOut});
            case 8304:
                game.camGame.overrideFollowPoint = null;
                
                for (i in 0...game.dadStrums.strums.members.length)
                {
                    var spr = game.dadStrums.strums.members[i];
                    FlxTween.tween(spr, {x: spr.x - 600}, 1.5, {ease: FlxEase.expoIn});
                    FlxTween.angle(spr, 0, i * -10, 1.5, {startDelay: (i * 0.05)});
                }
                for (i in 0...game.playerStrums.strums.members.length)
                {
                    var spr = game.playerStrums.strums.members[i];
                    FlxTween.tween(spr, {x: spr.x + 600}, 1.5, {ease: FlxEase.expoIn});
                    FlxTween.angle(spr, 0, i * -10, 1.5, {startDelay: (i * 0.05)});
                }
            case 8368:
                game.defaultCamZoom = 0.9;
                game.camZooming = true;
                for (i in 0...game.dadStrums.strums.members.length) {
                    var spr = game.dadStrums.strums.members[i];
                    spr.alpha = 0;
                    FlxTween.tween(spr, {x: spr.x + 600, alpha: 1}, 1, {ease: FlxEase.expoOut, startDelay: (i * 0.1)});
                    FlxTween.angle(spr, spr.angle, 0, 0.5, {startDelay: (i * 0.05)});
                }
                for (i in 0...game.playerStrums.strums.members.length)
                {
                    var spr = game.playerStrums.strums.members[i];
                    spr.alpha = 0;
                    FlxTween.tween(spr, {x: spr.x - 600, alpha: 1}, 1, {ease: FlxEase.expoOut, startDelay: (i * 0.1)});
                    FlxTween.angle(spr, spr.angle, 0, 0.5, {startDelay: (i * 0.05)});
                }
                FlxTween.tween(game.camHUD, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
            case 8624:
                game.defaultCamZoom = 0.8;
                game.camZooming = false;
        }
    }

    function loopCountTimer(loopTimes:Int, resetTime:Float, func:Void->Void)
    {
        loopCount = 0;
        loopTimer = new FlxTimer().start(0, function(timer:FlxTimer)
        {
            if (loopCount <= loopTimes)
            {
                func();
                loopCount += 1;
                timer.reset(resetTime);
            } else {
                loopTimer.cancel();
                loopTimer = null;
            }
        });
    }

    function throwThatBitchInThere(guyWhoComesIn:String = 'bambi-new', guyWhoFliesOut:String = 'dave')
    {
        if(BAMBICUTSCENEICONHURHURHUR != null)
        {
            game.remove(BAMBICUTSCENEICONHURHURHUR);
        }
        BAMBICUTSCENEICONHURHURHUR = new HealthIcon(guyWhoComesIn, false);
        BAMBICUTSCENEICONHURHURHUR.state = game.iconP2.state;
        BAMBICUTSCENEICONHURHURHUR.y = game.healthBar.y - (BAMBICUTSCENEICONHURHURHUR.height / 2);
        game.add(BAMBICUTSCENEICONHURHURHUR);
        BAMBICUTSCENEICONHURHURHUR.cameras = [game.camHUD];
        BAMBICUTSCENEICONHURHURHUR.x = -100;
        FlxTween.linearMotion(BAMBICUTSCENEICONHURHURHUR, -100, BAMBICUTSCENEICONHURHURHUR.y, game.iconP2.x, BAMBICUTSCENEICONHURHURHUR.y, 0.3, true, {ease: FlxEase.expoInOut});
        new FlxTimer().start((Conductor.instance.stepCrochet / 1000), function(timer:FlxTimer)
        {
            game.iconP2.char = guyWhoComesIn;

            this.BAMBICUTSCENEICONHURHURHUR.char = guyWhoFliesOut;
            this.BAMBICUTSCENEICONHURHURHUR.state = game.iconP2.state;
            this.stupidx = -5;
            this.stupidy = -5;
            this.updatevels = true; 
        });
    }

    function addSplitathonChar(char:String, position:FlxBasePoint):Void
    {
        game.switchDad(char, position, false);

        game.dad.reposition();
    }

    function splitathonExpression(character:String, ?position:FlxBasePoint, front:Bool):Void
    {
        if (backgroundChar != null) {
            game.currentStage.remove(backgroundChar);
            backgroundChar = null;
        }
        backgroundChar = Character.create(position.x, position.y, character == 'dave' ? 'dave-splitathon' : 'bambi-splitathon', CharacterType.OTHER);
        if (front) {
            backgroundChar.zIndex = game.dad.zIndex + 1;
        } else {
            backgroundChar.zIndex = game.dad.zIndex - 1;
        }
        game.currentStage.addCharacter(backgroundChar, CharacterType.OTHER, position, false);
    }

    function splitathonFlare(fadeIn:Float, delayCount:Float, fadeOutTime:Float)
    {
        if (!Preferences.flashingLights)
            return;
            
        var toTween:Array<FlxSprite> = [game.dad, game.gf, game.boyfriend, backgroundChar];
        for (i in MapTools.values(game.currentStage.namedProps)) {
            if (i.spriteName != 'bg') {
                toTween.push(i);
            }
        }
        for (i in 0...toTween.length) {
            var spr = toTween[i];
            if (spr == null) continue;

            FlxTween.color(spr, fadeIn, Stage.nightColor, FlxColor.WHITE, {
                startDelay: i * delayCount,
                onComplete: function(tween:FlxTween) {
                    FlxTween.color(spr, fadeOutTime, FlxColor.WHITE, Stage.nightColor, {ease: FlxEase.sineOut});
                }});
        }
    }
    function splitathonDuoFlare(fadeIn:Float, delayCount:Float, fadeOutTime:Float)
    {
        if (!Preferences.flashingLights) return;
        
        var toTween:Array<FlxSprite> = [game.dad, game.gf, game.boyfriend, backgroundChar];
        for (i in MapTools.values(game.currentStage.namedProps)) {
            if (i.spriteName != 'bg') {
                toTween.push(i);
            }
        }
        for (i in 0...toTween.length) {
            var spr = toTween[i];
            if (spr == null) continue;
            
            var targetColor = FlxColor.interpolate(Stage.nightColor, FlxColor.WHITE, 0.5);
                    
            FlxTween.color(spr, fadeIn, Stage.nightColor, targetColor, {
                    startDelay: ([game.dad, game.gf, game.boyfriend, backgroundChar].contains(spr)) ? 0 : i * delayCount,
                    onComplete: function(tween:FlxTween) {
                        FlxTween.color(spr, fadeOutTime, targetColor, Stage.nightColor, {ease: FlxEase.sineOut});
                    }
            });
        }
    }
    function switchSplitathonSinger()
    {
        var dadVar = game.dad;
        var charExpression = backgroundChar;
        
        game.dad = charExpression;
        backgroundChar = dadVar;
        
        game.dad.holdTimer = 0;
        backgroundChar.holdTimer = 0;
    }
}