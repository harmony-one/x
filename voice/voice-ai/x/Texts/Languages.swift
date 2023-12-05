import Foundation

func getLanguageCode(preferredLanguage: String? = nil) -> String {
    let code = preferredLanguage ?? String(Locale.preferredLanguages[0].prefix(2))
    if languageCodes.contains(code) {
        return code
    } else {
        return "en"
    }
}

// iOS NSLocale follows ISO639-1 language codes
let languageCodes = ["aa", "ab", "af", "ak", "am", "an", "ar", "as", "av", "ay", "az", "ba", "be", "bg", "bh", "bi", "bm", "bn", "bo", "br",
    "bs", "ca", "ce", "ch", "co", "cr", "cs", "cu", "cv", "cy", "da", "de", "dv", "dz", "ee", "el", "en", "eo", "es", "et",
    "eu", "fa", "ff", "fi", "fj", "fo", "fr", "ga", "gd", "gl", "gn", "gu", "gv", "ha", "he", "hi", "ho", "hr", "ht", "hu",
    "hy", "hz", "ia", "id", "ie", "ig", "ii", "ik", "io", "is", "it", "iu", "ja", "jv", "ka", "kg", "ki", "kj", "kk", "kl",
    "km", "kn", "ko", "kr", "ks", "ku", "kv", "kw", "ky", "la", "lb", "lg", "li", "ln", "lo", "lt", "lu", "lv", "mg", "mh",
    "mi", "mk", "ml", "mn", "mr", "ms", "mt", "my", "na", "nb", "nd", "ne", "ng", "nl", "nn", "no", "nr", "nv", "ny", "oc",
    "oj", "om", "or", "os", "pa", "pi", "pl", "ps", "pt", "qu", "rm", "rn", "ro", "ru", "rw", "sa", "sc", "sd", "se", "sg",
    "si", "sk", "sl", "sm", "sn", "so", "sq", "sr", "ss", "st", "su", "sv", "sw", "ta", "te", "tg", "th", "ti", "tk", "tl",
    "tn", "to", "tr", "ts", "tt", "tw", "ty", "ug", "uk", "ur", "uz", "ve", "vi", "vo", "wa", "wo", "xh", "yi", "yo", "za",
    "zh", "zu"]

// SFSpeechRecognizer supported locales:
//[en-SG (fixed), fr-BE (fixed), en-CA (fixed), cs-CZ (fixed), nl-NL (fixed), th-TH (fixed), vi-VN (fixed), de-CH (fixed), pt-BR (fixed), uk-UA (fixed), en-AE (fixed), es-CO (fixed), fr-CA (fixed), fr-FR (fixed), en-ID (fixed), en-NZ (fixed), ms-MY (fixed), hi-IN (fixed), ca-ES (fixed), hu-HU (fixed), fi-FI (fixed), it-CH (fixed), de-DE (fixed), zh-CN (fixed), pt-PT (fixed), wuu-CN (fixed), en-IE (fixed), yue-CN (fixed), ko-KR (fixed), hi-IN-translit (fixed), en-GB (fixed), ro-RO (fixed), en-AU (fixed), es-CL (fixed), sk-SK (fixed), tr-TR (fixed), hi-Latn (fixed), fr-CH (fixed), es-MX (fixed), he-IL (fixed), en-IN (fixed), el-GR (fixed), it-IT (fixed), de-AT (fixed), nl-BE (fixed), en-PH (fixed), sv-SE (fixed), es-ES (fixed), ar-SA (fixed), ja-JP (fixed), hr-HR (fixed), zh-HK (fixed), es-US (fixed), nb-NO (fixed), pl-PL (fixed), da-DK (fixed), id-ID (fixed), es-419 (fixed), en-ZA (fixed), en-US (fixed), zh-TW (fixed), en-SA (fixed), ru-RU (fixed)]
