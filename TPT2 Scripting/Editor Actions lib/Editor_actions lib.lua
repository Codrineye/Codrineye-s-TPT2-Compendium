--[==[

; Script that defines multiple helper lua functions
; that let you easily build and return large expressions
; by using a lua macro instead of multiple line breaks
; 
; Building expressions in lua can greately improve script
; readability and maintinability if used correctly
; 

; 
; For this library, I will take a page out of d0s's book and
; just write the functions out in a string
; 
; I'm pretty sure this should make everything easier
; 
; The library is made to read from the Editor_actions string and
; create a function that the user can call, that returns
; the formatted value requested by the syntax
; 
; Function name is defined first, its name ends at the first instance of
; an open parenthesis (
; 
; Function parameters are the contents within the set of
; (enclosed parenthesies), the match() pattern stops reading when
; it reaches a closed parenthesis )
; 
; Function return output is found at the first instance of a
; quote mark " and stops reading once it hits a semicolon ;
; 
; A function sequence ends with a semicolon ;
]==]

Editor = {};
Editor.format_error_message = false;
Editor.error_msg_params = {};

--[[Internal variable for debugging, logs the function]]
local logging = false;

--[[Internal variable that stores an error message]]
local err_msg = {};

function Editor.assemble_error(input_string)
  if not Editor.format_error_message then
    err_msg = table.pack(
      "Cod-proofing violation!\n\n",
      "Editor.assemble_error was called when Editor.format_error_message is false.\n",
      "Why are you trying to assemble an error when the output is un-formatted?"
    );
  elseif input_string:match(",") == nil then
    err_msg = table.pack(
      "Cod-proofing violation!\n\n",
      "Editor.assemble_error called for an input without multiple parameters.\n",
      "Any formatting applied would only make the output harder to read."
    );
  end

  if err_msg[1] ~= nil then
    err_msg[#err_msg+1] = "\n\n";
    err_msg[#err_msg+1] = "Unformatted input message:\n";
    err_msg[#err_msg+1] = input_string;
    error(table.concat(err_msg), 0);
  end

  local spaces = 0;

  local idx = 1;
  local args = {};

  local pos = 0;

  while pos < #input_string do
    --[[/*
      * Extract the text up to and including the first parenthesee.
      * Add pos as our offset, so args doesn't have repeat contents.
    */]]
    args[idx] = input_string:match("([^%(%)]+.)", pos);
    if args[idx] == nil then
      -- We failed to extract anything meaningfull, so just extract the first character
      args[idx] = input_string:sub(pos + 1, pos + 1);
    
    elseif input_string:sub(pos + 1, pos + 1) == ("(") then
      --[[/*
        * If the first character was a paranthesee,
        * The match wouldn't have hit it, so we have to add it
      */]]
      args[idx] = "(" .. args[idx];
    end

    if args[idx]:sub(#args[idx], #args[idx]) == "(" then
      args[idx] = args[idx]:gsub("%%0s", "%%" .. spaces .. "s");
      spaces = spaces + 2;
    else
      spaces = spaces - 2;
      args[idx] = args[idx]:gsub("%%0s", "%%" .. spaces .. "s");
    end

    pos = pos + #args[idx];
    idx = idx + 1;
  end

  local action = "\n" .. string.gsub(table.concat(args), "\\n", "\n");
  action = string.format(action, table.unpack(Editor.error_msg_params));
  error(action, 0);
end

local function create_Editor_functions(actions_string)

  --[[/*
    * Every action must end with a ;
    * If the actions_string doesn't contain a `;`, throw an error
  */]]
  if actions_string:match(";") == nil then
    error("\n\nMalformed action string.\nInput contains no `;`.", 0);
  end

  local action_count = 0;
  --[[/*
    * Keep count of our actions for additional helpful information
    * 
    * Create a pattern that defines an action.
  */]]
  local actions_pattern = "([%w_]+)(%b())%s*(.*)";
  for line in actions_string:gmatch("[^;]+") do
    -- line is the action without the EOL character

    action_count = action_count + 1;
    local action = table.pack(line:match(actions_pattern))
    -- Extracts our action name, parameters and output

    if #action ~= 3 then
      err_msg = table.pack(
        "\n\n",
        "|Cannot compute actions string:\n",
        "|'", line, "'\n",
        "|Was only able to extract " .. #action .. " values of the expected 3:\n",
        "|name = '", action[1] or "nil", "'\n",
        "|params = '", action[2] or "nil", "'\n",
        "|output = '", action[3] or "nil", "'"
      );
      error(table.concat(err_msg), 0);
    end

    --[[/*
      * now that all 3 parameters have been obtained,
      * we can assign them to their respective variables
      * so it's easier to know what we're doing
    */]]
    local name, params, output = table.unpack(action);
    params = params:sub(2, -2);

    -- Create the name of our function and check if it has already been defined
    local func_name = "Editor_" .. name;
    if Editor[func_name] ~= nil then
      --[[/*
        * If the function already exists, throw an error telling us that we messed up.
        * Access the functions "root" to be able to compare the input and output of the 2
      */]]
      local root = "root_" .. func_name;
      local origin = Editor[root];
      err_msg = table.pack(
        "\n\n",
        "|Action duplicate detected on action string:\n",
        "|'", line, "'\n|\n",
        "|line number = ", action_count, "\n",
        "|root line number = ", origin.action_count, "\n|\n",
        "|name = '", name, "'\n",
        "|root name = '", origin.name, "'\n|\n",
        "|params = '", params, "'\n",
        "|original params = '", origin.params, "'\n|\n",
        "|output = '", output, "'\n",
        "|original output = '", origin.output, "'"
      );
      error(table.concat(err_msg), 0);
    end

    local params_count = 1;
    for _ in params:gmatch(",") do
      params_count = params_count + 1;
    end

    -- Now we handle logging the action, so we can check if our error handling is faulty
    if logging then
      local print_msg = table.pack(
        "|Logging action ", line, " which is number ", action_count, "\n",
        "|name = '", name, "'\n",
        "|params = '", params, "'\n",
        "|params_count = ", params_count, "\n",
        "|output = '", output, "'\n"
      );
      print(table.concat(print_msg));
    end

    --[[/*
      * Time to create the function body.
      * Since this is activated using load(), we need to return the function definition,
      * Additionally, every escape character must be doubled, meaning that,
      * to create %s, you'd need to do %%s
    */]]
    local func_body = string.format(
        [==[
          return function(%s)
            local output = %s;
            local params = table.pack(%s);
            local param_count = %d;
            Editor.error_msg_params[#Editor.error_msg_params + 1] = "";
            if #params < param_count then
              local err_msg = table.pack(
                "\n\n",
                "Missing ", (#params == 0) and "all" or (param_count - #params), " parameters!",
                "\nExpected ", param_count, " but obtained ", #params, " parameters"
              );
              if #params == 0 then
              end
              error(table.concat(err_msg));
            elseif not Editor.format_error_message or #params == 1 or not output:match(",") then
              return string.format(output, table.unpack(params));
            end
            
            local action = {};
            action[1] = output:match("([^%%(%%)]+.)");
            
            for i = 1, param_count do
              Editor.error_msg_params[#Editor.error_msg_params + 1] = "";
              action[#action + 1] = "\\n%%0s" .. params[i];
              if i ~= #params then
                action[#action + 1] = ",";
              end
            end
            action[#action + 1] = "\\n%%0s";
            if output:match("%%b()") ~= nil then
              action[#action + 1] = string.sub("()", -1);
            end
            return table.concat(action)
          end
        ]==],
        params, output, params, params_count
      );
    --[[/*
      * With our function defined, we must load the function in a chunk
      * We assign 2 values here:
      * - chunk is the actual function we're loading
      * - err is an error message returned if the function failed to load
      * 
      * The parameters in load are as follows:
      * - The function to load
      * - The "chunk" we're loading it into. This provides the function name.      * - The mode of our function.
      *   The mode "t" reprezents text, as our function body is defined as a string
      *   and its parameters are treated as strings
      * - The environment is global, as we need to have access to our Editor body
    ]]
    local chunk, err = load(func_body, func_name, "t", _G);
    if not chunk then
      -- If the chunk failed to load, throw an error and include the error message
      err_msg = table.pack(
        "\n\n",
        "|Error while loading function '", name, "'\n",
        "|Error message =\n",
        "|`", err, "`"
      );
      error(table.concat(err_msg), 0);
    end

    Editor[func_name] = chunk();
    --[[/*
      * We've successfully created the function called func_name,
      * Add it to the global scope instead of our Editor table
      * so that the call Editor.Editor_name() can just be Editor_name()
      * 
      * Also define the root properties of our function.
      * Since these aren't useful to anyone other than ourselves, we can add them to our
      * Editor table instead, purely for organization purposes.
    */]]
    local root = "root_" .. func_name;
    Editor[root] = {};
    local root_data = Editor[root];

    root_data.name = name;
    root_data.params = params;
    root_data.output = output;
    root_data.action_count = action_count;
  end
end

local Editor_actions = [==[
stringify_value(value_to_stringify) [["%s"]];
encase_value(value_to_encase) "(%s)";

setVar(var_type, dataType, name, set_value) "%s.%s.set(%s, %s)";
set_globalVar(dataType, name, set_value) "global.%s.set(%s, %s)";
set_localVar(dataType, name, set_value) "local.%s.set(%s, %s)";

getVar(var_type, dataType, name) "%s.%s.get(%s)";
get_globalVar(dataType, name) "global.%s.get(%s)";
get_localVar(dataType, name) "local.%s.get(%s)";

unsetVar(var_type, name) "%s.unset(%s)";
unset_globalVar(name) "global.unset(%s)";
unset_localVar(name) "local.unset(%s)";

math(leftVal, op_name, rightVal) "%s %s %s";

primitive_math(primitive_op, dataType, leftVal, op_name, rightVal) "%s.%s(%s, %s, %s)";
primitive_comparison(dataType, leftVal, op_name, rightVal) "comparison.%s(%s, %s, %s)";
primitive_arithmetic(dataType, leftVal, op_name, rightVal) "arithmetic.%s(%s, %s, %s)";

not(value_to_negate) "not(%s)";

if(condition, valueTrue, valueFalse) "if(%s, %s, %s)";
ternary.int(condition, valueTrue, valueFalse) "if(%s, %s, %s)";
ternary.double(condition, valueTrue, valueFalse) "if(%s, %s, %s)";
ternary.string(condition, valueTrue, valueFalse) "if(%s, %s, %s)";
ternary.vec2(condition, valueTrue, valueFalse) "if(%s, %s, %s)";

contains(parent_string, checker_string) "string.contains(%s, %s)";

len(string_value) "string.length(%s)";
index(parent_string, checker_string, string_offset) "string.indexOf(%s, %s, %s)";

concat(left_string, right_string) "concat(%s, %s)";
sub(parent_string, string_offset, substring_lenght) "substring(%s, %s, %s)";

impulse() "script.impulse()";

lower(string_to_manipulate) "string.lower(%s)";
upper(string_to_manipulate) "string.upper(%s)";

budget() "generic.budget()";
time_frame() "time.frame()";
screenWidth() "screen.width()";
screenHeight() "screen.height()";

min(leftVal, rightVal) "min(%s, %s)";
max(leftVal, rightVal) "max(%s, %s)";
rnd(minVal, maxVal) "rnd(%s, %s)";

screenWidth_double() "screen.width.d()";
screenHeight_double() "screen.height.d()";
get_UISize() "option.ui.size()";

time_now() "timestamp.now()";
time_utcnow() "timestamp.utcnow()";

time_delta() "time.delta()";
time_unscaled() "time.unscaledDelta()";
get_timeScale() "time.scale()";

floor(floor_value) "double.floor(%s)";
ceil(ceil_value) "double.ceil(%s)";
round(round_value) "double.round(%s)";

sin(sin_value) "double.sin(%s)";
cos(cos_value) "double.cos(%s)";
tan(tan_value) "double.tan(%s)";
asin(asin_value) "double.asin(%s)";
acos(acos_value) "double.acos(%s)";
atan(atan_value) "double.atan(%s)";
atan2(atan2_value) "double.atan2(%s)";

vector_xCoord(vector_value) "vec2.x(%s)";
vector_yCoord(vector_value) "vec2.y(%s)";
vec(vector_coord_x, vector_coord_y) "vec.fromCoords(%s, %s)";

getMousePosition() "mouse.position()";
get_leftMouseState() "mouse.0.state()";
get_rightMouseState() "mouse.1.state()";
get_middleMouseState() "mouse.2.state()";

convertDataType(originalType, desiredType, value) "%s2%s(%s)";
convertFromString(desiredType, value, fallback) "s2%s(%s, %s)";

convertIntToDouble(value) "i2d(%s)";
convertIntToString(value) "i2s(%s)";

convertDoubleToInt(value) "d2i(%s)";
convertDoubleToString(value) "d2s(%s)";

convertStringToInt(value, fallback) "s2i(%s, %s)";
convertStringToDouble(value, fallback) "s2d(%s, %s)";

visibilityGet(windowID) "visibility.get(%s)";
childVisibilityGet(windowID, elementID) "child.visibility.get(%s, %s)";

createWindow(windowID, windowType) "window.create(%s, %s)";
destroyWindow(windowID) "window.destroy(%s)";
destroyWindow_all() "window.destroy.all()";

setWindowPosition(windowID, position) "window.position.set(%s, %s)";

setTextInWindow(windowID, elementID, value) "window.text.set(%s, %s, %s)";
setSpriteInWindow(windowID, elementID, spriteID) "window.sprite.set(%s, %s, %s)";

setWindowVisibility(windowID, visibility) "window.visibility.set(%s, %s)";
setChildVisibility(windowID, elementID, visibility) "window.child.visibility.set(%s, %s, %s)";

resource(resourceID) "resource(%s)";

isopen(roomID) "town.window.isopen(%s)";
anyopen() "town.window.anyopen()";
show(roomID, enter) "town.window.show(%s)";

softwareEnabled(softwareID) "software.enabled(%s)";
softwareFind(softwareName) "software.find(%s)";

towerHealth(percentage) "tower.health(%s)";
towerEnergy(percentage) "tower.energy(%s)";
towerShield(percentage) "tower.shield(%s)";
moduleCooldown(module_index) "tower.module.cooldown(%s)";

highscore(type, region, difficulty) "highscore.%s(%s, %s)";

highscoreWave(region, difficulty) "highscore.wave(%s, %s)";
highscoreEra(region, difficulty) "highscore.era(%s, %s)";
highscoreInfinity(region, difficulty) "highscore.infinity(%s, %s)";

disableCost(element_name) "disable.cost(%s)";
activeID(active_spell_index) "active.id(%s)";
activeIndex(moduleId) "active.index(%s)";

workerPaused(workerID) "worker.paused(%s)";
workerGroup(workerID) "worker.group(%s)";
workerName(workerID) "worker.name(%s)";
workerTask(workerID) "worker.task(%s)";

adventureCountEntities(entityType) "adventure.countEntities(%s)";
adventureHasItem(item_name) "adventure.hasItem(%s)";
adventureIsWall(tile_coords) "adventure.isWall(%s)";
adventureIsBomb(tile_coords) "adventure.isBomb(%s)";
adventureIsEnemy(tile_coords) "adventure.isEnemy(%s)";
adventureIsCompleted(room_coords) "adventure.isCompleted(%s)";
adventureEntityType(tile_coords) "adventure.entityType(%s)";

isMachineActive(machine_name) "active(%s)";
factoryCountItems(item_name, tier) "count(%s, %s)";
factoryCountMachineItems(machine_name) "machine.item.count(%s)";
factoryItemInMachine(machine_name) "machine.item(%s)";
factoryFindItem(item_name) "factory.find(%s)";

marketPreference(stone_element) "museum.pref(%s)";
isMarketSlotLocked(stone_index) "museum.isLocked(%s)";
museumFreeSlots(target_menu) "museum.freeSlots(%s)";
maxStoneTier(element) "museum.maxTier(%s)";
slotTier(offerSlot) "museum.slotTier(%s)";
trashTier(trashSlot) "museum.trashTier(%s)";
slotElement(offerSlot) "museum.slotElement(%s)";
trashElement(trashSlot) "museum.trashElement(%s)";

goto(label) "goto(%s)";
gotoif(label, condition) "gotoif(%s, %s)";

execute(script_to_execute) "execute(%s)";
executesync(script_to_execute) "executesync(%s)";
]==];
--[[/*
  * Now that the string has been defined,
  * let the function do the rest
  *
  * For the input between the lua version and the external editor version
  * to match, I have to replace every instance of \n with an empty string
*/]]
create_Editor_functions(Editor_actions:gsub("\n", ""));
