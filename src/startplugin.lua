local ssf = require("skipstartupframes/src/ssf")

-- Notifiers
local startNotifier = nil
local stopNotifier = nil
local frameNotifier = nil
local menuNotifier = nil

local slow_motion_rate = 0.3

-- Initialize frame processing function to do nothing
local process_frame = function() end

-- Variable references
local rom = nil
local target = nil

-- Variable to help differentiate between hard and soft resets
local running = false

-- Run when MAME begins emulation
local start = function()
  rom = emu.romname()

  -- If no rom is loaded, don"t do anything
  if not rom or rom == "___empty" then
    return
  end

  -- Soft reset detected
  if running then
    -- If the frame targets have not been changed in the options menu, reload the frames from the files
    if not ssf.frames.dirty then
      ssf.frames:load(rom)
    end

    -- Set the frame target to the reset frame target
    target = ssf.frames.reset_frame_target

    ssf.print("Soft reset detected. Frame target: " .. target)
  else
    -- Start or Hard reset detected
    running = true

    -- Load the frames from the files
    ssf.frames:load(rom)

    -- Set the frame target to the start frame target
    target = ssf.frames.start_frame_target

    ssf.print("Start or Hard reset detected. Frame target: " .. target)
  end

  -- Variable references
  local screens = manager.machine.screens
  local screens_exist = #screens > 0
  local video = manager.machine.video
  local sound = manager.machine.sound

  -- Starting frame
  local frame = 0

  -- Process each frame
  process_frame = function()

    if ssf.config:get("slow_motion") then
      video.throttled = true
      video.throttle_rate = slow_motion_rate
    else
      -- Disable throttling
      video.throttled = false
      video.throttle_rate = 1
    end

    -- Mute sound
    if ssf.config:get("mute") then
      sound.system_mute = true
    end

    -- Black out screen
    if screens_exist then
      for _,screen in pairs(screens) do
        -- Blackout screen
        if ssf.config:get("blackout") then
          screen:draw_box(0, 0, screen.width, screen.height, 0x00000000, 0xff000000)
        end

        -- Show frame count
        if ssf.config:get("show_frames") then
          screen:draw_text(0, 0, "ROM: "..rom.." Frame: "..frame, 0xffffffff, 0xff000000)
        end
      end
    end

    -- Iterate frame count when not paused
    if not manager.machine.paused then
      frame = frame + 1
    end

    -- Frame target reached
    if frame >= target then

      ssf.print("Frame target of " .. target .. " reached")

      -- Re-enable throttling
      video.throttled = true

      -- Reset throttle rate
      video.throttle_rate = 1

      -- Unmute sound
      sound.system_mute = false

      -- Reset frame processing function to do nothing when frame target is reached
      process_frame = function() end
    end
  end
end

-- Run when MAME stops emulation or a hard reset occurs
local stop = function()
  -- Reset the frame processing function
  process_frame = function() end

  -- Save any custom frame changes made in options menu
  ssf.frames:save(rom)

  -- Reset variables
  running = false
  rom = nil
  target = 0
end

-- Runs when plugin initially loads
function ssf:startplugin()
  -- Create ssf_custom.txt if it does not exist
  local custom_frames_file = ssf.plugin_directory .. "/ssf_custom.txt"
  local custom_frames = io.open(custom_frames_file, "a")
  custom_frames:close()

  local menu_callback = function(index, event)
    return self:menu_callback(index, event)
  end

  local menu_populate = function()
    return self:menu_populate(rom)
  end

  -- Register frame done notifier that processes each frame
  if emu.register_frame_done ~= nil then
    -- Backwards compatibility
    ssf.print("Registering frame notifier")
    emu.register_frame_done(function() process_frame() end)
  else
    emu.print_warning("Skip Startup Frames plugin requires a newer version of MAME")
    return
  end

  -- Register start/stop notifiers
  if emu.add_machine_reset_notifier ~= nil and emu.add_machine_stop_notifier ~= nil then
    -- Modern MAME notifier (0.254 and newer)
    startNotifier = emu.add_machine_reset_notifier(start)
    stopNotifier = emu.add_machine_stop_notifier(stop)
  elseif emu.register_start ~= nil and emu.register_stop ~= nil then
    -- Backwards compatibility notifier
    emu.register_start(start)
    emu.register_stop(stop)
  else
    emu.print_warning("Skip Startup Frames plugin requires a newer version of MAME")
    return
  end

  -- Custom plugin menu registration
  if emu.register_menu ~= nil then
    menuNotifier = emu.register_menu(menu_callback, menu_populate, _p("plugin-skipstartupframes", "Skip Startup Frames"))
  end

end
