local ssf = require('skipstartupframes/src/skipstartupframes')

-- Option menu variables
local menuSelection = 3
local blackoutIndex
local muteIndex
local parentFallbackIndex
local debugIndex
local debugSlowMotionIndex
local frameTargetIndex

-- Option menu creation/population
function ssf:menu_populate()
  local result = {}

  table.insert(result, { 'Skip Startup Frames', '', 'off' })

  table.insert(result, { '---', '', '' })

  table.insert(result, {_p("plugin-skipstartupframes", "Black out screen during startup"), self.options:get('blackout') and 'Yes' or 'No', 'lr' })
  blackoutIndex = #result

  table.insert(result, { _p("plugin-skipstartupframes", "Mute audio during startup"), self.options:get('mute') and 'Yes' or 'No', 'lr' })
  muteIndex = #result

  table.insert(result, { _p("plugin-skipstartupframes", "Fallback to parent rom startup frames"), self.options:get('parentFallback') and 'Yes' or 'No', 'lr' })
  parentFallbackIndex = #result

  table.insert(result, { _p("plugin-skipstartupframes", "Debug Mode"), self.options:get('debug') and 'Yes' or 'No', 'lr' })
  debugIndex = #result

  table.insert(result, { _p("plugin-skipstartupframes", "Slow Motion during Debug Mode"), self.options:get('debugSlowMotion') and 'Yes' or 'No', 'lr' })
  debugSlowMotionIndex = #result

  table.insert(result, { '---', '', '' })

  table.insert(result, { _p("plugin-skipstartupframes", "Frame Target for " .. self.rom), self.frameTarget, self.frameTarget > 0 and 'lr' or 'r' })
  frameTargetIndex = #result

  return result, menuSelection
end

-- Option menu event callback
function ssf:menu_callback(index, event)
  -- Add escape event to close menu
  if event == 'back' then
    return false
  end

  menuSelection = index

  -- Blackout Screen Option
  if index == blackoutIndex then
    if event == 'left' or event == 'right' then
      self.options:toggle('blackout')
    end
    return true

  -- Mute Audio Option
  elseif index == muteIndex then
    if event == 'left' or event == 'right' then
      self.options:toggle('mute')
    end
    return true

  -- Parent ROM Fallback Option
  elseif index == parentFallbackIndex then
    if event == 'left' or event == 'right' then
      self.options:toggle('parentFallback')
    end
    return true

  -- Debug Mode Option
  elseif index == debugIndex then
    if event == 'left' or event == 'right' then
      self.options:toggle('debug')
    end
    return true

  -- Debug Slow Motion Option
  elseif index == debugSlowMotionIndex then
    if event == 'left' or event == 'right' then
      self.options:toggle('debugSlowMotion')
    end
    return true

  -- Adjust frame target for current game
  elseif index == frameTargetIndex then
    if event == 'left' then
      self.frameTarget = self.frameTarget - 1
    elseif event == 'right' then
      self.frameTarget = self.frameTarget + 1
    end
    return true

  end
end
