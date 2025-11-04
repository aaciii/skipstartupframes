local ssf = require('skipstartupframes/src/ssf')
local inifile = require('skipstartupframes/lib/inifile')

-- config.ini file path
local config_file = ssf.plugin_directory .. '/config.ini'

-- Default config values
local defaults = {
  blackout = true,
  mute = true,
  parent_fallback = true,
  show_frames = false,
  slow_motion = false
}

local configValues = {}

-- config interface
ssf.config = {
  -- Return a config value
  get = function(self, key)
    return configValues[key]
  end,

  -- Set a config value
  set = function(self, key, value)
    -- Ignore if the key does not exist
    if not self:exists(key) then
      return
    end
    configValues[key] = value

    ssf.print("Config value for '" .. key .. "' set to " .. tostring(value))
    inifile.save(config_file, { config = configValues })
  end,

  -- Toggle a config's value
  toggle = function(self, key)
    -- Ignore if config is not a boolean
    if (type(self:get(key)) ~= "boolean") then
      return
    end

    self:set(key, not self:get(key))
  end,

  -- Reset a config value to its default value
  reset = function(self, key)
    self:set(key, defaults[key])
  end,

  -- Check if a config value exists
  exists = function(self, key)
    return configValues[key] ~= nil
  end
}

-- Check if config file exists
local success, result = pcall(function() return lfs.attributes(config_file) end)
if result then
  -- Config file exists...

  ssf.print("Loading config from " .. config_file)

  -- Parse config file
  configValues = inifile.parse(config_file).config or {}

  -- Merge config with defaults
  for k, v in pairs(defaults) do
    if (configValues[k] == nil or type(configValues[k]) ~= type(v)) then
      ssf.print("Config value for '" .. k .. "' is missing or has incorrect type. Using default value.")
      configValues[k] = v
    end
  end
else
  -- Config file does not exist...
  ssf.print("Config file not found. Creating new config file with default values.")

  -- Use default config values
  configValues = defaults

  -- Save default config to file
  inifile.save(config_file, { config = configValues })
end
