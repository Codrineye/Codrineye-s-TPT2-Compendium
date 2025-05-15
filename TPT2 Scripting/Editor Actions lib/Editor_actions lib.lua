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
Editor.output_table = false;

Editor.cache = {};
Editor.cache.comma = ", ";
Editor.cache.parens = table.pack("(", ")");

-- Internal variable for debugging, logs the function
local logging = false;

-- Internal variable that stores an error message
local err_msg = {};

-- Function that processes all the actions to form the desired output
function Editor.process_action(output, param_count, ...)
  local params = table.pack(...);
  Editor.error_message_params[#Editor.error_message_params + 1] = "";
  if #params < param_count then
    err_msg = table.pack(
      "n",
      "nMissing ", (#params == 0) and "all" or (param_count - #params), " parameter(s)!",
      "nExpected ", param_count, " but obtained ", #params, " parameters"
    );
    error(table.concat(err_msg));
  end
  local acc = {};
  local param = 1;
  local passed_paren = false;
  output = ";" .. output:gsub("%%s", "PARAM");
  for word in output:gmatch("[^PARAM]+") do
    if param_count > 1 and word:match("[%(%)]") ~= nil then
      --[[/*
        * we only care if we've passed the first paren
        * when we're formatting for an error message
      */]]
      passed_paren = Editor.format_error_message;
    end

    if param == 1 then
      -- get rid of the `;` we added to the output
      word = word:sub(2);
    end

    if param > param_count and passed_paren then
      acc[#acc + 1] = "n%0s";
    end
    acc[#acc + 1] = word;
    if param <= param_count then
      if passed_paren then
        Editor.error_message_params[#Editor.error_message_params + 1] = "";
        acc[#acc + 1] = "n%0s";
      end

      local str;
      if type(params[param]) ~= "table" then
        str = tostring(params[param]);
        if Editor.format_error_message and str == "%" then
          acc[#acc + 1] = "%%";
        else
          acc[#acc + 1] = str;
        end
      else
        local params_count = #params[param];
        if params_count > math.maxinteger then
          error("table input is too large!n" .. params_count .. " elements");
        elseif Editor.format_error_message then
          for i = 1, params_count do
            str = tostring(params[param][i]);
            acc[#acc + 1] = (str == "%") and "%%" or str;
          end
        else
          for i = 1, params_count do
            acc[#acc + 1] = tostring(params[param][i]);
          end
        end
      end
    end
    param = param + 1;
  end

  return Editor.output_table and acc or table.concat(acc);
end

function Editor.assemble_error(input)
  local action = (type(input) ~= "table") and input or table.concat(input);

  if not Editor.format_error_message then
    err_msg = table.pack(
      "Cod-proofing violation!nn",
      "Editor.assemble_error was called when Editor.format_error_message is false.n",
      "Why are you trying to assemble an error when the output is un-formatted?"
    );
  elseif not action:match(",") then
    err_msg = table.pack(
      "Cod-proofing violation!nn",
      "Editor.assemble_error called for an input without multiple parameters.n",
      "Any formatting applied would only make the output harder to read."
    );
  end

  if err_msg[1] ~= nil then
    err_msg[#err_msg + 1] = "nn";
    err_msg[#err_msg + 1] = "Unformatted input message:n";
    err_msg[#err_msg + 1] = action;
    error(table.concat(err_msg), 0);
  end

  local spaces = 0;

  local idx = 1;
  local args = {};

  local pos = 0;
  while pos < #action do
    local pos_copy = pos;

    --[[/*
        * Extract the text up to and including the first parenthesee.
        * Add pos as our offset, so acc doesn't have repeat contents.
      */]]
    args[idx] = action:match("^([^%(%)]+.)", pos + 1);
    pos = pos + #(args[idx] or "")
    if not args[idx] then
      --[[extract just 1 parenthesee]]
      args[idx] = action:sub(pos + 1, pos + 1);
      pos = pos + 1;
    elseif action:sub(pos_copy + 1, pos_copy + 1) == Editor.cache.parens[1] then
      --[[/*
          * If the first character was a paranthesee,
          * the match wouldn't have hit it, so we have to add it
        */]]
      args[idx] = Editor.cache.parens[1] .. args[idx];
      pos = pos - 1;
    end

    if args[idx]:sub(#args[idx], #args[idx]) == Editor.cache.parens[1] then
      args[idx] = args[idx]:gsub("%%0s", "%%" .. spaces .. "s");
      spaces = spaces + 2;
    else
      local _, count = args[idx]:gsub("%%0s", "");
      args[idx] = args[idx]:gsub("%%0s", "%%" .. spaces .. "s", count - 1);
      spaces = spaces - 2;
      args[idx] = args[idx]:gsub("%%0s", "%%" .. spaces .. "s");
    end

    idx = idx + 1;
    if pos == pos_copy then
      error("Prevent infinite loop");
    end
  end

  action = table.concat(args);
  action = "n" .. action:gsub("n", "n");
  action = action:format(table.unpack(Editor.error_message_params))
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
            local output, params_count = [[%s]], %d;
            return Editor.process_action(output, params_count, %s);
          end
        ]==],
      params, output, params_count, params
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
stringify_value(value_to_stringify) "%s";
encase_value(value_to_encase) (%s);

setVar(var_type, dataType, name, set_value) %s.%s.set(%s, %s);
set_globalVar(dataType, name, set_value) global.%s.set(%s, %s);
set_localVar(dataType, name, set_value) local.%s.set(%s, %s);

getVar(var_type, dataType, name) %s.%s.get(%s);
get_globalVar(dataType, name) global.%s.get(%s);
get_localVar(dataType, name) local.%s.get(%s);

unsetVar(var_type, name) %s.unset(%s);
unset_globalVar(name) global.unset(%s);
unset_localVar(name) local.unset(%s);

math(leftVal, op_name, rightVal) %s %s %s;

primitive_math(primitive_op, dataType, leftVal, op_name, rightVal) %s.%s(%s, %s, %s);
primitive_comparison(dataType, leftVal, op_name, rightVal) comparison.%s(%s, %s, %s);
primitive_arithmetic(dataType, leftVal, op_name, rightVal) arithmetic.%s(%s, %s, %s);

not(value_to_negate) not(%s);

if(condition, valueTrue, valueFalse) if(%s, %s, %s);

contains(parent_string, checker_string) contains(%s, %s);

len(string_value) len(%s);
index(parent_string, checker_string, string_offset) index(%s, %s, %s);

concat(left_string, right_string) concat(%s, %s);
sub(parent_string, string_offset, substring_lenght) sub(%s, %s, %s);

lower(string_to_manipulate) lower(%s);
upper(string_to_manipulate) upper(%s);

min(leftVal, rightVal) min(%s, %s);
max(leftVal, rightVal) max(%s, %s);
rnd(minVal, maxVal) rnd(%s, %s);

floor(floor_value) floor(%s);
ceil(ceil_value) ceil(%s);
round(round_value) round(%s);

sin(sin_value) sin(%s);
cos(cos_value) cos(%s);
tan(tan_value) tan(%s);
asin(asin_value) asin(%s);
acos(acos_value) acos(%s);
atan(atan_value) atan(%s);
atan2(atan2_value) atan2(%s);

vector_xCoord(vector_value) x(%s);
vector_yCoord(vector_value) y(%s);
vec(vector_coord_x, vector_coord_y) vec(%s, %s);

convertDataType(originalType, desiredType, value) %s2%s(%s);
convertFromString(desiredType, value, fallback) s2%s(%s, %s);

convertIntToDouble(value) i2d(%s);
convertIntToString(value) i2s(%s);

convertDoubleToInt(value) d2i(%s);
convertDoubleToString(value) d2s(%s);

convertStringToInt(value, fallback) s2i(%s, %s);
convertStringToDouble(value, fallback) s2d(%s, %s);

visibilityGet(windowID) visibility.get(%s);
childVisibilityGet(windowID, elementID) child.visibility.get(%s, %s);

createWindow(windowID, windowType) window.create(%s, %s);
destroyWindow(windowID) window.destroy(%s);

setWindowPosition(windowID, position) window.position.set(%s, %s);

setTextInWindow(windowID, elementID, value) window.text.set(%s, %s, %s);
setSpriteInWindow(windowID, elementID, spriteID) window.sprite.set(%s, %s, %s);

setWindowVisibility(windowID, visibility) window.visibility.set(%s, %s);
setChildVisibility(windowID, elementID, visibility) window.child.visibility.set(%s, %s, %s);

resource(resourceID) resource(%s);

softwareEnabled(softwareID) software.enabled(%s);
softwareFind(softwareName) software.find(%s);

towerHealth(percentage) health(%s);
towerEnergy(percentage) energy(%s);
towerShield(percentage) shield(%s);
moduleCooldown(module_index) cooldown(%s);

highscore(type, region, difficulty) highscore.%s(%s, %s);

highscoreWave(region, difficulty) highscore.wave(%s, %s);
highscoreEra(region, difficulty) highscore.era(%s, %s);
highscoreInfinity(region, difficulty) highscore.infinity(%s, %s);

disableCost(element_name) disable.cost(%s);
activeID(active_spell_index) active.id(%s);
activeIndex(moduleId) active.index(%s);

workerPaused(workerID) worker.paused(%s);
workerGroup(workerID) worker.group(%s);
workerName(workerID) worker.name(%s);
workerTask(workerID) worker.task(%s);

adventureCountEntities(entityType) adventure.countEntities(%s);
adventureHasItem(item_name) adventure.hasItem(%s);
adventureIsWall(tile_coords) adventure.isWall(%s);
adventureIsBomb(tile_coords) adventure.isBomb(%s);
adventureIsEnemy(tile_coords) adventure.isEnemy(%s);
adventureIsCompleted(room_coords) adventure.isCompleted(%s);
adventureEntityType(tile_coords) adventure.entityType(%s);

isMachineActive(machine_name) active(%s);
factoryCountItems(item_name, tier) count(%s, %s);
factoryCountMachineItems(machine_name) machine.item.count(%s);
factoryItemInMachine(machine_name) machine.item(%s);
factoryFindItem(item_name) factory.find(%s);

marketPreference(stone_element) museum.pref(%s);
isMarketSlotLocked(stone_index) museum.isLocked(%s);
museumFreeSlots(target_menu) museum.freeSlots(%s);
maxStoneTier(element) museum.maxTier(%s);
slotTier(offerSlot) museum.slotTier(%s);
trashTier(trashSlot) museum.trashTier(%s);
slotElement(offerSlot) museum.slotElement(%s);
trashElement(trashSlot) museum.trashElement(%s);

]==];
--[[/*
  * Now that the string has been defined,
  * let the function do the rest
  *
  * For the input between the lua version and the external editor version
  * to match, I have to replace every instance of \n with an empty string
*/]]
create_Editor_functions(Editor_actions:gsub("\n", ""));
