local factory_item_limit = 89;

Factory = {};

Factory.cq = {}; -- Make the queue part of the Factory table

Factory.items = {};
Factory.item_names = {};

Factory.prods = {};
Factory.prod_machines = {};

Factory.categories = {};
Factory.group_map = {};
Factory.group_map.item = 0;
Factory.group_map.craft = 1;
Factory.group_map.group = 2;
Factory.group_map.special = 2; -- Intentionally the same

Factory.name_max_size = 0;
Factory.game_name_sizes = {};
Factory.game_name_sizes.item = 0;
Factory.game_name_sizes.craft = 0;
Factory.game_name_sizes.group = 0;
Factory.game_name_sizes.special = 0;

function Factory.add_item(name, tiers, game_name, craft_type)
  local item = {};
  item.id = 1 + #Factory.items;
  if item.id > factory_item_limit then
    -- throw an error if we got more items than we permit
    error(string.format(
      "Too many items: cannot add more than %s items",
      factory_item_limit
    ));
  elseif tiers == 0 then
    error("Items cannot have tier 0");
    -- minimum tiers value we can manage is 1
  end
  local params = table.pack(name, game_name, tiers, craft_type);
  local item_names = table.pack("name", "game_name", "tier", "craft_type");
  for i = 1, #params do
    local val = params[i];
    local val_name = item_names[i];
    if val == nil then
      error(string.format("Trying to add an empty value '%s'", val_name));
    end
    item[val_name] = val;
  end
  Factory.items[item.id] = item;
  Factory.item_names[name] = item;

  if #name > Factory.name_max_size then Factory.max_name_size = #name; end
  if #game_name > Factory.game_name_sizes[craft_type] then
    Factory.game_name_sizes[craft_type] = #game_name;
  end
  local const = ":const int factory." .. name .. " " .. item.id;
  return const;
end

function Factory.add_category(name, ...)
  local category = {};
  category.name = name;
  local names = table.pack("default", "first", "last");
  local args = table.pack(...);
  for i = 1, 3 do
    local trimmed = args[i]:gsub("^ +", "");
    local item = Factory.item_names[trimmed];
    if not item then
      error(string.format("Can't find item '%s'", trimmed));
    end
    category[names[i]] = item.id;
  end
  Factory.categories[1 + #Factory.categories] = category;
end
function Factory.composite_string(var, filter, use_group_info)
  local acc = {};
  local size = 0;
  local first = #Factory.items;
  local last = 0;
  local group_map = Factory.group_map;

  if filter == nil then
    size = math.max(
      Factory.game_name_sizes["item"],
      Factory.game_name_sizes["craft"]
    );
  else
    size = Factory.game_name_sizes[filter];
  end
  size = size + 1;
  local fmt = "%-" .. size .. "s%d";
  size = size + 1;
  for items = 1, #Factory.items do
    local item = Factory.items[items];
    if filter == nil or item.craft_type == filter then
      if use_group_info then
        acc[1 + #acc] = fmt:format(item.game_name, group_map[item.craft_type]);
      else
        acc[1 + #acc] = fmt:format(item.game_name, item.tier - 1);
      end
      if items < first then first = items; end
      if items > last then last = items; end
    end
  end
  Factory.items_count = last - first + 1;
  Factory.entry_size = size;
  return table.concat(acc);
end
