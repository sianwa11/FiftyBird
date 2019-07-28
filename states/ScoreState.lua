ScoreState = Class{__includes = BaseState}

function ScoreState:enter(params)
  self.score = params.score
end

function ScoreState:update(dt)
  --go back to play if enter was pressed
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('countdown')
  end
end

function ScoreState:render()
  --render score in middle of screen
  love.graphics.setFont(flappyFont)
  love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(mediumFont)
  love.graphics.printf('Score:' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

  if self.score >= 5 then
    love.graphics.draw(medals['silver'],200, 100)
  end
  if self.score >= 10 then
    love.graphics.draw(medals['bronze'],200,100)
  end
  if self.score >= 15 then
    love.graphics.draw(medals['gold'],200,100)
  end


  love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end
