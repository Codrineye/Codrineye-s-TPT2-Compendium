Spell = {};

-- Table holding information needed for debugging
Spell.debug = {};
Spell.debug.can_log = false;
Spell.debug.can_halt = false;
Spell.debug.halt_limit = 0;
Spell.debug.can_display = false;
Spell.debug.concat_format = "";

-- Table holding information needed for recording
Spell.active = {};
Spell.active.space = 0;
Spell.active.loop_sign = "n";
Spell.active.pointer_mult = 1;
Spell.active.sync_ammount = 0;

-- Table that has spell_compactor data
Spell.comp = {};
Spell.comp.active = {};
-- Internal method to terminate the program for debugging
local spell_debug_stop = false;

function Spell.comp.add_blueprint(blueprint_name, loopable_blueprint)
  --[[/*
      * Adding a blueprint marks the end of this recording "chunk"
      * it creates a const int that holds the ammount of space you
      * have recorded so that you can easily cut out that part from
      * the compacted string
      *
      * This function takes in
      * * a blueprint name
      * * a marker to determine if this recording loops or not
      *
     */]]
  if loopable_blueprint then
    Spell.active.loop_sign = "l";
  end
  local bp_name = blueprint_name:match('%b""'):sub(2, -2);
  bp_name = string.format("blueprint_%s", bp_name);

  local space = Spell.active.space;
  return string.format(":const int %s %s", bp_name, space)
  --[[/*
      * Returned value is used by user to take an index in a
      * substring to extract the desired recorded sequence
     */]]
end
function Spell.comp.sync(spell_ammount)
  --[[/*
      * Sync system prevents the compactor from refreshing its budget
      * until all synchronized spells have been use.instant/position
     */]]
  local sync = tonumber(spell_ammount);
  if sync < 0 then
    error(string.format(
      "Attempt to add a negative sync ammount at spell nr %s\n",
      1 + #Spell.comp.active
    ));
  end
  sync = math.max(1, sync) - 1;
  --[[/*
      * max operation prevents sync_ammount from being negative
      * value in spell.active.sync_ammount always gets overwritten
      *
      * decrement sync_ammount to take into account the parent spell
     */]]
  Spell.active.sync_ammount = sync;
end

function Spell.comp.add_spell(name, timer, coord_x, coord_y)
  -- Function that records a spell

  local dbug = Spell.debug;
  local halt_limit = dbug.halt_limit == 0;
  halt_limit = halt_limit and dbug.can_halt;
  --[[/*
      * Check if we should halt the program
      *
      * We halt if our halt limit has been reached
      * or if our spell_debug_stop flag has been set to true
     */]]

  if halt_limit or spell_debug_stop then
    Spell.debug.halt();
  end

  local match_string = [[%b""]];
  local active_name = name:match(match_string):sub(2, -2);

  local actives_index = 1 + #Spell.comp.active;
  local new_spell = {};

  new_spell.pointer_mult = Spell.active.pointer_mult;
  --[[/*
      * Record the pointer multiplier and then set it to 1,
      * Must be reset to 1 in case we added a blueprint
     */]]
  Spell.active.pointer_mult = 1;

  new_spell.sync = 0;
  local used_space = 2;
  --[[/*
      * Recordings take up space
      * We keep the space we take up in this variable
      * It currently holds 2 because pointer_mult and sync are
      * length-1 signals, so together they take up 2 units of space
     */]]

  local sync = Spell.active.sync_ammount;
  if sync > 0 then
    new_spell.sync = 1;
    Spell.active.sync_ammount = sync - 1;
    --[[/*
        * Signals that we don't refresh the execution budget
        * Decrement our sync ammount
       */]]
  end
  new_spell.name = active_name;
  --[[/*
       * Check to see if the spell_type is grounded
       * if it is, we've got to include our coordinates
      */]]
  local parameters = table.pack(timer, coord_x, coord_y);
  local spell_values = table.pack("timer", "coord_x", "coord_y");

  for i, variable in ipairs(spell_values) do
    local value = tonumber(parameters[i]);
    new_spell[variable] = {};
    new_spell[variable] = 0.0 + value
    --[[/*
        * the addition with 0.0 here is to guarantee the correct data type.
        * timer, coord_x, coord_y need to be doubles for the actions
        * waitwhile() and vec().
        * float and double are the same type in this editor
       */]]
  end
  spell_values[4] = "name";

  local sizes = table.pack(
    "timer_size",
    "size_x", "size_y",
    "name_size"
  );
  for i, variable in ipairs(spell_values) do
    local size = sizes[i];
    new_spell[size] = {};
    new_spell[size] = #tostring(new_spell[variable]);
    used_space = used_space + new_spell[size];
    --[[/*
        * Get the ammount of characters in each variable
        * and add this ammount to our used_space
       */]]
  end
  for i, size in ipairs(sizes) do
    local size_of_size = string.format("%s_size", size);
    new_spell[size_of_size] = {};
    new_spell[size_of_size] = #tostring(new_spell[size]);
    used_space = used_space + 1 + new_spell[size_of_size];
    --[[/*
        * Get the size of each variables size
        * then add these to the used space
        * we add 1 to it because we've also got
        * a marker telling us this size
       */]]
  end

  new_spell.space = used_space;
  new_spell.space_size = #tostring(used_space);
  new_spell.space_size_size = #tostring(new_spell.space_size);

  used_space = used_space + new_spell.space_size_size;
  used_space = used_space + new_spell.space_size;

  Spell.comp.active[actives_index] = new_spell;
  Spell.active.space = Spell.active.space + used_space;
  --[[/*
      * Add the space used in this recording to our
      * overall used space
     */]]

  --[[/*
      * Check if we're logging or
      * if compilation should be halted
      *
      * Remember that dbug is the same as Spell.debug
      * in this function
     */]]
  local logging_check = dbug.can_halt or dbug.can_log;
  if logging_check then
    Spell.debug.log();
  end
  if dbug.can_halt then
    Spell.debug.halt_limit = dbug.halt_limit - 1;
  end
end

function Spell.comp.concat_actives()
  local spells = {};
  -- table holding the compacted data

  local actives = Spell.comp.active;
  local debug = Spell.debug;
  -- access our recordings

  local actives_count = #actives;
  -- nr of recordings

  actives[actives_count].pointer_mult = 0;
  -- Set the last multiplier to 0 to enables sequence looping

  local concat_debug = {};
  concat_debug.format = "";
  concat_debug.separation = "";
  concat_debug.chunk_end = "";

  if Spell.debug.can_display then
    concat_debug.format = Spell.debug.concat_format;
    concat_debug.separation = " ";
    concat_debug.chunk_end = "End of recording %s";
  end

  for i = 1, actives_count do
    --[[/*
        * Spell data is compacted in the order
        *
        * space_size_size - space_size - space
        * sync signal
        * timer_size_size - timer_size - timer
        * if spell is grounded
        * * size_x_size - size_x - coord_x
        * * size_y_size - size_y - coord_y
        * otherwise
        * * 1 1 0
        * * 1 1 0
        * name_size_size - name_size - name
        * pointer_mult signal
       */]]
    local active_data = actives[i];
    local spell_data = table.pack(
      concat_debug.format,
      concat_debug.format, active_data.space_size_size,
      concat_debug.separation, active_data.space_size,
      concat_debug.separation, active_data.space,
      -- Recording starts off with the space it takes up

      concat_debug.format, active_data.sync,
      --[[/*
          * And then the spell data used by the compactor,
          * which begins with the sync check
         */]]
      concat_debug.format, active_data.timer_size_size,
      concat_debug.separation, active_data.timer_size,
      concat_debug.separation, active_data.timer,
      -- Adds the spell timer

      concat_debug.format, active_data.size_x_size,
      concat_debug.separation, active_data.size_x,
      concat_debug.separation, active_data.coord_x,
      -- Adds the spells x coord

      concat_debug.format, active_data.size_y_size,
      concat_debug.separation, active_data.size_y,
      concat_debug.separation, active_data.coord_y,
      -- Adds the spells y coord

      concat_debug.format, active_data.name_size_size,
      concat_debug.separation, active_data.name_size,
      concat_debug.separation, active_data.name,
      -- Adds the spells name

      concat_debug.format, active_data.pointer_mult,
      concat_debug.format, concat_debug.chunk_end:format(i)
    );

    for _, data in ipairs(spell_data) do
      spells[1 + #spells] = data;
    end
  end

  local str_fmt = [["%s"
  return str_fmt:format(table.concat(spells));
end
function Spell.debug.log()
  --[[/*
      * Function handles logging logic.
      * It can only be called from Spell.comp.add_spell
      *
      * logging is performed through print() to not stop compilation
     */]]
  local active = Spell.comp.active;
  local spell_index = #active;
  local spell = active[spell_index];

  local logging_text = table.pack(
    "%s| Spell has %s: '%s'\n",
    "%s| with a size of: %s\n",
    "%s| which itself has a size of: %s\n"
  ); -- list of the logging messages

  local logging_values = table.pack(
    "name", "name_size", "name_size_size",
    "sync", "pointer_mult",
    "timer", "timer_size", "timer_size_size",
    "coord_x", "size_x", "size_x_size",
    "coord_y", "size_y", "size_y_size",
    "space", "space_size", "space_size_size"
  );
  --[[/*
      * List of values that get logged
      * in the same order they're listed here
     */]]
  local logging_matches = table.pack(
    3,    -- name
    1, 1, -- sync and pointer_mult
    3,    -- timer
    3, 3, -- coord_x/y
    3     -- space
  ); -- How to match the logging values to the logging_text

  local values_index = 1;
  -- Keeps track of what value we're looking at
  local values_index_for_space = 15
  -- Indicates what values_index means we're logging space

  local text = "| Logging spell number %s:\n\n";
  local log = text:format(spell_index);
  --[[/*
      * Our log is built within the string `log`;
      * The string `text` is the text we're adding to the log
      * and then we use string.format(text, log, other values)
      * which is truncated to text:format(log, other values);
     */]]
  for _, matches in ipairs(logging_matches) do
    --[[/*
        * `for i = 1, matches`
        * is equivalent to
        * `while i <= matches`
       */]]
    for i = 1, matches do
      text = logging_text[i];
      -- Get the matching logging text

      local value = logging_values[values_index];
      local spell_value = spell[value] or "nil";
      --[[/*
          * Gets our logging_value
          * If its respecitve value exists then
          * * spell_value = spell[value]
          * else
          * * spell_value = "nil" to signal that
          * * something has gone wrong
          *
        */]]
      local fmt = table.pack(log, spell_value);
      if i == 1 then
        fmt = table.pack(log, value, spell_value);
      end
      --[[/*
          * This is our format.
          * Usually, this is just (log, spell_value)
          * If i == 1 then we're adding logging_text[1]
          * which needs:
          * * log
          * * name of the value we're logging
          * * value of our recorded spell
          *
        */]]
      if values_index == values_index_for_space then
        --[[/*
            * We are logging space.
            * This value has a special case since it
            * changes both our text and fmt
           */]]
        text = "%s| Summing up to a total of %s\n";
        fmt = table.pack(log, spell_value);
        -- We need to change fmt here because this case is when i == 1
      end
      log = text:format(table.unpack(fmt));
      values_index = 1 + values_index;
      -- We now update the log and increment our values_index
    end
  end
  print(log);
  -- And finally, we print our formatted log
end

function Spell.debug.halt()
  --[[/*
      * Function handles halting logic.
      * It's access points are
      * * Spell.comp.add_spell
      * * Spell Config
      *
      * halting is performed through error() to stop compilation
     */]]
  local debug = Spell.debug;
  local should_halt = debug.can_halt or debug.can_display;
  if not should_halt then return end
  -- We return if we shouldn't halt

  local compactor = Spell.comp;
  local halt_text = table.pack(
    "\n",
    "Compilation stopped, debug mode enabled\n",
    "Output has been modified by a spell_debug macro"
  );
  if debug.can_log then
    local halt_logging = table.pack(
      "\n",
      "Logging enabled, logs are visible ",
      "in your browsers developer console"
    );
    for _, text in ipairs(halt_logging) do
      halt_text[1 + #halt_text] = text;
    end
  end
  if debug.can_display then
    local halt_display = table.pack(
      "\n",
      "Output formatting enabled\n",
      "Every component of the output will begin ",
      "with the string inputed in ",
      "spell_debug.display_format\n",
      "Retrieving output showing ",
      #compactor.active,
      " "
    );
    if #compactor.active == 1 then
      halt_display[9] = "recording";
    else
      halt_display[9] = "recordings";
    end
    halt_display[10] = compactor.concat_actives();
    for _, text in ipairs(halt_display) do
      halt_text[1 + #halt_text] = text;
    end
  end
  error(table.concat(halt_text), 0);
end
