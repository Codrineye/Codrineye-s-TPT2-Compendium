dofile("TPT2 Scripting/Codrineye's Compactors/Factory Compactor/lua factory/factory_macros.lua");
local function item(name, tiers, game_name)
  return Factory.add_item(name, tiers, game_name, "item");
end

local function make(name, tiers, game_name)
  return Factory.add_item(name, tiers, game_name, "craft");
end

local function group(name, tiers)
  return Factory.add_item(name, tiers, "ore", "group");
end

local function special(name, tiers, game_name)
  return Factory.add_item(name, tiers, game_name, "special");
end

local function category(name, default, first, last)
  return Factory.add_category(name, default, first, last);
end

make("arcade_producer", 5, "producer.arcade")
make("construction_firm_producer", 5, "producer.constructionFirm")
make("exotic_producer", 1, "producer.exoticgems")
make("factory_producer", 5, "producer.factory")
make("gem_producer", 1, "producer.gems")
make("headquarters_producer", 5, "producer.headquarters")
make("laboratory_producer", 5, "producer.laboratory")
make("mine_producer", 5, "producer.mine")
make("museum_producer", 5, "producer.museum")
make("powerplant_producer", 5, "producer.powerplant")
make("pumpkin_producer", 1, "pumpkin.producer")
make("shipyard_producer", 5, "producer.shipyard")
make("statue_of_cubos_producer", 5, "producer.statueofcubos")
make("town_producer", 5, "producer.town")
make("tradingpost_producer", 5, "producer.tradingpost")
make("workshop_producer", 5, "producer.workshop")

make("acceleration_booster", 3, "booster.acceleration")
make("machine_booster", 3, "booster.machines")
make("production_booster", 3, "booster.production.regular")
make("resource_booster", 3, "booster.resource.drops")
make("tree_booster", 3, "booster.trees")

category("prod", "town_producer", "arcade_producer", "resource_booster")

make("assembly", 10, "machine.assembler")
make("belt", 10, "machine.transportbelt")
make("boiler", 10, "machine.boiler")
make("crusher", 10, "machine.crusher")
make("cutter", 10, "machine.cutter")
make("mixer", 10, "machine.mixer")
make("oven", 10, "machine.oven")
make("presser", 10, "machine.presser")
make("refiner", 10, "machine.refinery")
make("shaper", 10, "machine.shaper")

category("mach", "belt", "assembly", "shaper")

make("block", 10, "block")
make("chip", 5, "chip")
make("hammer", 1, "hammer")
make("lump", 9, "lump")
make("insul_cable", 10, "cable.insulated")
make("motor", 10, "motor")
make("pump", 10, "pump")
make("rainbow_dust", 1, "dust.rainbow")
make("rubber_sapling", 1, "sapling.rubber")
make("stacked_plate", 10, "plate.stack")
make("stacked_pumpkin", 1, "pumpkin.stack")
make("void_sapling", 1, "sapling.void")

category("crft", "chip", "block", "void_sapling")

special("ore", 10, "ore")
special("crushable_ore", 10, "ore")
special("mixable_lump", 9, "lump")

group("all", 10)
group("chips", 1)
group("chip_and_prods", 5)
group("machines", 10)
group("parts", 10)
group("producers", 5)

category("grup", "all", "all", "producers")


item("anti_pumpkin", 1, "pumpkin.anti")
item("board", 10, "plate.circuit")
item("cable", 10, "cable")
item("carved_pumpkin", 1, "pumpkin.carved")
item("circuit", 10, "circuit")
item("dense_block", 10, "block.dense")
item("dense_plate", 10, "plate.dense")
item("dust", 10, "dust")
item("ingot", 10, "ingot")
item("pipe", 10, "pipe")
item("plate", 10, "plate")
item("pumpkin_plate", 1, "pumpkin.plate")
item("rainbow_ingot", 1, "ingot.rainbow")
item("rainbow_plate", 1, "plate.rainbow")
item("ring", 10, "ring")
item("rod", 10, "rod")
item("rubber_plate", 1, "plate.rubber")
item("screw", 10, "screw")
item("wire", 10, "wire")

category("part", "circuit", "anti_pumpkin", "wire")

item("void_essence", 1, "essence.void")
item("pumpkin", 1, "pumpkin")
item("rubber", 1, "rubber")
