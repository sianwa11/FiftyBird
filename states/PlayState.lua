PlayeState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

medals = {
  ['gold'] = love.graphics.newImage('sprites/gold0.png'),
  ['silver'] = love.graphics.newImage('sprites/silver0.png'),
  ['bronze'] = love.graphics.newImage('sprites/bronze0.png')
}

function PlayeState:enter(params)
  self.bird = params.bird
  self.pipePairs = params.pipePairs
  self.timer = params.timer
  self.score = params.score
  -- initializeour last recorded Y value for a gap placement to base other gaps off of
self.lastY = params.lastY
end

function PlayeState:update(dt)
  --update timer for pipe spawning
  self.timer = self.timer + dt

  --spawn a new pipe pair every second and a half
  if self.timer > math.random(2, 80) then
    -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
    -- no higher than 10 pixels below the top edge of the screen,
    -- and no lower than a gap length (90 pixels) from the bottom
    local y = math.max(-PIPE_HEIGHT + 10,
        math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y

        --add new pipePair at end of screen at our new Y
        table.insert(self.pipePairs,PipePair(y))

        --reset timer
        self.timer = 0
  end

  --for every pair of pipes
  for k, pair in pairs(self.pipePairs) do
    --score a point if bird has gone past pipe
    --ignore it if its already been scored
    if not pair.scored then
      if pair.x + PIPE_WIDTH < self.bird.x then
        self.score = self.score + 1
        pair.scored = true
        sounds['score']:play()

      end
    end


    --update position of pair
    pair:update(dt)
  end

  --A loop to delete pipes without shifting down a table removal
  for k, pair in pairs(self.pipePairs) do
    if pair.remove then
      table.remove(self.pipePairs, k)
    end
  end

  self.bird:update(dt)

  --collision between bird and all pipes in pairs
  for k, pair in pairs(self.pipePairs) do
    for l, pipe in pairs(pair.pipes) do
      if self.bird:collides(pipe) then
        sounds['explosion']:play()
        sounds['hurt']:play()

        gStateMachine:change('score', {
            score = self.score

        })
      end
    end
  end

  --reset if we hit ground or top of screen
  if self.bird.y > VIRTUAL_HEIGHT - 15 or self.bird.y <= 0 then
    sounds['explosion']:play()
    sounds['hurt']:play()

    gStateMachine:change('score', {
        score = self.score
    })
  end

  if love.keyboard.wasPressed('p') then
    gStateMachine:change('pause',{
      score = self.score,
      bird = self.bird,
      pipePairs = self.pipePairs,
      timer = self.timer,
      lastY = self.lastY
    })
  end

end

function PlayeState:render()
    for k, pair in pairs(self.pipePairs) do
      pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score:' .. tostring(self.score, 8, 8))

  self.bird:render()
end
