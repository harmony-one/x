// swiftlint:disable file_length

import Foundation

func getSettingsText(for languageCode: String, buttonName: String) -> String {
    if let languageDictionary = settingsTranslations[languageCode], let translatedText = languageDictionary[buttonName] {
        return translatedText
    } else {
        if buttonName == "purchase" {
            return "Purchase"
        } else if buttonName == "share" {
            return "Share"
        } else if buttonName == "tweet" {
            return "Tweet"
        } else if buttonName == "systemSettings" {
            return "System Settings"
        } else if buttonName == "saveTranscript" {
            return "Save Transcript"
        } else if buttonName == "signIn" {
            return "Sign In"
        } else if buttonName == "signOut" {
            return "Sign Out"
        } else {
            return buttonName
        }
    }
}

var settingsTranslations: [String: [String: String]] = [
    "aa": [
        "purchase": "Kaan",
        "share": "Dulaa",
        "tweet": "Twiit",
        "systemSettings": "Haggooyyi Sittiinsii",
        "saveTranscript": "Taageera Karraa",
        "signIn": "Log In",
        "signOut": "Sign Out"
    ],
    "ab": [
        "purchase": "Ақыҭ",
        "share": "Иҳадақъ",
        "tweet": "Туҩатыр",
        "systemSettings": "Имкәысқәа арбыҟара",
        "saveTranscript": "Ирҳарцара азақышарцара",
        "signIn": "Ауыстыру",
        "signOut": "Sign Out"
    ],
    "af": [
        "purchase": "Aankoop",
        "share": "Deel",
        "tweet": "Tweet",
        "systemSettings": "Stelselinstellings",
        "saveTranscript": "Stoor Transcript",
        "signIn": "Teken In"
    ],
    "ak": [
        "purchase": "Nkɔmba",
        "share": "Dwen sɛ",
        "tweet": "Tweɛt",
        "systemSettings": "System Settings",
        "saveTranscript": "Tumi Tɛ Awufoɔ",
        "signIn": "Sini In"
    ],
    "am": [
        "purchase": "ግብር አስገባ",
        "share": "አጋሮ",
        "tweet": "ትይዩ",
        "systemSettings": "የስርዓተ ቅኝት",
        "saveTranscript": "ጽሑፍ አስቀምጥ",
        "signIn": "ማግኘት"
    ],
    "an": [
        "purchase": "Compra",
        "share": "Compartir",
        "tweet": "Tuitar",
        "systemSettings": "Achustes d'o Sistema",
        "saveTranscript": "Alzar a transcripción",
        "signIn": "Coneutar"
    ],
    "ar": [
        "purchase": "شراء",
        "share": "مشاركة",
        "tweet": "تغريد",
        "systemSettings": "إعدادات النظام",
        "saveTranscript": "حفظ النص",
        "signIn": "تسجيل الدخول"
    ],
    "as": [
        "purchase": "কেনি",
        "share": "শ্যার",
        "tweet": "টুইট",
        "systemSettings": "সিস্টেম সেটিংস",
        "saveTranscript": "পৰ্চৰূপ সংগ্ৰহ কৰক",
        "signIn": "চাইন ইন"
    ],
    "av": [
        "purchase": "Хъуаркъа",
        "share": "Къагъаркъ",
        "tweet": "Туит",
        "systemSettings": "Системан азарардан",
        "saveTranscript": "Транскрипци гъӏуьдцаза",
        "signIn": "Дилиу"
    ],
    "ay": [
        "purchase": "Jani",
        "share": "Yati",
        "tweet": "Yatiwa",
        "systemSettings": "Sistema Yupaychasqan",
        "saveTranscript": "Transcripciónwa Yatiwa",
        "signIn": "Ñanirka"
    ],
    "az": [
        "purchase": "Satınalmaq",
        "share": "Paylaşmaq",
        "tweet": "Tweetləmək",
        "systemSettings": "Sistem Ayarları",
        "saveTranscript": "Transkripti Saxlamaq",
        "signIn": "Daxil Ol"
    ],
    "ba": [
        "purchase": "Сатып алу",
        "share": "Бөлүсөм",
        "tweet": "Твиттерде жазуу",
        "systemSettings": "Система параметрлери",
        "saveTranscript": "Транскрипцияны сактоо",
        "signIn": "Кируу"
    ],
    "be": [
        "purchase": "Купля",
        "share": "Падзяліцца",
        "tweet": "Твітнуць",
        "systemSettings": "Налады сістэмы",
        "saveTranscript": "Захаваць транскрыпцыю",
        "signIn": "Увайсці"
    ],
    "bg": [
        "purchase": "Купуване",
        "share": "Споделяне",
        "tweet": "Туитване",
        "systemSettings": "Настройки на системата",
        "saveTranscript": "Запазване на транскрипция",
        "signIn": "Вход"
    ],
    "bh": [
        "purchase": "खरीददारी",
        "share": "साझा करें",
        "tweet": "ट्वीट करें",
        "systemSettings": "सिस्टम सेटिंग्स",
        "saveTranscript": "ट्रांसक्रिप्ट सहेजें",
        "signIn": "साइन इन करें"
    ],
    "bi": [
        "purchase": "Kone",
        "share": "Ngoŕo",
        "tweet": "Kwandu",
        "systemSettings": "Ngeri na Kagati ka Sistema",
        "saveTranscript": "Ngeri iwe Burikira",
        "signIn": "Saje"
    ],
    "bm": [
        "purchase": "Beli",
        "share": "Kongsi",
        "tweet": "Tweet",
        "systemSettings": "Tetapan Sistem",
        "saveTranscript": "Simpan Transkrip",
        "signIn": "Log Masuk"
    ],
    "bn": [
        "purchase": "ক্রয়",
        "share": "ভাগ করুন",
        "tweet": "টুইট করুন",
        "systemSettings": "সিস্টেম সেটিংস",
        "saveTranscript": "ট্রান্সক্রিপ্ট সংরক্ষণ করুন",
        "signIn": "সাইন ইন"
    ],
    "bo": [
        "purchase": "དབྱེ་བ",
        "share": "ཕྱི་མ",
        "tweet": "ཕྱི་མིང་གཏོང",
        "systemSettings": "མིང་གཏོང་སྤྱོད་ཁ",
        "saveTranscript": "ཕལཝོའི་ནང་གཏོང",
        "signIn": "གཏུགས་ཚངས་བཀོལ་བ"
    ],
    "br": [
        "purchase": "Prañs",
        "share": "Rannañ",
        "tweet": "Tweetiñ",
        "systemSettings": "Arventennou ar Sistemoù",
        "saveTranscript": "Enrollañ an distroid",
        "signIn": "Siniañ"
    ],
    "bs": [
        "purchase": "Kupovina",
        "share": "Podijeli",
        "tweet": "Tvitanje",
        "systemSettings": "Sistemski postavke",
        "saveTranscript": "Spremi transkript",
        "signIn": "Prijava"
    ],
    "ca": [
        "purchase": "Compra",
        "share": "Comparteix",
        "tweet": "Tuiteja",
        "systemSettings": "Configuració del sistema",
        "saveTranscript": "Desa la transcripció",
        "signIn": "Inicia sessió"
    ],
    "ce": [
        "purchase": "Хыза",
        "share": "Борзана",
        "tweet": "Твиттара",
        "systemSettings": "Система параметралара",
        "saveTranscript": "Транскрипт цӀанатӏо",
        "signIn": "Ингал"
    ],
    "ch": [
        "purchase": "Konpra",
        "share": "Chagi",
        "tweet": "Tweet",
        "systemSettings": "Sisteman Setiyu",
        "saveTranscript": "Paremetran ni Fannakat nu Putungan",
        "signIn": "Mamonsig"
    ],
    "co": [
        "purchase": "Acquistu",
        "share": "Pensate",
        "tweet": "Tuità",
        "systemSettings": "Impostazioni di u sistema",
        "saveTranscript": "Custudisce a trascrizzione",
        "signIn": "Signate in"
    ],
    "cr": [
        "purchase": "Pimatisowin",
        "share": "Wâpamêw",
        "tweet": "Tweepitamowin",
        "systemSettings": "Sistîm Sakihewewin",
        "saveTranscript": "Tâtwepimatisowin ê-kihikêyamowin",
        "signIn": "Ikiciwakiciya"
    ],
    "cs": [
        "purchase": "Nákup",
        "share": "Sdílet",
        "tweet": "Tweetnout",
        "systemSettings": "Nastavení systému",
        "saveTranscript": "Uložit přepis",
        "signIn": "Přihlásit se"
    ],
    "cu": [
        "purchase": "Купити",
        "share": "Дѣлати раздѣлъ",
        "tweet": "Туитъ",
        "systemSettings": "Състѣмьны устройенї",
        "saveTranscript": "Спазити рѣчение",
        "signIn": "Съвъръшити логинъ"
    ],
    "cv": [
        "purchase": "Сакла",
        "share": "Паллах",
        "tweet": "Туит",
        "systemSettings": "Система йышмачӑлӑхисем",
        "saveTranscript": "Транскрипций пулталах",
        "signIn": "Шырa̋матӳр калар"
    ],
    "cy": [
        "purchase": "Prynu",
        "share": "Rhannu",
        "tweet": "Tweethu",
        "systemSettings": "Gosodiadau System",
        "saveTranscript": "Cadw'r trawsgrifiad",
        "signIn": "Mewngofnodi"
    ],
    "da": [
        "purchase": "Køb",
        "share": "Del",
        "tweet": "Tweet",
        "systemSettings": "Systemindstillinger",
        "saveTranscript": "Gem Transkript",
        "signIn": "Log ind"
    ],
    "de": [
        "purchase": "Kaufen",
        "share": "Teilen",
        "tweet": "Tweeten",
        "systemSettings": "Systemeinstellungen",
        "saveTranscript": "Transkript speichern",
        "signIn": "Anmelden"
    ],
    "dv": [
        "purchase": "ކުރެވަރު",
        "share": "ކިޔާސް",
        "tweet": "ޓުޓު",
        "systemSettings": "ސިޔާލުގެ ކުރުވަރުގެ ހަދަނުގެ ބޭނުން",
        "saveTranscript": "ޓެކްސް ޚަބަރު ކުރެވަރުގެ ހަދަނު",
        "signIn": "ލޮގިއޭޝަން"
    ],
    "dz": [
        "purchase": "རྩིས་བསྐྲུན་འབྲི་བ",
        "share": "བསྐུལ་འབྱུང",
        "tweet": "མགྲིན་འཐུང",
        "systemSettings": "མཛོད་ཤོག་སྤྱོད་སེལ",
        "saveTranscript": "ཡོད་དགོས་གྲངས་རྐྱང",
        "signIn": "ནང་འཇུག"
    ],
    "ee": [
        "purchase": "Ostu",
        "share": "Jaga",
        "tweet": "Twiit",
        "systemSettings": "Süsteemi seaded",
        "saveTranscript": "Salvesta transkriptsioon",
        "signIn": "Logi sisse"
    ],
    "el": [
        "purchase": "Αγορά",
        "share": "Κοινοποίηση",
        "tweet": "Κοινοποίηση στο Twitter",
        "systemSettings": "Ρυθμίσεις συστήματος",
        "saveTranscript": "Αποθήκευση μεταγραφής",
        "signIn": "Σύνδεση"
    ],
    "en": [
        "purchase": "Purchase",
        "share": "Share",
        "tweet": "Tweet",
        "systemSettings": "System Settings",
        "saveTranscript": "Save Transcript",
        "signIn": "Sign In"
    ],
    "eo": [
        "purchase": "Aĉeti",
        "share": "Kunhavigi",
        "tweet": "Pafi mesaĝon",
        "systemSettings": "Sisteman Agordojn",
        "saveTranscript": "Konservi Transskribon",
        "signIn": "Ensaluti"
    ],
    "es": [
        "purchase": "Comprar",
        "share": "Compartir",
        "tweet": "Tuitear",
        "systemSettings": "Configuración del sistema",
        "saveTranscript": "Guardar Transcripción",
        "signIn": "Iniciar sesión"
    ],
    "et": [
        "purchase": "Osta",
        "share": "Jaga",
        "tweet": "Tweeti",
        "systemSettings": "Süsteemi sätted",
        "saveTranscript": "Salvesta transkriptsioon",
        "signIn": "Logi sisse"
    ],
    "eu": [
        "purchase": "Erosi",
        "share": "Partekatu",
        "tweet": "Tuiteatu",
        "systemSettings": "Sistema Ezarpenak",
        "saveTranscript": "Transkripzioa Gorde",
        "signIn": "Saioa hasi"
    ],
    "fa": [
        "purchase": "خرید",
        "share": "اشتراک‌گذاری",
        "tweet": "توییت",
        "systemSettings": "تنظیمات سیستم",
        "saveTranscript": "ذخیره کردن متن",
        "signIn": "ورود"
    ],
    "ff": [
        "purchase": "Xer",
        "share": "Jëmm",
        "tweet": "Tweet",
        "systemSettings": "Setilaayu Señ Ser",
        "saveTranscript": "Noppu Kër",
        "signIn": "Kuy Jàngal"
    ],
    "fi": [
        "purchase": "Osta",
        "share": "Jaa",
        "tweet": "Twiittaa",
        "systemSettings": "Järjestelmäasetukset",
        "saveTranscript": "Tallenna teksti",
        "signIn": "Kirjaudu sisään"
    ],
    "fj": [
        "purchase": "Voliti",
        "share": "Vakarautaki",
        "tweet": "Tuitea",
        "systemSettings": "Sistem Setting",
        "saveTranscript": "Vakarauca ni Vola",
        "signIn": "Vakarauca ni Loga"
    ],
    "fo": [
        "purchase": "Keypa",
        "share": "Deila",
        "tweet": "Títt",
        "systemSettings": "Kerfi Stillingar",
        "saveTranscript": "Vista Afrit",
        "signIn": "Innskrá"
    ],
    "fr": [
        "purchase": "Acheter",
        "share": "Partager",
        "tweet": "Tweeter",
        "systemSettings": "Paramètres du système",
        "saveTranscript": "Enregistrer la transcription",
        "signIn": "Se connecter"
    ],
    "ga": [
        "purchase": "Ceannaigh",
        "share": "Roinn",
        "tweet": "Tuiteáil",
        "systemSettings": "Socruithe córas",
        "saveTranscript": "Sábháil an trascríobh",
        "signIn": "Logáil isteach"
    ],
    "gd": [
        "purchase": "Ceannaich",
        "share": "Roinn",
        "tweet": "Tuiteachadh",
        "systemSettings": "Suidhichidhean an t-siostaim",
        "saveTranscript": "Sàbhail an trannsaigire",
        "signIn": "Log a-steach"
    ],
    "gl": [
        "purchase": "Compra",
        "share": "Compartir",
        "tweet": "Tuitear",
        "systemSettings": "Axustes do sistema",
        "saveTranscript": "Gardar a transcrición",
        "signIn": "Iniciar sesión"
    ],
    "gn": [
        "purchase": "Kuatiaty",
        "share": "Petei",
        "tweet": "Twyta",
        "systemSettings": "Sistema ñemohenda",
        "saveTranscript": "Ñemoñeho transliteración",
        "signIn": "Mbopi ha'ei"
    ],
    "gu": [
        "purchase": "ખરીદી",
        "share": "વહેંચો",
        "tweet": "ટ્વીટ",
        "systemSettings": "સિસ્ટમ સેટિંગ્સ",
        "saveTranscript": "ટ્રાન્સક્રિપ્ટ સાચવો",
        "signIn": "પ્રવેશ કરો"
    ],
    "gv": [
        "purchase": "Keeaghey",
        "share": "Roinn",
        "tweet": "Tweet",
        "systemSettings": "Ronnaghey yn System",
        "saveTranscript": "Cummal y Transchropt",
        "signIn": "Log ayn"
    ],
    "ha": [
        "purchase": "Saman",
        "share": "Shirya",
        "tweet": "Shawo",
        "systemSettings": "Saiti na System",
        "saveTranscript": "Gudanar Fassara",
        "signIn": "Shigo"
    ],
    "he": [
        "purchase": "קנייה",
        "share": "שיתוף",
        "tweet": "ציוץ",
        "systemSettings": "הגדרות מערכת",
        "saveTranscript": "שמור טקסט",
        "signIn": "התחברות"
    ],
    "hi": [
        "purchase": "खरीद",
        "share": "साझा करें",
        "tweet": "ट्वीट",
        "systemSettings": "सिस्टम सेटिंग्स",
        "saveTranscript": "ट्रांसक्रिप्ट सहेजें",
        "signIn": "साइन इन करें"
    ],
    "ho": [
        "purchase": "Babara",
        "share": "Longilongi",
        "tweet": "Tuiti",
        "systemSettings": "Maloa'ira Fakamatala",
        "saveTranscript": "Faingofua'i e Tokoni",
        "signIn": "Fa'ahao"
    ],
    "hr": [
        "purchase": "Kupovina",
        "share": "Podijeli",
        "tweet": "Tvitni",
        "systemSettings": "Postavke sustava",
        "saveTranscript": "Spremi transkript",
        "signIn": "Prijava"
    ],
    "ht": [
        "purchase": "Achte",
        "share": "Pataje",
        "tweet": "Twiit",
        "systemSettings": "Anviwònman Sistèm",
        "saveTranscript": "Sere Transkripsyon",
        "signIn": "Konekte"
    ],
    "hu": [
        "purchase": "Vásárlás",
        "share": "Megosztás",
        "tweet": "Tweetelés",
        "systemSettings": "Rendszerbeállítások",
        "saveTranscript": "Transzkript mentése",
        "signIn": "Bejelentkezés"
    ],
    "hy": [
        "purchase": "Գնում",
        "share": "Կիսվել",
        "tweet": "Թվիթեռ",
        "systemSettings": "Համախարապետական կարգավորումներ",
        "saveTranscript": "Պահպանել տեքստը",
        "signIn": "Մուտք գործել"
    ],
    "hz": [
        "purchase": "Veka",
        "share": "Shame",
        "tweet": "Tweet",
        "systemSettings": "Kwambuluko kweNdaba",
        "saveTranscript": "Londza Lilongoloi",
        "signIn": "Gulula"
    ],
    "ia": [
        "purchase": "Acheto",
        "share": "Comparte",
        "tweet": "Tuitea",
        "systemSettings": "Configuration de systema",
        "saveTranscript": "Salva Transcripto",
        "signIn": "Sign in"
    ],
    "id": [
        "purchase": "Beli",
        "share": "Bagikan",
        "tweet": "Tweet",
        "systemSettings": "Pengaturan Sistem",
        "saveTranscript": "Simpan Transkrip",
        "signIn": "Masuk"
    ],
    "ie": [
        "purchase": "Achats",
        "share": "Compartir",
        "tweet": "Tuitear",
        "systemSettings": "Setats de System",
        "saveTranscript": "Salve Transcript",
        "signIn": "Sign in"
    ],
    "ig": [
        "purchase": "Ọrịa",
        "share": "Zi",
        "tweet": "Tweet",
        "systemSettings": "Ọrụjọ Ịnịọrụ",
        "saveTranscript": "Gosiri Transcript",
        "signIn": "Tinye njikọ"
    ],
    "ii": [
        "purchase": "ꂰꑌ",
        "share": "ꄏꐀ",
        "tweet": "ꏆꉙ",
        "systemSettings": "ꂱꆨꅀꄚ ꇙꉣ",
        "saveTranscript": "ꃆꃩꀍ ꄚꂶꀉ",
        "signIn": "ꁁꉆ"
    ],
    "ik": [
        "purchase": "Agudluguq",
        "share": "Napaaq",
        "tweet": "Tweet",
        "systemSettings": "Uummat Utupkaq",
        "saveTranscript": "Atsanignatut Tunuvaq",
        "signIn": "Atakkaq"
    ],
    "io": [
        "purchase": "Aĉeto",
        "share": "Partoprenar",
        "tweet": "Tviti",
        "systemSettings": "Sistemo Agardos",
        "saveTranscript": "Konservar Transkripto",
        "signIn": "Enirar"
    ],
    "is": [
        "purchase": "Kaupa",
        "share": "Deila",
        "tweet": "Títa",
        "systemSettings": "Stýringar kerfis",
        "saveTranscript": "Geyma Texta",
        "signIn": "Skrá inn"
    ],
    "it": [
        "purchase": "Acquista",
        "share": "Condividi",
        "tweet": "Tweet",
        "systemSettings": "Impostazioni di sistema",
        "saveTranscript": "Salva Trascrizione",
        "signIn": "Accedi"
    ],
    "iu": [
        "purchase": "ᐊᖅᑭᑦ",
        "share": "ᖃᐅᔨᒃᑯᓐᓇ",
        "tweet": "ᑭᒪᔪᖓ",
        "systemSettings": "ᓄᓇᕗᑦ ᐅᓪᓗᒥᐅᑦ",
        "saveTranscript": "ᐅᓪᓗᒥᐅᑎᓪᓗ",
        "signIn": "ᐅᓪᓗᒥ"
    ],
    "ja": [
        "purchase": "購入",
        "share": "共有",
        "tweet": "ツイート",
        "systemSettings": "システム設定",
        "saveTranscript": "トランスクリプトを保存",
        "signIn": "サインイン"
    ],
    "jv": [
        "purchase": "Mbeli",
        "share": "Dhagel",
        "tweet": "Ndeleng",
        "systemSettings": "Setelan Sistem",
        "saveTranscript": "Simpen Transkrip",
        "signIn": "Gabung"
    ],
    "ka": [
        "purchase": "შესყიდვა",
        "share": "გაზიარება",
        "tweet": "ტვიტი",
        "systemSettings": "სისტემის პარამეტრები",
        "saveTranscript": "ტრანსკრიპციის შენახვა",
        "signIn": "შესვლა"
    ],
    "kg": [
        "purchase": "Koléka",
        "share": "Kokola",
        "tweet": "Tweeta",
        "systemSettings": "Bisoso bya Sisteme",
        "saveTranscript": "Kubika Kiebao",
        "signIn": "Kusonga"
    ],
    "ki": [
        "purchase": "Gūtirika",
        "share": "Kūterera",
        "tweet": "Gūtwarikirira",
        "systemSettings": "Mithembo ya Gūtwarikirira",
        "saveTranscript": "Kūira Gūthimba",
        "signIn": "Gūtheherera"
    ],
    "kj": [
        "purchase": "Uwongo",
        "share": "Nyɛ",
        "tweet": "Uwongereza",
        "systemSettings": "Sɛt So Ahummɔbɔ",
        "saveTranscript": "Tumi Nyansa Ahosɛpɔn",
        "signIn": "Sɛ Adanse"
    ],
    "kk": [
        "purchase": "Сатып алу",
        "share": "Бөлісу",
        "tweet": "Твиттерде жазу",
        "systemSettings": "Жүйе параметрлері",
        "saveTranscript": "Транскрипт сақтау",
        "signIn": "Кіру"
    ],
    "kl": [
        "purchase": "Inuttut",
        "share": "Talerpunga",
        "tweet": "Twiitip",
        "systemSettings": "Systemimi neriunerat",
        "saveTranscript": "Ilaavaraarlu Transkriptit",
        "signIn": "Suleqatigiinni"
    ],
    "km": [
        "purchase": "ទិញ",
        "share": "ចែករំលែក",
        "tweet": "រក្សាទុក",
        "systemSettings": "ការកំណត់ប្រព័ន្ធ",
        "saveTranscript": "រក្សាបញ្ជាសង្ខេប",
        "signIn": "ចូលគណនី"
    ],
    "kn": [
        "purchase": "ಖರೀದಿ",
        "share": "ಹಂಚಿಕೊಳ್ಳಿ",
        "tweet": "ಟ್ವೀಟ್",
        "systemSettings": "ಸಿಸ್ಟಮ್ ಸೆಟ್ಟಿಂಗ್ಸ್",
        "saveTranscript": "ಟ್ರಾನ್ಸ್ಕ್ರಿಪ್ಟ್ ಉಳಿಸಿ",
        "signIn": "ಸೈನ್ ಇನ್"
    ],
    "ko": [
        "purchase": "구매",
        "share": "공유",
        "tweet": "트윗",
        "systemSettings": "시스템 설정",
        "saveTranscript": "트랜스크립트 저장",
        "signIn": "로그인"
    ],
    "kr": [
        "purchase": "Kal",
        "share": "Bil",
        "tweet": "Twiit",
        "systemSettings": "Kedon lōn Eo",
        "saveTranscript": "Kajjito lōn Kōn",
        "signIn": "Aola"
    ],
    "ks": [
        "purchase": "خريد",
        "share": "ساجھہ کرو",
        "tweet": "ٹویٹ",
        "systemSettings": "سسٹم کی ترتیبات",
        "saveTranscript": "ٹرانسکرپٹ محفوظ کرو",
        "signIn": "سائن ان کریں"
    ],
    "ku": [
        "purchase": "Bikarhêne",
        "share": "Parve bike",
        "tweet": "Tweeta",
        "systemSettings": "Mîhengên Sistêmê",
        "saveTranscript": "Transkriptê Bişîne",
        "signIn": "Tevgerîn"
    ],
    "kv": [
        "purchase": "Купи",
        "share": "Даромаддан",
        "tweet": "Твит кардан",
        "systemSettings": "Танзимотҳои низом",
        "saveTranscript": "Транскрипт нависед",
        "signIn": "Воридшавӣ"
    ],
    "kw": [
        "purchase": "Pra",
        "share": "Rannvro",
        "tweet": "Tweeta",
        "systemSettings": "Gwirysiow System",
        "saveTranscript": "Pargyvva'n Transkript",
        "signIn": "Enrolla"
    ],
    "ky": [
        "purchase": "Сатып алуу",
        "share": "Бөлүш",
        "tweet": "Твиттерге жазуу",
        "systemSettings": "Система параметрлери",
        "saveTranscript": "Транскрипт сактоо",
        "signIn": "Кириңиз"
    ],
    "la": [
        "purchase": "Emere",
        "share": "Communica",
        "tweet": "Nuntia",
        "systemSettings": "Dispositio Systematis",
        "saveTranscript": "Serva Transcriptionem",
        "signIn": "Signum In"
    ],
    "lb": [
        "purchase": "Kaafen",
        "share": "Deelen",
        "tweet": "Tweeten",
        "systemSettings": "System Astellungen",
        "saveTranscript": "Transkript späicheren",
        "signIn": "Aloggen"
    ],
    "lg": [
        "purchase": "Kuuma",
        "share": "Kugabana",
        "tweet": "Tweeta",
        "systemSettings": "Obuwufuzi bwa ssytemu",
        "saveTranscript": "Okukola empandika",
        "signIn": "Okusingira"
    ],
    "li": [
        "purchase": "Koup",
        "share": "Deel",
        "tweet": "Tweet",
        "systemSettings": "Systeem Instèllinge",
        "saveTranscript": "Transcript bewaar",
        "signIn": "Aanmelden"
    ],
    "ln": [
        "purchase": "Acheter",
        "share": "Partager",
        "tweet": "Tweeter",
        "systemSettings": "Paramètres du système",
        "saveTranscript": "Enregistrer la transcription",
        "signIn": "Se connecter"
    ],
    "lo": [
        "purchase": "ຊື້",
        "share": "ແບບຟືກ",
        "tweet": "ຕຽງສືກ",
        "systemSettings": "ການຕັ້ງຄ່າລະບົບ",
        "saveTranscript": "ບັນທຶກສຽງຄວາມ",
        "signIn": "ເຂົ້າສູ່ລະບົບ"
    ],
    "lt": [
        "purchase": "Pirkti",
        "share": "Dalintis",
        "tweet": "Tvitinti",
        "systemSettings": "Sistemos Nustatymai",
        "saveTranscript": "Išsaugoti Transkriptą",
        "signIn": "Prisijungti"
    ],
    "lu": [
        "purchase": "Kaafen",
        "share": "Deelen",
        "tweet": "Tweeten",
        "systemSettings": "System Astellungen",
        "saveTranscript": "Transkript späicheren",
        "signIn": "Aloggen"
    ],
    "lv": [
        "purchase": "Pirkt",
        "share": "Dalīties",
        "tweet": "Tvītot",
        "systemSettings": "Sistēmas iestatījumi",
        "saveTranscript": "Saglabāt transkriptu",
        "signIn": "Pierakstīties"
    ],
    "mg": [
        "purchase": "Acheter",
        "share": "Mamorona",
        "tweet": "Tweeta",
        "systemSettings": "Sampam-peo système",
        "saveTranscript": "Ampianarina ny Transkripta",
        "signIn": "Hilaza"
    ],
    "mh": [
        "purchase": "Kūrōw",
        "share": "Mōnōrōnō",
        "tweet": "Twīto",
        "systemSettings": "Kejear lon Doul",
        "saveTranscript": "Jelḷọk Transkrip",
        "signIn": "Mool"
    ],
    "mi": [
        "purchase": "Hoko",
        "share": "Whakawhiti",
        "tweet": "Tīhau",
        "systemSettings": "Tautuhinga Pūnaha",
        "saveTranscript": "Tiaki Tohutoro",
        "signIn": "Takiuru"
    ],
    "mk": [
        "purchase": "Купи",
        "share": "Сподели",
        "tweet": "Твитни",
        "systemSettings": "Системски поставки",
        "saveTranscript": "Зачувај транскрипт",
        "signIn": "Најави се"
    ],
    "ml": [
        "purchase": "വാങ്ങുക",
        "share": "പങ്കിടുക",
        "tweet": "ട്വീറ്റ്",
        "systemSettings": "സിസ്റ്റം ക്രമീകരണങ്ങൾ",
        "saveTranscript": "ട്രാൻസ്ക്രിപ്റ്റ് സേവ് ചെയ്യുക",
        "signIn": "സൈൻ ഇൻ"
    ],
    "mn": [
        "purchase": "Худалдаа",
        "share": "Хуваалцах",
        "tweet": "Твит",
        "systemSettings": "Системийн тохиргоо",
        "saveTranscript": "Транскриптийг хадгалах",
        "signIn": "Нэвтрэх"
    ],
    "mr": [
        "purchase": "खरेदी करा",
        "share": "सामायिक करा",
        "tweet": "ट्विट करा",
        "systemSettings": "सिस्टम सेटिंग्ज",
        "saveTranscript": "ट्रांसक्रिप्ट संग्रहित करा",
        "signIn": "साइन इन करा"
    ],
    "ms": [
        "purchase": "Beli",
        "share": "Kongsi",
        "tweet": "Tweet",
        "systemSettings": "Tetapan Sistem",
        "saveTranscript": "Simpan Transkrip",
        "signIn": "Log Masuk"
    ],
    "mt": [
        "purchase": "Ixtri",
        "share": "Iffisser",
        "tweet": "Tweet",
        "systemSettings": "Settar tas-Sistema",
        "saveTranscript": "Salva Tranċizzjoni",
        "signIn": "Daħħal"
    ],
    "my": [
        "purchase": "ဝယ်ပါ",
        "share": "မျှဝေရေး",
        "tweet": "ထွက်ချိန်",
        "systemSettings": "စနစ်ကိုယ်စီများ",
        "saveTranscript": "စာသားကူးမည်",
        "signIn": "လော့ဂ်ယျ"
    ],
    "na": [
        "purchase": "Hukwa",
        "share": "Tjisamika",
        "tweet": "Tweet",
        "systemSettings": "Tjitaen-ombu",
        "saveTranscript": "Tjamavo Trinskripta",
        "signIn": "Tjahira"
    ],
    "nb": [
        "purchase": "Kjøp",
        "share": "Del",
        "tweet": "Tweet",
        "systemSettings": "Systeminnstillinger",
        "saveTranscript": "Lagre Transkripsjon",
        "signIn": "Logg inn"
    ],
    "nd": [
        "purchase": "Thenga",
        "share": "Yenza izimpawu",
        "tweet": "Kuphawulele",
        "systemSettings": "Izilungiselelo zesistimu",
        "saveTranscript": "Londoloza Itraskripthi",
        "signIn": "Gcina"
    ],
    "ne": [
        "purchase": "खरीद",
        "share": "साझा गर्नुहोस्",
        "tweet": "ट्विट",
        "systemSettings": "प्रणाली सेटिङ",
        "saveTranscript": "ट्रान्सक्रिप्ट संरक्षण गर्नुहोस्",
        "signIn": "साइन इन गर्नुहोस्"
    ],
    "ng": [
        "purchase": "Kpeŋ",
        "share": "Yila",
        "tweet": "Wada",
        "systemSettings": "Yalaŋ zung kalaŋ",
        "saveTranscript": "Halaŋ kpeŋ kpalaŋ",
        "signIn": "Linda"
    ],
    "nl": [
        "purchase": "Kopen",
        "share": "Delen",
        "tweet": "Tweeten",
        "systemSettings": "Systeeminstellingen",
        "saveTranscript": "Transcript opslaan",
        "signIn": "Aanmelden"
    ],
    "nn": [
        "purchase": "Kjøp",
        "share": "Del",
        "tweet": "Tweet",
        "systemSettings": "Systeminnstillinger",
        "saveTranscript": "Lagre transkripsjon",
        "signIn": "Logg inn"
    ],
    "no": [
        "purchase": "Kjøp",
        "share": "Del",
        "tweet": "Tweet",
        "systemSettings": "Systeminnstillinger",
        "saveTranscript": "Lagre transkripsjon",
        "signIn": "Logg inn"
    ],
    "nr": [
        "purchase": "Thenga",
        "share": "Yenza izimpawu",
        "tweet": "Kuphawulele",
        "systemSettings": "Izilungiselelo zesistimu",
        "saveTranscript": "Londoloza Itraskripthi",
        "signIn": "Gcina"
    ],
    "nv": [
        "purchase": "Hózhǫ́ǫ́go",
        "share": "Tłʼiish",
        "tweet": "Niyol",
        "systemSettings": "Hózhǫ́ǫ́go bikááʼ haaztʼiinii",
        "saveTranscript": "Tłʼiish chʼaakai",
        "signIn": "Hózhǫ́ǫ́go bikááʼ"
    ],
    "ny": [
        "purchase": "Kunika",
        "share": "Sankha",
        "tweet": "Tweet",
        "systemSettings": "Zilankhulo za mfundo",
        "saveTranscript": "Kulola Transkripti",
        "signIn": "Tsogolo"
    ],
    "oc": [
        "purchase": "Achicar",
        "share": "Partejar",
        "tweet": "Tuit",
        "systemSettings": "Paramètres del sistema",
        "saveTranscript": "Enregistra la transcripcion",
        "signIn": "Conegut"
    ],
    "oj": [
        "purchase": "Oshi",
        "share": "Ihmashkana",
        "tweet": "Twiit",
        "systemSettings": "Sistim Kashkinwe",
        "saveTranscript": "Tiwaken Transkript",
        "signIn": "Opiskwew"
    ],
    "om": [
        "purchase": "Iyyeessaa",
        "share": "Ga'uunfaa",
        "tweet": "Twiitii",
        "systemSettings": "Loltoota Sistimii",
        "saveTranscript": "Galmaa Iyyeessaa",
        "signIn": "Golmalee"
    ],
    "or": [
        "purchase": "କେନ୍ଦ୍ର କ୍ରେନ୍",
        "share": "ଭାଗ କରନ୍ତୁ",
        "tweet": "ଟ୍ୱିଟ୍",
        "systemSettings": "ସିଷ୍ଟମ୍ ସେଟିଂସ୍",
        "saveTranscript": "ଟ୍ରାନ୍ସକ୍ରିପ୍ଟ ରଖନ୍ତୁ",
        "signIn": "ସାଇନ୍ ଇନ୍"
    ],
    "os": [
        "purchase": "Купи",
        "share": "Создацæ",
        "tweet": "Твитт",
        "systemSettings": "Системæны уæдыдæг",
        "saveTranscript": "Транскрипты рыхсах",
        "signIn": "Войд"
    ],
    "pa": [
        "purchase": "ਖਰੀਦੋ",
        "share": "ਸਾਂਝਾ ਕਰੋ",
        "tweet": "ਟਵੀਟ",
        "systemSettings": "ਸਿਸਟਮ ਸੈਟਿੰਗਾਂ",
        "saveTranscript": "ਟ੍ਰਾਂਸਕ੍ਰਿਪਟ ਸੰਭਾਲੋ",
        "signIn": "ਸਾਇਨ ਇਨ ਕਰੋ"
    ],
    "pi": [
        "purchase": "क्रय",
        "share": "सामिये",
        "tweet": "ट्वीट",
        "systemSettings": "प्रणाली सेटिंग",
        "saveTranscript": "ट्रांसक्रिप्ट संरक्षित करें",
        "signIn": "साइन इन करें"
    ],
    "pl": [
        "purchase": "Kup",
        "share": "Udostępnij",
        "tweet": "Tweetuj",
        "systemSettings": "Ustawienia systemu",
        "saveTranscript": "Zapisz transkrypt",
        "signIn": "Zaloguj się"
    ],
    "ps": [
        "purchase": "خریداری کول",
        "share": "شریکول",
        "tweet": "ټویټ",
        "systemSettings": "سیسټم ترتیبات",
        "saveTranscript": "ټرانسکرپټ خوندي کول",
        "signIn": "ساپړنه"
    ],
    "pt": [
        "purchase": "Comprar",
        "share": "Compartilhar",
        "tweet": "Tweetar",
        "systemSettings": "Configurações do sistema",
        "saveTranscript": "Salvar Transcrição",
        "signIn": "Entrar"
    ],
    "qu": [
        "purchase": "Yanapaq",
        "share": "Riqsiy",
        "tweet": "Tuiyt'aq",
        "systemSettings": "Sistema Suntur",
        "saveTranscript": "T'ikray Transcripción",
        "signIn": "Kachan"
    ],
    "rm": [
        "purchase": "Cumprar",
        "share": "Dividir",
        "tweet": "Tuetta",
        "systemSettings": "Configuraziun dal sistem",
        "saveTranscript": "Salver la transcripziun",
        "signIn": "Sign In"
    ],
    "rn": [
        "purchase": "Kwiyiriza",
        "share": "Guhagura",
        "tweet": "Kwandika",
        "systemSettings": "Impanuro y'umwihariko",
        "saveTranscript": "Gusigasira transkripti",
        "signIn": "Kwamamaza"
    ],
    "ro": [
        "purchase": "Cumpărare",
        "share": "Partajare",
        "tweet": "Tweeta",
        "systemSettings": "Setări de sistem",
        "saveTranscript": "Salvare Trascript",
        "signIn": "Conectare"
    ],
    "ru": [
        "purchase": "Покупка",
        "share": "Поделиться",
        "tweet": "Твитнуть",
        "systemSettings": "Настройки системы",
        "saveTranscript": "Сохранить транскрипт",
        "signIn": "Войти"
    ],
    "rw": [
        "purchase": "Kugura",
        "share": "Kugurisha",
        "tweet": "Gufata ibitweeti",
        "systemSettings": "Gutangiza ibikorerwa",
        "saveTranscript": "Gusubira impandika",
        "signIn": "Kwinjira"
    ],
    "sa": [
        "purchase": "क्रयः",
        "share": "शेयरः",
        "tweet": "ट्वीटः",
        "systemSettings": "सिद्धान्तसंवादः",
        "saveTranscript": "तृणाय ग्रन्थः",
        "signIn": "योगः"
    ],
    "sc": [
        "purchase": "Cumporare",
        "share": "Parti",
        "tweet": "Tuita",
        "systemSettings": "Setàgios de su sistema",
        "saveTranscript": "Serrai sa traskrizzioni",
        "signIn": "Iskira"
    ],
    "sd": [
        "purchase": "خريد",
        "share": "هڪڻ",
        "tweet": "ٽويٽ",
        "systemSettings": "سسٽم جي ترتيبات",
        "saveTranscript": "ٽرينسڪرپٽ ختم ڪريو",
        "signIn": "سائين ڪريو"
    ],
    "se": [
        "purchase": "Bargat",
        "share": "Diibmu",
        "tweet": "Twiitta",
        "systemSettings": "Systeama Nuppástallet",
        "saveTranscript": "Bargat Tranškriberat",
        "signIn": "Registreret"
    ],
    "sg": [
        "purchase": "Léet",
        "share": "Sàmmà",
        "tweet": "Tweeta",
        "systemSettings": "Làppàndángà léet",
        "saveTranscript": "Fàkwà Ťranskrípt",
        "signIn": "Sàpàngé"
    ],
    "si": [
        "purchase": "මිලදී",
        "share": "බෙදාගන්න",
        "tweet": "ට්වීට්",
        "systemSettings": "පද්ධතිය සැකසුම්",
        "saveTranscript": "ට්‍රාන්ස්ක්‍රිප්ට් සුරක්ෂිතයට සුරක්ෂිතයට සුරක්ෂිතයට",
        "signIn": "පිළිබඳ වීම"
    ],
    "sk": [
        "purchase": "Nákup",
        "share": "Zdieľať",
        "tweet": "Tweetnúť",
        "systemSettings": "Nastavenia systému",
        "saveTranscript": "Uložiť prepis",
        "signIn": "Prihlásiť sa"
    ],
    "sl": [
        "purchase": "Nakup",
        "share": "Deli",
        "tweet": "Tweetaj",
        "systemSettings": "Nastavitve sistema",
        "saveTranscript": "Shrani transkripcijo",
        "signIn": "Prijava"
    ],
    "sm": [
        "purchase": "Fa'atau",
        "share": "Fa'atauaina",
        "tweet": "Tweet",
        "systemSettings": "Fa'atonuga o le sitama",
        "saveTranscript": "Sefeina le pepa fa'amatalaga",
        "signIn": "Saini i luma"
    ],
    "sn": [
        "purchase": "Kukumbira",
        "share": "Kugadzirisa",
        "tweet": "Kwandisa",
        "systemSettings": "Maitiro emusasa",
        "saveTranscript": "Kutonga Transcript",
        "signIn": "Kuenderera"
    ],
    "so": [
        "purchase": "Iibka",
        "share": "La wadaag",
        "tweet": "Tweet",
        "systemSettings": "Diyaarinta Nidaamka",
        "saveTranscript": "Keydinta Liiska Qoraalka",
        "signIn": "Gelis"
    ],
    "sq": [
        "purchase": "Blerje",
        "share": "Ndaj",
        "tweet": "Tweet",
        "systemSettings": "Cilësimet e sistemit",
        "saveTranscript": "Ruaj transkriptën",
        "signIn": "Hyr"
    ],
    "sr": [
        "purchase": "Куповина",
        "share": "Дели",
        "tweet": "Твитуј",
        "systemSettings": "Подешавања система",
        "saveTranscript": "Сачувај транскрипт",
        "signIn": "Пријави се"
    ],
    "ss": [
        "purchase": "Ukulinda",
        "share": "Sicinisekisa",
        "tweet": "Twita",
        "systemSettings": "Izilungiselelo zesistimu",
        "saveTranscript": "Londoloza Itraskripthi",
        "signIn": "Aloggen"
    ],
    "st": [
        "purchase": "Teng",
        "share": "Phaella",
        "tweet": "Twiit",
        "systemSettings": "Lefapha la selemo",
        "saveTranscript": "Bala Palo ya Phalane",
        "signIn": "Balaola"
    ],
    "su": [
        "purchase": "Bilas",
        "share": "Pamundutkeun",
        "tweet": "Twit",
        "systemSettings": "Panata Sistim",
        "saveTranscript": "Simpen Transkrip",
        "signIn": "Lebet"
    ],
    "sv": [
        "purchase": "Köp",
        "share": "Dela",
        "tweet": "Tweeta",
        "systemSettings": "Systeminställningar",
        "saveTranscript": "Spara Transkript",
        "signIn": "Logga in"
    ],
    "sw": [
        "purchase": "Ununue",
        "share": "Shiriki",
        "tweet": "Tuma Ujumbe",
        "systemSettings": "Mipangilio ya Mfumo",
        "saveTranscript": "Hifadhi Nakala",
        "signIn": "Ingia"
    ],
    "ta": [
        "purchase": "வாங்கு",
        "share": "பகிர்",
        "tweet": "ட்வீட்",
        "systemSettings": "அமைப்புகள் அமைப்பு",
        "saveTranscript": "டிரான்ஸ்கிரிப்ட் சேமிக்க",
        "signIn": "உள்நுழை"
    ],
    "te": [
        "purchase": "ఖరీదు చేయండి",
        "share": "షేర్ చేయండి",
        "tweet": "ట్వీట్ చేయండి",
        "systemSettings": "సిస్టమ్ సెట్టింగ్స్",
        "saveTranscript": "ట్రాన్స్క్రిప్ట్ సేవ్ చేయండి",
        "signIn": "సైన్ ఇన్"
    ],
    "tg": [
        "purchase": "Харид",
        "share": "Роиҳондан",
        "tweet": "Твит кардан",
        "systemSettings": "Танзимотҳои система",
        "saveTranscript": "Қатъгузории транскрипт",
        "signIn": "Даромадан"
    ],
    "th": [
        "purchase": "ซื้อ",
        "share": "แชร์",
        "tweet": "ทวีต",
        "systemSettings": "การตั้งค่าระบบ",
        "saveTranscript": "บันทึกทรานสคริปต์",
        "signIn": "เข้าสู่ระบบ"
    ],
    "ti": [
        "purchase": "ጉዕ",
        "share": "ኣስገብር",
        "tweet": "ጥዊት",
        "systemSettings": "ናይ ስርዓት ተግባር",
        "saveTranscript": "ትርክታ ተቐይረ",
        "signIn": "ኣጠቓቕ"
    ],
    "tk": [
        "purchase": "Satyn almak",
        "share": "Paýlaşmak",
        "tweet": "Tweýt etmek",
        "systemSettings": "Systema gurluşlary",
        "saveTranscript": "Transkripty sakla",
        "signIn": "Içeri gir"
    ],
    "tl": [
        "purchase": "Bilhin",
        "share": "Magbahagi",
        "tweet": "Mag-tweet",
        "systemSettings": "Mga Setting ng System",
        "saveTranscript": "I-save ang Transkripto",
        "signIn": "Mag-sign In"
    ],
    "tn": [
        "purchase": "Thenga",
        "share": "Yenza izimpawu",
        "tweet": "Kuphawulele",
        "systemSettings": "Izilungiselelo zesistimu",
        "saveTranscript": "Londoloza Itraskripthi",
        "signIn": "Gcina"
    ],
    "to": [
        "purchase": "Fai",
        "share": "Fa'avae",
        "tweet": "Tuiti",
        "systemSettings": "Tefito e fakafonua",
        "saveTranscript": "Seivi lahi",
        "signIn": "Fakatonu"
    ],
    "tr": [
        "purchase": "Satın Al",
        "share": "Paylaş",
        "tweet": "Tweetle",
        "systemSettings": "Sistem Ayarları",
        "saveTranscript": "Transkripti Kaydet",
        "signIn": "Giriş Yap"
    ],
    "ts": [
        "purchase": "Luma",
        "share": "Sicinisekisa",
        "tweet": "Twita",
        "systemSettings": "Izilungiselelo zesistimu",
        "saveTranscript": "Londoloza Itraskripthi",
        "signIn": "Aloggen"
    ],
    "tt": [
        "purchase": "Almağa",
        "share": "Äyırtmağa",
        "tweet": "Tüýtertme",
        "systemSettings": "Sistemä Cäläwşarı",
        "saveTranscript": "Transkriptı Qoraw",
        "signIn": "Yıqtıw"
    ],
    "tw": [
        "purchase": "Bo",
        "share": "Fefe",
        "tweet": "Tuo",
        "systemSettings": "Nsɛmbaɛni nnidiɛ",
        "saveTranscript": "Atumike no akowaw Transkript",
        "signIn": "Hu na"
    ],
    "ty": [
        "purchase": "Henua",
        "share": "Fa'afaite",
        "tweet": "Tuita",
        "systemSettings": "Fa'aora ra tuma'i",
        "saveTranscript": "Tatou i te Tatou",
        "signIn": "Tapu i te"
    ],
    "ug": [
        "purchase": "سېتىۋالماق",
        "share": "ئىشلىتىش",
        "tweet": "تۋىتلاش",
        "systemSettings": "تىزىملىتىش سىستېمىسى",
        "saveTranscript": "تىرانسكرىپتنى ساقلاش",
        "signIn": "كىرىش"
    ],
    "uk": [
        "purchase": "Купити",
        "share": "Поділитися",
        "tweet": "Твітнути",
        "systemSettings": "Налаштування системи",
        "saveTranscript": "Зберегти транскрипт",
        "signIn": "Увійти"
    ],
    "ur": [
        "purchase": "خریدیں",
        "share": "اشتراک کریں",
        "tweet": "ٹویٹ کریں",
        "systemSettings": "نظام کی ترتیبات",
        "saveTranscript": "ٹرانسکرپٹ محفوظ کریں",
        "signIn": "سائن ان کریں"
    ],
    "uz": [
        "purchase": "Sotib olish",
        "share": "Ulashish",
        "tweet": "Tvitlash",
        "systemSettings": "Tizim sozlamalari",
        "saveTranscript": "Transkriptni saqlash",
        "signIn": "Kirish"
    ],
    "ve": [
        "purchase": "Khuda",
        "share": "Dzula",
        "tweet": "Tvitla",
        "systemSettings": "Vhusiku ya tisivatshivelo",
        "saveTranscript": "Lula Mufa",
        "signIn": "Loma"
    ],
    "vi": [
        "purchase": "Mua hàng",
        "share": "Chia sẻ",
        "tweet": "Tweet",
        "systemSettings": "Cài đặt hệ thống",
        "saveTranscript": "Lưu bản ghi",
        "signIn": "Đăng nhập"
    ],
    "vo": [
        "purchase": "Läned",
        "share": "Däl",
        "tweet": "Tweetön",
        "systemSettings": "Sistem balanötis",
        "saveTranscript": "Savön täküpik",
        "signIn": "Lebo"
    ],
    "wa": [
        "purchase": "Akele",
        "share": "Divije",
        "tweet": "Tweeter",
        "systemSettings": "Apontiaedjes del sistinme",
        "saveTranscript": "Sere li tecse",
        "signIn": "S\' incrire"
    ],
    "wo": [
        "purchase": "Loppa",
        "share": "Baatu",
        "tweet": "Tweet",
        "systemSettings": "Defar settummu bi",
        "saveTranscript": "Noppal Transkript",
        "signIn": "Noppal"
    ],
    "xh": [
        "purchase": "Thenga",
        "share": "Lungisa",
        "tweet": "Tywelela",
        "systemSettings": "Izilungiselelo zesistimu",
        "saveTranscript": "Londoloza Itraskripthi",
        "signIn": "Gcina"
    ],
    "yi": [
        "purchase": "קויפן",
        "share": "טיילן",
        "tweet": "טוויטן",
        "systemSettings": "סיסטעם איינשטעלונגען",
        "saveTranscript": "שפּעיך טראַנסקריפּט",
        "signIn": "איינלאָגן אין"
    ],
    "yo": [
        "purchase": "Ra",
        "share": "Pelẹ",
        "tweet": "Towọ",
        "systemSettings": "Amọọlẹ awọn eto",
        "saveTranscript": "Fi Transcript lọ",
        "signIn": "Ṣisẹgun"
    ],
    "za": [
        "purchase": "Cuf",
        "share": "Hailcuf",
        "tweet": "Hailcuf",
        "systemSettings": "Gaemdzujh-swzdoz",
        "saveTranscript": "Nauz-cufq",
        "signIn": "Gohcm"
    ],
    "zh": [
        "purchase": "购买",
        "share": "分享",
        "tweet": "推特",
        "systemSettings": "系统设置",
        "saveTranscript": "保存副本",
        "signIn": "登录"
    ],
    "zu": [
        "purchase": "Ukulanda",
        "share": "Yabelana",
        "tweet": "Yatshala",
        "systemSettings": "Izilungiselelo zesistimu",
        "saveTranscript": "Londoloza Itraskripthi",
        "signIn": "Gcina"
    ]
]

