-- Define the plugin directory
local plugin_directory = manager.plugins['skipstartupframes'].directory

-- Load the plugin metadata
local json = require('json')
local plugin_json_file = io.open(plugin_directory .. '/plugin.json', 'r')
local plugin_json_content = plugin_json_file:read('*a')
plugin_json_file:close()
local ssf = json.parse(plugin_json_content).plugin

-- Set the plugin directory
ssf.plugin_directory = plugin_directory

-- Print function
ssf.print = function(message)
  emu.print_verbose("Skip Startup Frames Plugin: " .. tostring(message))
end

return ssf
