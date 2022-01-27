-- Organizer library v2

local org = {}
register_unhandled_command(function(...)
    local cmds = {...}
    for _,v in ipairs(cmds) do
        if S{'organizer','organize','org','o'}:contains(v:lower()) then
            org.export_set()
            return true
        end
    end
    return false
end)


function org.export_set()
    if not sets then
        windower.add_to_chat(123,'Organizer Library: Cannot export your sets for collection because the table is nil.')
        return
    elseif not windower.dir_exists(windower.windower_path..'addons/organizer/') then
        windower.add_to_chat(123,'Organizer Library: The organizer addon is not installed. Activate it in the launcher.')
        return
    end
    
    -- Makes a big table keyed to item resource tables, with values that are 1-based
    -- numerically indexed tables of different entries for each of the items from the sets table.
    local item_list = org.unpack_names({},'L1',sets,{})
    
    local trans_item_list = org.identify_items(item_list)
    
    for i,v in pairs(trans_item_list) do
        trans_item_list[i] = org.simplify_entry(v)
    end

    if trans_item_list:length() == 0 then
        windower.add_to_chat(123,'Organizer Library: Your sets table is empty.')
        return
    end
    
    local flattab = T{}
    for name,tab in pairs(trans_item_list) do
        for _,info in ipairs(tab) do
            flattab:append({id=tab.id,name=tab.name,log_name=tab.log_name,augments=info.augments,count=info.count})
        end
    end

    -- See if we have any non-equipment items to drag along
    if organizer_items then
        local organizer_item_list = org.unpack_names({}, 'L1', organizer_items, {
            item="Remedy",
            item="Carbonara",
            item="Antidote",
            item="Holy Water",
            ammo="Orichalc. Bullet",
            item="Panacea",
        item="Icarus Wing",
        item="Bean Daifuku +1",
        item="Grape Daifuku +1",
        item="Grape Daifuku",
        item="Miso Ramen",
        item="Tropical Crepe",
        item="Maze Tabula R01",
        item="Bean Daifuku",
        item="Kusamochi",
        item="Toolbag (Shihe)",
        item="Trump Card Case",
        item="Coconut Rusk",
        item="Mars Orb",
        item="Antacid",
        ammo="Chrono Bullet",
        ammo="Automat. Oil +3",
        item="Prism Powder",
        item="Lustreless Wing",
         item="Tropical Crepe",
         item="Sarama's Hide",
         item="Sovereign's Hide",
    item="Hi-Reraiser",
    item="Hidhaegg's Scale",
    item="Reraiser",
    item="Instant Stoneskin",
    item="Icarus Wing",
    item="Remedy",
    item="Instant Warp",
    feet="Powder Boots",
    item="Mars Orb",
    item="Maze Tabula R01",
    item="Panacea",
    item="Antidote",
    item="Dawn Mulsum",
    item="B. Curry Bun +1",
    item="Holy Water",
    item="Vile Elixir +1",
    item="Grape Daifuku +1",
    item="Antacid",
    item="Grape Daifuku",
    item="Bean Daifuku",
    item="Silent Oil",
    item="Instant Reraise",
    item="Abdhaljs Seal",
    item="Shihei",
    item="Carbonara",
    item="Toolbag (Shihe)",
    item="Bean Daifuku +1",
    item="Salt Ramen",
    })

        for _,tab in pairs(org.identify_items(organizer_item_list)) do
            count = gearswap.res.items[tab.id].stack
            flattab:append({id=tab.id,name=tab.name,log_name=tab.log_name,count=count})
        end
    end
    
    -- At this point I have a table of equipment pieces indexed by the inventory name.
    -- I need to make a function that will translate that into a list of pieces in
    -- inventory or wardrobe.
    -- #trans_item_list[i] = Number of a given item
    -- trans_item_list[i].id = item ID
    
    local ward_ids = {8,10,11,12}
    local wardrobes = {}
    local ward = {}
    
    for _,id in pairs(ward_ids) do
        wardrobes[id] = windower.ffxi.get_items(id)
        wardrobes[id].max = windower.ffxi.get_bag_info(id).max
        ward[id] = T{}
    end
    
    local inv = T{}
    for i,v in ipairs(flattab) do
        local found
        local ward_id
        -- Iterate over the wardrobes and look for gear from the list that is already in wardrobes, then eliminate it from the list
        for id,wardrobe in pairs(wardrobes) do
            for n,m in ipairs(wardrobe) do
                if m.id == v.id and (not v.augments or v.augments and gearswap.extdata.decode(m).augments and gearswap.extdata.compare_augments(v.augments,gearswap.extdata.decode(m).augments)) then
                    found = n
                    break
                end
            end
            if found then
                ward_id = id
                break
            end
        end
        if found then
            table.remove(wardrobes[ward_id],found)
            ward[ward_id]:append(v)
        else
            inv:append(v)
        end
    end

    local inventory_max = windower.ffxi.get_bag_info(0).max
    
    for id=1,4 do
        if #inv > inventory_max and #ward[id] + (#inv-inventory_max) < wardrobes[id].max then
            local available = wardrobes[id].max - #ward[id]
            local length = math.min(#inv-80,available)
            ward:extend(inv:slice(1-length))
        end
    end
    
    if #inv > inventory_max then
        windower.add_to_chat(123,'Organizer Library: Your sets table contains too many items.')
        return
    end
    
    -- Scan wardrobe, eliminate items from your table that are in wardrobe
    -- Scan inventory
    
    local fi = file.new('../organizer/data/inventory/organizer-lib-file.lua')
    fi:write('-- Generated by the Organizer Library ('..os.date()..')\nreturn '..(inv:tovstring({'augments','log_name','name','id','count'})))
    
    for _,id in ipairs(ward_ids) do
        local fw = file.new('../organizer/data/'..gearswap.res.bags[id].command..'/organizer-lib-file.lua')
        fw:write('-- Generated by the Organizer Library ('..os.date()..')\nreturn '..(ward[id]:tovstring({'augments','log_name','name','id','count'})))
    end

    windower.send_command('wait 0.5;org o organizer-lib-file')
end

function org.simplify_entry(tab)
    -- Some degree of this needs to be done in unpack_names or I won't be able to detect when two identical augmented items are equipped.
    local output = T{id=tab.id,name=tab.name,log_name=tab.log_name}
    local rare = gearswap.res.items[tab.id].flags:contains('Rare')
    for i,v in ipairs(tab) do
        local handled = false
        if v.augment then
            v.augments = {v.augment}
            v.augment = nil
        end
        
        for n,m in ipairs(output) do
            if (not v.bag or v.bag and v.bag == m.bag) and v.slot == m.slot and
                (not v.augments or ( m.augments and gearswap.extdata.compare_augments(v.augments,m.augments))) then
                output[n].count = math.min(math.max(output[n].count,v.count),gearswap.res.items[tab.id].stack)
                handled = true
                break
            elseif (not v.bag or v.bag and v.bag == m.bag) and v.slot == m.slot and v.augments and not m.augments then
                -- v has augments, but there currently exists a matching version of the
                -- item without augments in the output table. Replace the entry with the augmented entry
                local countmax = math.min(math.max(output[n].count,v.count),gearswap.res.items[tab.id].stack)
                output[n] = v
                output[n].count = countmax
                handled = true
                break
            elseif rare then
                handled = true
                break
            end
        end
        if not handled then
            output:append(v)
        end
        
    end
    return output
end

function org.identify_items(tab)
    local name_to_id_map = {}
    local items = windower.ffxi.get_items()
    for id,inv in pairs(items) do
        if type(inv) == 'table' then
            for ind,item in ipairs(inv) do
                if type(item) == 'table' and item.id and item.id ~= 0 then
                    name_to_id_map[gearswap.res.items[item.id][gearswap.language]:lower()] = item.id
                    name_to_id_map[gearswap.res.items[item.id][gearswap.language..'_log']:lower()] = item.id
                end
            end
        end
    end
    local trans = T{}
    for i,v in pairs(tab) do
        local item = name_to_id_map[i:lower()] and table.reassign({},gearswap.res.items[name_to_id_map[i:lower()]]) --and org.identify_unpacked_name(i,name_to_id_map)
        if item then
            local n = gearswap.res.items[item.id][gearswap.language]:lower()
            local ln = gearswap.res.items[item.id][gearswap.language..'_log']:lower()
            if not trans[n] then
                trans[n] = T{id=item.id,
                    name=n,
                    log_name=ln,
                    }
            end
            trans[n]:extend(v)
        end
    end
    return trans
end

function org.unpack_names(ret_tab,up,tab_level,unpacked_table)
    for i,v in pairs(tab_level) do
        local flag = false
        if type(v)=='table' and i ~= 'augments' and not ret_tab[tostring(tab_level[i])] then
            ret_tab[tostring(tab_level[i])] = true
            unpacked_table, ret_tab = org.unpack_names(ret_tab,i,v,unpacked_table)
        elseif i=='name' then
            -- v is supposed to be a name, then.
            flag = true
        elseif type(v) == 'string' and v~='augment' and v~= 'augments' and v~= 'priority' then
            -- v is a string that's not any known option of gearswap, so treat it as an item name.
            -- I really need to make a set of the known advanced table options and use that instead.
            flag = true
        end
        if flag then
            local n = tostring(v):lower()
            if not unpacked_table[n] then unpacked_table[n] = {} end
            local ind = #unpacked_table[n] + 1
            if i == 'name' and gearswap.slot_map[tostring(up):lower()] then -- Advanced Table
                unpacked_table[n][ind] = tab_level
                unpacked_table[n][ind].count = unpacked_table[n][ind].count or 1
                unpacked_table[n][ind].slot = gearswap.slot_map[up:lower()]
            elseif gearswap.slot_map[tostring(i):lower()] then
                unpacked_table[n][ind] = {slot=gearswap.slot_map[i:lower()],count=1}
            end
        end
    end
    return unpacked_table, ret_tab
end

function org.string_augments(tab)
    local aug_str = ''
    if tab.augments then
        for aug_ind,augment in pairs(tab.augments) do
            if augment ~= 'none' then aug_str = aug_str..'['..aug_ind..'] = '..'"'..augment..'",\n' end
        end
    end
    if tab.augment then
        if tab.augment ~= 'none' then aug_str = aug_str.."'"..augment.."'," end
    end
    if aug_str ~= '' then return '{\n'..aug_str..'}' end
end