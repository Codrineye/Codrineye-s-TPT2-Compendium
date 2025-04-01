dofile("TPT2 Scripting/Codrineye's Compactors/Factory Compactor/lua factory/factory_constants.lua");

Factory.recipes = {};
Factory.recipe_item = {};

function Factory.recipe(item)
  local recipe_item = Factory.item_names[item];

  if recipe_item == nil then
    error(string.format("Unknown item '%s'", item));
  elseif recipe_item.recipes ~= nil then
    error(string.format("Duplicate recipe for '%s'", item));
  end

  Factory.recipe_item = recipe_item;
  local offset = 10 * recipe_item.id;
  --[[/*
    * There are two types of recipe list that we store:
    * A "forward" list stored on the item itself, which records what
    * items are needed to *make* that item, and a "reverse" list
    * stored on the main factory object and indexed by queue id,
    * which records what items can be *made from* the item.
    * The forward list is used by the item group system, while the
    * reverse list is used by the recipe system proper.
  */]]
  for i = offset, offset + recipe_item.tier - 1 do
    if Factory.recipes[i] == nil then
      Factory.recipes[i] = {};
    end
  end
  recipe_item.recipes = {};
  for i = 1, recipe_item.tier do
    recipe_item.recipes[i] = {};
  end
end

function Factory.component(tiers, item_name, counts)
  local recipe_item = Factory.recipe_item;
  if recipe_item == nil then
    error("Tried to define a component before calling recipe!", 0);
  end
  local name = item_name:gsub(" ", "");
  local item = Factory.item_names[name];
  if not item then
    error(string.format("Unknown item '%s'", name));
  end

  if item.craft_type == "group" then
    error(string.format(
      [[Cannot add item "%s" because it is a group]],
      item.name
    ));
  end
  local tier_tmp = {};
  for word in tiers:gmatch("%S+") do
    local tier = tonumber(word);
    if tier == nil then
      error(string.format("Bad tier '%s'", word));
    end
    tier_tmp[1 + #tier_tmp] = tier;
  end
  if #tier_tmp ~= 1 and #tier_tmp ~= recipe_item.tier then
    error(string.format(
      "Tiers list has wrong size, item %s has %s tiers",
      recipe_item.name, recipe_item.tier
    ));
  end
  local base_tier;
  for tier = 1, recipe_item.tier do
    base_tier = tier_tmp[tier] or base_tier;
    local tmp_tier = base_tier;
    tier_tmp[tier] = tmp_tier < 1 and (tmp_tier + tier) or tmp_tier;
  end

  local counts_tmp = {};
  for word in counts:gmatch("%S+") do
    local count = tonumber(word);
    if count == nil then
      error(string.format("Bad count '%s'", word));
    end
    counts_tmp[1 + #counts_tmp] = count;
  end

  if #counts_tmp ~= 1 and #counts_tmp ~= recipe_item.tier then
    error(string.format(
      "Counts ist has wrong size, item %s has %s tiers",
      recipe_item.name, recipe_item.tier
    ));
  end

  for i = 1 + #counts_tmp, recipe_item.tier do
    counts_tmp[i] = counts_tmp[i - 1];
  end
  --[[/*
    * Finally, merge the two expanded lists and distribute
    * the results across the recipes for each tier. These recipes are
    * "reversed", in the sense that they don't describe how to make
    * each item, but rather all the items that this one can be used
    * to help make.
    * It's this reversed list that is needed for computing
    * the material needs when crafting.
  */]]
  local recipes = Factory.recipes;
  local offset = recipe_item.id * 10 - 1;

  local function tier_n_count_merge(item_tier)
    local tier = tier_tmp[item_tier];
    local count = counts_tmp[item_tier];
    if count <= 0 or tier <= 0 then return; end
    --[[/*
      * Tiers less than 1 can happen naturally, due to the negative
      * tier convention, so they are silently dropped.
      * Tiers greater than the maximum number of tiers are an error
    */]]
    if tier > item.tier then
      error(string.format(
        "Tier %s > item max tier %s",
        tier, item.tier
      ));
    end
    local idx = item.id * 10 + tier - 1;
    local comp = recipes[idx];
    if comp == nil then
      comp = {};
      recipes[idx] = comp;
    end

    comp[1 + #comp] = offset + item_tier;
    comp[1 + #comp] = count;
    local item_recipe = recipe_item.recipes[item_tier];
    item_recipe[1 + #item_recipe] = idx;
    item_recipe[1 + #item_recipe] = count;
  end

  for i = 1, recipe_item.tier do
    tier_n_count_merge(i);
  end
end

function Factory.produce(item, source, mult, machine)
  local recipe_item = Factory.item_names[item];

  if not recipe_item then
    error(string.format("Unknown item '%s'", item));
  elseif recipe_item.recipes ~= nil then
    error(string.format("Duplicate recipe for '%s'", item));
  end

  local source_item = Factory.item_names[source];
  if not source_item then
    error(string.format("Unknown item '%s'", source));
  elseif source_item.tier ~= recipe_item.tier then
    error(string.format(
      "Tier mismatch: %s(%s) vs %s (%s)",
      source, source_item.tier, item, recipe_item.tier
    ));
  end
  do
    local prods = Factory.prods;
    if #prods == 0 or prods[#prods].machine ~= machine then
      if Factory.prod_machines[machine] ~= nil then
        error("Found 2nd group for machine '" .. machine .. "'", 0);
      end
      Factory.prod_machines[machine] = 1 + #prods;
      Factory.prod_machines[1 + #Factory.prod_machines] = machine;
    end
  end
  local prod = {};
  prod.item = recipe_item;
  prod.source = source_item;
  prod.mult = mult;
  prod.machine = machine;
  Factory.prods[1 + #Factory.prods] = prod;

  local offset = 10 * source_item.id;
  local count = 1 / mult;
  for i = offset, offset + recipe_item.tier - 1 do
    if Factory.recipes[i] == nil then
      Factory.recipes[i] = {};
    end
    local recipe = Factory.recipes[i];
    recipe[1 + #recipe] = 10 * recipe_item.id - offset + i;
    recipe[1 + #recipe] = count;
  end
  recipe_item.recipes = {};
  for i = 1, recipe_item.tier do
    local recipe = {};
    recipe[1] = offset + i - 1;
    recipe[2] = count;
    recipe_item.recipes[i] = recipe;
  end
end

local function recipe(item)
  Factory.recipe(item);
end

local function component(tiers, item, counts)
  Factory.component(tiers, item, counts);
end

local function produce(item, source, mult, machine)
  Factory.produce(
    item,
    source:gsub(" ", ""),
    mult,
    machine:gsub(" ", "")
  );
end

local function recipe_producers(x)
  local producers = {
    "town_producer",
    "factory_producer",
    "mine_producer",
    "workshop_producer",
    "construction_firm_producer",
    "laboratory_producer",
    "headquarters_producer",
    "powerplant_producer",
    "arcade_producer",
    "tradingpost_producer",
    "shipyard_producer",
    "museum_producer",
    "statue_of_cubos_producer"
  }
  for i = 1, #producers do
    component("0", producers[i], x);
  end
end

local function recipe_parts()
  component("0", "insul_cable", "1");
  component("0", "stacked_plate", "1");
  component("0", "motor", "1");
  component("0", "pump", "1");
  component("1", "hammer", "0 1 0 0 0 0 0 0 0 0");
  component("0", "block", "1");
  component("0", "ingot", "1");
  component("0", "plate", "1");
  component("0", "dense_plate", "1");
  component("0", "dense_block", "1");
  component("0", "pipe", "1");
  component("0", "cable", "1");
  component("0", "wire", "1");
  component("0", "rod", "1");
  component("0", "ring", "1");
  component("0", "screw", "1");
  component("0", "board", "1");
  component("0", "circuit", "1");
  component("0", "rubber_plate", "1 0 0 0 0 0 0 0 0 0");
  component("1", "rubber_sapling", "0 0 0 0 0 0 0 0 1 0");
end

local function recipe_machines_and_parts()
  component("0", "oven", "1");
  component("1", "presser", "0 1 0 0 0 0 0 0 0 0");
  component("0", "presser", "0 1 1 1 1 1 1 1 1 1");
  component("0", "assembly", "1");
  component("0", "refiner", "1");
  component("0", "mixer", "1");
  component("0", "crusher", "1");
  component("0", "belt", "1");
  component("0", "cutter", "1");
  component("0", "shaper", "1");
  component("0", "boiler", "1");
  recipe_parts();
end

local recipes = [[
{recipe(town_producer)}
{component(2 3 5 7 9, screw, 2 4 4 4 4)}
{component(2 0 0 0 0, plate, 2 0 0 0 0)}
{component(0 3 5 7 9, board, 0 2 2 2 6)}
{component(-1, chip, 0 2 2 2 4)}
{component(-1, town_producer, 1)}

{recipe(factory_producer)}
{component(1 3 5 7 9, wire, 1 4 4 4 4)}
{component(2 0 0 0 0, screw, 1 0 0 0 0)}
{component(0 3 5 7 9, board, 0 1 1 1 3)}
{component(2 3 5 0 0, plate, 2 2 2 0 0)}
{component(0 0 0 7 9, dense_plate, 0 0 0 2 4)}
{component(1 1 2 3 4, chip, 2 1 1 1 3)}
{component(-1, factory_producer, 1)}

{recipe(mine_producer)}
{component(2 3 5 7 9, screw, 2 2 2 4 4)}
{component(1 2 4 6 8, wire, 2 3 2 5 5)}
{component(2 0 5 7 9, plate, 1 0 1 2 2)}
{component(0 3 5 7 9, dense_plate, 0 2 2 2 2)}
{component(1 1 2 3 4, chip, 1)}
{component(-1, mine_producer, 1)}

{recipe(workshop_producer)}
{component(0 2 4 6 8, wire, 0 4 2 8 8)}
{component(1 3 5 7 9, wire, 4 2 2 2 2)}
{component(2 3 5 7 9, plate, 1 2 2 2 2)}
{component(1 0 2 3 4, chip, 1 0 2 2 2)}
{component(-1, workshop_producer, 1)}

{recipe(construction_firm_producer)}
{component(2 4 6 8 10, rod, 3 4 10 10 10)}
{component(2 4 6 8 10, plate, 2)}
{component(1 1 2 3 4, chip, 1 2 2 2 2)}
{component(-1, construction_firm_producer, 1)}

{recipe(laboratory_producer)}
{component(0 3 5 7 9, pipe, 0 3 5 10 14)}
{component(2 4 6 8 10, motor, 1)}
{component(1 3 5 7 9, dense_plate, 2 2 4 4 6)}
{component(0, chip, 3 2 4 4 6)}
{component(-1, laboratory_producer, 1)}

{recipe(headquarters_producer)}
{component(1 3 5 7 9, wire, 2 4 8 8 12)}
{component(2 4 6 8 10, motor, 1 2 2 2 2)}
{component(0, chip, 3 2 4 4 6)}
{component(-1, headquarters_producer, 1)}

{recipe(powerplant_producer)}
{component(1 3 5 7 9, insul_cable, 2 2 4 4 6)}
{component(2 4 6 8 10, motor, 1)}
{component(0 3 5 7 9, block, 0 3 5 5 14)}
{component(0, chip, 3 2 4 4 6)}
{component(-1, powerplant_producer, 1)}

{recipe(arcade_producer)}
{component(2 4 6 8 9, insul_cable, 4 6 6 6 6)}
{component(2 4 6 8 10, pipe, 4 4 4 4 8)}
{component(0, chip, 4 4 4 4 6)}
{component(-1, arcade_producer, 1)}

{recipe(tradingpost_producer)}
{component(2 4 6 8 10, ring, 6 8 8 8 12)}
{component(2 4 6 8 10, plate, 4)}
{component(0, chip, 2 2 2 2 4)}
{component(-1, tradingpost_producer, 1)}

{recipe(shipyard_producer)}
{component(2 4 6 8 10, insul_cable, 6 8 8 8 12)}
{component(1 3 5 7 9, block, 4)}
{component(0, chip, 2 2 2 2 4)}
{component(-1, shipyard_producer, 1)}

{recipe(museum_producer)}
{component(3 5 7 9 10, insul_cable, 6 7 7 7 9)}
{component(2 4 6 8 10, block, 4 5 5 5 7)}
{component(0, chip, 2 2 2 2 4)}
{component(-1, museum_producer, 1)}

{recipe(statue_of_cubos_producer)}
{component(1 3 5 7 9, dense_block, 4 5 5 5 7)}
{component(2 4 6 8 10, motor, 2)}
{component(2 4 6 8 10, pipe, 2)}
{component(2 4 6 8 10, pump, 2 3 3 3 5)}
{component(0, chip, 2 2 2 2 4)}
{component(-1, statue_of_cubos_producer, 1)}

{recipe(gem_producer)}
{component(5, chip, 10)}
{component(4, chip, 10)}
{component(10, insul_cable, 2)}
{component(1, dense_block, 1)}
{component(2, dense_block, 1)}
{component(3, dense_block, 1)}
{component(4, dense_block, 1)}
{component(5, dense_block, 1)}
{component(6, dense_block, 1)}
{component(7, dense_block, 1)}
{component(8, dense_block, 1)}
{component(9, dense_block, 1)}
{component(10, dense_block, 1)}

{recipe(exotic_producer)}
{component(5, chip, 10)}
{component(10, insul_cable, 2)}
{component(10, dense_block, 10)}
{component(10, assembly, 1)}
{component(10, boiler, 1)}
{component(10, crusher, 1)}
{component(10, cutter, 1)}
{component(10, mixer, 1)}
{component(10, oven, 1)}
{component(10, presser, 1)}
{component(10, refiner, 1)}
{component(10, shaper, 1)}
{component(10, belt, 1)}

{recipe(acceleration_booster)}
{component(2 3 5, chip, 1 4 6)}
{component(4, plate, 4 0 0)}
{component(1, rainbow_plate, 0 2 4)}
{component(4 8 0, circuit, 4 8 0)}
{component(10, dense_block, 0 0 12)}
{component(1, void_essence, 0 0 4)}
{component(-1, acceleration_booster, 2)}

{recipe(machine_booster)}
{component(2 3 5, chip, 2)}
{component(4 7 10, pipe, 4)}
{component(4, wire, 2 0 0)}
{component(0 7 10, dense_block, 0 2 2)}
{component(8, dense_plate, 0 6 0)}
{component(1, rainbow_plate, 0 0 4)}
{component(1, void_essence, 0 0 2)}
{component(4, circuit, 1 0 0)}
{component(-1, machine_booster, 1)}

{recipe(production_booster)}
{component(1 3 0, chip, 4 4 0)}
{component(2 7 0, plate, 4 6 0)}
{component(2 7 10, circuit, 1 4 4)}
{component(10, dense_block, 0 0 12)}
{component(1, void_essence, 0 0 4)}
{component(-1, production_booster, 0 1 4)}

{recipe(resource_booster)}
{component(3, plate, 6 0 0)}
{component(1, rainbow_plate, 0 0 2)}
{component(1 3 4, chip, 2 2 6)}
{component(4 8 0, circuit, 1 2 0)}
{component(0 7 10, block, 0 4 4)}
{component(1, void_essence, 0 0 1)}
{component(-1, resource_booster, 0 1 2)}

{recipe(tree_booster)}
{component(7, block, 0 2 0)}
{component(2 0 5, chip, 1 0 2)}
{component(5 7 0, screw, 6 2 0)}
{component(5, ring, 2 0 0)}
{component(7, plate, 0 2 0)}
{component(7, pipe, 0 2 0)}
{component(1, rainbow_plate, 0 0 2)}
{component(1, rubber_sapling, 6 0 0)}
{component(1, void_sapling, 0 0 6)}
{component(1, void_essence, 0 0 10)}
{component(-1, tree_booster, 1)}

{recipe(pumpkin_producer)}
{component(0, carved_pumpkin, 6)}
{component(0, anti_pumpkin, 6)}
{component(0, pumpkin_plate, 20)}

{recipe(oven)}
{component(0, plate, 4 6 8 8 8 8 8 8 8 8)}
{component(0, insul_cable, 2 2 3 3 3 4 4 4 4 4)}
{component(0, block, 0 0 0 0 0 2 2 2 2 2)}
{component(-1, oven, 1)}

{recipe(presser)}
{component(1, hammer, 2 0 0 0 0 0 0 0 0 0)}
{component(0, plate, 4 5 7 7 7 9 9 9 9 9)}
{component(0, wire, 1 1 2 2 2 3 3 3 3 3)}
{component(0, block, 0 0 0 0 4 5 5 5 5 5)}
{component(1 1 1 2 2 2 3 3 4 4, chip, 2)}
{component(-1, presser, 1)}

{recipe(assembly)}
{component(0, pipe, 1 1 1 1 1 2 2 2 2 2)}
{component(0, dense_plate, 6 5 8 8 8 10 10 10 12 12)}
{component(0, motor, 1 1 1 1 1 1 1 1 2 2)}
{component(1 1 1 2 2 2 3 3 4 4, chip, 1 1 1 1 1 1 1 1 1 2)}
{component(-1, assembly, 1)}

{recipe(refiner)}
{component(0, block, 0 0 0 0 0 0 5 5 5 7)}
{component(0, dense_plate, 4)}
{component(0, motor, 1 1 1 1 2 2 2 2 2 4)}
{component(0, ring, 1 2 2 2 3 3 3 3 3 5)}
{component(0, pump, 1 2 2 2 3 3 3 3 3 5)}
{component(1 1 2 2 2 2 3 4 4 5, chip, 2)}
{component(-1, refiner, 1)}

{recipe(mixer)}
{component(0, dense_plate, 5 4 4 5 5 6 6 6 6 6)}
{component(0, motor, 2)}
{component(0, pump, 1 1 1 2 2 3 3 3 3 3)}
{component(1 1 1 2 2 2 2 3 4 4, chip, 1 1 1 2 2 3 3 3 3 3)}
{component(-1, mixer, 1)}

{recipe(crusher)}
{component(0, dense_plate, 7 8 8 8 8 8 8 9 9 9)}
{component(0, motor, 1 1 1 1 1 1 1 2 2 2)}
{component(1 1 1 2 2 2 2 2 4 4, chip, 1 2 2 2 2 2 2 3 3 3)}
{component(-1, crusher, 1)}

{recipe(belt)}
{component(1, rubber, 3 4 4 4 4 0 0 0 0 0)}
{component(1, rubber_plate, 0 0 0 0 0 4 5 5 5 5)}
{component(0, motor, 3 3 3 3 3 3 4 4 4 4)}
{component(0, insul_cable, 3 4 4 4 4 4 5 5 5 5)}
{component(0 0 0 1 2 2 3 3 4 4, chip, 0 0 0 4 4 4 5 5 5 5)}
{component(-1, belt, 1)}

{recipe(cutter)}
{component(0, plate, 2 2 2 2 2 2 2 0 0 0)}
{component(0, dense_plate, 3 3 3 3 3 4 4 2 2 2)}
{component(0, block, 0 0 0 0 0 0 0 4 4 6)}
{component(0, motor, 3 4 4 4 4 5 5 5 5 7)}
{component(-1, cutter, 1)}

{recipe(shaper)}
{component(0, plate, 4 4 4 4 4 4 4 4 4 0)}
{component(0, dense_plate, 0 0 0 0 0 0 0 0 0 4)}
{component(0, screw, 1 2 2 2 2 3 3 3 3 3)}
{component(0, block, 1 2 2 2 2 3 3 3 3 0)}
{component(0, dense_block, 0 0 0 0 0 0 0 0 0 5)}
{component(0, motor, 2)}
{component(0, insul_cable, 1 1 1 1 1 2 2 2 2 4)}
{component(-1, shaper, 1)}

{recipe(boiler)}
{component(0, wire, 2 2 2 3 3 3 3 3 4 5)}
{component(0, dense_plate, 2 2 2 3 3 3 3 3 4 5)}
{component(0, block, 4 7 7 8 8 8 8 8 9 10)}
{component(0, motor, 1 1 1 2 2 2 2 2 3 4)}
{component(0, screw, 2)}
{component(0, pump, 1)}
{component(-1, boiler, 1)}

{recipe(rainbow_dust)}
{component(1, dust, 1)}
{component(2, dust, 1)}
{component(3, dust, 1)}
{component(4, dust, 1)}
{component(5, dust, 1)}
{component(6, dust, 1)}
{component(7, dust, 1)}
{component(8, dust, 1)}
{component(9, dust, 1)}
{component(10, dust, 1)}

{recipe(chip)}
{component(1 3 5 7 9, circuit, 2)}
{component(2 4 6 8 10, circuit, 2 4 4 2 2)}
{component(1 3 5 7 9, board, 1 4 4 6 8)}
{component(2 4 6 8 10, board, 1 2 2 6 8)}
{component(-1, chip, 0 4 8 12 12)}

{recipe(insul_cable)}
{component(0, cable, 1 1 1 2 3 4 5 10 12 16)}
{component(1, rubber, 1 2 0 0 0 0 0 0 0 0)}
{component(1, rubber_plate, 0 0 2 4 6 8 10 10 12 16)}

{recipe(stacked_plate)}
{component(0, plate, 9)}

{recipe(stacked_pumpkin)}
{component(0, pumpkin, 9)}

{recipe(motor)}
{component(0, plate, 4)}
{component(0, screw, 1)}
{component(0, rod, 2)}
{component(0, wire, 1)}
{component(1, rubber, 1)}

{recipe(pump)}
{component(0, plate, 2)}
{component(0, motor, 1)}
{component(0, ring, 2)}
{component(1, rubber_plate, 4)}

{recipe(hammer)}
{component(2, ingot, 6)}
{component(2, rod, 1)}

{recipe(block)}
{component(0, dense_plate, 8 8 8 8 8 8 12 12 12 12)}

{recipe(rubber_sapling)}
{component(0, rubber, 8)}
{component(9, ore, 1)}

{recipe(void_sapling)}
{component(1, rainbow_dust, 8)}
{component(1, rubber_sapling, 1)}

{recipe(producers)}
{recipe_producers(1)}

{recipe(machines)}
{component(0, oven, 1)}
{component(0, presser, 1)}
{component(0, assembly, 1)}
{component(0, refiner, 1)}
{component(0, mixer, 1)}
{component(0, crusher, 1)}
{component(0, belt, 1)}
{component(0, cutter, 1)}
{component(0, shaper, 1)}
{component(0, boiler, 1)}

{recipe(parts)}
{recipe_parts}

{recipe(chips)}
{component(1, chip, 1)}
{component(2, chip, 1)}
{component(3, chip, 1)}
{component(4, chip, 1)}
{component(5, chip, 1)}

{recipe(chip_and_prods)}
{component(0, chip, 1)}
{recipe_producers(1)}

{recipe(all)}
{component(0, chip, 1 1 1 1 1 0 0 0 0 0)}
{recipe_producers(1 1 1 1 1 0 0 0 0 0)}
{recipe_machines_and_parts}

{produce(rainbow_ingot, rainbow_dust, 1, oven)}

{produce(plate, ingot, 1, presser)}
{produce(rainbow_plate, rainbow_ingot, 1, presser)}
{produce(dense_plate, stacked_plate, 1, presser)}
{produce(rubber_plate, rubber, 1, presser)}
{produce(pumpkin_plate, stacked_pumpkin, 1, presser)}

{produce(dense_block, block, 1, boiler)}
{produce(anti_pumpkin, pumpkin, 1, boiler)}

{produce(rod, ingot, 2, shaper)}
{produce(pipe, plate, 1, shaper)}
{produce(ring, rod, 1, shaper)}

{produce(cable, ingot, 2, refinery)}
{produce(board, plate, 1, refinery)}
{produce(wire, cable, 1, refinery)}

{produce(screw, rod, 4, cutter)}
{produce(carved_pumpkin, pumpkin, 1, cutter)}

{produce(circuit, cable, 1, assembler)}

{recipe(dust)}
{recipe(lump)}
{recipe(ingot)}

{recipe(ore)}
{recipe(crushable_ore)}
{recipe(mixable_lump)}
{recipe(rubber)}
{recipe(void_essence)}
{recipe(pumpkin)}
]]

for line in recipes:gmatch("[^\n]+") do
  local name = line:match("[^%(]+");
  -- Macro that determines what action is being performed

  assert(name, "No macro could be found on action " .. line);
  local args = {};
  -- Store all of our macro arguments

  local macro_args = line:match("%b()");

  if macro_args then
    -- If the macro has multiple arguments, we need to get them all
    macro_args = macro_args:sub(2, -2)
    -- Remove the parentheses from macro_args

    name = name:sub(2)
    -- Remove the beining parentheses from name

    local arg_count = 0;
    for arg in macro_args:gmatch("[^,]+") do
      arg_count = arg_count + 1;
      if arg == nil then
        error("Cannot compute arg " .. arg_count .. " from " .. macro_args);
      end
      args[arg_count] = arg;
    end
  else
    name = name:sub(2, -2);
  end
  -- list of all macro names
  local macro_names = {
    "recipe", "component", "produce",
    "recipe_producers", "recipe_parts", "recipe_machines_and_parts"
  }
  -- list of the addresses the macro can call
  local macro_calls = {
    recipe, component, produce,
    recipe_producers, recipe_parts, recipe_machines_and_parts
  }
  local macro = nil;
  local inc = 0;
  while inc < #macro_names do
    inc = inc + 1;
    if name == macro_names[inc] then
      macro = macro_calls[inc];
      inc = #macro_names + inc;
    end
  end
  if macro == nil then
    error("Count not recognize macro call " .. line .. " with macro name " .. name);
  end
  macro(table.unpack(args));
end

for i = 1, #Factory.items do
  if not Factory.items[i].recipes then
    local item = Factory.items[i];
    error(string.format(
      "%s(%s) has no assigned recipe!",
      item.name, item.id
    ));
  end
end
