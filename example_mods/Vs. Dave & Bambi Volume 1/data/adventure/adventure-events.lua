-- Converted from DB v1.0.6 HXC
import play.stage.ScriptedStage;
import flixel.FlxObject;
import flixel.math.FlxBasePoint;
import flixel.math.FlxRect;
import openfl.filters.BlurFilter;
import play.camera.FollowType;
import flixel.FlxCameraFollowStyle;

using util.tools.MapTools;

class AdventureEvents extends SongModule
{
    var tristanRoomStage:ScriptedStage;
    var busStopStage:ScriptedStage;
    var schoolStage:ScriptedStage;
    var parkStage:ScriptedStage;

    var curStage:ScriptedStage;

    var blackBehind:FlxSprite;
    var vignette:FlxSprite;
    var slideTransition:FlxSprite;

    var tristanCam:FlxCamera;
    var tristanCamFollow:FlxObject = new FlxObject(0, 0, 1, 1);

    var playerCam:FlxCamera;
    var playerCamFollow:FlxObject = new FlxObject(0, 0, 1, 1);

    var blur:BlurFilter = new BlurFilter(0, 0, 5);
    var mosaic:RuntimeShader = new RuntimeShader(Paths.frag('mosaic'));

    var bfGhost1:Character;
    var bfGhost2:Character;

    var splitScreenSection:Bool = false;

    public function new()
    {
        super('adventureEvents', 0, 'adventure');
    }

    function onCreatePost(e:ScriptEvent)
    {
        game.dad.addCharAtlas('characters/tristan/tristan_adventure_notice', [
            {name: 'notice', prefix: 'notice'},
        ], 'tristan-adventure');
        
        tristanRoomStage = game.currentStage;

        busStopStage = game.loadStage('bus-stop');
        busStopStage.alpha = 0.001;
        busStopStage.active = false;
        game.add(busStopStage);
        
        schoolStage = game.loadStage('school');
        schoolStage.alpha = 0.001;
        schoolStage.active = false;
        game.add(schoolStage);
        
        parkStage = game.loadStage('park');
        parkStage.alpha = 0.001;
        parkStage.active = false;
        game.add(parkStage);

        curStage = tristanRoomStage;
        
        blackBehind = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
        blackBehind.scale.set(FlxG.width * 3, FlxG.height * 3);
        blackBehind.updateHitbox();
        blackBehind.screenCenter();
        blackBehind.alpha = 0.01;
        blackBehind.zIndex = game.dad.zIndex - 1;
        game.currentStage.add(blackBehind);

        vignette = new FlxSprite().loadGraphic(Paths.image('vignette'));
        vignette.color = FlxColor.BLACK;
        vignette.camera = game.camHUD;
        vignette.alpha = 0.00001;
        game.add(vignette);

        bfGhost1 = Character.create(game.boyfriend.x, game.boyfriend.y, game.boyfriend.id, game.boyfriend.characterType);
        bfGhost1.alpha = 0.0;
        bfGhost1.blend = 12;
        game.add(bfGhost1);

        bfGhost2 = Character.create(game.boyfriend.x, game.boyfriend.y, game.boyfriend.id, game.boyfriend.characterType);
        bfGhost2.alpha = 0.0;
        bfGhost2.blend = 12;
        game.add(bfGhost2);
        
        slideTransition = new FlxSprite().makeGraphic(FlxG.width / 10, FlxG.height / 10, FlxColor.BLACK);
        slideTransition.scale.set(10, 10);
        slideTransition.updateHitbox();
        slideTransition.screenCenter();
        slideTransition.alpha = 0.001;
        slideTransition.camera = game.camOther;
        game.add(slideTransition);
    }

    function onCreateUI(e:ScriptEvent)
    {
        tristanCam = new FlxCamera();
        tristanCam.follow(tristanCamFollow, FlxCameraFollowStyle.LOCKON, 1);
        tristanCam.height = Std.int(FlxG.height / 2);
        tristanCam.zoom = 0.75;
        tristanCam.visible = false;
        tristanCam.x = -FlxG.stage.window.width;
        FlxG.cameras.insert(tristanCam, FlxG.cameras.list.indexOf(game.camHUD));
        tristanCamFollow.setPosition(game.dad.cameraFocusPoint.x - 300, game.dad.cameraFocusPoint.y + 50);

        playerCam = new FlxCamera();
        playerCam.follow(playerCamFollow, FlxCameraFollowStyle.LOCKON, 1);
        playerCam.height = Std.int(FlxG.height / 2);
        playerCam.y = FlxG.height / 2;
        playerCam.visible = false;
        playerCam.x = FlxG.stage.window.width;
        playerCam.zoom = 0.8;
        FlxG.cameras.insert(playerCam, FlxG.cameras.list.indexOf(game.camHUD));
        playerCamFollow.setPosition(game.boyfriend.cameraFocusPoint.x + 250, game.boyfriend.cameraFocusPoint.y + 250);

        FlxG.signals.gameResized.add(this.onGameResized);
    }

    function onGameResized(width:Int, height:Int):Void
    {
        // Make sure to only apply game resizing when we're not doing the split screen section.
        if (splitScreenSection)
            return;
        
        if (width > FlxG.width)
        {
            tristanCam.x = -width;
            playerCam.x = width;
        }
    }

    function onDestroy(e:ScriptEvent)
    {
        // TODO: Is there a good way to fix this within Polymod?
        FlxG.signals.gameResized.handlers.shift();
        // FlxG.signals.gameResized.remove(this.onGameResized);

        game.removeStage(busStopStage);
        game.removeStage(schoolStage);
        game.removeStage(parkStage);

        blackBehind = null;

        if (vignette != null)
        {
            vignette.destroy();
            vignette = null;
        }
        
        if (slideTransition != null)
        {
            slideTransition.destroy();
            slideTransition = null;
        }

        if (tristanCam != null)
        {
            tristanCam.destroy();
            tristanCam = null;
        }
        
        if (playerCam != null)
        {
            playerCam.destroy();
            playerCam = null;
        }
        
        blur = null;
        mosaic = null;
    }

    function onStepHit(e:ConductorScriptEvent)
    {
        switch (e.step)
        {
            case 224:
                game.defaultCamZoom -= 0.1;
            case 392:
                game.defaultCamZoom += 0.2;
            case 440:
                game.camGame.lockTarget = true;
                game.camGame.followPoint = new FlxBasePoint(game.boyfriend.cameraFocusPoint.x + 100, game.boyfriend.cameraFocusPoint.y + 50);
                
                FlxTween.tween(game, {defaultCamZoom: 3}, (Conductor.instance.stepCrochet / 1100) * 8, {ease: FlxEase.sineOut});
                FlxTween.tween(blackBehind, {alpha: 0.5}, (Conductor.instance.stepCrochet / 1100) * 8, {ease: FlxEase.sineOut});
            case 448:
                FlxTween.cancelTweensOf(game.defaultCamZoom);
                FlxTween.cancelTweensOf(blackBehind);

                FlxTween.tween(game, {defaultCamZoom: 0.85}, (Conductor.instance.stepCrochet / 1100) * 8, {ease: FlxEase.backOut});
                FlxTween.tween(blackBehind, {alpha: 0.0}, (Conductor.instance.stepCrochet / 1100) * 8, {
                    ease: FlxEase.sineOut,
                    onComplete: (t:FlxTimer) -> {
                        game.camGame.followType = FollowType.LERP;
                        game.camGame.lockTarget = false;
                    }
                });

                // Switch BG.
                switchBG('bus-stop');

                game.camGame.followType = FollowType.INSTANT;
                game.camGame.followPoint.set(game.boyfriend.cameraFocusPoint.x + 100, game.boyfriend.cameraFocusPoint.y + 50);
            case 454, 460:
                game.defaultCamZoom -= 0.05;
            case 560:
                game.camGame.followType = FollowType.INSTANT;
                FlxG.camera.zoom = game.defaultCamZoom = 1;
            case 578:
                game.camGame.followType = FollowType.LERP;
            case 672, 700, 728, 756:
                if (e.step == 672)
                {
                    game.defaultCamZoom = 0.7;
                    this.busStopStage.scriptCall('playMarvinAnimation', ['turn-transition']);
                }
                
                FlxTween.tween(bfGhost1, {x: bfGhost1.x - 5, alpha: 0.4}, 1, {
                    ease: FlxEase.quadIn,
                    onComplete: (t:FlxTween) -> {
                        FlxTween.tween(bfGhost1, {x: bfGhost1.x + 5, alpha: 0}, 1, {
                            startDelay: (Conductor.instance.measureLength / 1000) - 2.0,
                            ease: FlxEase.quadOut
                        });
                    }
                });

                FlxTween.tween(bfGhost2, {x: bfGhost2.x + 5, alpha: 0.4}, 1, {
                    ease: FlxEase.quadIn,
                    onComplete: (t:FlxTween) -> {
                        FlxTween.tween(bfGhost2, {x: bfGhost2.x - 5, alpha: 0}, 1, {
                            startDelay: (Conductor.instance.measureLength / 1000) - 2.0,
                            ease: FlxEase.quadOut
                        });
                    }
                });
            case 784:
                FlxTween.tween(bfGhost1, {x: bfGhost1.x - 10, alpha: 0.3}, 1, {ease: FlxEase.quadIn});
                FlxTween.tween(bfGhost2, {x: bfGhost2.x + 10, alpha: 0.3}, 1, {ease: FlxEase.quadIn});

                bfGhost1.animation.timeScale = 0.6;
                bfGhost2.animation.timeScale = 0.2;

                game.defaultCamZoom = 0.9;
            case 892:
                slideTransition.clipRect = FlxRect.get(0, 0, 0, FlxG.height);
                slideTransition.alpha = 1;
                FlxTween.tween(slideTransition.clipRect, {width: slideTransition.frameWidth}, (Conductor.instance.crochet / 1100), {ease: FlxEase.sineOut});
            case 896:
                // Make sure the tweens are reset are good to do before switching.
                FlxTween.cancelTweensOf(blackBehind);
                FlxTween.cancelTweensOf(game);
                FlxTween.cancelTweensOf(vignette);

                switchBG('school');
                
                var bullyBoy = schoolStage.scriptGet('bullyBoy');
                bullyBoy.visible = false;
                
                FlxTween.tween(slideTransition.clipRect, {x: slideTransition.frameWidth}, (Conductor.instance.crochet / 1100), {
                    ease: FlxEase.sineIn,
                    onComplete: (t:FlxTween) -> 
                    {
                        game.remove(bfGhost1);
                        bfGhost1.destroy();
                        bfGhost1 = null;
                        
                        game.remove(bfGhost2);
                        bfGhost2.destroy();
                        bfGhost2 = null;
                        
                        slideTransition.visible = false;
                    }
                });
                
                FlxTween.tween(game, {defaultCamZoom: 1.1}, (Conductor.instance.stepCrochet / 1100) * 224);
                FlxTween.tween(blackBehind, {alpha: 1.0}, (Conductor.instance.stepCrochet / 1000) * 224);
                FlxTween.tween(vignette, {alpha: 1.0}, (Conductor.instance.stepCrochet / 1100) * 224);

                for (prop in schoolStage.members)
                {
                    if (Std.isOfType(prop, BGSprite))
                    {
                        if (['kevin', 'ezekiel'].contains(prop.spriteName))
                        {
                            FlxTween.tween(prop, {alpha: 0.0}, (Conductor.instance.stepCrochet / 1000) * 224);
                        }
                    }
                }
            case 1120:
                for (i in schoolStage.members)
                {
                    if (Std.isOfType(i, BGSprite))
                    {
                        if (['kevin', 'ezekiel'].contains(i.spriteName))
                        {
                            FlxTween.cancelTweensOf(i);
                            FlxTween.tween(i, {alpha: 1}, 0.5);
                        }
                    }
                }

                FlxTween.cancelTweensOf(blackBehind);
                FlxTween.cancelTweensOf(game.defaultCamZoom);
                FlxTween.cancelTweensOf(vignette);

                FlxTween.tween(blackBehind, {alpha: 0.0}, 0.5);
                FlxTween.tween(vignette, {alpha: 0.0}, 0.5);

                FlxTween.tween(game, {defaultCamZoom: 0.8}, 0.5, {ease: FlxEase.elasticOut});
            case 1232:
                FlxTween.tween(game, {defaultCamZoom: 0.6}, (Conductor.instance.measureLength / 1100), {ease: FlxEase.sineIn});
            case 1344:
                FlxTween.tween(game, {defaultCamZoom: 1.0}, 0.5, {ease: FlxEase.backOut});
            case 1400:
                splitScreenSection = true;

                tristanCam.visible = true;
                FlxTween.tween(tristanCam, {x: 0}, 0.5, {
                    onComplete: (t:FlxTween) -> 
                    {
                        game.camMoveOnNoteAllowed = false;
                        game.camGame.overrideFollowPoint = new FlxBasePoint(tristanCam.target.x, tristanCam.target.y);
                        game.camGame.setFollow(game.camGame.overrideFollowPoint.x, game.camGame.overrideFollowPoint.y);
                        game.defaultCamZoom = tristanCam.zoom;
                    }
                });
                
                playerCam.visible = true;
                FlxTween.tween(playerCam, {x: 0}, 0.5);
            case 1444:
                schoolStage.scriptCall('playBullyboySlide');

                game.camGame.visible = false;
                FlxTween.tween(tristanCam, {height: FlxG.stage.window.height}, (Conductor.instance.stepCrochet / 1000) * 12, {
                    onComplete: (t:FlxTween) -> {
                        game.camGame.visible = true;
                        tristanCam.visible = false;
                        playerCam.visible = false;
                    }
                });

                FlxTween.tween(playerCam, {height: 0}, (Conductor.instance.stepCrochet / 1000) * 12, {
                    onUpdate: (t:FlxTween) -> {
                        playerCam.y = FlxG.height - playerCam.height;
                    }
                });
            case 1468:
                FlxTween.tween(game.camHUD, {alpha: 0}, 0.5);
                game.camGame.overrideFollowPoint = new FlxBasePoint(game.dad.cameraFocusPoint.x + 400, game.dad.cameraFocusPoint.y - 100);
            case 1480:
                game.camGameZoom.canWorldZoom = false;
                game.camHUDZoom.canWorldZoom = false;
                FlxTween.num(game.camGame.scaleX, 0, (Conductor.instance.stepCrochet / 1250) * 4, null, (v:Float) -> 
                {
                    game.camGame.setScale(v, game.camGame.scaleY);
                });
            case 1484:
                game.camHUD.alpha = 1;
                switchBG('park');
                
                parkStage.scriptCall('initalizeMovingChars');

                FlxTween.num(0, 0.8, (Conductor.instance.stepCrochet / 1250) * 4,
                {
                    onComplete: (t:FlxTween) -> {
                        game.dad.canDance = true;
                        game.dad.dance(true);

                        game.camGame.overrideFollowPoint = null;
                        game.camGameZoom.canWorldZoom = true;
                        game.camHUDZoom.canWorldZoom = true;

                        FlxG.camera.zoom = game.defaultCamZoom = 0.8;
                        game.camMoveOnNoteAllowed = true;
                    }
                }, (v:Float) -> 
                {
                    game.camGame.setScale(v, game.camGame.scaleY);
                });
            case 1596:
                game.defaultCamZoom -= 0.1;
            case 1708:
                FlxG.camera.zoom = game.defaultCamZoom = 0.9;
                game.camGame.followType = FollowType.INSTANT;
            case 1928:
                slideTransition.clipRect = FlxRect.get(0, 0, slideTransition.frameWidth, 0);
                slideTransition.alpha = 1;
                slideTransition.visible = true;
                
                FlxTween.tween(slideTransition.clipRect, {height: slideTransition.frameHeight}, (Conductor.instance.crochet / 1100), {ease: FlxEase.quadOut});
            case 1932:
                switchBG('room');

                game.camGame.filters = [blur];
                FlxTween.tween(blur, {blurX: 30}, (Conductor.instance.stepCrochet / 1000) * 84); 
            case 1936:
                var easedStep = TweenUtil.easeSteps(5, FlxEase.quadOut);

                FlxTween.tween(slideTransition, {alpha: 0}, (Conductor.instance.crochet / 1100), {ease: easedStep});
            case 2048:
                mosaic.setFloatArray('blockSize', [1, 1]);

                game.camGame.filters = [blur, new ShaderFilter(mosaic)];

                FlxTween.num(1, 200.0, (Conductor.instance.stepCrochet / 1250) * 36, null, (v:Float) -> {
                    mosaic.setFloatArray('blockSize', [v, v]);
                });
            case 2060:
                FlxTween.tween(game.camGame, {alpha: 0}, 2);
                FlxTween.tween(game.camHUD, {alpha: 0}, 2);
        }
    }

    function onOpponentNoteHit(e:NoteScriptEvent)
    {
        if (Conductor.instance.curMeasure == 52 && e.note.direction == 1)
        {
            game.dad.canDance = false;
            game.dad.playAnim('notice', true);
            e.cancel();
        }
    }

    function onPlayerNoteHit(e:NoteScriptEvent)
    {
        switch (e.note.type)
        {
            case "bfGhostNote1":
                e.character = bfGhost1;
            case "bfGhostNote2":
                e.character = bfGhost2;
            default:
                super.onPlayerNoteHit(e);
        }

        if (Conductor.instance.curStep > 783 && Conductor.instance.curStep < 896)
        {
            bfGhost1.sing(e.note.direction);
            bfGhost2.sing(e.note.direction);
        }
    }

    function onGhostNoteMiss(e:GhostNoteScriptEvent)
    {
        if (Conductor.instance.curStep > 783 && Conductor.instance.curStep < 896)
        {
            bfGhost1.sing(e.direction, true);
            bfGhost2.sing(e.direction, true);
        }
    }

    function onNoteMiss(e:NoteScriptEvent)
    {
        if (Conductor.instance.curStep > 672 && Conductor.instance.curStep < 896)
        {
            switch (e.note.type)
            {
                case "bfGhostNote1":
                    e.character = bfGhost1;
                case "bfGhostNote2":
                    e.character = bfGhost2;
                default:
                    super.onNoteMiss(e);
            }
        }
        
        if (Conductor.instance.curStep > 783 && Conductor.instance.curStep < 896)
        {
            bfGhost1.sing(e.note.direction, true);
            bfGhost2.sing(e.note.direction, true);
        }
    }
    
    function switchBG(type:String)
    {
        var stage:ScriptedStage = null;
        stage = switch (type) {
            case 'room': tristanRoomStage;
            case 'bus-stop': busStopStage;
            case 'school': schoolStage;
            case 'park': parkStage;
            default:
        }
        for (i in curStage)
        {
            i.alpha = 0;
        }

        for (i in stage)
        {
            i.alpha = 1;
        }
        game.currentStage = stage;
        
        curStage.moveSpriteToStage(blackBehind, stage, blackBehind.getPosition());
        curStage.moveCharactersToStage(stage);
        curStage.active = false;
        
        for (id in stage.characters.keys())
        {
            var char:Character = stage.getCharacter(id);
            char.alpha = 1;
        }

        bfGhost1.setPosition(game.boyfriend.x, game.boyfriend.y);
        bfGhost2.setPosition(game.boyfriend.x, game.boyfriend.y);

        curStage = stage;
        stage.active = true;

        switch (type)
        {
            case 'bus-stop':
                game.ratings.x -= 50;
                game.ratings.y -= 100;
            case 'school':
                game.ratings.y += 200;
            case 'park':
                game.ratings.y -= 200;
        }
    }
}