PauseState = Class{__includes = BaseState}--inheritance

function PauseState:enter(params)
  self.params = params
  sounds['music']:pause()
end

function PauseState:update(dt)
  if love.keyboard.wasPressed('p') then
    gStateMachine:change('play', self.params)
  end
end

function PauseState:render()
  love.graphics.setFont(pauseFont)
  love.graphics.printf('Paused', 0, 100, VIRTUAL_WIDTH, 'center')
end

function PauseState:exit()
  sounds['music']:play()
end
