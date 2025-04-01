dofile("TPT2 Scripting/Codrineye's Compactors/Factory Compactor/lua factory/recipes.lua")

-- Debugging function, kept in case of future problems.
local function debug_dump_recipes()
  -- change true to false to catch any evaluation issues
  if true then
    return;
  end
  local acc = {};
  for i = 1, #Factory.items do
    local item = Factory.items[i];
    acc[#acc+1] = string.format("%02d %-25s [", i, item.name);
    for tier = 1, item.tier do
      acc[#acc+1] = string.format("\n%5s", "");
      acc[#acc+1] = "(";
      local recipes = Factory.recipes[i * 10 + tier - 1];
      if not recipes then
        error(table.concat(acc));
      end
      for recipe = 1, #recipes do
        if recipe ~= 1 then
          acc[#acc+1] = " ";
        end
        acc[#acc+1] = string.format("%03f", recipes[recipe]);
      end
      acc[#acc+1] = ")";
    end
    acc[#acc+1] = "\n]\n";
  end
  -- Change true to false to see the evaluation of all recipes
  if true then
    return;
  end
  error(table.concat(acc), 0);
end

debug_dump_recipes()

--[[/*
  * Now that all the recipes are defined, we have to put them in a
  * valid order. We do this with a modified breadth-first-search, optimized
  * around the structure of our data. Each item (which in this context is
  * a type-tier pair, identified by the formula type * 10 + tier) is
  * sequentially checked against a graph that is incrementally being formed.
  * If all its recipe-items have already been satisfied (or it has none),
  * then it is also satisfied, and (as long as it has recipe-items) it's put
  * on a queue to be output. Otherwise, a count is kept of how many
  * unsatisfied recipes it has, and an entry is made in each blocking recipe
  * pointing back to this item. After each item, the queue is processed.
  * The head of the queue is popped and gets the next sequential id
  * this is how the recipes get their order. Also, any items blocked on it
  * will have their tallies decremented by one. If these go to zero,
  * they are now satisfied and will be added to the queue to be output,
  * as well.
*/]]
do
  local recipes_list = {};
  Factory.recipes_list = recipes_list;
  local items = Factory.items;
  local recipes = Factory.recipes;
  local graph = {};
  local inc = 0;
  local function analyze(id)
    local recipe = recipes[id];

    -- Stop item analysis if there's no recipe
    if not recipe then
      return;
    end

    local entry = graph[id];
    if not entry then
      entry = {};
      entry.blocking = {};
      graph[id] = entry;
    end

    local blockers = 0;
    for i = 1, #recipe, 2 do
      local other = graph[recipe[i]];
      if not other then
        other = {};
        other.blocking = {};
        other.blockers = -1;
        graph[recipe[i]] = other;
      end
      if other.blockers ~= 0 then
        blockers = blockers + 1;
        other.blocking[#other.blocking + 1] = id;
      end
    end

    entry.blockers = blockers;
    local queue = {};
    if blockers == 0 then
      queue[1] = id;
    end

    local q_front = 1;
    while q_front <= #queue do
      local q_id = queue[q_front];
      entry = graph[q_id];
      recipes_list[#recipes_list + 1] = q_id;
      for i = 1, #entry.blocking do
        local other = graph[entry.blocking[i]];
        other.blockers = other.blockers - 1;
        if other.blockers == 0 then
          queue[#queue + 1] = entry.blocking[i];
        end
      end
      q_front = q_front + 1;
    end
  end

  for tier = 10, 1, -1 do
    for item = 1, #items do
      analyze(10 * item + tier - 1);
      inc = inc + 1;
    end
  end
end

-- Debugging function, kept in in case of future problems
local function debug_dump_recipes_list()
  -- change true to false to catch any evaluation issues
  if true then
    return;
  end
  local acc = {};
  for list = 1, #Factory.recipes_list do
    local id = Factory.recipes_list[list];
    acc[#acc+1] = string.format("%03d:", id);
    local recipes = Factory.recipes[id];
    for i = 1, #recipes do
      acc[#acc+1] = string.format(" %03f", recipes[i]);
    end
    acc[#acc+1] = "\n";
  end
  -- change true to false to see the error message
  if true then
    return;
  end
  error(table.concat(acc));
end

debug_dump_recipes_list();

--[[/*
  * Constructs the data table that is used to create loop_data. See below
  * for the format of this string. One difference is that in loop_data,
  * the previous item/current item index data is at the beginning and end
  * of the string. Here, that is actually only stored once, and the sub()
  * read window is expanded to overlap consequetive sections to pick up
  * the previous item when reading the next.
*/]]
local function get_data(num_terms)
  assert(tonumber(num_terms), "Inputed num_terms of get_data is not a number");
  local num_terms_2 = num_terms * 2;
  local recipe_limit = 0;
  local acc_main = {};

  local multipliers = "0123a   b   c   d   e   f   g   h   i   j   k   l   m   n   o   p   q   r   s  t   u   v   w   x   y   z";
  -- letters from a to z with 3 spaces inbetween

  local mult_max = {};
  for i = 0, num_terms do
    mult_max[i] = 0;
  end
  acc_main[1] = [["___]];

  for list = 1, #Factory.recipes_list do
    local id = Factory.recipes_list[list];
    local recipes = Factory.recipes[id];
    local limit = (#recipes - 1) // num_terms_2;
    if limit < 0 then
      limit = 0;
    end
    for i = 1, num_terms_2 * (limit + 1), 2 do
      if i < #recipes then
        acc_main[1 + #acc_main] = recipes[i] + 100;
      else
        acc_main[1 + #acc_main] = "   ";
        -- 3 spaces to mark the end of a list of recipes
      end
      local mod = 1 + (i // 2) % num_terms;
      local mult = 0;
      if i < #recipes then
        mult = 4 * recipes[i + 1];
      end
      if mult > mult_max[mod] then
        mult_max[mod] = mult;
      end
      acc_main[1 + #acc_main] = multipliers:sub(mult + 1, mult + 1);
      -- Extract just 1 character

      if mod == num_terms then
        acc_main[1 + #acc_main] = id + 100;
        recipe_limit = 1 + recipe_limit;
      end
    end
  end
  Factory.main_size = 4 * num_terms + 3;
  acc_main[#acc_main+1] = [["]];
  Factory.multipliers = {};
  Factory.num_terms = num_terms;
  Factory.recipe_limit = recipe_limit;

  for i = 1, num_terms do
    if mult_max[i] >= #multipliers then
      error("Multiplier limit reached at " .. i);
    end
    Factory.multipliers[i] = multipliers:sub(1, mult_max[i] + 1);
  end
  return table.concat(acc_main)
end

local function lookup_item()
  local acc = {};
  local group_map = Factory.group_map;

  local size = 1 + math.max(
    Factory.game_name_sizes["item"],
    Factory.game_name_sizes["craft"]
  );
  local fmt = "%-" .. size .. "s%d";
  size = size + 1;
  for items = 1, #Factory.items do
    local item = Factory.items[items];
    acc[#acc+1] = fmt:format(item.game_name, group_map[item.craft_type])
  end
  Factory.items_count = #Factory.items;
  return table.concat(acc), size;
end

--[[/*
  * Returns the set of lookup/multiplier terms that will be added
  * in to form the base of the value.
  * Most of the data for this is pre-comupted by get_data().
*/]]
local function recipe_terms()
  local acc = {};
  for i = 1, Factory.num_terms do
    if i ~= 1 then
      acc[#acc+1] = " + ";
    end
    acc[#acc + 1] = string.format(
      [[max(0.0, ceil(global.double.get("cq" . sub(loop_data, %d, 3)) *
        i2d(index("%s", sub(loop_data, %d, 1), 0)) * 0.25))]],
      Factory.entry_size + 4 * i - 1,
      Factory.multipliers[i],
      Factory.entry_size + 4 * i + 2
    );
  end
  return table.concat(acc);
end

--[[/*
  * This is used to test the type of an item, in order to efficiently
  * disable the count. Item groups don't have a single real item associated,
  * but the count() still has to count something real to avoid a spurious
  * log line. Ore and lumps are also classified as groups so that they won't
  * be counted, because they're treated specially.
*/]]
local function item_types()
  return string.format([[sub(loop_data, %d, 1)]], Factory.entry_size - 1);
end

--[[/*
  * These are used to test if the item is a dust.
  * Dust gets its queue value inflated by one, which has the effect
  * of always ending up with 1 at the end.
  * (Although it doesn't prevent temporarily using all dust.)
*/]]
local function recipe_item_trunc()
  return string.format(
    [[sub(loop_data, %d, 2)]],
    Factory.entry_size + Factory.main_size
  );
end

local function item_trunc(item)
  return string.format('"%d"', Factory.item_names[item].id + 10);
end

local function prev_item()
  return string.format(
    [[sub(loop_data, %d, 3)]],
    Factory.entry_size
  );
end

-- The tier value is just the last digit of recipe_item
local function tier_value()
  return string.format(
    [[sub(loop_data, %d, 1)]],
    2 + Factory.entry_size + Factory.main_size
  );
end

local function recipe_item_name()
  return [[sub(loop_data, 0, index(loop_data, " ", 0))]];
end

local data_name = get_data(4);

for i = 0, Factory.recipe_limit do
  --[[/*
    * Evaluates to an expression that results in an string containing
    * encoded data for this recipe. The first entry_size-1 characters are the
    * in-game item name, space-padded. Then comes the item type info:
    * 0 is a regular item, 1 is a crafted item, and 2 is an item-group.
    * After that is a series of 3-number strings, each of which is
    * a craft-queue index.
    * The first is the index for the previous item, which is used to
    * determine if this is a continuation from a previous line.
    * The next `num_terms` terms are index values for queue values to add.
    * After each term is a single character which is a multiplier value.
    * Following that is an index for the current item, which is used as
    * the index to set, and possibly also as an index to read from.
    *
    * All of this is pulled from reading the appropriate sections of "data",
    * mostly as-is. However, there is a secondary lookup for the item name.
  */]]
  local item, size = lookup_item();
  local offset = tonumber(data_name:sub(Factory.main_size * (i + 1), Factory.main_size * (i + 1) + 2))
  if not offset then
    offset = -1;
  end
  offset = size * (offset - 11)
  local loop_data = item:sub(
    offset,
    offset + size
  ) .. data_name:sub(
    i * Factory.main_size,
    3 + (i + 1) * Factory.main_size
  );
  local data_extraction_offset = size + Factory.main_size;
  local recipe_item = loop_data:sub(data_extraction_offset, data_extraction_offset + 3);

  Factory.cq[recipe_item] = 0;

  --[[/*
    * The core expression that does all the work. If this item is the
    * target item, then set the queue value to factory_target_amount
    * - this ensures that the target is always made,
    * even if it already exists. Otherwise, we set it to the sum of
    * all of its recipe terms, minus the existing count. This core value is
    * the "queue value", and equals how many must be
    * crafted (if positive) or how many extra we have (if negative).
    * Since we are hardcoding the number of recipe terms that are handled
    * in each loop iteration to a small constant (4), there are additional
    * wrinkles because we may need to process the same item multiple times to
    * get all the recipe terms in. This means that if we're seeing
    * the same item again, we add the previous value of the variable
    * and skip subtracting the count. We also skip the count if the item
    * is a group, since those don't have valid items to count anyway.
    * In this way, we efficiently encode a sum that requires multiple passes.
global.double.set({raw_name({recipe_item})}, if(\
  {recipe_item} == i2s(factory_target + 100),\
  factory_target_amount,\
  if(\
    {prev_item} == {recipe_item}, \
    global.double.get({queue_str} . {recipe_item}),\
    0.0\
  ) + {recipe_terms} - if(\
    {item_type} == "2" || {prev_item} == {recipe_item},\
    0.0,\
    count({recipe_item_name}, index(" 0123456789", {tier_value}, 0))\
    - if({recipe_item_trunc} == {item_trunc(dust)}, 1.0, 0.0)\
  )\
))
  */]]
end
