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
Editor.error_msg_spacing = 0;

-- Internal variable for debugging, logs the function components
local logging = false;

-- Invernal variable that stores an error message
local err_msg = {};

local function create_Editor_functions(actions_string)
  local action_pattern = "([^%(]+)%(([^%)]+)%) (\"[^;]+)";
  -- This describes the pattern that actions are recorded in

  local computable_string = actions_string:match(action_pattern);
  if not computable_string then
    error("Cannot compute actions string: \n\n" .. actions_string, 0);
    -- Send an error if the string can't be computed
  end

  for line in actions_string:gmatch("[^;]+") do
    local name = line:match("([^%(]+)");
    local params = line:match("%b()"):sub(2, -2);
    --[[/*
      * :sub(2, -2) removes the (parenthesies)
      * string.sub("(test)", 2, -2) turns (test) into test
    */]]
    local params_substitute = table.pack(
      ", spaces", "spaces, ",
      ", parens", "parens, "
    );
    local user_params = params;
    for i = 1, #params_substitute do
      user_params = user_params:gsub(params_substitute[i], "");
    end
    --[[/*
      * The user params are the parameters the user needs to fill out
      * This removes the spaces and parens fields from the function input
      * 
      * spaces and pares are used inside the function so that
      * the end user can detect the issue with more ease
    */]]
    local output = line:match("(%) [^;]+)"):sub(3);
    --[[/*
        * We isolate the functions 
        * name, parameters and return output
        * using string.match(line, pattern)
        * 
        * we only create a global function if none of the
        * fields are nil
      */]]
    if not (name and params and output) then
      err_msg = table.pack(
        "Failed to load all parameters\n",
        "|line '", line, "'\n",
        "|name '", name, "'\n",
        "|params '", params, "'\n",
        "|output '", output, "'"
      );
      error(table.concat(err_msg), 0);
    end

    local func_name = string.format("Editor_%s", name);
    if _G[func_name] then
      local root = "root_" .. func_name;
      err_msg = table.pack(
        "Function replica detected:\n",
        "|name: '", name, "'\n",
        "|params: '", params, "' ",
        "|original_params: '", _G[root].params, "'\n",
        "|output: '", output, "' ",
        "|original_output: '", _G[root].output, "'"
      );
      error(table.concat(err_msg), 0);
    end

    if logging then
      -- Log the function data for internal debugging
      local print_msg = table.pack(
        "|", line, "\n",
        "|name: ", name, "\n",
        "|params: ", params, "\n",
        "|user_params: ", user_params, "\n",
        "|output: ", output, "\n",
        "| "
      );
      error(table.concat(print_msg), 0);
    end
    local func_body = string.format([==[
      return function(%s)
        local spaces, parens = "", "";
        if Editor.format_error_message then
          local level = Editor.error_msg_spacing;
          Editor.error_msg_spacing = level + 1;
          spaces = "\\\n" .. string.rep("  ", level + 1);
          parens = "\\\n" .. string.rep("  ", level);
        end
        return string.format(%s, %s);
      end]==], user_params, output, params
    );
    local chunk, err = load(func_body, "Editor_actions lib", "t", _G);
    if not chunk then
      err_msg = table.pack(
        "Error loading function '", name, "'\n",
        "Error code ", err
      );
      error(table.concat(err_msg), 0);
    end

    Editor[func_name] = chunk();
    local root = "root_" .. func_name;
    Editor[root] = {};
    local func_data = Editor[root];

    func_data.params = params;
    func_data.output = output;
  end
end
  local Editor_actions = [==[
stringify_value(value_to_stringify) [["%s"]];
encase_value(value_to_encase) "(%s)";

varGet(var_type, data_type, var_name) "%s.%s.get(%s)";
get_globalVar(data_type, var_name) "global.%s.get(%s)";
get_localVar(data_type, var_name) "local.%s.get(%s)";

math(leftVal, op_name, rightVal) "%s %s %s";
primitive_math(leftVal, op_name, rightVal) "%s, "%s", %s";

primitive_comparison(dataType, leftVal, op_name, rightVal) 
"comparison.%s(%s, "%s", %s)";

primitive_arithmetic(dataType, leftVal, op_name, rightVal) 
"arithmetic.%s(%s, %s, %s)";

not(value_to_negate) "not(%s)";
if(condition, valueTrue, valueFalse) "if(%s, %s, %s)";

contains(parent_string, checker_string) "contains(%s, %s)";

len(string_value) "len(%s)";
index(parent_string, checker_string, string_offset) "index(%s, %s, %s)";

concat(left_string, right_string) "concat(%s, %s)";
sub(parent_string, string_offset, substring_lenght) "sub(%s, %s, %s)";

lower(string_to_manipulate) "lower(%s)";
upper(string_to_manipulate) "upper(%s)";

floor(floor_value) "floor(%s)";
ceil(ceil_value) "ceil(%s)";
round(round_value) "round(%s)";

sin(sin_value) "sin(%s)";
cos(cos_value) "cos(%s)";
tan(tan_value) "tan(%s)";
asin(asin_value) "asin(%s)";
acos(acos_value) "acos(%s)";
atan(atan_value) "atan(%s)";
atan2(atan2_value) "atan2(%s)";

min(leftVal, rightVal) "min(%s, %s)";
max(leftVal, rightVal) "max(%s, %s)";
rnd(minVal, maxVal) "rnd(%s, %s)";

vector_xCoord(vector_value) "vec2.x(%s)";
vector_yCoord(vector_value) "vec2.y(%s)";
vec(vector_coord_x, vector_coord_y) "vec(%s, %s)";

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

isopen(roomID) "isopen(%s)";
resource(resourceID) "resource(%s)";

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
]==];
--[[/*
  * Now that the string has been defined,
  * let the function do the rest
*/]]
create_Editor_functions(Editor_actions);
