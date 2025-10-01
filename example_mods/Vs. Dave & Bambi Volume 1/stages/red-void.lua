local shadname = "glitchEffect";

function onCreate()
    makeLuaSprite('bg', 'backgrounds/void/redsky', -1500, -700) 
    initLuaShader(shadname)
    setSpriteShader('bg', shadname)
    setShaderFloat('bg', 'uWaveAmplitude', 0.1)
    setShaderFloat('bg', 'uFrequency', 5)
    setShaderFloat('bg', 'uSpeed', 2)	
    scaleObject('bg', 1.5, 1.5)
    addLuaSprite('bg', false)
end

function onUpdatePost(elapsed)
	setShaderFloat('bg', 'uTime', os.clock())
end