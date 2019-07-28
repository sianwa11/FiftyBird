 --Library for virtual resolution
push = require 'push'

--OOP Library
Class = require 'class'

--require Bird Class
require 'Bird'

--require Pipe Class
require 'Pipe'

--class representing pair of pipes together
require 'PipePair'




--code related to game states and state machines
require 'StateMachine'
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'
require 'states/PauseState'

--physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

--background image and scroll location
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

--ground image and starting scroll location
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0



--speed at which we will scroll our images
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

--where we should loop our background back to x=0
local BACKGROUND_LOOPING_POINT = 413

--where we should loop our background back to x=0
local BACKGROUND_LOOPING_POINT = 514

--scrolling varible to pause the game when collision is detected
 scrolling = true

--[[load function]]
function love.load()
  --nearest neighbour filter
  love.graphics.setDefaultFilter('nearest','nearest')

  math.randomseed(os.time())

  game_paused = false

  --title
  love.window.setTitle('Fifty Bird')

  --initializing retro fonts
  smallFont = love.graphics.newFont('font.ttf', 8)
  mediumFont = love.graphics.newFont('flappy.ttf', 14)
  flappyFont = love.graphics.newFont('flappy.ttf', 28)
  hugeFont = love.graphics.newFont('flappy.ttf', 56)
  pauseFont = love.graphics.newFont('flappy.ttf', 15)
  love.graphics.setFont(flappyFont)

  --table of sounds
  sounds = {
    ['jump'] = love.audio.newSource('jump.wav', 'static'),
    ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
    ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
    ['score'] = love.audio.newSource('score.wav', 'static'),
    ['levelup'] = love.audio.newSource('Levelup.wav', 'static'),
    ['music'] = love.audio.newSource('marios_way.mp3', 'static')
  }

  sounds['music']:setLooping(true)
  sounds['music']:play()

  --initialize virtual resolution
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = false,
    resizable = true
  })

  --initializing statemachine with all state-returning functions
  gStateMachine = StateMachine {
    ['title'] = function() return TitleScreenState() end,
    ['countdown'] = function() return CountdownState() end,
    ['play'] = function() return PlayeState() end,
    ['score'] = function() return ScoreState() end,
    ['pause'] = function() return PauseState() end
  }
  gStateMachine:change('title')

 --input table
  love.keyboard.keysPressed = {}
  love.mouse.buttonsPressed = {}
end

--[[allows window to be resized]]
function love.resize(w, h)
  push:resize(w, h)
end


function love.keypressed(key)
  -- add to our table of keys pressed this frame
  love.keyboard.keysPressed[key] = true

  if key == 'escape' then
    love.event.quit()
  end

end

function love.mousepressed(x, y, button, isTouch)
 love.mouse.buttonsPressed[button] = true
end

--[[
    Function used to check the global input table for keys
]]
function love.keyboard.wasPressed(key)
  if love.keyboard.keysPressed[key] then
    return true
  else
    return false
  end
end

function love.mouse.wasPressed(button)
  return love.mouse.buttonsPressed[button]
end

function love.update(dt)
  if scrolling then
  --update background and ground scrolling
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
      % BACKGROUND_LOOPING_POINT

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
      % VIRTUAL_WIDTH
  end

    --update state machine which defers to right state
    gStateMachine:update(dt)

    --reset input table
      love.keyboard.keysPressed = {}
      love.keyboard.buttonsPressed = {}
  end


function love.draw()
  push:start()

  --draw background at top left
  love.graphics.draw(background, -backgroundScroll, 0)
  gStateMachine:render()
  --draw ground on top of background and at bottom
  love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)


  push:finish()
end
