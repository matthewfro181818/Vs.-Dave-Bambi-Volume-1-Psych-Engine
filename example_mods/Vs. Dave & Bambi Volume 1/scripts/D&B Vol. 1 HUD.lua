--[[
    VS. Dave & Bambi Volume 1 HUD
    Script by: NextGen
    Please credit me when using this script or a modified version of it in your mod!
]]--

function createLuaText(tag, width, posX, posY) -- A simplified version of making a luaText
    makeLuaText(tag, '', width, posX, posY)
    setTextAlignment(tag, 'left')
    setTextSize(tag, 21)
    setTextFont(tag, 'comic-sans.ttf')
    setProperty(tag..'.antialiasing', true)
    scaleObject(tag, 0.95, 1)
    addLuaText(tag)
end

function createAsset(tag, imgPath, posX, posY) -- A simplified version of making a luaSprite
    makeLuaSprite(tag, imgPath, posX, posY)
    scaleObject(tag, 0.5, 0.5, false)
    setObjectCamera(tag, 'camHUD')
    addLuaSprite(tag)
end

function formatTime(millisecond) -- Formats time in its proper format
    local seconds = math.floor(millisecond / 1000)
    return string.format('%01d:%02d', (seconds / 60) % 60, seconds % 60)
end

function rgbToHex(array) -- Self-explainatory
    return string.format('%.2x%.2x%.2x', array[1], array[2], array[3])
end

--------------------------------

function onCountdownStarted()
    if downscroll then
        setProperty('healthBar.y', 50.2)
        setProperty('iconP1.y', -24.8)
        setProperty('iconP2.y', -24.8)
        for n = 0, 3 do
            setPropertyFromGroup('opponentStrums', n, 'y', 555)
            setPropertyFromGroup('playerStrums', n, 'y', 555)
        end
    end
    for i = 0, getProperty('unspawnNotes.length') - 1 do
		if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
		end
	end

    loadGraphic('healthBar.bg', 'ui/healthBar')
    setProperty('healthBar.bg.scale.x', 1.01) -- To cover the sides

    setProperty('showCombo', true)
    setObjectCamera('comboGroup', 'camGame')
    setProperty('comboGroup.x', getProperty('gfGroup.x') - 170)
    setProperty('comboGroup.y', getProperty('gfGroup.y') + 150)

    makeLuaSprite('clockCover', nil, nil, downscroll and 588 or 40)
    makeGraphic('clockCover', 90, 80, '808080')
    addLuaSprite('clockCover')
    setObjectCamera('clockCover', 'camHUD')
    screenCenter('clockCover', 'x')

    createInstance('timeGauge', 'flixel.addons.display.FlxPieDial', {0, downscroll and getProperty('timeBar.y') - 95 or 35.25, 45, FlxColor('#'..rgbToHex(getProperty("dad.healthColorArray"))..''), 360, 40, false, 0})
    callMethod('timeGauge.replaceColor', {FlxColor('BLACK'), FlxColor('TRANSPARENT')})
    setObjectCamera('timeGauge', 'camHUD')
    addLuaSprite('timeGauge')
    screenCenter('timeGauge', 'x')
    setProperty('timeGauge.amount', 0)

    createAsset('alarmClock', 'ui/timer', nil, getProperty('clockCover.y') - 30)
    scaleObject('alarmClock', 1, 1)
    screenCenter('alarmClock', 'x')

    createAsset('accuracyIcon', 'ui/accuracy', 456, getProperty('healthBar.y') + 6)
    createLuaText('accuracyText', 1280, 481, getProperty('healthBar.y') + 26)

    createAsset('missesIcon', 'ui/misses', 596, getProperty('healthBar.y') + 8)
    createLuaText('missesText', 1280, 651, getProperty('healthBar.y') + 24)

    createAsset('scoreIcon', 'ui/score', 744, getProperty('healthBar.y') + 5)
    createLuaText('scoreText', 1280, 808, getProperty('healthBar.y') + 27)

    for _, uE in ipairs({'accuracyIcon', 'accuracyText', 'missesIcon', 'missesText', 'scoreIcon', 'scoreText'}) do
        setObjectOrder(uE, getObjectOrder('healthBar', 'uiGroup'))
        setObjectOrder('noteGroup', getObjectOrder(uE) - 1)
    end

    setTextFont('timeTxt', 'comic-sans.ttf')
    setTextSize('timeTxt', 23)
    setTextBorder('timeTxt', 2.5, '000000')
    screenCenter('timeTxt', 'x')
    setProperty('timeTxt.y', getProperty('clockCover.y') + 95)

    setTextFont('botplayTxt', 'comic-sans.ttf')
    setTextSize('botplayTxt', 29)
    setTextBorder('botplayTxt', 2.25, '000000')
    setProperty('botplayTxt.y', downscroll and getProperty('healthBar.y') + 55 or getProperty('healthBar.y') - 55)

    setProperty('timeBar.visible', false)
    setProperty('scoreTxt.visible', false)
end

function onUpdatePost(elapsed)
    setTextString('timeTxt', ''..formatTime(math.max(0, getSongPosition() - noteOffset))..' / '..formatTime(songLength)..'')
    setProperty('timeGauge.amount', math.max(0, getSongPosition() - noteOffset) / songLength)
    setProperty('timeGauge.visible', getProperty('timeGauge.amount') > 0.005) -- Not the most practical solution, but it works

    setTextString('accuracyText', ratingName == '?' and '100%' or callMethodFromClass('backend.CoolUtil', 'floorDecimal', {100 * rating, 2})..'%')
    setTextString('missesText', callMethodFromClass('flixel.util.FlxStringUtil', 'formatMoney', {misses, false}))
    setTextString('scoreText', callMethodFromClass('flixel.util.FlxStringUtil', 'formatMoney', {score, false}))

    for _, t in ipairs({'clockCover', 'alarmClock'}) do
        setProperty(t..'.alpha', getProperty('timeTxt.alpha'))
    end
    for p = 1, 2 do
        setProperty('iconP'..p..'.origin.y', 0)
        setProperty('iconP'..p..'.scale.y', (getProperty('iconP'..p..'.scale.x') - 1) / -2.5 + 1)
    end
end

function onBeatHit()
    setProperty('iconP1.scale.x', math.max(1.05, 1 + getHealth() / 4))
    setProperty('iconP2.scale.x', math.max(1.05, 1 + (2 - getHealth()) / 4))
    doTweenX('bounceP1', 'iconP1.scale', 1, crochet / 1500, 'quintOut')
    doTweenX('bounceP2', 'iconP2.scale', 1, crochet / 1500, 'quintOut')
end

function opponentNoteHit(_, _, _, sustain)
	if sustain then
		setProperty('dad.holdTimer', 0)
	end
end 

function goodNoteHit(_, _, _, sustain)
	if sustain then
		setProperty('boyfriend.holdTimer', 0)
	end
end 