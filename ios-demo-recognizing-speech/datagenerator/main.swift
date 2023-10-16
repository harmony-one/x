/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A simple utility for generating Custom LM training data
*/

import Speech

let data = SFCustomLanguageModelData(locale: Locale(identifier: "en_US"), identifier: "com.apple.SpokenWord", version: "1.0") {
    
    SFCustomLanguageModelData.PhraseCount(phrase: "Play the Albin counter gambit", count: 10)
    
    // Move Commands
    SFCustomLanguageModelData.PhraseCountsFromTemplates(classes: [
        "piece": ["pawn", "rook", "knight", "bishop", "queen", "king"],
        "royal": ["queen", "king"],
        "rank": Array(1...8).map({ String($0) })
    ]) {
        SFCustomLanguageModelData.TemplatePhraseCountGenerator.Template(
            "<piece> to <royal> <piece> <rank>",
            count: 10_000
        )
    }

    SFCustomLanguageModelData.CustomPronunciation(grapheme: "Winawer", phonemes: ["w I n aU @r"])
    SFCustomLanguageModelData.CustomPronunciation(grapheme: "Tartakower", phonemes: ["t A r t @ k aU @r"])

    SFCustomLanguageModelData.PhraseCount(phrase: "Play the Winawer variation", count: 10)
    SFCustomLanguageModelData.PhraseCount(phrase: "Play the Tartakower", count: 10)
}

try await data.export(to: URL(filePath: "/var/tmp/CustomLMData.bin"))
