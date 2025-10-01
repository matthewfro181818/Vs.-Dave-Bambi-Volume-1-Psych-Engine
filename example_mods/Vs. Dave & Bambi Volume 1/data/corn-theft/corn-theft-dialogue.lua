-- Converted from DB v1.0.6 dialogue.hxc
function onStartCountdown()
    if not allowCountdown and isStoryMode then
        startDialogue("corn-theft")
        allowCountdown = true
        return Function_Stop
    end
    return Function_Continue
end

function onNextDialogue(line)
    -- optional hook
end

function onSkipDialogue(line)
    -- optional hook
end
