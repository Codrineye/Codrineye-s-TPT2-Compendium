BP = {};

--[[Table holding information needed for debugging]]
BP.debug = {};
BP.debug.can_log = false;
BP.debug.can_halt = false;
BP.debug.halt_limit = 0;
BP.debug.can_display = false;
BP.debug.concat_format = "";

--[[Table that has data needed in compacting data]]
BP.used_space = {};
BP.used_space.secure = 0;
BP.used_space.active = 0;

BP.sync_ammount = 0;

--[[Table that has compactor specific data]]
BP.comp = {};

--[[Store the software security levels]]

BP.comp.software = {}
--[[Store the module secures]]
BP.comp.secure = {};

--[[Blueprint activation]]
BP.comp.active = {};
BP.comp.blueprint = {};

--[[Internal method to terminate the program for debugging]]
local bp_debug_stop = false;

--[[list of all the software]]
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
for _, soft in ipairs(software_list) do BP.comp.software[soft] = -50; end

function BP.comp.add_software(software, level)
    local err_msg;
    local soft = BP.comp.software;
    local sec = level:match([[%b""]]):sub(2, -2):gsub(" ", "");
    if soft[software] == nil then
        err_msg = "Attempt to assign a security level to an " ..
                      "unrecognized software\n" .. "If this is a new " ..
                      "software, an update to the compactor should " ..
                      "be released soon";
    elseif soft[software] ~= -50 then
        err_msg = "Trying to assign a security level to " ..
                      "an already set software";
        --[[/*
          * Smallest security level I've seen is -1, 
          * so -50 should never be assigned naturally
         */]]
    elseif tonumber(sec) == nil then
        err_msg = "Trying to assing an empty security level";
    elseif math.type(tonumber(sec)) ~= "integer" then
        err_msg = "Trying to assign a non-integer security level";
    end

    --[[Throw an error if we have an error message]]
    if err_msg then error(err_msg, 0) end

    local software_name = string.format("software.%s", software);
    local lvl = string.rep(" ", #software_name - #sec);
    sec = string.format("%s%s", sec, lvl);
    BP.comp.software[software] = sec;
end

function BP.comp.concat_software(concat_mode)
    local modes = {};
    modes.software_list = true;
    modes.software_secure = true;
    assert(modes[concat_mode], "Invalid concat_mode.\n" ..
               "If you're seeing this, you're either a user that messed " ..
               "with something you shouldn't have, or I messed up");
    local software = "";

    local secure_fmt = "%s%s|";
    local software_fmt = "software.%s";
    for _, soft in ipairs(software_list) do
        local concat_val = "";
        if concat_mode == [[software_list]] then
            concat_val = software_fmt:format(soft);
        else
            concat_val = BP.comp.software[soft];
        end
        software = secure_fmt:format(software, concat_val);
    end
    return string.format([["%s"]], software);
end

function BP.comp.recorded_secures(blueprint_name)
    assert(#BP.comp.secure, "Attempt to define a security recording before " ..
               "adding a module to secure");
    local space = BP.used_space.secure;
    local const = [[:const int secures_%s %s]];
    return const:format(blueprint_name, space);
end
function BP.comp.add_secure(module_name)
    local secures_idx = 1 + #BP.comp.secure;
    local secure_name = string.format("%s|", module_name:gsub(" ", ""));
    BP.comp.secure[secures_idx] = secure_name;
    BP.used_space.secure = #secure_name + BP.used_space.secure;
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
    if loopable then
        local active_index = #BP.comp.active;
        BP.comp.active[active_index].loop_sign = "#";
        --[[/*
          * Changes the loop sign to `#` so that we can
          * easily check it with a contains of the full spell
         */]]
    end

    local space = BP.used_space.active;
    --[[Get the ammount of space we've currently used up]]
    local bp_name = name:match([[%b""]]):sub(2, -2);
    --[[removes the quote marks from the match operation]]
    BP.comp.blueprint[bp_name] = space;
    --[[/*
        * And create a blueprint that stores
        * How much space we've used up thus far
       */]]
    bp_name = string.format("blueprint_%s", bp_name);
    --[[change the bp_name so we can output it as a const int]]
    return string.format(":const int %s %s", bp_name, space)
end

function BP.comp.blueprint_base(defined_base)
    --[[/*
        * Defines the base at which a loopable blueprint
        * uses the timer. This is used to calculate `tm` such that
        * the active timer is compared to tm, which makes
        * spell activation more precise
       */]]
    local err_msg = "";
    local spell = BP.comp.active[#BP.comp.active];

    if spell == nil then
        err_msg = "Trying to add a timer_base without any recorded spells";
    elseif tonumber(defined_base) == nil then
        err_msg = "Trying to define a timer_base as a non number";
    elseif math.type(tonumber(defined_base)) ~= "float" then
        err_msg = "Trying to define a timer_base as a non double";
    end
    if err_msg == "" then error(err_msg, 0) end

    local spell_fmt = "%s|"
    BP.comp.active[#BP.comp.active].timer_base = spell_fmt:format(defined_base);
    local space = tonumber(BP.comp.active[#BP.comp.active].space:sub(1, -2));
    BP.used_space.active = BP.used_space.active - space;
    --[[We also have to update the total ammount of space being used]]

    space = -1 + space + #BP.comp.active[#BP.comp.active].timer_base;
    --[[/*
        * We substract by 1 since the space variable already has
        * the space of 1 from the default state of `|`
       */]]
    local used_space = space;
    local prev_space = -1;
    while used_space ~= prev_space do
        prev_space = used_space;
        spell.space = spell_fmt:format(used_space);
        used_space = space + #BP.comp.active[#BP.comp.active].space;
        --[[We loop until we're not adding any extra space]]
    end
    --[[And we can end by adding the new used space to the total]]
    BP.used_space.active = BP.used_space.active + used_space;
end

function BP.comp.sync(spell_ammount)
    --[[/*
        * The synchronization system prevents the
        * script from refreshing the budget untill
        * all synchronized spells have been used.
       */]]

    local sync = tonumber(spell_ammount);
    assert(sync >= 0, "Trying to add a negative sync_ammount");
    --[[Synchronizing less than 1 spell is meaningless]]

    sync = sync - 1;
    --[[/*
        * We subtract 1 from the sync_ammount
        * to cover the first spell
        * 
        * Sync_ammount always gets overwritten
       */]]
    BP.sync_ammount = sync;
end

function BP.comp.add_spell(name, timer, coord_x, coord_y)
    --[[Function that records a spell]]

    local dbug = BP.debug;
    local halt_limit = dbug.halt_limit == 0 and dbug.can_halt;
    --[[/*
        * Check if we should halt the program
        * 
        * We halt if our halt limit has been reached
        * or if our spell_debug_stop flag has been set to true
       */]]
    if halt_limit or bp_debug_stop then BP.debug.halt(); end

    local active_name = name:match([[%b""]]):sub(2, -2);

    local actives_index = 1 + #BP.comp.active;
    local new_spell = {};

    new_spell.loop_sign = "/";
    --[[/*
        * loop sign is by default "/" to show that nothing happens
        * aka, our pointer is increased by 2 + space.
        * 
        * When loop_sign is "#", our pointer is reset to 0
        * to loop our sequence
       */]]
    new_spell.sync = "/";
    new_spell.timer_base = "|";
    local used_space = 3;
    --[[/*
        * Recordings take up space, we keep track
        * of how much space has been used with used_space
        * used_space is currently 3 because, sync and loop_sign
        * are length-1 signals and the timer_base is empty by default
       */]]
    local sync = BP.sync_ammount;
    if sync > 0 then
        new_spell.sync = "s";
        BP.sync_ammount = sync - 1;
    end
    --[["s" means that the script skips refreshing the budget.]]
    new_spell.name = active_name;

    local parameters = table.pack(timer, coord_x, coord_y);
    local spell_values = table.pack("timer", "coord_x", "coord_y");

    for i, variable in ipairs(spell_values) do
        local value = tonumber(parameters[i]);
        new_spell[variable] = {};
        new_spell[variable] = 0.0 + value
        --[[/*
          * the addition with 0.0 here is to guarantee 
          * the correct data type.
          * timer, coord_x and coord_y need to be doubles 
          * for the actions waitwhile() and vec().
          * float and double are the same type in this editor
         */]]
    end
    spell_values[4] = "name";
    for _, variable in ipairs(spell_values) do
        new_spell[variable] = string.format("%s|", new_spell[variable]);
        used_space = used_space + #new_spell[variable];
        --[[/*
          * string.format converts the value in
          * new_spell[variable] into a string. Meaning that
          * I no longer have to convert the value to a string myself
         */]]
    end

    local internal_space = used_space;
    local prev = -1
    while prev ~= used_space do
        prev = used_space;
        new_spell.space = string.format("%s|", used_space);
        used_space = internal_space + #new_spell.space;
    end
    --[[/*
        * Add the extra space taken up by our signal bits
        * and space recording.  We add our space here so that
        * we don't have to pass through the entire string an extra time
       */]]

    BP.comp.active[actives_index] = new_spell;
    BP.used_space.active = BP.used_space.active + used_space;

    local logging_check = dbug.can_halt or dbug.can_log;
    if logging_check then BP.debug.log() end

    if dbug.can_halt then BP.debug.halt_limit = dbug.halt_limit - 1; end
    --[[/*
        * Check if we're logging or
        * if compilation should be halted
        * 
        * Remember that dbug is the same as BP.debug
        * in this function
       */]]
    local spell_number = string.format("spell_%s", actives_index);
    local const_txt = ":const int %s %s";
    return const_txt:format(spell_number, BP.used_space.active);
end

function BP.comp.concat_actives()
    local spells = {};
    --[[table holding the compacted data]]

    local actives = BP.comp.active;
    local dbug = BP.debug;
    --[[access our recordings]]

    local actives_count = #actives;
    --[[nr of recordings]]

    do
        local identifier = [["BP.comp.Define_entire_blueprint"]]
        BP.comp.recorded_blueprint(identifier, false);
    end
    --[[/*
        * Record the final blueprint to the BP.comp.Blueprint table
        * without forcing the blueprint to be in a loop
        * 
        * I'm doing this in a do...end block so that the identifier
        * doesn't linger in the rest of the code
       */]]

    local concat_debug = {};
    concat_debug.format = "";
    concat_debug.separation = "";
    concat_debug.bit_format = "%s";
    concat_debug.spell_data = "%s";
    concat_debug.chunk_end = "End of recording %s";

    if dbug.can_display then
        local fmt = dbug.concat_format;
        concat_debug.format = fmt;
        concat_debug.separation = " ";
        concat_debug.bit_format = fmt .. "Bit signal %s = '%s'";
        concat_debug.spell_data = fmt .. "%s %s size %s";
    end

    for i = 1, actives_count do
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
        local data_pack = {};
        do
            local data = actives[i];
            if dbug.can_display then
                data_pack.loop_bit = table.pack("loop", data.loop_sign);
                data_pack.sync_bit = table.pack("sync", data.sync);

                data_pack.base = table.pack(data.timer_base, "timer_base",
                                            #data.timer_base);
                data_pack.space = table.pack(data.space, "space", #data.space);
                data_pack.timer = table.pack(data.timer, "timer", #data.timer);

                data_pack.coord_x = table.pack(data.coord_x, "coord_x",
                                               #data.coord_x);
                data_pack.coord_y = table.pack(data.coord_y, "coord_y",
                                               #data.coord_y);

                data_pack.name = table.pack(data.name, "name", #data.name);
                data_pack.chunk_end = concat_debug.chunk_end:format(i);
            else
                data_pack.loop_bit = table.pack(data.loop_sign);
                data_pack.sync_bit = table.pack(data.sync);

                data_pack.base = table.pack(data.timer_base);

                data_pack.space = table.pack(data.space);
                data_pack.timer = table.pack(data.timer);

                data_pack.coord_x = table.pack(data.coord_x);
                data_pack.coord_y = table.pack(data.coord_y);

                data_pack.name = table.pack(data.name);
                data_pack.chunk_end = "";
            end
        end

        local spell_data = table.pack(concat_debug.format,

                                      concat_debug.bit_format:format(
                                          table.unpack(data_pack.loop_bit)),
        --[[Adds the loop_sign bit]]

                                      concat_debug.bit_format:format(
                                          table.unpack(data_pack.sync_bit)),
        --[[adds the sync signal bit]]
                                      concat_debug.spell_data:format(
                                          table.unpack(data_pack.base)),

                                      concat_debug.spell_data:format(
                                          table.unpack(data_pack.space)),
        --[[Adds the space we take up]]
                                      concat_debug.spell_data:format(
                                          table.unpack(data_pack.timer)),
        --[[Adds the spell timer]]

                                      concat_debug.spell_data:format(
                                          table.unpack(data_pack.coord_x)),
        --[[Adds the spells x coord]]
                                      concat_debug.spell_data:format(
                                          table.unpack(data_pack.coord_y)),
        --[[Adds the spells y coord]]

                                      concat_debug.spell_data:format(
                                          table.unpack(data_pack.name)),
        --[[Adds the spells name]]

                                      concat_debug.format, data_pack.chunk_end);

        for _, data in ipairs(spell_data) do spells[1 + #spells] = data; end
    end

    local str_fmt = [["%s"]]
    return str_fmt:format(table.concat(spells));
end
function BP.debug.log()
    --[[/*
        * Function handles logging logic.
        * It can only be called from BP.comp.add_spell
        * 
        * logging is performed through print() to not stop compilation
       */]]
    local active = BP.comp.active;
    local spell_index = #active;
    local spell = active[spell_index];

    local logging_text = table.pack("%s| BP has %s: '%s'\n"); --[[/*
           * list of the logging messages
           * There were more messages here, but they've been
           * removed.
           * 
           * I'm keeping it a table just in case I need
           * to add more messages
          */]]
    local logging_values = table.pack("name", "sync", "loop_sign", "timer",
                                      "coord_x", "coord_y", "space"); --[[/*
        * List of values that get logged
        * in the same order they're listed here
       */]]

    local values_index_for_space = 7
    --[[Indicates what value means we're logging space]]

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
        local spell_value = spell[value] or "nil";
        --[[/*
          * Gets our spell_value
          * If its respecitve value exists then 
          * * spell_value = spell[value]
          * else
          * * spell_value = "nil" to signal that
          * * something has gone wrong
          * 
        */]]

        local fmt = table.pack(log, value, spell_value);
        if i == values_index_for_space then
            text = "%s| Summing up to a total space of %s\n"
            fmt = table.pack(log, spell_value);
        end
        log = text:format(table.unpack(fmt));
    end
    print(log);
    --[[And finally, we print our formatted log]]
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
    local debug = BP.debug;
    local should_halt = debug.can_halt or debug.can_display;
    if not should_halt then return end
    --[[We return if we shouldn't halt]]

    local halt_text = table.pack("\n",
                                 "Compilation stopped, debug mode enabled\n",
                                 "Output has been modified by a spell_debug macro");
    if debug.can_log then
        local halt_logging = table.pack("\n",
                                        "Logging enabled, logs are visible ",
                                        "in your browsers developer console");
        for _, text in ipairs(halt_logging) do
            halt_text[1 + #halt_text] = text;
        end
    end
    if debug.can_display then
        local halt_display = table.pack("\n", "Output formatting enabled\n",
                                        "Every component of the output will begin ",
                                        "with the string inputed in ",
                                        "spell_debug.display_format\n",
                                        "Retrieving output showing ",
                                        #BP.comp.active, " ");
        if #BP.comp.active == 1 then
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
