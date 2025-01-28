-----------------------------Authors of this file--------------------------------
------           ******************************************                ------
---                                                                           ---
--	  Aragan (Asura) --------------- [Author Primary]                          -- 
--                                                                             --
---------------------------------------------------------------------------------
-- Haste/DW Detection Requires Gearinfo Addon

-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    gs c toggle LuzafRing -- Toggles use of Luzaf Ring on and off
    
    Offense mode is melee or ranged.  Used ranged offense mode if you are engaged
    for ranged weaponskills, but not actually meleeing.
    
    Weaponskill mode, if set to 'Normal', is handled separately for melee and ranged weaponskills.

state.Roller1 state.Roller2 have all rolls send to autocor addon 

cycle Roll

    send_command('bind f2 gs c cycle Roller1;input //gs c Roller1')
    send_command('bind f3 gs c cycle Roller2;input //gs c Roller2')
    send_command('bind ^f2 gs c cycleback Roller1;input //gs c Roller1')
    send_command('bind ^f3 gs c cycleback Roller2;input //gs c Roller2')

macro

/con gs c Roller1
/con gs c Roller2
/con input //cor 

    --]]


-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    include('Display.lua')

    -- Load and initialize the include file.
    include('Mote-Include.lua')
    include('organizer-lib')
    organizer_items  = {
        "Airmid's Gorget",
        "Molybdosis",
        "Tumult's Blood",
        "Sarama's Hide",
        "Hidhaegg's Scale",
        "Sovereign's Hide",
        "Grape Daifuku",
        "Soy Ramen",
        "G. Curry Bun +1",
        "Pukatrice Egg",
        "Moogle Amp.",
        "Popo. con Queso",
        "Pear Crepe",
        "Crab Sushi",
        "Om. Sandwich",
        "Red Curry Bun",
        "Prime Sword",
        "Earp",
        "Mafic Cudgel",
        "Living Bullet",
        "Decimating Bullet",
        "Chrono Bullet",
        "Trump Card Case",
        "Trump Card",
        "Chr. Bul. Pouch", 
        "Liv. Bul. Pouch", 
        "Dec. Bul. Pouch",
        "Gyudon",
        "Reraiser",
        "Hi-Reraiser",
        "Vile Elixir",
        "Vile Elixir +1",
        "Miso Ramen",
        "Carbonara",
        "Silent Oil",
        "Salt Ramen",
        "Panacea",
        "Sublime Sushi",
        "Sublime Sushi 1+",
        "Prism Powder",
        "Antacid",
        "Icarus Wing",
        "Warp Cudgel",
        "Holy Water",
        "Sanjaku-Tenugui",
        "Shinobi-Tabi",
        "Shihei",
        "Remedy",
        "Emporox's Ring",
        "Red Curry Bun",
        "Instant Reraise",
        "Black Curry Bun",
        "Rolan. Daifuku",
        "Reraise Earring",
    }
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    -- Whether to use Luzaf's Ring
    state.LuzafRing = M(false, "Luzaf's Ring")
    state.WeaponLock = M(false, 'Weapon Lock')
    state.Moving  = M(false, "moving")
    state.RP = M(false, "Reinforcement Points Mode")  
    state.CapacityMode = M(false, 'Capacity Point Mantle') 
    state.phalanxset = M(false,true)

    -- Whether a warning has been given for low ammo
    state.warned = M(false)
    include('Mote-TreasureHunter')
    define_roll_values()
    send_command('lua l AutoCOR')
    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
    "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Wh. Rarab Cap +1",
    "Dev. Bul. Pouch", "Chr. Bul. Pouch", "Liv. Bul. Pouch", "Cumulus Masque +1", "Airmid's Gorget",}
    elemental_ws = S{"Aeolian Edge", "Leaden Salute", "Wildfire"}
    no_shoot_ammo = S{"Animikii Bullet", "Hauksbok Bullet"}
    absorbs = S{'Absorb-STR', 'Absorb-DEX', 'Absorb-VIT', 'Absorb-AGI', 'Absorb-INT', 'Absorb-MND', 'Absorb-CHR', 'Absorb-Attri', 'Absorb-MaxAcc', 'Absorb-TP'}
    state.QDMode = M{['description']='Quick Draw Mode', 'STP', 'Enhance', 'TH'}
    state.Roller1 = M{['description']='Roller', 'Chaos Roll', 'Samurai Roll','Fighter\'s Roll',
    'Wizard\'s Roll', 'Warlock\'s Roll','Miser\'s Roll',
      'Companion\'s Roll','Puppet Roll', 'Beast Roll', 'Drachen Roll',
      'Blitzer\'s Roll', 'Courser\'s Roll', 'Allies\' Roll',
     'Avenger\'s Roll', 'Magus\'s Roll', 'Runeist\'s Roll', 'Gallant\'s Roll',
    'Monk\'s Roll', 'Healer\'s Roll', 'Rogue\'s Roll',
    'Choral Roll', 'Hunter\'s Roll', 'Ninja Roll', 'Evoker\'s Roll',
    'Dancer\'s Roll', 'Scholar\'s Roll', 'Bolter\'s Roll', 'Caster\'s Roll','Naturalist\'s Roll',
    }
    state.Roller2 = M{['description']='Roller', 'Samurai Roll', 'Chaos Roll', 'Fighter\'s Roll',
    'Wizard\'s Roll', 'Warlock\'s Roll','Miser\'s Roll',
      'Companion\'s Roll','Puppet Roll', 'Beast Roll', 'Drachen Roll',
      'Blitzer\'s Roll', 'Courser\'s Roll', 'Allies\' Roll',
     'Avenger\'s Roll', 'Magus\'s Roll', 'Runeist\'s Roll', 'Gallant\'s Roll',
    'Monk\'s Roll', 'Healer\'s Roll', 'Rogue\'s Roll',
    'Choral Roll', 'Hunter\'s Roll', 'Ninja Roll', 'Evoker\'s Roll',
    'Dancer\'s Roll', 'Scholar\'s Roll', 'Bolter\'s Roll', 'Caster\'s Roll','Naturalist\'s Roll',
    }
    state.rollset = M{'none', 'melee','magic', description='rollset'}

end


-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.GunMode = M{['description']='Gun Mode', 'normal','DeathPenalty', 'Anarchy', 'Fomalhaut', 'Earp'} 

    state.OffenseMode:options('Normal', 'Acc', 'STP', 'Ranged', 'CRIT')
    state.RangedMode:options('Normal', 'Acc', 'STP', 'NOENMITY', 'Critical')
    state.HybridMode:options('Normal', 'PDT')
    state.WeaponskillMode:options('Normal', 'PDL', 'SC')
    --state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT', 'Evasion', 'HP', 'Regen', 'EnemyCritRate')
    state.PhysicalDefenseMode:options('PDT', 'Evasion', 'HP')
    state.MagicalDefenseMode:options('MDT')
    swordList = S{"Naegling", "Demers. Degen +1"}
    daggerList = S{"Tauret",}
    sub_weapons = S{"Sangarius +1", "Perun 1+", "Tanmogayi +1", "Reikiko", "Digirbalag", "Twilight Knife",
    "Kustawi +1", "Zantetsuken", "Excalipoor II", "Warp Cudgel", "Qutrub Knife", "Wind Knife +1", "Firetongue", "Nihility",
        "Extinction", "Heartstopper +1", "Twashtar", "Aeneas", "Gleti's Knife", "Naegling", "Tauret", "Caduceus", "Loxotic Mace +1",
        "Debahocho +1", "Dolichenus", "Arendsi Fleuret", "Demers. Degen +1", "Ternion Dagger +1", "Blurred Knife +1",}
    state.WeaponSet = M{['description']='Weapon Set', 'normal', 'SWORDS', 'Tauret', 'Rostam', 'Kustawi'}
    state.Weapongun = M{['description']='Weapon Set', 'normal', 'DeathPenalty', 'Anarchy', 'Fomalhaut', 'Earp'}

    gear.RAbullet = "Decimating Bullet"
    gear.WSbullet = "Chrono Bullet"
    gear.MAbullet = "Living Bullet"
    gear.QDbullet = "Living Bullet"
    options.ammo_warning_limit = 15

        -- 'Out of Range' distance; WS will auto-cancel
    range_mult = {
            [0] = 0,
            [2] = 1.70,
            [3] = 1.490909,
            [4] = 1.44,
            [5] = 1.377778,
            [6] = 1.30,
            [7] = 1.20,
            [8] = 1.30,
            [9] = 1.377778,
            [10] = 1.45,
            [11] = 1.490909,
            [12] = 1.70,
        }

    --keyboard buttons bind
    --use //listbinds    .. to show command keys
    -- Additional local binds
    send_command('bind ^` input /ja "Double-up" <me>')
    send_command('bind !` input /ja "Bolter\'s Roll" <me>')
    send_command('bind !w gs c toggle WeaponLock')
    send_command('bind f4 gs c cycle QDMode')
    send_command('bind ^numlock input /ja "Triple Shot" <me>')
    send_command('bind f5 gs c cycle WeaponskillMode')
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind ^/ gs disable all')
    send_command('bind !/ gs enable all')
    send_command('bind f7 gs c cycle Weapongun')
    send_command('bind !f7 gs c cycleback Weapongun')
    send_command('bind f6 gs c cycle WeaponSet')
    send_command('bind !f6 gs c cycleback WeaponSet')
    send_command('bind !- gs c toggle RP') 
    send_command('bind ^p gs c toggle phalanxset') 
    send_command('@wait 6;input /lockstyleset 151')
    send_command('bind f2 gs c cycle Roller1;input //gs c Roller1')
    send_command('bind f3 gs c cycle Roller2;input //gs c Roller2')
    send_command('bind ^f2 gs c cycleback Roller1;input //gs c Roller1')
    send_command('bind ^f3 gs c cycleback Roller2;input //gs c Roller2')
    send_command('bind f1 gs c cycle rollset')
    state.Auto_Kite = M(false, 'Auto_Kite')

    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    
    lockstyle()
    determine_haste_group()
    update_combat_form()
    select_default_macro_book()
    if init_job_states then init_job_states({"WeaponLock"},{"IdleMode","OffenseMode","WeaponskillMode","RangedMode","WeaponSet","Weapongun","QDMode","TreasureMode"}) 
    end
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^numlock')
    send_command('unbind !w')

end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    ---- WeaponSet ----

    sets.normal = {}
    sets.SWORDS = {main="Naegling", sub="Crepuscular Knife",}
    sets.Tauret = {main="Tauret", sub="Crepuscular Knife",}
    sets.Rostam = {main={ name="Rostam", augments={'Path: A',}}, sub="Tauret"}
    sets.Kustawi = {main="Kustawi +1", sub="Crepuscular Knife",}

    sets.normal = {}
    sets.DeathPenalty = {range="Death Penalty"}
    sets.Anarchy = {range="Anarchy +2"}
    sets.Fomalhaut = {range="Fomalhaut"}
    sets.Earp = {range="Earp"}

    sets.DefaultShield = {sub="Nusku Shield"}
    sets.FullTP = {ear1="Crematio Earring"}

    -- Precast Sets

    -- Precast sets to enhance JAs
    
    sets.precast.JA['Snake Eye'] = {}
    sets.precast.JA['Wild Card'] = {feet="Lanun Bottes +3"}
    sets.precast.JA['Random Deal'] = {body="Lanun Frac +3"}

    
    sets.precast.CorsairRoll = {
    main={ name="Rostam", augments={'Path: C',}},
    range={ name="Compensator", augments={'DMG:+9','Rng.Acc.+9','Rng.Atk.+9',}},
    head={ name="Lanun Tricorne +3", augments={'Enhances "Winning Streak" effect',}},
    body="Adamantite Armor",
    hands="Chasseur's Gants +3",
    legs="Desultor Tassets",
    feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
    neck="Regal Necklace",
    right_ear="Genmei Earring",
    left_ring="Defending Ring",
    right_ring="Luzaf's Ring",
    back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
    
    sets.precast.CorsairRoll["Caster's Roll"] = set_combine(sets.precast.CorsairRoll, {legs="Chas. Culottes +3",})
    sets.precast.CorsairRoll["Courser's Roll"] = set_combine(sets.precast.CorsairRoll, {feet="Chass. Bottes +2"})
    sets.precast.CorsairRoll["Blitzer's Roll"] = set_combine(sets.precast.CorsairRoll, {head="Chass. Tricorne +2",})
    sets.precast.CorsairRoll["Tactician's Roll"] = set_combine(sets.precast.CorsairRoll, {body="Chasseur's Frac +2",})
    sets.precast.CorsairRoll["Allies' Roll"] = set_combine(sets.precast.CorsairRoll, {hands="Chasseur's Gants +3",})
    
    sets.precast.LuzafRing = {ring2="Luzaf's Ring"}
    sets.precast.FoldDoubleBust = {hands={ name="Lanun Gants +3", augments={'Enhances "Fold" effect',}},}
    
    --sets.precast.CorsairShot = {}
    

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Mummu Bonnet +2",    
        body="Passion Jacket",
        ring1="Asklepian Ring",
        waist="Gishdubar Sash",
    }
    sets.TreasureHunter = { 
        --ammo="Per. Lucky Egg",
        head="White rarab cap +1", 
        waist="Chaac Belt",
     }
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {
    head="Mummu Bonnet +2",    
    body="Passion Jacket",
    }

    -- Fast cast sets for spells
    
    sets.precast.FC = {    head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
    hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
    legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
    left_ear="Etiolation Earring",
    right_ear="Loquac. Earring",
    left_ring="Prolix Ring",
    right_ring="Kishar Ring",
}
sets.precast.JA.Jump = {
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Iskur Gorget",
    waist="Olseni Belt",
    left_ear="Telos Earring",
    right_ear="Crep. Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
}
sets.precast.JA['High Jump'] = set_combine(sets.precast.JA.Jump, {
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Iskur Gorget",
    waist="Olseni Belt",
    left_ear="Telos Earring",
    right_ear="Crep. Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}) 
sets.precast.JA['Super Jump'] = sets.precast.JA.Jump

sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {body="Passion Jacket",})

sets.midcast['Enhancing Magic'] = {
    neck="Incanter's Torque",
    waist="Olympus Sash",
    left_ear="Brachyura Earring",
    right_ear="Andoaa Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back="Moonlight Cape",
}
sets.midcast.Phalanx = set_combine(sets.midcast['Enhancing Magic'], {
    body={ name="Herculean Vest", augments={'Phys. dmg. taken -1%','Accuracy+11 Attack+11','Phalanx +2','Mag. Acc.+18 "Mag.Atk.Bns."+18',}},
    hands={ name="Herculean Gloves", augments={'Accuracy+11','Pet: Phys. dmg. taken -5%','Phalanx +4',}},
    feet={ name="Herculean Boots", augments={'Accuracy+8','Pet: Attack+28 Pet: Rng.Atk.+28','Phalanx +4','Mag. Acc.+12 "Mag.Atk.Bns."+12',}},
})
sets.precast.RA = {
        hands={ name="Lanun Gants +3", augments={'Enhances "Fold" effect',}},
        head="Chass. Tricorne +2",
        body="Oshosi Vest +1",
        legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}},
    feet="Meg. Jam. +2",
    neck={ name="Comm. Charm +2", augments={'Path: A',}},
    waist="Yemaya Belt",
    back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
}

sets.precast.RA.Flurry1 = set_combine(sets.precast.RA, {
    body="Laksa. Frac +3", --0/20
    }) --47/52

sets.precast.RA.Flurry2 = set_combine(sets.precast.RA.Flurry1, {
    hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
    head="Chass. Tricorne +2",
    body="Laksa. Frac +3",
 legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}},
 feet="Meg. Jam. +2",
 waist="Yemaya Belt",
 back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
    }) --32/73


       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head="Nyame Helm",
        body="Laksa. Frac +3",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Ishvara Earring",
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    }
    sets.precast.WS.PDL = set_combine(sets.precast.WS, {
        body="Ikenga's Vest",
		left_ring="Sroda Ring", 
	})
	sets.precast.WS.SC = set_combine(sets.precast.WS, {
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Warder's Charm +1", augments={'Path: A',}},
	})

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Evisceration'] = {
    head={ name="Blistering Sallet +1", augments={'Path: A',}},
    body="Mummu Jacket +2",
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Zoar Subligar +1", augments={'Path: A',}},
    feet="Mummu Gamash. +2",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    right_ear="Odr Earring",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Ilabrat Ring",
    right_ring="Regal Ring",
    back="Annealed Mantle",
    }
    sets.precast.WS['Evisceration'].PDL = sets.precast.WS['Evisceration'], {
        body="Ikenga's Vest",
        left_ear="Mache Earring +1",
    }

    sets.precast.WS['Savage Blade'] = {
        head="Nyame Helm",
		body="Nyame Mail",
        hands="Chasseur's Gants +3",
        legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Rep. Plat. Medal",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    right_ear="Ishvara Earring",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Regal Ring",
    right_ring="Cornelia's Ring",
    back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    }
    sets.precast.WS['Savage Blade'].PDL = set_combine(sets.precast.WS['Savage Blade'], {
        body="Ikenga's Vest",
		left_ring="Sroda Ring", 
        neck={ name="Comm. Charm +2", augments={'Path: A',}},
        waist="Kentarch Belt +1",
	})

    sets.precast.WS['Requiescat'] = {
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        hands="Meg. Gloves +2",
        legs="Meg. Chausses +2",
        feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
        neck="Fotia Gorget",
        waist="Fotia Belt",
        right_ear="Telos Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Regal Ring",
        right_ring="Rufescent Ring",
        back="Annealed Mantle",
}

    sets.precast.WS['Last Stand'] = {
    ammo=gear.WSbullet,
    head={ name="Lanun Tricorne +3", augments={'Enhances "Winning Streak" effect',}},
    body="Ikenga's Vest",
    hands="Chasseur's Gants +3",
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
    neck={ name="Comm. Charm +2", augments={'Path: A',}},
    waist="Fotia Belt",
    right_ear="Ishvara Earring",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Dingir Ring",
    right_ring="Regal Ring",
    back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    }

    sets.precast.WS['Last Stand'].PDL = set_combine(sets.precast.WS['Last Stand'], {
    head={ name="Nyame Helm", augments={'Path: B',}},
    body="Ikenga's Vest",
    legs="Ikenga's Trousers",
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck="Fotia Gorget",
    waist="Fotia Belt",
    right_ear="Ishvara Earring",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Sroda Ring", 
    right_ring="Cornelia's Ring",
    back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })

    sets.precast.WS['Last Stand'].SC = set_combine(sets.precast.WS['Last Stand'], {
        ammo=gear.WSbullet,
        head={ name="Nyame Helm", augments={'Path: B',}},
        body="Laksa. Frac +3",
        hands="Chasseur's Gants +3",
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
        neck="Fotia Gorget",
        waist="Fotia Belt",
        right_ear="Ishvara Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Dingir Ring",
        right_ring="Regal Ring",
        back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })

    sets.precast.WS['Wildfire'] = {
        ammo=gear.MAbullet,
        head="Nyame Helm",
        body="Lanun Frac +3",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
        neck={ name="Comm. Charm +2", augments={'Path: A',}},
        waist="Orpheus's Sash",
        left_ear="Friomisi Earring",
        right_ear="Crematio Earring",
        left_ring="Dingir Ring",
        right_ring="Cornelia's Ring",
        back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
}
sets.precast.WS['Wildfire'].SC = set_combine(sets.precast.WS['Wildfire'],  {
    head={ name="Nyame Helm", augments={'Path: B',}},
    right_ear="Chas. Earring +1",
    left_ear="Digni. Earring",
    neck="Fotia Gorget",
})
    sets.precast.WS['Hot Shot'] = set_combine(sets.precast.WS['Wildfire'],  {  
    hands="Chasseur's Gants +3",})

    sets.precast.WS['Leaden Salute'] = {     
    ammo=gear.MAbullet,
    head="Pixie Hairpin +1",
    body="Lanun Frac +3",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
    neck={ name="Comm. Charm +2", augments={'Path: A',}},
    waist="Svelt. Gouriz +1",
    right_ear="Friomisi Earring",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Dingir Ring",
    right_ring="Archon Ring",
    back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
}
    
    sets.precast.WS['Leaden Salute'].PDL = {   
    ammo=gear.RAbullet,
    head="Pixie Hairpin +1",
    body="Lanun Frac +3",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
    neck={ name="Comm. Charm +2", augments={'Path: A',}},
    waist="Svelt. Gouriz +1",
    right_ear="Friomisi Earring",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Dingir Ring",
    right_ring="Archon Ring",
    back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    }
    sets.precast.WS['Leaden Salute'].SC = set_combine(sets.precast.WS['Leaden Salute'],  {
        head={ name="Nyame Helm", augments={'Path: B',}},
        right_ear="Chas. Earring +1",
        left_ear="Digni. Earring",
        neck={ name="Comm. Charm +2", augments={'Path: A',}},
    })


-- Elemental Weapon Skill --elemental_ws--

-- SANGUINE BLADE
-- 50% MND / 50% STR Darkness Elemental
sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS, {
    head="Pixie Hairpin +1",
    body="Lanun Frac +3",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
    neck={ name="Comm. Charm +2", augments={'Path: A',}},
    waist="Svelt. Gouriz +1",
    right_ear="Friomisi Earring",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Dingir Ring",
    right_ring="Archon Ring",
    back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
})

sets.precast.WS["Dark Harvest"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
sets.precast.WS["Shadow of Death"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
sets.precast.WS["Infernal Scythe"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
sets.precast.WS["Energy Steal"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
sets.precast.WS["Energy Drain"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
sets.precast.WS.Cataclysm = sets.precast.WS["Sanguine Blade"]

sets.precast.WS["Burning Blade"] = set_combine(sets.precast.WS, {
    head="Nyame Helm",
    body="Lanun Frac +3",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
    neck="Baetyl Pendant",
    waist="Orpheus's Sash",
    right_ear="Friomisi Earring",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Dingir Ring",
    right_ring="Cornelia's Ring",
    back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
})

sets.precast.WS["Red Lotus Blade"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Shining Blade"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Seraph Blade"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Cloudsplitter"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Primal Rend"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Aeolian Edge"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Cyclone"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Gust Slash"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Shining Strike"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Seraph Strike"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Flash Nova"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Thunder Thrust"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Raiden Thrust"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Frostbite"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Freezebite"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Herculean Slash"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Earth Crusher"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Rock Crusher"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Starburst"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Sunburst"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Flaming Arrow"] = set_combine(sets.precast.WS["Burning Blade"],{})


    -- Midcast Sets
    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        hands="Rawhide Gloves", --15
        legs="Carmine Cuisses +1", --20
        neck="Loricate Torque +1", --5
        ear1="Halasz Earring", --5
        ring2="Evanescence Ring", --5
        waist="Rumination Sash", --10
        }
        
    -- Specific spells
    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt
    sets.midcast.Absorb = {
        ammo="Pemphredo Tathlum",
        neck="Erra Pendant",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Kishar Ring",
    }
    sets.midcast.CorsairShot = {
        ammo=gear.QDbullet,
        head="Nyame Helm",
        body="Lanun Frac +3",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
        neck={ name="Comm. Charm +2", augments={'Path: A',}},
        waist="Skrymir Cord",
        left_ear="Friomisi Earring",
        right_ear="Crematio Earring",
        left_ring="Dingir Ring",
        right_ring="Cornelia's Ring",
        back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
}

    sets.midcast.CorsairShot.Acc = {
        ammo=gear.QDbullet,
        head="Nyame Helm",
        body="Lanun Frac +3",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Chass. Bottes +2",
        neck={ name="Comm. Charm +2", augments={'Path: A',}},
        waist="Skrymir Cord",
        left_ear="Friomisi Earring",
        right_ear="Crematio Earring",
        left_ring="Dingir Ring",
        right_ring="Cornelia's Ring",
        back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
}
    sets.midcast.CorsairShot.STP = {
        ammo=gear.QDbullet,
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Iskur Gorget",
        ear1="Dedition Earring",
        ear2="Telos Earring",
        ring1="Chirich Ring +1",
        ring2="Chirich Ring +1",
        waist="Kentarch Belt +1",
        back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},

        }
    sets.midcast.CorsairShot['Light Shot'] = {
        ammo=gear.QDbullet,
        head="Malignance Chapeau",
        body="Laksa. Frac +3",
        hands="Malignance Gloves",
        legs="Chas. Culottes +3",
        feet="Chass. Bottes +2",
        neck={ name="Comm. Charm +2", augments={'Path: A',}},
        waist="Eschan Stone",
        left_ear="Crep. Earring",
        right_ear="Chas. Earring +1",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
}

    sets.midcast.CorsairShot['Dark Shot'] = sets.midcast.CorsairShot['Light Shot']
    sets.midcast.CorsairShot.Enhance = {feet="Chass. Bottes +2"}


    -- Ranged gear
sets.midcast.RA = {
    ammo=gear.RAbullet,
    head="Ikenga's Hat",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Chas. Culottes +3",
    feet="Malignance Boots",
    neck="Iskur Gorget",
    waist="Yemaya Belt",
    left_ear="Crep. Earring",
    right_ear="Telos Earring",
    left_ring="Dingir Ring",
    right_ring="Ilabrat Ring",
    back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
}

sets.midcast.RA.Acc = {
    ammo=gear.WSbullet,
    head="Malignance Chapeau",
    body="Laksa. Frac +3",
    hands="Malignance Gloves",
    legs="Chas. Culottes +3",
    feet="Malignance Boots",
    neck={ name="Comm. Charm +2", augments={'Path: A',}},
    waist="Yemaya Belt",
    left_ear="Crep. Earring",
    right_ear="Telos Earring",
    left_ring="Regal Ring",
    right_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
    back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
}

sets.midcast.RA.STP = {
    ammo=gear.RAbullet,
    head="Ikenga's Hat",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Chas. Culottes +3",
    feet="Malignance Boots",
    neck="Iskur Gorget",
    waist="Gerdr Belt",
    left_ear="Dedition Earring",
    right_ear="Telos Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
}
sets.midcast.RA.NOENMITY = set_combine(sets.midcast.RA, {
    head="Ikenga's Hat",
    body="Ikenga's Vest",
    hands="Ikenga's Gloves",
    legs="Ikenga's Trousers",
    feet="Osh. Leggings +1",
    neck="Iskur Gorget",
    right_ear="Enervating Earring",
    right_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
    back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
})
sets.midcast.RA.Critical = set_combine(sets.midcast.RA, {
    ammo=gear.WSbullet,
    head="Meghanada Visor +2",
    body="Nisroch Jerkin",
    hands="Chasseur's Gants +3",
    legs="Mummu Kecks +2",
    feet="Osh. Leggings +1",
    neck="Iskur Gorget",
    waist="Gerdr Belt",
    left_ear="Odr Earring",
    right_ear="Chas. Earring +1",
    left_ring="Mummu Ring",
    right_ring="Dingir Ring",
    back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
})
    
-- Sets to return to when not performing an action.
    
-- Resting sets
sets.resting = {
    head="Meghanada Visor +2",
    body="Meg. Cuirie +2",
    hands="Meg. Gloves +2",
    legs="Meg. Chausses +2",
    feet="Meg. Jam. +2",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    left_ear="Infused Earring",
    ring1="Sheltered Ring",ring2="Paguroidea Ring"}


-- Idle sets
sets.idle = {
    head="Malignance Chapeau",
    body="Adamantite Armor",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Odnowa Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Defending Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back="Moonlight Cape",
}

sets.idle.Evasion = set_combine(sets.idle, {
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    waist="Svelt. Gouriz +1",
    left_ear="Infused Earring",
    right_ear="Eabani Earring",
    left_ring="Defending Ring",
    right_ring="Vengeful Ring",
    back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
})
sets.idle.Town ={legs="Carmine Cuisses +1",
    left_ear="Infused Earring",}
sets.idle.HP =  {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body="Adamantite Armor",
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        left_ear="Tuisto Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Ilabrat Ring",
        right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        back="Moonlight Cape",
}
sets.idle.Regen = set_combine(sets.idle, {
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    right_ear="Infused Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
})
sets.idle.EnemyCritRate = set_combine(sets.idle, { 
    ammo="Eluder's Sachet",
    left_ring="Warden's Ring",
    right_ring="Fortified Ring",
    back="Reiki Cloak",
})

    -- Defense sets
sets.defense.PDT = {
    head="Nyame Helm",
    body="Adamantite Armor",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Paguroidea Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back="Moonlight Cape",
}

sets.defense.MDT = {
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
    waist="Plat. Mog. Belt",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Shadow Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back="Moonlight Cape",
}
sets.defense.Evasion =  {
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    waist="Svelt. Gouriz +1",
    left_ear="Infused Earring",
    right_ear="Eabani Earring",
    left_ring="Defending Ring",
    right_ring="Vengeful Ring",
    back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
}
sets.defense.HP =  {
    head={ name="Nyame Helm", augments={'Path: B',}},
    body="Adamantite Armor",
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Plat. Mog. Belt",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Ilabrat Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back="Moonlight Cape",
}
    
    sets.Adoulin = {body="Councilor's Garb",
       legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},}
    sets.MoveSpeed = {legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},}
    sets.Kiting = {legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group


sets.engaged = {
    head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
    neck="Iskur Gorget",
    waist="Windbuffet Belt +1",
    left_ear="Cessance Earring",
    right_ear="Telos Earring",
    left_ring="Epona's Ring",
    right_ring="Petrov Ring",
    back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
    }
sets.engaged.Acc = {
    head="Malignance Chapeau",
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Iskur Gorget",
    waist="Kentarch Belt +1",
    left_ear="Cessance Earring",
    right_ear="Telos Earring",
    ring1="Chirich Ring +1",
    ring2="Chirich Ring +1",
    back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
}
sets.engaged.CRIT = {
    head={ name="Blistering Sallet +1", augments={'Path: A',}},
    body="Mummu Jacket +2",
    hands="Mummu Wrists +2",
    legs={ name="Zoar Subligar +1", augments={'Path: A',}},
    feet="Mummu Gamash. +2",
    neck="Nefarious Collar +1",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Cessance Earring",
    right_ear="Brutal Earring",
    left_ring="Epona's Ring",
    right_ring="Hetairoi Ring",
        back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
}
sets.engaged.Ranged = {    
    head="Malignance Chapeau",
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs="Chas. Culottes +3",
    feet="Malignance Boots",
    neck="Iskur Gorget",
    waist="Windbuffet Belt +1",
    left_ear="Cessance Earring",
    right_ear="Telos Earring",
    left_ring="Epona's Ring",
    right_ring="Petrov Ring",
    back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
    }

    sets.engaged.STP = set_combine(sets.engaged, {
        left_ear="Dedition Earring",
        ring1="Chirich Ring +1",
        ring2="Chirich Ring +1",
        waist="Kentarch Belt +1",
    })

    -- * DNC Subjob DW Trait: +15%
    -- * NIN Subjob DW Trait: +25%

    --DW cap all set haste capped

    sets.engaged.DW = {
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
        feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
        neck="Iskur Gorget",
        waist="Windbuffet Belt +1",
        left_ear="Suppanomimi",
        right_ear="Telos Earring",
        left_ring="Epona's Ring",
        right_ring="Petrov Ring",
        back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
    }
    sets.engaged.DW.Acc = set_combine(sets.engaged.Acc,{
        waist="Reiki Yotai",
        left_ear="Suppanomimi",
    })
    sets.engaged.DW.CRIT = set_combine(sets.engaged.CRIT,{
        waist="Reiki Yotai",
        left_ear="Suppanomimi",
    })
    sets.engaged.DW.Ranged = {    
        head="Malignance Chapeau",
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs="Chas. Culottes +3",
        feet="Malignance Boots",
        neck="Iskur Gorget",
        waist="Windbuffet Belt +1",
        left_ear="Cessance Earring",
        right_ear="Telos Earring",
        left_ring="Epona's Ring",
        right_ring="Petrov Ring",
        back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    }
    sets.engaged.DW.STP = set_combine(sets.engaged, {
        waist="Reiki Yotai",
        left_ear="Suppanomimi",
        ring1="Chirich Ring +1",
        ring2="Chirich Ring +1",
    })

    -- No Magic Haste (74% DW to cap)

    ------------------------------------------------------------------------------------------------
      ---------------------------------------- DW-HASTE ------------------------------------------
    ------------------------------------------------------------------------------------------------
    sets.engaged.DW.LowHaste = { 
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        hands="Floral Gauntlets", --5
        legs="Carmine Cuisses +1", --6
        feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
        neck="Iskur Gorget",
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
        left_ring="Epona's Ring",
        right_ring="Petrov Ring",
        back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
    } -- 33%
    sets.engaged.DW.Acc.LowHaste = set_combine(sets.engaged.DW.Acc, {
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        hands="Floral Gauntlets", --5
        legs="Carmine Cuisses +1", --6
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
        }) -- 33%

    sets.engaged.DW.CRIT.LowHaste = set_combine(sets.engaged.DW.CRIT, {
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        hands="Floral Gauntlets", --5
        legs="Carmine Cuisses +1", --6
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
        }) -- 33%
    sets.engaged.DW.Ranged.LowHaste = set_combine(sets.engaged.DW.Ranged, {
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        hands="Floral Gauntlets", --5
        legs="Carmine Cuisses +1", --6
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
        }) -- 33%

    sets.engaged.DW.STP.LowHaste = set_combine(sets.engaged.DW.STP, {
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        hands="Floral Gauntlets", --5
        legs="Carmine Cuisses +1", --6
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
        }) -- 33%


    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = { 
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
        feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
        neck="Iskur Gorget",
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
        left_ring="Epona's Ring",
        right_ring="Petrov Ring",
        back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
        } -- 22%
    sets.engaged.DW.Acc.MidHaste = set_combine(sets.engaged.DW.Acc,{ 
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
        }) -- 22%
    sets.engaged.DW.CRIT.MidHaste = set_combine(sets.engaged.DW.CRIT,{ 
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
        }) -- 22%

    sets.engaged.DW.Ranged.MidHaste = set_combine(sets.engaged.DW.Ranged,{ 
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
        }) -- 22%
   sets.engaged.DW.STP.MidHaste = set_combine(sets.engaged.DW.STP,{ 
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
    }) -- 22%

    sets.engaged.DW.MaxHaste = set_combine(sets.engaged.DW)
    sets.engaged.DW.Acc.MaxHaste = set_combine(sets.engaged.DW.Acc)
    sets.engaged.DW.CRIT.MaxHaste = set_combine(sets.engaged.DW.CRIT)
    sets.engaged.DW.Ranged.MaxHaste = set_combine(sets.engaged.DW.Ranged)
    sets.engaged.DW.STP.MaxHaste = set_combine(sets.engaged.DW.STP)

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

sets.engaged.Hybrid = {
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Chas. Culottes +3",
    feet="Malignance Boots",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
}
   
sets.engaged.PDT = set_combine(sets.engaged,{
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Chas. Culottes +3",
    feet="Malignance Boots",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
})
sets.engaged.Acc.PDT = set_combine(sets.engaged.Acc,{
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Chas. Culottes +3",
    feet="Malignance Boots",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
})
sets.engaged.CRIT.PDT = set_combine(sets.engaged.CRIT,{
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Chas. Culottes +3",
    feet="Malignance Boots",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
})
sets.engaged.Ranged.PDT = set_combine(sets.Ranged,{    
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Chas. Culottes +3",
    feet="Malignance Boots",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
})
sets.engaged.STP.PDT = set_combine(sets.engaged.STP,{
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Chas. Culottes +3",
    feet="Malignance Boots",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
})
sets.engaged.DW.PDT = set_combine(sets.engaged.DW, {
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Chas. Culottes +3",
    feet="Malignance Boots",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
})
sets.engaged.DW.Acc.PDT = set_combine(sets.engaged.DW.Acc,{
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Chas. Culottes +3",
    feet="Malignance Boots",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
})
sets.engaged.DW.CRIT.PDT = set_combine(sets.engaged.DW.CRIT,{
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    left_ear="Suppanomimi",
    waist="Reiki Yotai",
})
sets.engaged.DW.Ranged.PDT = set_combine(sets.engaged.DW.Ranged,{    
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Chas. Culottes +3",
    feet="Malignance Boots",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
})

sets.engaged.DW.STP.PDT = set_combine(sets.engaged.DW.STP,{
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    left_ear="Suppanomimi",
    waist="Reiki Yotai",
})

sets.engaged.DW.PDT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
sets.engaged.DW.Acc.PDT.LowHaste = set_combine(sets.engaged.DW.Acc.LowHaste, sets.engaged.Hybrid)
sets.engaged.DW.CRIT.PDT.LowHaste = set_combine(sets.engaged.DW.CRIT.LowHaste, sets.engaged.Hybrid)
sets.engaged.DW.Ranged.PDT.LowHaste = set_combine(sets.engaged.DW.Ranged.LowHaste, sets.engaged.Hybrid)
sets.engaged.DW.STP.PDT.LowHaste = set_combine(sets.engaged.DW.STP.LowHaste, sets.engaged.Hybrid)

sets.engaged.DW.PDT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
sets.engaged.DW.Acc.PDT.MidHaste = set_combine(sets.engaged.DW.Acc.MidHaste, sets.engaged.Hybrid)
sets.engaged.DW.CRIT.PDT.MidHaste = set_combine(sets.engaged.DW.CRIT.MidHaste, sets.engaged.Hybrid)
sets.engaged.DW.Ranged.PDT.MidHaste = set_combine(sets.engaged.DW.Ranged.MidHaste, sets.engaged.Hybrid)
sets.engaged.DW.STP.PDT.MidHaste = set_combine(sets.engaged.DW.STP.MidHaste, sets.engaged.Hybrid)

sets.engaged.DW.PDT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
sets.engaged.DW.Acc.PDT.MaxHaste = set_combine(sets.engaged.DW.Acc.MaxHaste, sets.engaged.Hybrid)
sets.engaged.DW.CRIT.PDT.MaxHaste = set_combine(sets.engaged.DW.CRIT.MaxHaste, sets.engaged.Hybrid)
sets.engaged.DW.Ranged.PDT.MaxHaste = set_combine(sets.engaged.DW.Ranged.MaxHaste, sets.engaged.Hybrid)
sets.engaged.DW.STP.PDT.MaxHaste = set_combine(sets.engaged.DW.STP.MaxHaste, sets.engaged.Hybrid)


-------------

sets.TripleShot = {
    head="Oshosi Mask +1",
    body="Chasseur's Frac +2",
    hands={ name="Lanun Gants +3", augments={'Enhances "Fold" effect',}},
    legs="Osh. Trousers +1",
    feet="Osh. Leggings +1",
    }

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

sets.buff.Doom = {    neck="Nicander's Necklace",
   waist="Gishdubar Sash",
   left_ring="Purity Ring",
   right_ring="Blenmot's Ring +1",}
   sets.RP = {neck="Comm. Charm +2"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs) 
    -- Check that proper ammo is available if we're using ranged attacks or similar.
    if spell.action_type == 'Ranged Attack' or spell.type == 'WeaponSkill' or spell.type == 'CorsairShot' then
        do_bullet_checks(spell, spellMap, eventArgs)
    end
    if spell.type == "WeaponSkill" then
        if (spell.target.model_size + spell.range * range_mult[spell.range]) < spell.target.distance then
            cancel_spell()
            add_to_chat(123, spell.name..' Canceled: [Out of /eq]')
            return
        end
    end
    if spell.english == 'Fold' and buffactive['Bust'] == 2 then
        if sets.precast.FoldDoubleBust then
            equip(sets.precast.FoldDoubleBust)
            eventArgs.handled = true
        end
    end
    if spell.english == 'Warcry' then
        if buffactive['Warcry'] then
            cancel_spell()
            add_to_chat(123, spell.name..' Canceled: Warcry its up [active]')
        end
    end
    if spellMap == 'Utsusemi' then
        if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
            cancel_spell()
            add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')
            eventArgs.handled = true
            return
        elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
            send_command('cancel 66; cancel 444; cancel 445; cancel ; Copy Image; cancel Copy Image (2); cancel Copy Image (3)')
        end
    end
end
function job_post_precast(spell, action, spellMap, eventArgs)
    if (spell.type == 'CorsairRoll' or spell.english == "Double-Up") then
        if player.status ~= 'Engaged' and state.WeaponLock.value == false then
            equip(sets.precast.CorsairRoll.Duration)
        end
        if state.LuzafRing.value then
            equip(sets.precast.LuzafRing)
        end
    end
	if spell.type:lower() == 'weaponskill' then
		if player.tp == 3000 then  -- Replace Moonshade Earring if we're at cap TP
            equip({left_ear="Ishvara Earring"})
		end
	end
    if spell.action_type == 'Ranged Attack' then
        special_ammo_check()
        if flurry == 2 then
            equip(sets.precast.RA.Flurry2)
        elseif flurry == 1 then
            equip(sets.precast.RA.Flurry1)
        end
    elseif spell.type == 'WeaponSkill' then
        if spell.skill == 'Marksmanship' then
            special_ammo_check()
        end
        -- Replace TP-bonus gear if not needed.
        if spell.english == 'Leaden Salute' or spell.english == 'Aeolian Edge' and player.tp > 2900 then
            equip(sets.FullTP)
        end
        if elemental_ws:contains(spell.name) then
            -- Matching double weather (w/o day conflict).
            if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
                equip({waist="Hachirin-no-Obi"})
            -- Target distance under 1.7 yalms.
            elseif spell.target.distance < (1.7 + spell.target.model_size) then
                equip({waist="Orpheus's Sash"})
            -- Matching day and weather.
            elseif spell.element == world.day_element and spell.element == world.weather_element then
                equip({waist="Hachirin-no-Obi"})
            -- Target distance under 8 yalms.
            elseif spell.target.distance < (8 + spell.target.model_size) then
                equip({waist="Orpheus's Sash"})
            -- Match day or weather.
            elseif spell.element == world.day_element or spell.element == world.weather_element then
                equip({waist="Hachirin-no-Obi"})
            end
        end
    end
end
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.type == 'CorsairShot' then
        if (spell.english ~= 'Light Shot' and spell.english ~= 'Dark Shot') then
            -- Matching double weather (w/o day conflict).
            if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
                equip({waist="Hachirin-no-Obi"})
            -- Target distance under 1.7 yalms.
            elseif spell.target.distance < (1.7 + spell.target.model_size) then
                equip({waist="Orpheus's Sash"})
            -- Matching day and weather.
            elseif spell.element == world.day_element and spell.element == world.weather_element then
                equip({waist="Hachirin-no-Obi"})
            -- Target distance under 8 yalms.
            elseif spell.target.distance < (8 + spell.target.model_size) then
                equip({waist="Orpheus's Sash"})
            -- Match day or weather.
            elseif spell.element == world.day_element or spell.element == world.weather_element then
                equip({waist="Hachirin-no-Obi"})
            end
            if state.QDMode.value == 'Enhance' then
                equip(sets.midcast.CorsairShot.Enhance)
            elseif state.QDMode.value == 'TH' then
                equip(sets.midcast.CorsairShot)
                equip(sets.TreasureHunter)
            elseif state.QDMode.value == 'STP' then
                equip(sets.midcast.CorsairShot.STP)
            end
        end
    elseif spell.action_type == 'Ranged Attack' then
        if buffactive['Triple Shot'] then
            equip(sets.TripleShot)
        end
    end
end
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if (spell.type == 'CorsairRoll' or spell.english == "Double-Up") and not spell.interrupted then
        display_roll_info(spell)
    end
    if spell.english == "Light Shot" then
        send_command('@timers c "Light Shot ['..spell.target.name..']" 60 down abilities/00195.png')
    end
    if player.status ~= 'Engaged' and state.WeaponLock.value == false then
        check_weaponset()
    end
end
function job_buff_change(buff,gain)
    -- If we gain or lose any flurry buffs, adjust gear.
    if S{'flurry'}:contains(buff:lower()) then
        if not gain then
            flurry = nil
            --add_to_chat(122, "Flurry status cleared.")
        end
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end
    if buff == "phalanx" or "Phalanx II" then
        if gain then
            state.phalanxset:set(false)
        end
    end
    if buff == "Charm" then
        if gain then  			
           send_command('input /p Charmd, please Sleep me.')		
        else	
           send_command('input /p '..player.name..' is no longer Charmed, please wake me up!')
        end
    end
    if buff == "petrification" then
        if gain then    
            equip(sets.defense.PDT)
            send_command('input /p Petrification, please Stona.')		
        else
        send_command('input /p '..player.name..' is no longer Petrify!')
        handle_equipping_gear(player.status)
        end
    end
    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /p Doomed, please Cursna.')
            send_command('@input /item "Holy Water" <me>')	
             disable('ring1','ring2','waist','neck')
        else
            enable('ring1','ring2','waist','neck')
            send_command('input /p Doom removed.')
            handle_equipping_gear(player.status)
        end
    end
    if buff == "Defense Down" then
        if gain then  			
            send_command('input /item "Panacea" <me>')
        end
    elseif buff == "Magic Def. Down" then
        if gain then  			
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "Max HP Down" then
        if gain then  			
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "Evasion Down" then
        if gain then  			
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "Magic Evasion Downn" then
        if gain then  			
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "Dia" then
        if gain then  			
            send_command('@input /item "panacea" <me>')
        end  
    elseif buff == "Bio" then
        if gain then  			
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "Bind" then
        if gain then  			
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "slow" then
        if gain then  			
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "weight" then
        if gain then  			
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "Attack Down" then
        if gain then  			
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "Accuracy Down" then
        if gain then  			
            send_command('@input /item "panacea" <me>')
        end
    end

    if buff == "VIT Down" then
        if gain then
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "INT Down" then
        if gain then
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "MND Down" then
        if gain then
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "STR Down" then
        if gain then
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "AGI Down" then
        if gain then
            send_command('@input /item "panacea" <me>')
        end
    end

    if buff == "curse" then
        if gain then  
        send_command('input /item "Holy Water" <me>')
        end
    end
    if buff == "poison" then
        if gain then  
        send_command('input /item "remedy" <me>')
        end
    end
    if buff == "sleep" then
        if gain then    
            send_command('input /p ZZZzzz, please cure.')		
        else
            send_command('input /p '..player.name..' is no longer Sleep!')
        end
    end
    if not midaction() then
        handle_equipping_gear(player.status)
    end
end
function check_buffs(check)
     
end
--Read incoming packet to differentiate between Haste/Flurry I and II
windower.register_event('action',
    function(act)
        --check if you are a target of spell
        local actionTargets = act.targets
        playerId = windower.ffxi.get_player().id
        isTarget = false
        for _, target in ipairs(actionTargets) do
            if playerId == target.id then
                isTarget = true
            end
        end
        if isTarget == true then
            if act.category == 4 then
                local param = act.param
                if param == 845 and flurry ~= 2 then
                    --add_to_chat(122, 'Flurry Status: Flurry I')
                    flurry = 1
                elseif param == 846 then
                    --add_to_chat(122, 'Flurry Status: Flurry II')
                    flurry = 2
              end
            end
        end
    end)
function job_handle_equipping_gear(playerStatus, eventArgs)
    determine_haste_group()
    update_combat_form()
    check_moving()

end
--[[function get_combat_form()
    if S{'NIN', 'DNC'}:contains(player.sub_job) and sub_weapons:contains(player.equipment.sub) then
        state.CombatForm:set("DW")
    else
        state.CombatForm:reset()
    end
end]]
function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    elseif player.equipment.sub:endswith('Shield') then
        state.CombatForm:reset()
    end
end
--[[function update_offense_mode()
    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
        state.CombatForm:set('DW')
    else
        state.CombatForm:reset()
    end
end]]

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end
    if state.phalanxset .value == true then
        --equip(sets.midcast.Phalanx)
        send_command('gs equip sets.midcast.Phalanx')
        send_command('input /p Phalanx set equiped [ON] PLZ GIVE ME PHALANX')		
    else 
        state.phalanxset:reset()
    end
    if update_job_states then update_job_states() 
    end
    check_weaponset()
end

windower.register_event('zone change',
    function()
        --add that at the end of zone change
        if update_job_states then update_job_states() end
    end
)

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Return a customized weaponskill mode to use for weaponskill sets.
-- Don't return anything if you're not overriding the default value.
function get_custom_wsmode(spell, spellMap, default_wsmode)
    if buffactive['Transcendancy'] then
        return 'Brew'
    end
end
mov = {counter=0}
if player and player.index and windower.ffxi.get_mob_by_index(player.index) then
    mov.x = windower.ffxi.get_mob_by_index(player.index).x
    mov.y = windower.ffxi.get_mob_by_index(player.index).y
    mov.z = windower.ffxi.get_mob_by_index(player.index).z
end

moving = false
windower.raw_register_event('prerender',function()
    mov.counter = mov.counter + 1;
    if mov.counter>15 then
        local pl = windower.ffxi.get_mob_by_index(player.index)
        if pl and pl.x and mov.x then
            dist = math.sqrt( (pl.x-mov.x)^2 + (pl.y-mov.y)^2 + (pl.z-mov.z)^2 )
            if dist > 1 and not moving then
                state.Moving.value = true
                send_command('gs c update')
				if world.area:contains("Adoulin") then
                send_command('gs equip sets.Adoulin')
				else
                send_command('gs equip sets.MoveSpeed')
                end

        moving = true

            elseif dist < 1 and moving then
                state.Moving.value = false
                send_command('gs c update')
                moving = false
            end
        end
        if pl and pl.x then
            mov.x = pl.x
            mov.y = pl.y
            mov.z = pl.z
        end
        mov.counter = 0
    end
end)

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    --if newStatus == 'Engaged' and player.equipment.main == 'Chatoyant Staff' then
        --state.OffenseMode:set('Ranged')
    --end
    --handle_equipping_gear(player.status)
    check_moving()
    --check_weaponset()
end

function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 11 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 11 and DW_needed <= 27 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 27 and DW_needed <= 38 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 38 and DW_needed <= 40 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 40 and DW_needed <= 42 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 42 then
            classes.CustomMeleeGroups:append('LowHaste')
        end
    end
end
function check_moving()
    if state.DefenseMode.value == 'None'  and state.Kiting.value == false then
        if state.Auto_Kite.value == false and moving then
            state.Auto_Kite:set(true)
            send_command('gs c update')

        elseif state.Auto_Kite.value == true and moving == false then
            state.Auto_Kite:set(false)
            send_command('gs c update')

        end
    end
end
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    -- if state.CP.current == 'on' then
    --     equip(sets.CP)
    --     disable('back')
    -- else
    --     enable('back')
    -- end
    if state.RP.current == 'on' then
        equip(sets.RP)
        disable('neck')
    else
        enable('neck')
    end
    if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
    end
    if world.area:contains("Adoulin") then
        idleSet = set_combine(idleSet, {body="Councilor's Garb"})
    end
    return idleSet
end
-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.CapacityMode.value then
        meleeSet = set_combine(meleeSet, sets.CapacityMantle)
    end
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end
    if state.RP.current == 'on' then
        equip(sets.RP)
        disable('neck')
    else
        enable('neck')
    end
    --[[if state.WeaponSet.value == "SWORDS" then
        send_command('input /lockstyleset 151')
    elseif state.WeaponSet.value == "DAGGERS" then
        send_command('input /lockstyleset 163')
    end]]
    --meleeSet = set_combine(meleeSet, select_earring())

    check_weaponset()

    return meleeSet
end
function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)


    if cmdParams[1]:lower() == 'roller1' then
        send_command('@input //cor roll 1 "'..state.Roller1.value..'"')
    elseif cmdParams[1]:lower() == 'roller2' then
        send_command('@input //cor roll 2 "'..state.Roller2.value..'"')
    end
  

end


function check_weaponset()
    equip(sets[state.WeaponSet.current])
    equip(sets[state.Weapongun.current])
    if (player.sub_job ~= 'NIN' and player.sub_job ~= 'DNC') then
        equip(sets.DefaultShield)
    elseif player.sub_job == 'NIN' and player.sub_job_level < 10 or player.sub_job == 'DNC' and player.sub_job_level < 20 then
        equip(sets.DefaultShield)
    end
end
function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then
        if type(tonumber(cmdParams[2])) == 'number' then
            if tonumber(cmdParams[2]) ~= DW_needed then
            DW_needed = tonumber(cmdParams[2])
            DW = true
            end
        elseif type(cmdParams[2]) == 'string' then
            if cmdParams[2] == 'false' then
                DW_needed = 0
                DW = false
            end
        end
        if type(tonumber(cmdParams[3])) == 'number' then
            if tonumber(cmdParams[3]) ~= Haste then
                Haste = tonumber(cmdParams[3])
            end
        end
        if type(cmdParams[4]) == 'string' then
            if cmdParams[4] == 'true' then
                moving = true
            elseif cmdParams[4] == 'false' then
                moving = false
            end
        end
        if not midaction() then
            job_update()
        end
    end
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    local msg = ''
    
    msg = msg .. 'Off.: '..state.OffenseMode.current
    msg = msg .. ', Rng.: '..state.RangedMode.current
    msg = msg .. ', WS.: '..state.WeaponskillMode.current
    msg = msg .. ', QD.: '..state.CastingMode.current

    if state.DefenseMode.value ~= 'None' then
        local defMode = state[state.DefenseMode.value ..'DefenseMode'].current
        msg = msg .. ', Defense: '..state.DefenseMode.value..' '..defMode
    end
    
    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end
    
    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value then
        msg = msg .. ', Target NPCs'
    end

    msg = msg .. ', Roll Size: ' .. ((state.LuzafRing.value and 'Large') or 'Small')
    
    add_to_chat(122, msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function define_roll_values()
    rolls = {
        ["Corsair's Roll"]   = {lucky=5, unlucky=9, bonus="Experience Points"},
        ["Ninja Roll"]       = {lucky=4, unlucky=8, bonus="Evasion"},
        ["Hunter's Roll"]    = {lucky=4, unlucky=8, bonus="Accuracy"},
        ["Chaos Roll"]       = {lucky=4, unlucky=8, bonus="Attack"},
        ["Magus's Roll"]     = {lucky=2, unlucky=6, bonus="Magic Defense"},
        ["Healer's Roll"]    = {lucky=3, unlucky=7, bonus="Cure Potency Received"},
        ["Puppet Roll"]      = {lucky=4, unlucky=8, bonus="Pet Magic Accuracy/Attack"},
        ["Choral Roll"]      = {lucky=2, unlucky=6, bonus="Spell Interruption Rate"},
        ["Monk's Roll"]      = {lucky=3, unlucky=7, bonus="Subtle Blow"},
        ["Beast Roll"]       = {lucky=4, unlucky=8, bonus="Pet Attack"},
        ["Samurai Roll"]     = {lucky=2, unlucky=6, bonus="Store TP"},
        ["Evoker's Roll"]    = {lucky=5, unlucky=9, bonus="Refresh"},
        ["Rogue's Roll"]     = {lucky=5, unlucky=9, bonus="Critical Hit Rate"},
        ["Warlock's Roll"]   = {lucky=4, unlucky=8, bonus="Magic Accuracy"},
        ["Fighter's Roll"]   = {lucky=5, unlucky=9, bonus="Double Attack Rate"},
        ["Drachen Roll"]     = {lucky=3, unlucky=7, bonus="Pet Accuracy"},
        ["Gallant's Roll"]   = {lucky=3, unlucky=7, bonus="Defense"},
        ["Wizard's Roll"]    = {lucky=5, unlucky=9, bonus="Magic Attack"},
        ["Dancer's Roll"]    = {lucky=3, unlucky=7, bonus="Regen"},
        ["Scholar's Roll"]   = {lucky=2, unlucky=6, bonus="Conserve MP"},
        ["Bolter's Roll"]    = {lucky=3, unlucky=9, bonus="Movement Speed"},
        ["Caster's Roll"]    = {lucky=2, unlucky=7, bonus="Fast Cast"},
        ["Courser's Roll"]   = {lucky=3, unlucky=9, bonus="Snapshot"},
        ["Blitzer's Roll"]   = {lucky=4, unlucky=9, bonus="Attack Delay"},
        ["Tactician's Roll"] = {lucky=5, unlucky=8, bonus="Regain"},
        ["Allies's Roll"]    = {lucky=3, unlucky=10, bonus="Skillchain Damage"},
        ["Miser's Roll"]     = {lucky=5, unlucky=7, bonus="Save TP"},
        ["Companion's Roll"] = {lucky=2, unlucky=10, bonus="Pet Regain and Regen"},
        ["Avenger's Roll"]   = {lucky=4, unlucky=8, bonus="Counter Rate"},
    }
end

function display_roll_info(spell)
    rollinfo = rolls[spell.english]
    local rollsize = (state.LuzafRing.value and 'Large') or 'Small'

    if rollinfo then
        add_to_chat(104, spell.english..' provides a bonus to '..rollinfo.bonus..'.  Roll size: '..rollsize)
        add_to_chat(104, 'Lucky roll is '..tostring(rollinfo.lucky)..', Unlucky roll is '..tostring(rollinfo.unlucky)..'.')
    end
end


-- Determine whether we have sufficient ammo for the action being attempted.
function do_bullet_checks(spell, spellMap, eventArgs)
    local bullet_name
    local bullet_min_count = 1
    
    if spell.type == 'WeaponSkill' then
        if spell.skill == "Marksmanship" then
            if spell.element == 'None' then
                -- physical weaponskills
                bullet_name = gear.WSbullet
            else
                -- magical weaponskills
                bullet_name = gear.MAbullet
            end
        else
            -- Ignore non-ranged weaponskills
            return
        end
    elseif spell.type == 'CorsairShot' then
        bullet_name = gear.QDbullet
    elseif spell.action_type == 'Ranged Attack' then
        bullet_name = gear.RAbullet
        if buffactive['Triple Shot'] then
            bullet_min_count = 3
        end
    end
    
    local available_bullets = player.inventory[bullet_name] or player.wardrobe[bullet_name]
    
    -- If no ammo is available, give appropriate warning and end.
    if not available_bullets then
        if spell.type == 'CorsairShot' and player.equipment.ammo ~= 'empty' then
            add_to_chat(104, 'No Quick Draw ammo left.  Using what\'s currently equipped ('..player.equipment.ammo..').')
            return
        elseif spell.type == 'WeaponSkill' and player.equipment.ammo == gear.RAbullet then
            add_to_chat(104, 'No weaponskill ammo left.  Using what\'s currently equipped (standard ranged bullets: '..player.equipment.ammo..').')
            return
        else
            add_to_chat(104, 'No ammo ('..tostring(bullet_name)..') available for that action.')
            eventArgs.cancel = true
            return
        end
    end
    
    -- Don't allow shooting or weaponskilling with ammo reserved for quick draw.
    if spell.type ~= 'CorsairShot' and bullet_name == gear.QDbullet and available_bullets.count <= bullet_min_count then
        add_to_chat(104, 'No ammo will be left for Quick Draw.  Cancelling.')
        eventArgs.cancel = true
        return
    end
    
    -- Low ammo warning.
    if spell.type ~= 'CorsairShot' and state.warned.value == false
        and available_bullets.count > 1 and available_bullets.count <= options.ammo_warning_limit then
        local msg = '*****  LOW AMMO WARNING: '..bullet_name..' *****'
        --local border = string.repeat("*", #msg)
        local border = ""
        for i = 1, #msg do
            border = border .. "*"
        end
        
        add_to_chat(104, border)
        add_to_chat(104, msg)
        add_to_chat(104, border)

        state.warned:set()
    elseif available_bullets.count > options.ammo_warning_limit and state.warned then
        state.warned:reset()
    end
end
function special_ammo_check()
    -- Stop if Animikii/Hauksbok equipped
    if no_shoot_ammo:contains(player.equipment.ammo) then
        cancel_spell()
        add_to_chat(123, '** Action Canceled: [ '.. player.equipment.ammo .. ' equipped!! ] **')
        return
    end
end
function lockstyle()
    send_command('wait 2;input /lockstyleset 151')
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(5, 26)
end
