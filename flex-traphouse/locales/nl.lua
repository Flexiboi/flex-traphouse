local Translations = {
    error = {
        donthaveitem = 'Je hebt niet genoeg van dit..',
        stoppedsmelt = 'Gestopt met smelten..',
        incorrect_code = 'Code is ni juist',
        notonline = 'Burger is niet aanwezig..'
    },
    success = {
        smelted = 'Je bent gestart met %{value} te smelten. Wacht %{value2} seconden..',
        donesmelt = 'Je smelt is gedaan..'
    },
    info = {
        close = 'Sluit',
        enter = 'Ga binnen',
        leave = 'Verlaat traphuis',
        furnance = 'Smelten',
        input = 'Nodig',
        output = 'Je krijgt',
        smelting = 'aan het smelten..',
        crafting = 'Craften',
        chanceclothing = 'Verander kleren',
        stash = 'Open opslag',
        pincode = 'Trapcode: %{value}',
        letintrap = 'Laat burger traphouse binnen',
        wholetin = 'Wie wil je binnen laten? <burger ID>',
        confirmletin = 'Laat binnen',
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
