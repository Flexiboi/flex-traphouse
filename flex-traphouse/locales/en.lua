local Translations = {
    error = {
        donthaveitem = 'You dont have enough of this stuff..',
        stoppedsmelt = 'Stoped melting..',
        incorrect_code = 'Code isnt correct..',
        notonline = 'Player not online..'
    },
    success = {
        smelted = 'You started melting %{value}. Wait %{value2} seconds..',
        donesmelt = 'Done melting..'
    },
    info = {
        close = 'Close',
        enter = 'Enter',
        leave = 'Leave',
        furnance = 'Smelt',
        input = 'Need',
        output = 'Receive',
        smelting = 'melting..',
        crafting = 'Craft',
        chanceclothing = 'Change clothes',
        stash = 'Open stash',
        pincode = 'Trapcode: %{value}',
        letintrap = 'Let player in traphouse',
        wholetin = 'Who needs to enter? <ID>',
        confirmletin = 'Let in',
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
