BP = {};

-- Table holding information needed for debugging
BP.debug = {};
BP.debug.can_log = false;
BP.debug.can_halt = false;
BP.debug.halt_limit = 0;
BP.debug.can_display = false;
BP.debug.concat_format = "";

-- Table keeping track of how much space we're using up
BP.used_space = {};
BP.used_space.secure = 0;
BP.used_space.blueprint = 0;

-- Keep track of how many modules we have left to synchronize
BP.sync_ammount = 0;

-- Table that has compactor specific data
BP.comp = {};

-- Store the software security levels
BP.comp.software = {};
-- Store the era elements priority order
BP.comp.era = {};

-- Store the modules we want to secure
BP.comp.module = {};
BP.comp.secure = {};

-- Blueprint activation
BP.comp.spell = {};
BP.comp.blueprint = {};
BP.comp.spell_names = {};

--[[
; macros for communicating with the compactors debugging system
#spell_debug {lua(BP.debug.halt())}
#spell_debug.add_breakpoint {lua(
  BP.debug.can_display = true;
  BP.debug.halt();
)}

#spell_debug.log(level) {lua(BP.debug.can_log = {level})}
#spell_debug.can_halt(level) {lua(
  BP.debug.can_halt = {level};
)}

#spell_debug.recordings_before_halt(limit) {lua(
  BP.debug.halt_limit = {limit};
)}
#spell_debug.display_spells(level) {lua(
  BP.debug.can_display = {level};
)}
#spell_debug.display_format(format) {lua(
  BP.debug.concat_format = {format};
)}
]]

-- Internal method to terminate the program for debugging
local bp_debug_stop = false;
--[[/*
    * Empty table that replaces the need
    * for repetitive assert sequences
    * 
    * Adding to a table and concatenating it is more efficient
    * than ordinairy string concatenation
   */]]
local err_msg = {};

-- Function to more easily handle error messages
function BP.debug.detect_error()
    if not err_msg[1] then return; end
    -- Exit function if there's no error

    error(table.concat(err_msg), 0);
    --[[/*
        * If there is an error, send just the message,
        * the 0 ignores the call context since this "context" is
        * just illegible lua code
       */]]
end

--[[/*
    * WaterCat implementation
    * Set a list of software names and then
    * a security level to each software.
    * 
    * If the security level decided by the user
    * is smaller or = to the level given to the software
    * that software gets toggled on, othwerise, it's off
   */]]

-- list of all the software
local software_list = table.pack("autoskip", "wavestreaming", "wavesurge",
                                 "criticalWavejump", "wavemomentum",
                                 "wavestorm", "wavepersistence",
                                 "waveinstability", "wavevortex",
                                 "wavecatalyst", "waveendurance", "newbounds",
                                 "wavemarathon", "wavecompression", "erasurge",
                                 "eraburst", "eraswirl", "wavehorizon",
                                 "nobounds", "eratunneling", "wavebreach",
                                 "wavefloor", "erafloor", "erahorizon",
                                 "waverestart", "infinityhorizon");
local software_count = #software_list;
for i = 1, software_count do BP.comp.software[software_list[i]] = -50; end

function BP.comp.add_software(software, level)
    -- get direct access to the software we recognize
    local soft = BP.comp.software;

    -- get the security level from the macro call
    local sec = level:match([[%b""]]):sub(2, -2):gsub(" ", "");

    if soft[software] == nil then
        err_msg[1] = "Attempt to assign a security level to ";
        err_msg[2] = "an unrecognized software\n";
        err_msg[3] = "If this is a new software, an update to ";
        err_msg[4] = "the compactor should be released soon";

    elseif soft[software] ~= -50 then
      --[[/*
          * Smallest security level I've seen is -1, 
          * so -50 should never be assigned naturally
         */]]
        err_msg[1] = "Trying to assign a security level to an ";
        err_msg[2] = "already set software";
    elseif tonumber(sec) == nil then
        err_msg[1] = "Trying to assing a non-numeric security level";
    elseif math.type(tonumber(sec)) ~= "integer" then
        err_msg[1] = "Trying to assign a non-integer security level";
    end

    -- Detect if we have an error and send it
    BP.debug.detect_error();
    -- create the software ID
    local software_name = "software." .. software;
    --[[/*
        * get the extra space we need to fill out
        * such that the string in sec has as many characters
        * as the software ID does
       */]]
    local lvl = string.format("%%-%ss", #software_name);
    BP.comp.software[software] = lvl:format(sec);
end

function BP.comp.concat_software(concat_mode)
    local modes = {};
    modes.software_list = true;
    modes.software_secure = true;
    modes.software_len = true;

    if not modes[concat_mode] then
        err_msg[1] = "Invalid concat_mode.\n";
        err_msg[2] = "If you're seeing this then:\n";
        err_msg[3] = "- You're either a user that messed ";
        err_msg[4] = "with something you shouldn't have.\n";
        err_msg[5] = "or\n";
        err_msg[6] = "- You're a user that did nothing wrong and I ";
        err_msg[7] = "messed something up and didn't propperly bug test";
        error(table.concat(err_msg), 0)
    end
    BP.debug.detect_error();

    local software = {};
    local software_len = 0;

    for i = 1, software_count do
        if concat_mode == "software_len" then
            software_len = software_len + 9 + #software_list[i];
        elseif concat_mode == "software_list" then
            software[i] = "software." .. software_list[i] .. "|";
        else
            software[i] = BP.comp.software[software_list[i]] .. "|"
        end
    end
    if software_len > 0 then return software_len - 1; end
    return [["]] .. table.concat(software) .. [["]];
end

--[[/*
      * Easy Era cat
      * Set a priority level for all the era elements
      * you want to disable.
      * Create a ternary string that makes sure the
      * element of priority 1 gets disabled before priority 2
      * and so on...
      * Create an arithmetic.double that checks if the sum
      * of disabling all those elements is == -#BP.comp.era
     */]]

function BP.comp.set_priority(element_name)
    local elems = BP.comp.era;
    local name = tostring(element_name);
    -- don't overwrite the priority level of elements
    if elems[name] then return; end

    elems[1 + #elems] = string.format([["%s"]], name);
    elems[name] = #elems;
end

function BP.comp.disable_era()
    assert(BP.comp.era[1],
           "Cannot call disable.era without using set_priority macro first");
    local elems = BP.comp.era;
    local era = table.pack(elems[#elems]);
    for i = #elems - 1, 1, -1 do
        era = table.pack("if(", "disable.cost(", elems[i], ") != -1.0, ",
                         elems[i], ", ", table.concat(era), ")");
    end
    return table.concat(era);
end

function BP.comp.era_to_disable()
    local elems = BP.comp.era;
    local negative_elems = 0.0 - #elems;
    local era = table.pack("disable.cost(", elems[#elems], ")");
    for i = #elems - 1, 1, -1 do
        era = table.pack("disable.cost(", elems[i], ")", " + ",
                         table.concat(era));
    end
    era = table.pack(negative_elems, " != ", table.concat(era));
    return table.concat(era);
end

function BP.comp.recorded_secures(blueprint_name)
    if #BP.comp.module == 0 then
        -- Check if there are any modules to secure
        err_msg[1] = "Cannot define a recorded security sequence if ";
        err_msg[2] = "you haven't added modules to secure";
    end
    BP.debug.detect_error();

    local space = BP.used_space.secure;
    BP.comp.secure[blueprint_name] = space;
    -- give the user access to the updated data

    return ":const int secures_" .. blueprint_name .. " " .. space;
end

function BP.comp.add_secure(module_name)
    local secures_idx = 1 + #BP.comp.module;
    local secure_name = module_name:gsub(" ", "") .. "|";

    BP.comp.module[secures_idx] = secure_name;
    local space = #secure_name + BP.used_space.secure;
    BP.used_space.secure = space;
    return ":const int secure_module." .. secures_idx .. " " .. space;
end

function BP.comp.recorded_blueprint(name, loopable)
    --[[/*
        * This function is used to mark the end
        * of a blueprint recording to start making another recording
        * 
        * It returns a const int that holds how much space you used up
        * so that you can take a substring of the compacted string
        * more easily
        * 
        * blueprint_name is used to create the const int name
        * loopable_blueprint determines if this is a blueprint sequence
        * that gets looped or not
       */]]
    if #BP.comp.spell_names == 0 then
        err_msg[1] = "Cannot record a blueprint with no recorded spells";
    elseif type(loopable) ~= "boolean" then
        err_msg[1] = "Loopable flag must be 'true' or 'false'\n";
        err_msg[2] = "recieved ";
        err_msg[3] = loopable;
        err_msg[4] = " of type " .. type(loopable);
    end
    BP.debug.detect_error();

    if loopable then
        local spell_index = #BP.comp.spell;
        BP.comp.spell[spell_index].loop_sign = "#";
        -- `#` means loop, `/` means nothing
    end

    local space = BP.used_space.blueprint;
    -- Get the ammount of space we've currently used up

    local bp_name = name:match([[%b""]]):sub(2, -2);
    -- removes the quote marks from the match operation

    local blueprint = {};
    blueprint.space = space;
    for i = 1, #BP.comp.spell_names do
        blueprint[i] = BP.comp.spell_names[i];
        if blueprint[i]:match("nomatch") == "nomatch" then
            err_msg[1] = "\nFaulty blueprint definition\n";
            err_msg[2] = "Module timer is derived from a module ";
            err_msg[3] = "with ID '" .. blueprint[i]:gsub("nomatch", "");
            err_msg[4] = "' but this recording does not use this module";
            error(table.concat(err_msg), 0);
        end
        blueprint[blueprint[i]] = i;
    end

    BP.comp.spell_names = {};
    -- Clear the spell names for the next blueprint
    BP.comp.blueprint[bp_name] = blueprint;
    --[[/*
        * add an instance to the table so that this value
        * can be accessed in lua
       */]]
    return ":const int blueprint_" .. bp_name .. " " .. space;
end

function BP.comp.blueprint_base(defined_base)
    --[[/*
        * Defines the base at which a loopable blueprint
        * uses the timer. This is used to calculate `tm` such that
        * the active timer is compared to tm, which makes
        * spell activation more precise
       */]]
    local spell = BP.comp.spell[#BP.comp.spell];
    if BP.comp.spell_names[1] == nil then
        err_msg[1] = "Trying to assign a timer_base ";
        err_msg[2] = "without any recorded spells";
    elseif tonumber(defined_base) == nil then
        err_msg[1] = "Trying to define a timer_base as a non number";
    elseif math.type(tonumber(defined_base)) ~= "float" then
        err_msg[1] = "Trying to define a timer_base as a non double";
    end
    BP.debug.detect_error()

    local base_val = tonumber(defined_base);
    spell.timer_base = base_val .. "|";

    local space = tonumber(spell.space:sub(1, -2));
    BP.used_space.blueprint = BP.used_space.blueprint - space;
    -- We also have to update the total ammount of space being used

    space = space + #spell.timer_base - 1 - #spell.space;
    --[[/*
        * Since spell.timer_base originally had a value of `|`
        * space already includes this 1 character. To get an
        * accurate reading, we must subtract this 1.
       */]]

    local used_space = space;
    local prev_space = -1;
    while used_space ~= prev_space do
        prev_space = used_space;
        local value = table.pack(used_space, "|");
        spell.space = table.concat(value);
        used_space = space + #spell.space;
        -- We loop until we're not adding any extra space
    end
    -- And we can end by adding the new used space to the total
    BP.used_space.blueprint = BP.used_space.blueprint + used_space;
end

function BP.comp.sync(spell_ammount)
    -- Perform basic error handling on the parameter
    if tonumber(spell_ammount) == nil then
        err_msg[1] = "Trying to add a non-number as a sync ammount";
    elseif tonumber(spell_ammount) <= 0 then
        err_msg[1] = "Trying to add a sync ammount that's less than 1";
    elseif math.type(tonumber(spell_ammount)) ~= "integer" then
        err_msg[1] = "Trying to assign a non-integer as a sync ammount";
    end
    BP.debug.detect_error();
    --[[/*
        * The sync system prevents the compactor from refreshing its
        * execution budget until all synchronized modules have been used
        * 
        * We subtract the ammount of spells that are synchronized by 1
        * so that the final synchronized spell refreshes the budget
       */]]
    BP.sync_ammount = tonumber(spell_ammount) - 1;
    -- sync_ammount always gets overwritten
end

function BP.comp.add_spell(name, timer, coord_x, coord_y)
    -- Function that records a spell

    local halt_limit = BP.debug.halt_limit == 0 and BP.debug.can_halt;
    --[[/*
        * Check if we should halt the program
        * 
        * We halt if our "halt limit" has been reached
        * or if our spell_debug_stop flag has been set to true
       */]]
    if halt_limit or bp_debug_stop then BP.debug.halt() end

    local spell_names = BP.comp.spell_names;
    -- Add to the spell names we've seen thus far

    local active_name = name:match([[%b""]]):sub(2, -2);
    if active_name == "" then
        error("Trying to add a spell with an empty ID", 0);
    end
    spell_names[active_name] = spell_names[active_name] or (1 + #spell_names);
    spell_names[spell_names[active_name]] = active_name;

    local actives_index = 1 + #BP.comp.spell;
    local new_spell = {};

    new_spell.loop_sign = "/";
    --[[/*
        * loop sign is by default "/" to show that nothing happens
        * aka, our pointer is increased by 2 + space.
        * 
        * When loop_sign is "#", our pointer is reset to 0
        * so that we loop the activation sequence
       */]]
    new_spell.sync = "/";
    new_spell.timer_base = "|";
    local used_space = 3;
    --[[/*
        * Recordings take up space, we keep track
        * of how much space has been used with used_space
        * used_space is currently 3 because sync and loop_sign
        * are length-1 signals and the timer_base is empty by default
       */]]
    if BP.sync_ammount > 0 then
        new_spell.sync = "s";
        BP.sync_ammount = BP.sync_ammount - 1;
    end
    -- "s" means that the script skips refreshing the execution budget

    local parameters = table.pack(coord_x, coord_y, timer);
    local spell_values = table.pack("coord_x", "coord_y", "timer");
    if timer:match([[%b""]]) ~= nil then
        parameters = table.pack(coord_x, coord_y);
        spell_values = table.pack("coord_x", "coord_y");

        timer = timer:match([[%b""]]):sub(2, -2);
        -- remove the quotemarks
        spell_names[timer] = spell_names[timer] or (1 + #spell_names);
        local idx = spell_names[timer];
        spell_names[idx] = spell_names[idx] or timer .. "nomatch";
        new_spell.timer = timer;
    end

    for i = 1, #spell_values do
        local variable = spell_values[i];
        local param = tonumber(parameters[i]);
        if param == nil then
            error("Trying to add a non-number " .. variable, 0);
        elseif math.type(param) ~= "float" then
            error("Trying to add a non-double " .. variable);
        end
        new_spell[variable] = param;
    end
    new_spell.name = active_name;
    spell_values[3] = "timer";
    -- no need to check if timer is already a spell value
    spell_values[4] = "name";

    for i = 1, 4 do
        local value = spell_values[i];
        new_spell[value] = new_spell[value] .. "|";
        used_space = used_space + #new_spell[value];
    end

    local internal_space = used_space;
    local prev = -1
    while prev ~= used_space do
        prev = used_space;
        new_spell.space = used_space .. "|";
        used_space = internal_space + #new_spell.space;
    end
    -- Add the extra space taken up by our space size marker
    used_space = used_space + BP.used_space.blueprint;

    BP.comp.spell[actives_index] = new_spell;
    BP.used_space.blueprint = used_space;

    -- Check if we have to log the added data
    local logging_check = BP.debug.can_halt or BP.debug.can_log;
    if logging_check then BP.debug.log() end

    -- If we can halt, decrement our halting limit by 1
    if BP.debug.can_halt then BP.debug.halt_limit = BP.debug.halt_limit - 1; end
    return ":const int spell_" .. actives_index .. " " .. used_space;
end

function BP.comp.concat_actives()
    local actives = {};

    local spells = BP.comp.spell;
    -- table holding the compacted data
    local spells_count = #spells;
    -- number of spells recorded

    BP.comp.recorded_blueprint([["concat_actives"]], false);
    -- Make sure that the recorded blueprint is valid

    local concat_debug = {};
    if BP.debug.can_display then
        local fmt = BP.debug.concat_format;
        concat_debug.format = fmt;
        concat_debug.separation = " ";
        concat_debug.bit_format = fmt .. "Bit signal %s = '%s'";
        concat_debug.spell_data = fmt .. "%s %s size %s";
    else
        concat_debug.format = "";
        concat_debug.separation = "";
        concat_debug.bit_format = "%s";
        concat_debug.spell_data = "%s";
    end
    concat_debug.chunk_end = "End of recording %s";

    for i = 1, spells_count do
        --[[/*
          * spell data is compacted in the order
          * 
          * loop_sign
          * sync signal
          * timer_base
          * space
          * timer
          * coord_x coord_y
          * name
         */]]
        local data = spells[i];
        local data_pack = {};
        local data_names = table.pack("loop_bit", "sync_bit", "base", "space",
                                      "timer", "coord_x", "coord_y", "name");
        local data_set = {};
        local idx = 1;
        if BP.debug.can_display then
            -- Sets the data_set for the case where we can display
            data_set = table.pack("loop_sign", "sync");
            for _, set in ipairs(data_set) do
                local name = data_names[idx];
                data_pack[name] = table.pack(name:gsub("_bit", ""),
                -- removes the _bit from the name
                                             data[set]);
                idx = idx + 1;
            end
            data_pack.chunk_end = concat_debug.chunk_end:format(i);

            data_set = table.pack("timer_base", "space", "timer", "coord_x",
                                  "coord_y", "name");
        else
            -- Sets the data_set for the case where we can't display
            data_pack.chunk_end = "";
            data_set = table.pack("loop_sign", "sync", "timer_base", "space",
                                  "timer", "coord_x", "coord_y", "name");
        end
        for _, set in ipairs(data_set) do
            local name = data_names[idx];
            data_pack[name] = table.pack(data[set], set, #data[set]);
            idx = idx + 1;
        end

        actives[1 + #actives] = concat_debug.format;
        for _, name in ipairs(data_names) do
            local spell_data = data_pack[name];
            local fmt = "";
            -- Determine the format we're using
            if name:match("_bit") == "_bit" then
                fmt = concat_debug.bit_format;
            else
                fmt = concat_debug.spell_data;
            end
            actives[1 + #actives] = fmt:format(table.unpack(spell_data));
        end
        actives[1 + #actives] = concat_debug.format;
        actives[1 + #actives] = data_pack.chunk_end;
    end

    return table.concat(actives);
end

function BP.debug.log()
    --[[/*
        * Function handles logging logic.
        * It can only be called from BP.comp.add_spell
        * 
        * logging is performed through print() to not stop compilation
       */]]
    local spell_index = #BP.comp.spell;
    local spell = BP.comp.spell[spell_index];
    local logging_text = table.pack("%s| BP has %s: '%s'\n"); --[[/*
           * list of the logging messages
           * There were more messages here, but they've been
           * removed.
           * 
           * I'm keeping it a table just in case I need
           * to add more messages
          */]]
    local logging_values = table.pack("name", "sync", "loop_sign", "timer",
                                      "timer_base", "coord_x", "coord_y",
                                      "space"); --[[/*
        * List of values that get logged
        * in the same order they're listed here
       */]]

    local values_index_for_space = 8;
    -- Indicates what value means we're logging space

    local text = "| Logging spell number %s:\n|\n";
    local log = text:format(spell_index);
    --[[/*
        * Our log is built within the string `log`;
        * The string `text` is the text we're adding to the log
        * and then we use string.format(text, log, other values)
        * which is truncated to text:format(log, other values);
       */]]
    for i, value in ipairs(logging_values) do
        text = logging_text[1];
        local spell_value = spell[value];
        if spell_value == nil then
            err_msg = "Cannot log nil value " .. value;
            error(err_msg);
        end
        local fmt = table.pack(log, value, spell_value);
        if i == values_index_for_space then
            text = "%s| Summing up to a total space of %s\n"
            fmt = table.pack(log, spell_value);
        end
        log = text:format(table.unpack(fmt));
    end
    print(log);
    -- And finally, we print our formatted log
end

function BP.debug.halt()
    --[[/*
        * Function handles halting logic.
        * It's access points are 
        * * BP.comp.add_spell
        * * BP Config
        * 
        * halting is performed through error() to stop compilation
       */]]
    local should_halt = BP.debug.can_halt or BP.debug.can_display;
    if not should_halt then return end
    -- We return if we shouldn't halt

    local halt_text = table.pack("\n",
                                 "Compilation stopped, debug mode enabled\n",
                                 "Output has been modified by a spell_debug macro");
    if BP.debug.can_log then
        local halt_logging = table.pack("\n",
                                        "Logging enabled, logs are visible ",
                                        "in your browsers developer console");
        for _, text in ipairs(halt_logging) do
            halt_text[1 + #halt_text] = text;
        end
    end
    if BP.debug.can_display then
        local halt_display = table.pack("\n", "Output formatting enabled\n",
                                        "Every component of the output will begin ",
                                        "with the string inputed in ",
                                        "spell_debug.display_format\n",
                                        "Retrieving output showing ",
                                        #BP.comp.spell, " ");
        if #BP.comp.spell == 1 then
            halt_display[9] = "recording";
        else
            halt_display[9] = "recordings";
        end
        halt_display[10] = BP.comp.concat_actives();
        for _, text in ipairs(halt_display) do
            halt_text[1 + #halt_text] = text;
        end
    end
    error(table.concat(halt_text), 0);
end
