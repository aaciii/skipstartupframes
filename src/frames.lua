local ssf = require('skipstartupframes/src/skipstartupframes')

local file = ssf.plugin_directory .. "/ssf.txt"

-- Load the frames file
local load_frames = function()
  local frames_file = io.open(file, "r")

  -- Read in and parse the frames file
  local frames = {}
  if frames_file ~= nil then
    frames_file = frames_file:read("*a")

    -- Split lines
    for line in frames_file:gmatch("[^\r\n]+") do
      -- Split on comma
      local key, value = line:match("([^,]+),([^,]+)")

      -- Add rom and frame count to frames table
      if (key ~= nil and value ~= nil) then
        frames[key] = tonumber(value)
      end

    end
  end

  return frames
end

function ssf:save_frames(frames)
  -- Sort the table keys
  local sortedKeys = {}
  for n in pairs(frames) do
    table.insert(sortedKeys, n)
  end
  table.sort(sortedKeys)

  -- Prep the frame data for writing
  local data = ""
  for _,v in pairs(sortedKeys) do
    data = data..v..","..frames[v].."\n"
  end

  -- Write the frame data to the file
  local frames_file = io.open(file, "w")
  frames_file:write(data)
  frames_file:close()
end

function ssf:setFrameTarget()
  local frames = load_frames()

  self.frameTarget = frames[self.rom]

  -- If the rom was not found in SSF.txt...
  if self.frameTarget == nil and not self.options:get('debug') then

    -- If parent rom fallback is disabled, don't do anything
    if not self.options:get('parentFallback') then
      self.frameTarget = 0
      return
    end

    -- Look for parent ROM
    local parent = emu.driver_find(self.rom).parent

    -- No parent found, don't do anything
    if parent == "0" then
      self.frameTarget = 0
      return
    end

    -- Fetch frame count for parent rom from ssf.txt
    self.frameTarget = frames[parent]

    -- No frame count found for parent rom, don't do anything
    if self.frameTarget == nil then
      self.frameTarget = 0
      return
    end
  end

  -- Ensure frame target is not negative
  if self.frameTarget < 0 then
    self.frameTarget = 0
  end
end
