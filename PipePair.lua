PipePair = Class{}

--gap between pipes
local GAP_HEIGHT = math.random(45,100)

function PipePair:init(y)
  --initializes pipes past end of the screen
  self.x = VIRTUAL_WIDTH + 32

  -- y value is for the topmost pipe; gap is a vertical shift of the second lower pipe
  self.y = y

  self.pipes = {
    ['upper'] = Pipe('top', self.y),
    ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
  }

  --whether pipe pair is ready to be removed from the scene
  self.remove = false

  --whether or not this pair of pipes has been scored
  self.scored = false

end

function PipePair:update(dt)
  --remove pipe from left edge of screen
  --else move it from right to left
  if self.x > -PIPE_WIDTH then
    self.x = self.x - PIPE_SPEED * dt
    self.pipes['lower'].x = self.x
    self.pipes['upper'].x = self.x
  else
    self.remove = true
  end
end


function PipePair:render()
  for l, pipe in pairs(self.pipes) do
    pipe:render()
  end
end
