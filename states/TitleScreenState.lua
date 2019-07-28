TitleScreenState = Class{__includes = BaseState}--inheritance

function TitleScreenState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('countdown')
  end
end

function TitleScreenState:render()
  love.graphics.setFont(flappyFont)
  love.graphics.printf('Fifty Bird', 0, 64, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(mediumFont)
  love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')
  love.graphics.printf('Space bar to fly', 0, 150, VIRTUAL_WIDTH, 'center')
  love.graphics.printf('P to pause', 0, 200, VIRTUAL_WIDTH, 'center')
end
