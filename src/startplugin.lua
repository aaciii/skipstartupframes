local ssf = require('skipstartupframes/src/skipstartupframes')

-- Notifiers
local startNotifier = nil
local stopNotifier = nil
local menuNotifier = nil

local slowMotionRate = 0.3

function ssf:startplugin()
  -- Initialize frame processing function to do nothing
  local process_frame = function() end

  -- Trampoline function to process each frame
  emu.register_frame_done(function()
    process_frame()
  end)

  -- Variable to store frame target
  self.frameTarget = nil

  -- Variable to store rom name
  self.rom = nil

  -- Run when MAME begins emulation
  local start = function()
    self.rom = emu.romname()

    -- If no rom is loaded, don't do anything
    if not self.rom or self.rom == "___empty" then
      return
    end

    self:setFrameTarget()

    -- Variable references
    local screens = manager.machine.screens
    local video = manager.machine.video
    local sound = manager.machine.sound

    -- Enable throttling
    if not self.options:get('debug') then
      video.throttled = false
    end

    -- Mute sound
    if self.options:get('mute') and not self.options:get('debug') then
      sound.system_mute = true
    end

    -- Slow-Motion Debug Mode
    if self.options:get('debug') and self.options:get('debugSlowMotion') then
      video.throttle_rate = slowMotionRate
    end

    -- Starting frame
    local frame = 0

    -- Process each frame
    process_frame = function()
      -- Draw debug frame text if in debug mode
      if self.options:get('debug') and #screens > 0 then
        for _,screen in pairs(screens) do
          screen:draw_text(0, 0, "ROM: "..self.rom.." Frame: "..frame, 0xffffffff, 0xff000000)
        end
      end

      -- Black out screen only when not in debug mode
      if self.options:get('blackout') and not self.options:get('debug') and #screens > 0 then
        for _,screen in pairs(screens) do
          screen:draw_box(0, 0, screen.width, screen.height, 0x00000000, 0xff000000)
        end
      end

      -- Iterate frame count only when not in debug mode and machine is not paused
      if not self.options:get('debug') or not manager.machine.paused then
        frame = frame + 1
      end

      -- Frame target reached
      if not self.options:get('debug') and frame >= self.frameTarget then

        -- Re-enable throttling
        video.throttled = true

        -- Unmute sound
        sound.system_mute = false

        -- Reset throttle rate
        video.throttle_rate = 1

        -- Reset frame processing function to do nothing when frame target is reached
        process_frame = function() end
      end
    end

    return
  end

  -- Run when MAME stops emulation
  local stop = function()
    process_frame = function() end

    -- Update frames to ssf.txt
    if self.rom and self.frameTarget then
      frames[self.rom] = self.frameTarget
      self:save_frames(frames)

      -- Reset variables
      self.rom = nil
      self.frameTarget = nil
    end
  end

  local menu_callback = function(index, event)
    return self:menu_callback(index, event)
  end

  local menu_populate = function()
    return self:menu_populate()
  end

  -- MAME 0.254 and newer compatibility check
  if emu.add_machine_reset_notifier ~= nil and emu.add_machine_stop_notifier ~= nil then

    startNotifier = emu.add_machine_reset_notifier(start)
    stopNotifier = emu.add_machine_stop_notifier(stop)
    menuNotifier = emu.register_menu(menu_callback, menu_populate, _p("plugin-skipstartupframes", "Skip Startup Frames"))

  else
    -- MAME version not compatible (probably can't even load LUA plugins anyways)
    print("Skip Startup Frames plugin requires at least MAME 0.254")
    return
  end

end
