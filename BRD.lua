-----------------------------Authors of this file--------------------------------
------           ******************************************                ------
---                                                                           ---
--	  Aragan (Asura) --------------- [Author Primary]                          -- 
--                                                                             --
---------------------------------------------------------------------------------
-- IMPORTANT: This include requires supporting include files:
-- from my web :
-- Mote-include
-- Mote-Mappings
-- Mote-Globals


--[[
    Custom commands:
    
    ExtraSongsMode may take one of three values: None, Dummy, FullLength
    
    You can set these via the standard 'set' and 'cycle' self-commands.  EG:
    gs c cycle ExtraSongsMode
    gs c set ExtraSongsMode Dummy
    
    The Dummy state will equip the bonus song instrument and ensure non-duration gear is equipped.
    The FullLength state will simply equip the bonus song instrument on top of standard gear.
    
    
    Simple macro to cast a dummy Daurdabla song:
    /console gs c set ExtraSongsMode Dummy
    /ma "Shining Fantasia" <me>
    
    To use a Terpander rather than Daurdabla, set the info.ExtraSongInstrument variable to
    'Terpander', and info.ExtraSongs to 1.
---]]
--[[
--use addon singer and AutoBuffBard addon -- AutoBuffBard save more song setup command like : //abb bumba ccsv 

state.Songset have songsset its copy from AutoBuffBard addon file abb_sets 
u can add name songsset there and copy name in state.Songset

cycle Songset

send_command('bind f2 gs c cycle Songset')
send_command('bind !f2 gs c Songset')

macro

/con gs c Songset

its do all ja first  then do u songset
]]

-- Initialization function for this job file.
function get_sets()
    include('Display.lua') 
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
    include('organizer-lib')
    res = require 'resources'
end
organizer_items = {
    "Airmid's Gorget",
    "Tumult's Blood",
    "Sarama's Hide",
    "Hidhaegg's Scale",
    "Sovereign's Hide",
    "Grape Daifuku",
    "Soy Ramen",
    "G. Curry Bun +1",
    "Pukatrice Egg",
    "Moogle Amp.",
    "Om. Sandwich",
    "Red Curry Bun",
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
    "Reraise Earring",}
-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
	send_command('lua l Singer')
    state.ExtraSongsMode = M{['description']='Extra Songs', 'None', 'Dummy', 'FullLength', 'Marsyas'}
    include('Mote-TreasureHunter')
    state.TreasureMode:set('None')
    state.Buff['Pianissimo'] = buffactive['pianissimo'] or false
    send_command('wait 6;input /lockstyleset 168')
    elemental_ws = S{"Flash Nova", "Sanguine Blade","Seraph Blade","Burning Blade","Red Lotus Blade"
    , "Shining Strike", "Aeolian Edge", "Gust Slash", "Cyclone","Energy Steal","Energy Drain"
    , "Leaden Salute", "Wildfire", "Hot Shot", "Flaming Arrow", "Trueflight", "Blade: Teki", "Blade: To"
    , "Blade: Chi", "Blade: Ei", "Blade: Yu", "Frostbite", "Freezebite", "Herculean Slash", "Cloudsplitter"
    , "Primal Rend", "Dark Harvest", "Shadow of Death", "Infernal Scythe", "Thunder Thrust", "Raiden Thrust"
    , "Tachi: Goten", "Tachi: Kagero", "Tachi: Jinpu", "Tachi: Koki", "Rock Crusher", "Earth Crusher", "Starburst"
    , "Sunburst", "Omniscience", "Garland of Bliss"}
    -- For tracking current recast timers via the Timers plugin.
    custom_timers = {}
    staff = S{"Xoanon"}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal', 'Acc', 'Shield', 'CRIT')
    state.HybridMode:options('Normal', 'DT')
    state.PhysicalDefenseMode:options('PDT', 'Evasion')
    state.MagicalDefenseMode:options('MDT')
    state.WeaponskillMode:options('Normal', 'PDL')
    state.CastingMode:options('Normal', 'AUGMENT')
    state.IdleMode:options('Normal', 'DT', 'MDT', 'HP', 'Regen', 'Evasion', 'EnemyCritRate', 'Refresh', 'Sphere')

    state.LullabyMode = M{['description']='Lullaby Instrument', 'Harp', 'Horn'}

    state.Carol = M{['description']='Carol',
        'Fire Carol', 'Fire Carol II', 'Ice Carol', 'Ice Carol II', 'Wind Carol', 'Wind Carol II',
        'Earth Carol', 'Earth Carol II', 'Lightning Carol', 'Lightning Carol II', 'Water Carol', 'Water Carol II',
        'Light Carol', 'Light Carol II', 'Dark Carol', 'Dark Carol II',
        }

    state.Threnody = M{['description']='Threnody',
        'Fire Threnody II', 'Ice Threnody II', 'Wind Threnody II', 'Earth Threnody II',
        'Ltng. Threnody II', 'Water Threnody II', 'Light Threnody II', 'Dark Threnody II',
        }

    state.Etude = M{['description']='Etude',  'Herculean Etude', 'Sage Etude', 'Sinewy Etude', 'Learned Etude',
        'Quick Etude', 'Swift Etude', 'Vivacious Etude', 'Vital Etude', 'Dextrous Etude', 'Uncanny Etude',
        'Spirited Etude', 'Logical Etude', 'Enchanting Etude', 'Bewitching Etude'}

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
    
    -- Adjust this if using the Terpander (new +song instrument)
    info.ExtraSongInstrument = 'Daurdabla'
    info.SongHorn = 'Gjallarhorn'
    info.SongMarsyas = 'Marsyas'


    -- How many extra songs we can keep from Daurdabla/Terpander
    info.ExtraSongs = 2

    -- Set this to false if you don't want to use custom timers.
    state.UseCustomTimers = M(true, 'Use Custom Timers')
    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    state.HippoMode = M(false, "hippoMode")
    state.RP = M(false, "Reinforcement Points Mode")
    state.CapacityMode = M(false, 'Capacity Point Mantle')
	state.Songset = M{['description']='Songset','mboze', 'xevioso', 'kalunga', 'ngai','arebati', 'ongo', 'bumba',
	 'haste', 'magic', 'aria', 'ph','sortie4', 'ody4', 'ody','sortie',}
    state.WeaponSet = M{['description']='Weapon Set', 'Normal', 'Twashtar', 'TwashtarCrepuscular', 'Tauret', 'Naegling', 'NaeglingCrepuscular','Carnwenhan', 'Aeneas', 'Xoanon'}
    --state.Moving = M(false, "moving")

    --keyboard buttons bind
    --use //listbinds    .. to show command keys
    -- Additional local binds
    send_command('bind f7 gs c cycle ExtraSongsMode')
    send_command('bind !` input /ma "Chocobo Mazurka" <me>')
    send_command('wait 2;input /lockstyleset 168')
    send_command('bind @w gs c toggle WeaponLock')
    send_command('bind f5 gs c cycle WeaponskillMode')
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind !/ gs enable all')
    send_command('bind ^/ gs disable all')
    --send_command('bind f7 input //fillmode')
    send_command('bind f1 gs c cycle HippoMode')
    send_command('bind ^3 gs c cycle Etude')
    send_command('bind ^4 gs c Etude')
    send_command('bind f3 gs c cycle Carol')
    send_command('bind !f3 gs c Carol')
    send_command('bind f4 gs c cycle Threnody')
    send_command('bind !f4 gs c Threnody')
    send_command('bind f6 gs c cycle WeaponSet')
    send_command('bind !f6 gs c cycleback WeaponSet')
    send_command('bind @` gs c cycle LullabyMode')
    send_command('bind @c gs c toggle CapacityMode')
    send_command('bind @x gs c toggle RP')  
    send_command('bind f2 gs c cycle Songset')
    send_command('bind !f2 gs c Songset')
    select_default_macro_book()
    update_combat_form()
	DW_needed = 0
    DW = false
    --state.Auto_Kite = M(false, 'Auto_Kite')
    state.Moving  = M(false, "moving")
    moving = false
	--add that at the end of user_setup
    if init_job_states then init_job_states({"WeaponLock","MagicBurst","HippoMode"},{"IdleMode","OffenseMode","WeaponskillMode","WeaponSet","ExtraSongsMode","Etude","Carol","Threnody","TreasureMode"}) 
    end
    
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
    ---- WeaponSet ----

    sets.normal = {}
    sets.Twashtar = {main="Twashtar", sub="Centovente"}
    sets.TwashtarCrepuscular = {main="Twashtar", sub="Crepuscular Knife"}
    sets.Tauret = {main="Tauret", sub="Crepuscular Knife",}
    sets.Naegling = {main="Naegling", sub="Centovente"}
    sets.NaeglingCrepuscular = {main="Naegling", sub="Crepuscular Knife"}
    sets.Carnwenhan = {main="Carnwenhan", sub="Crepuscular Knife"}
    sets.Aeneas = {main="Aeneas", sub="Centovente"}
    sets.Xoanon = {main="Xoanon", sub="Alber Strap"}

    sets.DefaultShield = {sub="Genmei Shield"}

 -- neck JSE Necks Reinf
 sets.RP = {}
 -- Capacity Points Mode
 sets.CapacityMantle = {}

    -- Precast Sets

    sets.precast.RA = {
    range="Trollbane",  
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    left_ear="Crep. Earring",
    right_ear="Telos Earring",
    }
    sets.midcast.RA = {
    range="Trollbane",  
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
	hands={ name="Nyame Gauntlets", augments={'Path: B',}},
	legs={ name="Nyame Flanchard", augments={'Path: B',}},
	feet={ name="Nyame Sollerets", augments={'Path: B',}},
    }	

    -- Precast Sets

    -- Fast cast sets for spells
    sets.precast.FC = {      
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Inyanga Jubbah +2",
    hands="Leyline Gloves",
    legs="Aya. Cosciales +2",
    feet="Fili Cothurnes +2",
    waist="Witful Belt",
    neck="Orunmila's Torque",
    left_ear="Loquac. Earring",
    right_ear="Etiolation Earring",
    left_ring="Prolix Ring",
    right_ring="Kishar Ring",
    back={ name="Fi Follet Cape +1", augments={'Path: A',}},
}
    sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak", sub="Ammurapi Shield"})

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body={ name="Chironic Doublet", augments={'"Mag.Atk.Bns."+5','"Cure" potency +10%','MND+4','Mag. Acc.+1',}},
    legs="Doyen Pants",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    waist="Witful Belt",
    neck="Baetyl Pendant",
    left_ear="Loquac. Earring",
    right_ear="Mendi. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Kishar Ring",
    back="Fi Follet Cape +1",
})

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Inyanga Jubbah +2",
    hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
    legs="Aya. Cosciales +2",
    feet="Fili Cothurnes +2",
    neck="Baetyl Pendant",
    waist="Siegel Sash",
    left_ear="Etiolation Earring",
    right_ear="Loquac. Earring",
    left_ring="Kishar Ring",
    right_ring="Prolix Ring",
    back={ name="Fi Follet Cape +1", augments={'Path: A',}},
})
sets.precast.FC.Stoneskin = set_combine(sets.precast.FC['Enhancing Magic'], {
    legs="Doyen Pants",
    head="Umuthi Hat",
    waist="Siegel Sash",})

    sets.precast.FC.BardSong = {
        main="Carnwenhan",
        sub={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
        head="Fili Calot +2",
        body="Inyanga Jubbah +2",
        hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
        legs="Aya. Cosciales +2",
        feet="Fili Cothurnes +2",
        neck="Baetyl Pendant",
        waist="Witful Belt",
        left_ear="Etiolation Earring",
        right_ear="Loquac. Earring",
        left_ring="Kishar Ring",
        right_ring="Prolix Ring",
        back={ name="Fi Follet Cape +1", augments={'Path: A',}},
}

    sets.precast.FC.DaurdablaDummy = set_combine(sets.precast.FC.BardSong, {range=info.ExtraSongInstrument})
    sets.precast.FC.Gjallarhorn = set_combine(sets.precast.FC.BardSong, {range=info.SongHorn})
    sets.precast.FC.Marsyas = set_combine(sets.precast.FC.BardSong, {range=info.SongMarsyas})


    
    -- Precast sets to enhance JAs
    
    sets.precast.JA.Nightingale = {feet="Bihu Slippers +3"}
    sets.precast.JA.Troubadour = {body="Bihu Jstcorps. +3"}
    sets.precast.JA['Soul Voice'] = {legs="Bihu Cannions +3"}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        legs="Dashing Subligar",
    }
    sets.TreasureHunter = { 
        head="White rarab cap +1", 
        waist="Chaac Belt",
     }
       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {range="Linos",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Fotia Gorget",
        ear2="Ishvara Earring",
        ear1="Moonshade Earring",
        ring1="Ilabrat Ring",
        ring2="Cornelia's Ring",
        waist="Kentarch Belt +1",
        back={ name="Intarabus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    }
    
    sets.precast.WS.PDL = set_combine(sets.precast.WS,{
        body="Bunzi's Robe",
        neck={ name="Bard's Charm +2", augments={'Path: A',}},})
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Evisceration'] = { range="Linos",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        neck="Fotia Gorget",
        left_ear="Moonshade Earring",
        right_ear="Mache Earring +1",
    body="Bihu Jstcorps. +3",
    hands="Bunzi's Gloves",
    ring1="Hetairoi Ring",
    ring2="Ilabrat Ring",
    back="Annealed Mantle",
    waist="Fotia Belt",
    legs="Lustr. Subligar +1",
    feet="Lustra. Leggings +1",
    }
    sets.precast.WS['Evisceration'].PDL = set_combine(sets.precast.WS['Evisceration'],{
        body="Bunzi's Robe",
        neck={ name="Bard's Charm +2", augments={'Path: A',}},
        })
    sets.precast.WS['Exenterator'] = {range="Linos",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Bihu Jstcorps. +3",
        legs="Lustr. Subligar +1",
    feet="Lustra. Leggings +1",
    hands="Bunzi's Gloves",
    neck="Fotia Gorget",
    left_ear="Brutal Earring",
    right_ear="Balder Earring +1",
    ring1="Hetairoi Ring",
    ring2="Ilabrat Ring",
    waist="Fotia Belt",
    back="Annealed Mantle",
    }
    sets.precast.WS['Exenterator'].PDL = set_combine(sets.precast.WS['Exenterator'],{
        body="Bunzi's Robe",})
    sets.precast.WS['Mordant Rime'] = {range="Linos",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body="Bihu Jstcorps. +3",
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Bard's Charm +2", augments={'Path: A',}},
    ear1="Ishvara Earring",
    ear2="Regal Earring",
    ring1="Sroda Ring", 
    ring2="Cornelia's Ring",
    waist="Sailfi Belt +1",
    back={ name="Intarabus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
}
sets.precast.WS['Mordant Rime'].PDL = set_combine(sets.precast.WS['Mordant Rime'],{
    body="Bunzi's Robe",})
sets.precast.WS['Rudras Storm'] = {range="Linos",
head={ name="Nyame Helm", augments={'Path: B',}},
body="Bihu Jstcorps. +3",
hands={ name="Nyame Gauntlets", augments={'Path: B',}},
legs={ name="Nyame Flanchard", augments={'Path: B',}},
feet={ name="Nyame Sollerets", augments={'Path: B',}}, 
neck={ name="Bard's Charm +2", augments={'Path: A',}},
ear2="Ishvara Earring",
ear1="Moonshade Earring",
ring1="Ilabrat Ring",
ring2="Cornelia's Ring",
waist="Kentarch Belt +1",
back={ name="Intarabus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
}
sets.precast.WS['Rudras Storm'].PDL = set_combine(sets.precast.WS['Rudras Storm'],{
    body="Bunzi's Robe",
})

sets.precast.WS['Savage Blade'] = {range="Linos",
head={ name="Nyame Helm", augments={'Path: B',}},
body="Bihu Jstcorps. +3",
hands={ name="Nyame Gauntlets", augments={'Path: B',}},
legs={ name="Nyame Flanchard", augments={'Path: B',}},
feet={ name="Nyame Sollerets", augments={'Path: B',}},
neck="Rep. Plat. Medal",
ear1="Moonshade Earring",
ear2="Ishvara Earring",
ring1="Sroda Ring", 
ring2="Cornelia's Ring",
waist="Sailfi Belt +1",
back={ name="Intarabus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
}

sets.precast.WS['Savage Blade'].PDL = set_combine(sets.precast.WS['Savage Blade'],{
body="Bunzi's Robe",
neck={ name="Bard's Charm +2", augments={'Path: A',}},
})

sets.precast.WS['Myrkr'] = {
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
neck="Sibyl Scarf",
waist="Orpheus's Sash",
left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
right_ear="Friomisi Earring",
left_ring="Cornelia's Ring",
right_ring="Freke Ring",
back={ name="Intarabus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}


-- Elemental Weapon Skill --elemental_ws--

-- SANGUINE BLADE
-- 50% MND / 50% STR Darkness Elemental
sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS, {
    head="Pixie Hairpin +1",
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck="Sibyl Scarf",
    waist="Orpheus's Sash",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Friomisi Earring",
    left_ring="Cornelia's Ring",
    right_ring="Archon Ring",
    back={ name="Intarabus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
})

sets.precast.WS["Dark Harvest"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
sets.precast.WS["Shadow of Death"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
sets.precast.WS["Infernal Scythe"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
sets.precast.WS["Energy Steal"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
sets.precast.WS["Energy Drain"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
sets.precast.WS.Cataclysm = sets.precast.WS["Sanguine Blade"]

sets.precast.WS["Burning Blade"] = set_combine(sets.precast.WS, {
    range="Linos",
    head="C. Palug Crown",
    head={ name="Nyame Helm", augments={'Path: B',}},
body={ name="Nyame Mail", augments={'Path: B',}},
hands={ name="Nyame Gauntlets", augments={'Path: B',}},
legs={ name="Nyame Flanchard", augments={'Path: B',}},
feet={ name="Nyame Sollerets", augments={'Path: B',}},
    ear1="Moonshade Earring",
    ear2="Friomisi Earring",
    ring1={ name="Metamor. Ring +1", augments={'Path: A',}},
    ring2="Cornelia's Ring",
    neck="Sibyl Scarf",
    waist="Orpheus's Sash",
    back={ name="Intarabus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
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

    
sets.precast.WS['Black Halo'] = {
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Ishvara Earring",
    left_ring="Sroda Ring", 
    right_ring="Cornelia's Ring",
    back={ name="Intarabus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}


sets.precast.WS['Shattersoul'] = {
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Brutal Earring",
    right_ear="Ishvara Earring",
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    left_ring="Rufescent Ring",
    back={ name="Intarabus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}


    
    -- Midcast Sets

    -- General set for recast times.
    sets.midcast.FastRecast = {}
        
    -- Gear to enhance certain classes of songs.  No instruments added here since Gjallarhorn is being used.
    sets.midcast.Ballad = {legs="Fili Rhingrave +2"}
    sets.midcast.Lullaby = {}
    sets.midcast.Madrigal = {head="Fili Calot +2", back="Intarabus's Cape",}
    sets.midcast.March = {hands="Fili Manchettes +2",}
    sets.midcast.Minuet = {body="Fili Hongreline +2",}
    sets.midcast.Minne = {}
    sets.midcast.Paeon = {}
    sets.midcast.Carol = {}
    sets.midcast["Sentinel's Scherzo"] = {feet="Fili Cothurnes +2"}
    sets.midcast['Magic Finale'] = {neck="Sanctity Necklace",
    waist="Luminary Sash",
    legs="Fili Rhingrave +2",
}

    sets.midcast.Mazurka = {range=info.ExtraSongInstrument}
    
    sets.AUGMENT = {
    main="Carnwenhan",
    sub={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
    head="Fili Calot +2",
    body="Fili Hongreline +2",
    hands="Fili Manchettes +2",
    legs="Fili Rhingrave +2",
    feet="Fili Cothurnes +2",
    neck="Mnbw. Whistle +1",
    ear1="Odnowa Earring +1",
    ear2="Etiolation Earring",
    ring1="Moonlight Ring",
    ring2="Defending Ring",
    waist="Flume Belt +1",
    back="Intarabus's Cape",
    }
    -- For song buffs (duration and AF3 set bonus)
    sets.midcast.SongEffect = {
    main="Carnwenhan",
    sub={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
    head="Fili Calot +2",
    body="Fili Hongreline +2",
    hands="Fili Manchettes +2",
    legs="Inyanga Shalwar +2",
    feet="Brioso Slippers +3",
    neck="Mnbw. Whistle +1",
    ear1="Odnowa Earring +1",
    ear2="Loquac. Earring",
    ring1="Stikini Ring +1",
    ring2="Stikini Ring +1",
    waist="Witful Belt",
    back="Intarabus's Cape",
}
sets.midcast.SongEffect.AUGMENT = {
main="Carnwenhan",
sub={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
head="Fili Calot +2",
body="Fili Hongreline +2",
hands="Fili Manchettes +2",
legs="Fili Rhingrave +2",
feet="Fili Cothurnes +2",
neck="Mnbw. Whistle +1",
ear1="Odnowa Earring +1",
ear2="Etiolation Earring",
ring1="Moonlight Ring",
ring2="Defending Ring",
waist="Flume Belt +1",
back="Intarabus's Cape",
}
sets.midcast.SongStringSkill = {
    ring1="Stikini Ring +1",
    ring2="Stikini Ring +1",
}
    -- For song defbuffs (duration primary, accuracy secondary)
    sets.midcast.SongDebuff = {        range="Gjallarhorn",
    sub="Ammurapi Shield",
        head="Fili Calot +2",
        body="Fili Hongreline +2",
        hands="Fili Manchettes +2",    
        legs="Fili Rhingrave +2",
        feet="Fili Cothurnes +2",
        neck="Mnbw. Whistle +1",
        waist="Kobo Obi",
        left_ear="Digni. Earring",
        right_ear="Fili Earring +1",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Stikini Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    


    -- For song defbuffs (accuracy primary, duration secondary)
    sets.midcast.ResistantSongDebuff = {        range="Gjallarhorn",
    sub="Ammurapi Shield",
        head="Fili Calot +2",
        body="Fili Hongreline +2",
        hands="Fili Manchettes +2",    
        legs="Fili Rhingrave +2",
        feet="Fili Cothurnes +2",
        neck="Mnbw. Whistle +1",
        waist="Kobo Obi",
        left_ear="Digni. Earring",
        right_ear="Fili Earring +1",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Stikini Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }

    -- Song-specific recast reduction
    --sets.midcast.SongRecast = {}

    --sets.midcast.Daurdabla = set_combine(sets.midcast.FastRecast, sets.midcast.SongRecast, {range=info.ExtraSongInstrument})

    -- Cast spell with normal gear, except using Daurdabla instead
    sets.midcast.Daurdabla = {range=info.ExtraSongInstrument}

    -- Dummy song with Daurdabla; minimize duration to make it easy to overwrite.
    sets.midcast.DaurdablaDummy = set_combine(sets.midcast.SongEffect, {range=info.ExtraSongInstrument})
    sets.midcast.DaurdablaDummy.AUGMENT = set_combine(sets.midcast.SongEffect.AUGMENT, {range=info.ExtraSongInstrument})

    sets.midcast.Gjallarhorn = set_combine(sets.midcast.SongEffect, {range=info.SongHorn})
    sets.midcast.Marsyas = set_combine(sets.midcast.SongEffect, {range=info.SongMarsyas})

    --dummy songs
    sets.midcast["Army's Paeon"] = sets.midcast.DaurdablaDummy
    sets.midcast["Valor Minuet"] = sets.midcast.DaurdablaDummy
    sets.midcast["Knight's Minne"] = sets.midcast.DaurdablaDummy
    sets.midcast["Sheepfoe Mambo"] = sets.midcast.DaurdablaDummy
    sets.midcast["Shining Fantasia"] = sets.midcast.DaurdablaDummy
    sets.midcast["Herb Pastoral"] = sets.midcast.DaurdablaDummy

    -- Other general spells and classes.
    sets.midcast.Cure = {
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body={ name="Chironic Doublet", augments={'"Mag.Atk.Bns."+5','"Cure" potency +10%','MND+4','Mag. Acc.+1',}},
    legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Nodens Gorget",
    waist="Luminary Sash",
    left_ear="Gifted Earring",
    right_ear="Mendi. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back="Solemnity Cape",
}
        
    sets.midcast.Curaga = sets.midcast.Cure

    sets.midcast['Enhancing Magic'] = {
        sub="Ammurapi Shield",
        head="Telchine Cap",
        body="Telchine Chas.",
        hands="Telchine Gloves",
        legs="Telchine Braconi",
        feet="Telchine Pigaches",
        neck="Incanter's Torque",
        waist="Olympus Sash",
        left_ear="Andoaa Earring",
        right_ear="Mendi. Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back={ name="Fi Follet Cape +1", augments={'Path: A',}},
        }

    sets.midcast.Regen = set_combine(sets.midcast['Enhancing Magic'], {head="Inyanga Tiara +2"})
    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {waist="Gishdubar Sash", back="Grapevine Cape"})
    sets.midcast.Protect = set_combine(sets.midcast['Enhancing Magic'], {ring2="Sheltered Ring"})
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Shell
    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {   
        legs="Haven Hose",
        left_ear="Earthcry Earring",      
     neck="Nodens Gorget",
     waist="Siegel Sash",
    })
        
    sets.midcast.Cursna = {
        neck="Debilis Medallion",
        left_ring="Haoma's Ring",
        right_ring="Menelaus's Ring",
    }

    sets.midcast.StatusRemoval = {
            head="Vanya Hood",
            body="Vanya Robe",
            legs="Aya. Cosciales +2",
            feet="Vanya Clogs",
            neck="Incanter's Torque",
            ear2="Meili Earring",
            ring1="Stikini Ring +1",
            ring2="Stikini Ring +1",
            }


        
    sets.midcast['Enfeebling Magic'] = {
        main="Arendsi Fleuret",
        sub="Ammurapi Shield",
        range="Linos",
        body={ name="Cohort Cloak +1", augments={'Path: A',}},
        hands="Inyan. Dastanas +2",
        legs={ name="Chironic Hose", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','MND+7','"Mag.Atk.Bns."+10',}},
        feet="Medium's Sabots",
        neck="Incanter's Torque",
        waist="Luminary Sash",
        left_ear="Crep. Earring",
        right_ear="Fili Earring +1",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back="Aurist's Cape +1",
        }
    
    sets.midcast.Dispelga = set_combine(sets.midcast['Enfeebling Magic'], {main="Daybreak", sub="Ammurapi Shield"})
    
    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {
        body="Annoint. Kalasiris",
        hands="Inyan. Dastanas +2",
        legs="Assid. Pants +1",
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        left_ear="Infused Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
           }
    
    -- Defense sets

    sets.defense.PDT = {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body="Adamantite Armor",
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear="Tuisto Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Stikini Ring +1",
        right_ring="Defending Ring",
        back="Intarabus's Cape",    }
    sets.defense.Evasion = {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        waist="Svelt. Gouriz +1",
        left_ear="Infused Earring",
        right_ear="Eabani Earring",
        left_ring="Vengeful Ring",
        right_ring="Defending Ring",
        back="Intarabus's Cape",
    }

    sets.defense.MDT = {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear="Tuisto Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Stikini Ring +1",
        right_ring="Defending Ring",
        back="Moonlight Cape",
    }

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle = {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body="Adamantite Armor",
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear="Tuisto Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Stikini Ring +1",
        right_ring="Defending Ring",
        back="Intarabus's Cape",
    }

    sets.idle.PDT = {        head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    body="Adamantite Armor",
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Stikini Ring +1",
    right_ring="Defending Ring",
    back="Intarabus's Cape",
    }

    sets.idle.Town = {    
    feet="Fili Cothurnes +2",
    left_ear="Infused Earring",
}
sets.idle.HP = {
    ammo="Staunch Tathlum +1",
    head="Nyame Helm",
    body="Adamantite Armor",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Plat. Mog. Belt",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Moonlight Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back="Moonlight Cape",
}
sets.idle.MDT = sets.defense.MDT
sets.idle.Evasion = sets.defense.Evasion
sets.idle.EnemyCritRate = set_combine(sets.idle.PDT, { 
    ammo="Eluder's Sachet",
    left_ring="Warden's Ring",
    right_ring="Fortified Ring",
    back="Reiki Cloak",
})
sets.idle.Regen = set_combine(sets.idle, {
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    right_ear="Infused Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
})
sets.idle.Sphere = set_combine(sets.idle, {
    body="Annoint. Kalasiris",
})
    sets.idle.Weak = {       head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Carrier's Sash",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Stikini Ring +1",
    right_ring="Defending Ring",
    back="Intarabus's Cape",    }


    sets.Kiting = {feet="Fili Cothurnes +2"}
	sets.Adoulin = {body="Councilor's Garb",}
    sets.MoveSpeed = {feet="Fili Cothurnes +2",}

    sets.latent_refresh = {waist="Fucho-no-obi"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Basic set for if no TP weapon is defined.
    sets.engaged = {range="Linos",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Ashera Harness",
        hands="Volte Mittens",
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet="Battlecast Gaiters",
        neck={ name="Bard's Charm +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        right_ear="Cessance Earring",
        left_ear="Telos Earring",
        left_ring="Moonlight Ring",
        right_ring="Chirich Ring +1",
        back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
        }

    -- Sets with weapons defined.
    sets.engaged.Shield = {range="Linos",
        main="Naegling",
        sub="Genmei Shield",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Ashera Harness",
        hands="Bunzi's Gloves",
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Bard's Charm +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Telos Earring",
        right_ear="Fili Earring +1",
        left_ring="Moonlight Ring",
        right_ring="Chirich Ring +1",
        back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
        }

    sets.engaged.CRIT = set_combine(sets.engaged, {
        range="Linos",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        legs={ name="Zoar Subligar +1", augments={'Path: A',}},
        feet="Aya. Gambieras +2",
        neck="Nefarious Collar +1",
        right_ring="Hetairoi Ring",
        back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},  
      })
    sets.engaged.Acc = set_combine(sets.engaged, {        range="Linos",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Ashera Harness",
        hands="Aya. Manopolas +2",
        legs="Aya. Cosciales +2",
        feet="Aya. Gambieras +2",
        neck={ name="Bard's Charm +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Telos Earring",
        right_ear="Cessance Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
    })


    ---------------------------------------- DW-HASTE ------------------------------------------
    -- * DNC Subjob DW Trait: +15%
    -- * NIN Subjob DW Trait: +25%
    --DW cap all set haste capped

    sets.engaged.DW = set_combine(sets.engaged ,{
        range="Linos",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Ashera Harness",
        hands="Volte Mittens",
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet="Battlecast Gaiters",
        neck={ name="Bard's Charm +2", augments={'Path: A',}},
        waist="Reiki Yotai",
        left_ear="Suppanomimi",
        right_ear="Balder Earring +1",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},    
    })

    sets.engaged.DW.Acc = set_combine(sets.engaged.Acc ,{
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Ashera Harness",
        hands="Aya. Manopolas +2",
        legs="Aya. Cosciales +2",
        feet="Aya. Gambieras +2",
        neck={ name="Bard's Charm +2", augments={'Path: A',}},
        waist="Reiki Yotai",
        left_ear="Suppanomimi",
        right_ear="Cessance Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
    })
    sets.engaged.DW.CRIT = set_combine(sets.engaged.CRIT, {
    range="Linos",
    head={ name="Blistering Sallet +1", augments={'Path: A',}},
    legs={ name="Zoar Subligar +1", augments={'Path: A',}},
    feet="Aya. Gambieras +2",
    neck="Nefarious Collar +1",
    waist="Reiki Yotai",
    left_ear="Suppanomimi",
    right_ring="Hetairoi Ring",
    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},   
    })
------------------------------------------------------------------------------------------------
---------------------------------------- Hybrid Sets -------------------------------------------
------------------------------------------------------------------------------------------------

sets.engaged.Hybrid = {
    hands="Bunzi's Gloves",
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    ring1="Moonlight Ring", --5/5
    ring2="Moonlight Ring", --5/5
    }

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.Acc.DT = set_combine(sets.engaged.Acc, sets.engaged.Hybrid)
    sets.engaged.CRIT.DT = set_combine(sets.engaged.CRIT, sets.engaged.Hybrid)

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
    sets.engaged.DW.Acc.DT = set_combine(sets.engaged.DW.Acc, sets.engaged.Hybrid)
    sets.engaged.DW.CRIT.DT = set_combine(sets.engaged.DW.CRIT, sets.engaged.Hybrid)





    --------------------------------------
    -- Custom buff sets
    --------------------------------------



    sets.buff.Doom = {    neck="Nicander's Necklace",
    waist="Gishdubar Sash",
    left_ring="Purity Ring",
    right_ring="Blenmot's Ring +1",}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type:endswith('Magic') and buffactive.silence then
        eventArgs.cancel = true
        send_command('input /item "Remedy" <me>')
    end
end
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.type == "WeaponSkill" then
        if (spell.target.model_size + spell.range * range_mult[spell.range]) < spell.target.distance then
            cancel_spell()
            add_to_chat(123, spell.name..' Canceled: [Out of /eq]')
            return
        end
    end
    if spellMap == 'Utsusemi' then
        if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
            cancel_spell()
            add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')
            eventArgs.handled = true
            return
        elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
            send_command('cancel 66; cancel 444; cancel Copy Image; cancel Copy Image (2)')
        end
    end
    if spell.english == 'Warcry' then
        if buffactive['Warcry'] then
            cancel_spell()
            add_to_chat(123, spell.name..' Canceled: Warcry its up [active]')
        end
    end
    if spell.type == 'BardSong' then
        if spell.name == 'Honor March' then
            equip({range="Marsyas"})
        end
        if spell.name == "Aria of Passion" then
            equip({range="Loughnashade"})
        end
        if string.find(spell.name,'Lullaby') then
            if buffactive.Troubadour then
                equip({range="Marsyas"})
            elseif state.LullabyMode.value == 'Harp' and spell.english:contains('Horde') then
                equip({range="Daurdabla"})
            else
                equip({range="Gjallarhorn"})
            end
        end
        -- Auto-Pianissimo
        --[[if ((spell.target.type == 'PLAYER' and not spell.target.charmed) or (spell.target.type == 'NPC' and spell.target.in_party)) and
            not state.Buff['Pianissimo'] then
            
            local spell_recasts = windower.ffxi.get_spell_recasts()
            if spell_recasts[spell.recast_id] < 2 then
                send_command('@input /ja "Pianissimo" <me>; wait 1.5; input /ma "'..spell.name..'" '..spell.target.name)
                eventArgs.cancel = true
                return
            end
        end]]
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type:lower() == 'weaponskill' then
		if player.tp == 3000 then  -- Replace Moonshade Earring if we're at cap TP
            equip({left_ear="Ishvara Earring"})
		end
	end
    -- CP mantle must be worn when a mob dies, so make sure it's equipped for WS.
    if state.CapacityMode.value then
        equip(sets.CapacityMantle)
    end
    if spell.type == 'WeaponSkill' then
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
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Magic' then
        if spell.type == 'BardSong' then
            -- layer general gear on first, then let default handler add song-specific gear.
            local generalClass = get_song_class(spell)
            if generalClass and sets.midcast[generalClass] then
                equip(sets.midcast[generalClass])
            end
            if spell.name == 'Honor March' then
                equip({range="Marsyas"})
            end
            if spell.name == "Aria of Passion" then
                equip({range="Loughnashade"})
            end
            if string.find(spell.name,'Lullaby') then
                if buffactive.Troubadour then
                    equip({range="Marsyas"})
                elseif state.LullabyMode.value == 'Harp' and spell.english:contains('Horde') then
                    equip({range="Daurdabla"})
                    equip(sets.midcast.SongStringSkill)
                else
                    equip({range="Gjallarhorn"})
                end
            end
        end
    end
    if spell.skill == 'Enhancing Magic' then
        equip(sets.midcast['Enhancing Magic'])
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)


        --state.ExtraSongsMode:reset()
    
    if not spell.interrupted then
        if spell.name == 'Utsusemi: Ichi' then
            overwrite = true
        elseif spell.name == 'Utsusemi: Ni' then
            overwrite = true
        end
    end
end
-- Set eventArgs.handled to true if we don't want automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' and not spell.interrupted then
        if spell.target and spell.target.type == 'SELF' then
            adjust_timers(spell, spellMap)
        end
        if not spell.interrupted then
            if spell.name == 'Utsusemi: Ichi' then
                overwrite = true
            elseif spell.name == 'Utsusemi: Ni' then
                overwrite = true
            end
        end
    end
    if player.status ~= 'Engaged' and state.WeaponLock.value == false then
        check_weaponset()
    end
    check_weaponset()
end
function job_buff_change(buff,gain)
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
    if buff == "sleep" then
        if gain then    
            send_command('input /p ZZZzzz, please cure.')		
        else
            send_command('input /p '..player.name..' is no longer Sleep!')
        end
    end
    if not midaction() then
        job_update()
    end
end
function check_buffs(check)
     
end

function sub_job_change(new,old)
    if user_setup then
        user_setup()
        send_command('wait 6;input /lockstyleset 168')
    end
end
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
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

function update_offense_mode()
    if (player.sub_job == 'NIN' and player.sub_job_level > 9) or (player.sub_job == 'DNC' and player.sub_job_level > 19) then
        state.CombatForm:set('DW')
    else
        state.CombatForm:reset()
    end
    check_weaponset()

end
function job_handle_equipping_gear(playerStatus, eventArgs)
    update_combat_form()
    --check_moving()
    check_weaponset()
end
function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    --check_moving()
    check_weaponset()

end
--[[function check_moving()
    if state.DefenseMode.value == 'None'  and state.Kiting.value == false then
        if state.Auto_Kite.value == false and moving then
            state.Auto_Kite:set(true)
            send_command('gs c update')

        elseif state.Auto_Kite.value == true and moving == false then
            state.Auto_Kite:set(false)
            send_command('gs c update')

        end
    end
end]]
function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end
    if state.CapacityMode.value then
        meleeSet = set_combine(meleeSet, sets.CapacityMantle)
    end
    if state.RP.current == 'on' then
        equip(sets.RP)
        disable('neck')
    else
        enable('neck')
    end
    check_weaponset()

    return meleeSet
end
function check_buff(buff_name, eventArgs)
    if state.Buff[buff_name] then
        equip(sets.buff[buff_name] or {})

        eventArgs.handled = true
    end
end


-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if state.HippoMode.value == true then 
        idleSet = set_combine(idleSet, {feet="Hippo. Socks +1"})
    end
    if state.RP.current == 'on' then
        equip(sets.RP)
        disable('neck')
    else
        enable('neck')
    end
    --[[if state.Auto_Kite.value == true then
		idleSet = set_combine(idleSet, sets.Kiting)
	end]]
    if world.area:contains("Adoulin") then
        idleSet = set_combine(idleSet, {body="Councilor's Garb"})
    end
    check_weaponset()

    return idleSet
end


-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(002, '| ' ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
    ..string.char(31,002)..msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Determine the custom class to use for the given song.
function get_song_class(spell)
    -- Can't use spell.targets:contains() because this is being pulled from resources
    if set.contains(spell.targets, 'Enemy') then
        if state.CastingMode.value == 'AUGMENT' then
            return 'ResistantSongDebuff'
        else
            return 'SongDebuff'
        end
    elseif state.ExtraSongsMode.value == 'Dummy' then
        return 'DaurdablaDummy'
    elseif state.ExtraSongsMode.value == 'FullLength' then
        return 'Gjallarhorn'
    elseif state.ExtraSongsMode.value == 'Marsyas' then
        return 'Marsyas'
    else
        return 'SongEffect'
    end
end


-- Function to create custom buff-remaining timers with the Timers plugin,
-- keeping only the actual valid songs rather than spamming the default
-- buff remaining timers.
function adjust_timers(spell, spellMap)
    if state.UseCustomTimers.value == false then
        return
    end
    
    local current_time = os.time()
    
    -- custom_timers contains a table of song names, with the os time when they
    -- will expire.
    
    -- Eliminate songs that have already expired from our local list.
    local temp_timer_list = {}
    for song_name,expires in pairs(custom_timers) do
        if expires < current_time then
            temp_timer_list[song_name] = true
        end
    end
    for song_name,expires in pairs(temp_timer_list) do
        custom_timers[song_name] = nil
    end
    
    local dur = calculate_duration(spell.name, spellMap)
    if custom_timers[spell.name] then
        -- Songs always overwrite themselves now, unless the new song has
        -- less duration than the old one (ie: old one was NT version, new
        -- one has less duration than what's remaining).
        
        -- If new song will outlast the one in our list, replace it.
        if custom_timers[spell.name] < (current_time + dur) then
            send_command('timers delete "'..spell.name..'"')
            custom_timers[spell.name] = current_time + dur
            send_command('timers create "'..spell.name..'" '..dur..' down')
        end
    else
        -- Figure out how many songs we can maintain.
        local maxsongs = 2
        if player.equipment.range == info.ExtraSongInstrument then
            maxsongs = maxsongs + info.ExtraSongs
        end
        if buffactive['Clarion Call'] then
            maxsongs = maxsongs + 1
        end
        -- If we have more songs active than is currently apparent, we can still overwrite
        -- them while they're active, even if not using appropriate gear bonuses (ie: Daur).
        if maxsongs < table.length(custom_timers) then
            maxsongs = table.length(custom_timers)
        end
        
        -- Create or update new song timers.
        if table.length(custom_timers) < maxsongs then
            custom_timers[spell.name] = current_time + dur
            send_command('timers create "'..spell.name..'" '..dur..' down')
        else
            local rep,repsong
            for song_name,expires in pairs(custom_timers) do
                if current_time + dur > expires then
                    if not rep or rep > expires then
                        rep = expires
                        repsong = song_name
                    end
                end
            end
            if repsong then
                custom_timers[repsong] = nil
                send_command('timers delete "'..repsong..'"')
                custom_timers[spell.name] = current_time + dur
                send_command('timers create "'..spell.name..'" '..dur..' down')
            end
        end
    end
end

-- Function to calculate the duration of a song based on the equipment used to cast it.
-- Called from adjust_timers(), which is only called on aftercast().
function calculate_duration(spellName, spellMap)
    local mult = 1
    if player.equipment.range == 'Daurdabla' then mult = mult + 0.3 end -- change to 0.25 with 90 Daur
    if player.equipment.range == "Gjallarhorn" then mult = mult + 0.4 end -- change to 0.3 with 95 Gjall
    if player.equipment.range == "Marsyas" then mult = mult + 0.5 end

    if player.equipment.main == "Carnwenhan" then mult = mult + 0.5 end -- 0.1 for 75, 0.4 for 95, 0.5 for 99/119
    if player.equipment.main == "Legato Dagger" then mult = mult + 0.05 end
    if player.equipment.main == "Kali" then mult = mult + 0.05 end
    if player.equipment.sub == "Kali" then mult = mult + 0.05 end
    if player.equipment.sub == "Legato Dagger" then mult = mult + 0.05 end
    if player.equipment.neck == "Aoidos' Matinee" then mult = mult + 0.1 end
    if player.equipment.neck == "Mnbw. Whistle" then mult = mult + 0.2 end
    if player.equipment.neck == "Mnbw. Whistle +1" then mult = mult + 0.3 end
    if player.equipment.body == "Fili Hongreline +1" then mult = mult + 0.12 end
    if player.equipment.body == "Fili Hongreline +2" then mult = mult + 0.12 end
    if player.equipment.body == "Fili Hongreline +3" then mult = mult + 0.12 end
    if player.equipment.legs == "Inyanga Shalwar +1" then mult = mult + 0.15 end
    if player.equipment.legs == "Inyanga Shalwar +2" then mult = mult + 0.17 end
    if player.equipment.feet == "Brioso Slippers" then mult = mult + 0.1 end
    if player.equipment.feet == "Brioso Slippers +1" then mult = mult + 0.11 end
    if player.equipment.feet == "Brioso Slippers +2" then mult = mult + 0.13 end
    if player.equipment.feet == "Brioso Slippers +3" then mult = mult + 0.15 end
    if player.equipment.hands == 'Brioso Cuffs +1' then mult = mult + 0.1 end
    if player.equipment.hands == 'Brioso Cuffs +2' then mult = mult + 0.1 end
    if player.equipment.hands == 'Brioso Cuffs +3' then mult = mult + 0.2 end
    
    if spellMap == 'Paeon' and player.equipment.head == "Brioso Roundlet" then mult = mult + 0.1 end
    if spellMap == 'Paeon' and player.equipment.head == "Brioso Roundlet +1" then mult = mult + 0.1 end
    if spellMap == 'Madrigal' and player.equipment.head == "Aoidos' Calot +2" then mult = mult + 0.1 end
    if spellMap == 'Minuet' and player.equipment.body == "Aoidos' Hngrln. +2" then mult = mult + 0.1 end
    if spellMap == 'March' and player.equipment.hands == 'Ad. Mnchtte. +2' then mult = mult + 0.1 end
    if spellMap == 'Ballad' and player.equipment.legs == "Aoidos' Rhing. +2" then mult = mult + 0.1 end
    if spellName == "Sentinel's Scherzo" and player.equipment.feet == "Aoidos' Cothrn. +2" then mult = mult + 0.1 end
    
    if buffactive.Troubadour then
        mult = mult*2
    end
    if spellName == "Sentinel's Scherzo" then
        if buffactive['Soul Voice'] then
            mult = mult*2
        elseif buffactive['Marcato'] then
            mult = mult*1.5
        end
    end
    
    local totalDuration = math.floor(mult*120)

    return totalDuration
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
    end
end

-- Examine equipment to determine what our current TP weapon is.
function pick_tp_weapon()

end

-- Function to reset timers.
function reset_timers()
    for i,v in pairs(custom_timers) do
        send_command('timers delete "'..i..'"')
    end
    custom_timers = {}
end
-- Called for direct player commands.
function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)

    if cmdParams[1]:lower() == 'etude' then
        send_command('@input /ma "'..state.Etude.value..'" <stpc>')
    elseif cmdParams[1]:lower() == 'carol' then
        send_command('@input /ma "'..state.Carol.value..'" <stpc>')
    elseif cmdParams[1]:lower() == 'threnody' then
        send_command('@input /ma "'..state.Threnody.value..'" <stnpc>')
    end
    if cmdParams[1]:lower() == 'songset' then
		send_command('@input //abb "'..state.Songset.value..'" ccsv')
	end
end
function check_weaponset()
    equip(sets[state.WeaponSet.current])
    if (player.sub_job ~= 'NIN' and player.sub_job ~= 'DNC') then
        if player.equipment.main ~= 'Xoanon' then
          equip(sets.DefaultShield)
        end
    elseif player.sub_job == 'NIN' and player.sub_job_level < 10 or player.sub_job == 'DNC' and player.sub_job_level < 20 then
        if player.equipment.main ~= 'Xoanon' then
          equip(sets.DefaultShield)
        end
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
	if state.HippoMode.value == "Hippo" then
		moving = false
    elseif mov.counter>15 then
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


windower.raw_register_event('zone change',reset_timers)
windower.raw_register_event('logout',reset_timers)


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 32)
end

