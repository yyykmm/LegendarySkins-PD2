-- Legendary Skins
-- Original persist-script lifecycle with one-time completion marker.

local tostring = tostring
local type = type
local pairs = pairs

local M_blackmarket = managers.blackmarket
local weapon_skins = tweak_data.blackmarket.weapon_skins
local inventory_tradable = M_blackmarket._global.inventory_tradable

local i = 1
local j = tostring(i)

for id, data in pairs(weapon_skins) do
    if not string.find(id, "color") then
        while inventory_tradable[j] ~= nil do
            i = i + 1
            j = tostring(i)
        end

        if not M_blackmarket:have_inventory_tradable_item(
            "weapon_skins",
            id
        ) then
            M_blackmarket:tradable_add_item(
                j,
                "weapon_skins",
                id,
                "mint",
                true,
                1
            )
        end
    end
end

-- Preserve the original compatibility conversion.
local convert

convert = function()
    for inst, data in pairs(inventory_tradable) do
        if type(inst) == "number" then
            inventory_tradable[tostring(inst)] = data
            inventory_tradable[inst] = nil
        end
    end

    convert = nil
end

function BlackMarketManager:tradable_update()
    if convert then
        convert()
    end
end

-- Unlock skin definitions.
for id, data in pairs(weapon_skins) do
    if not string.find(id, "color") then
        data.locked = false
    end
end

-- Unlock customization for crafted weapons.
local crafted = M_blackmarket._global.crafted_items

for _, category in pairs({
    crafted.primaries,
    crafted.secondaries
}) do
    for _, data in pairs(category) do
        if data.cosmetics then
            data.customize_locked = nil
        end
    end
end

-- Preserve the original safe handling.
for _, safe in pairs(tweak_data.economy.safes) do
    if not safe.market_link then
        safe.market_link = "Fake Link"
    end
end

-- Stop SuperBLT's persist script after initialization.
_G["Legendary Skins"] = true
