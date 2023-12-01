import Foundation

func getButtonLabel(for languageCode: String, buttonName: String) -> String {
    if let languageDictionary = buttonTranslations[languageCode], let translatedText = languageDictionary[buttonName] {
        return translatedText
    } else {
        if buttonName == "reset" {
            return "New Session"
        } else if buttonName == "tapToSpeak" {
            return "Tap to Speak"
        } else if buttonName == "surprise" {
            return "Surprise ME!"
        } else if buttonName == "speak" {
            return "Press & Hold"
        } else if buttonName == "more" {
            return "More Actions"
        } else if buttonName == "play" {
            return "Pause / Play"
        } else {
            return buttonName
        }
    }
}

var buttonTranslations: [String: [String: String]] = [
    "aa": [
        "reset": "New Session",
        "tapToSpeak": "Tap to Speak",
        "surprise": "Surprise ME!",
        "speak": "Press & Hold",
        "more": "More Actions",
        "play": "Pause / Play"
    ],
    "ab": [
        "reset": "New Session",
        "tapToSpeak": "Tap to Speak",
        "surprise": "Surprise ME!",
        "speak": "Press & Hold",
        "more": "More Actions",
        "play": "Pause / Play"
    ],
    "af": [
        "reset": "Nuwe Sessie",
        "tapToSpeak": "Tik om te Praat",
        "surprise": "Verras ME!",
        "speak": "Druk en Hou",
        "more": "Meer Aksies",
        "play": "Pouse / Speel"
    ],
    "ak": [
        "reset": "New Session",
        "tapToSpeak": "Tap to Speak",
        "surprise": "Surprise ME!",
        "speak": "Press & Hold",
        "more": "More Actions",
        "play": "Pause / Play"
    ],
    "am": [
        "reset": "አዲስ ማስቀመቂያ",
        "tapToSpeak": "ትክክል ማስተዳደር",
        "surprise": "ያልታወቀውን አስታውቀኝ!",
        "speak": "አጠቃቀም እና ይቀናል",
        "more": "ተጨማሪ ተግባራት",
        "play": "ቀጥል / ሰጥለኝ"
    ],
    "an": [
        "reset": "Nueva Sesión",
        "tapToSpeak": "Toca para Hablar",
        "surprise": "¡Sorpresa para Mí!",
        "speak": "Presiona y Sostén",
        "more": "Más Acciones",
        "play": "Pausa / Reproducir"
    ],
    "ar": [
        "reset": "جلسة جديدة",
        "tapToSpeak": "اضغط للتحدث",
        "surprise": "مفاجأة لي!",
        "speak": "اضغط واستمر",
        "more": "المزيد من الأوامر",
        "play": "إيقاف مؤقت / تشغيل"
    ],
    "as": [
        "reset": "নতুন সেশন",
        "tapToSpeak": "ট্যাপ কৰক সহুৱাস",
        "surprise": "মন্তব্য কৰক মন্তব্য",
        "speak": "টিপি ধৰি মন্তব্য কৰক",
        "more": "অধিক কাৰ্য",
        "play": "বিৱেদন আত্মবৰ্জন কৰক"
    ],
    "av": [
        "reset": "Новая Сессия",
        "tapToSpeak": "Прикоснитесь, чтобы Говорить",
        "surprise": "Удиви меня!",
        "speak": "Нажмите и Удерживайте",
        "more": "Больше Действий",
        "play": "Пауза / Воспроизведение"
    ],
    "ay": [
        "reset": "Nueva Sesión",
        "tapToSpeak": "Toca para Hablar",
        "surprise": "¡Sorpresa para Mí!",
        "speak": "Presiona y Sostén",
        "more": "Más Acciones",
        "play": "Pausa / Reproducir"
    ],
    "az": [
        "reset": "Yeni Seans",
        "tapToSpeak": "Danışmaq üçün toxunun",
        "surprise": "Mənə təəccüblən!",
        "speak": "Bas və saxla",
        "more": "Daha çox əməliyyatlar",
        "play": "Durdayın / Oynatın"
    ],
    "ba": [
        "reset": "Жаңа сессия",
        "tapToSpeak": "Сөйлеу үшін басыңыз",
        "surprise": "Мені үйлесеңіз!",
        "speak": "Басып жатырсыз",
        "more": "Көбірек әрекеттер",
        "play": "Пауза / Ойнау"
    ],
    "be": [
        "reset": "Новая сесія",
        "tapToSpeak": "Націсніце, каб гаварыць",
        "surprise": "Здзейсніце мне сюрпрыз!",
        "speak": "Націсніце і трымайце",
        "more": "Больш дзеянняў",
        "play": "Паўза / Грайце"
    ],
    "bg": [
        "reset": "Нова сесия",
        "tapToSpeak": "Докоснете се за говор",
        "surprise": "Изненадайте ме!",
        "speak": "Натиснете и задръжте",
        "more": "Повече действия",
        "play": "Пауза / Играйте"
    ],
    "bh": [
        "reset": "नई सत्र",
        "tapToSpeak": "बोलने के लिए टैप करें",
        "surprise": "मुझे हैरान करो!",
        "speak": "दबाकर रखें और बोलें",
        "more": "अधिक क्रियाएँ",
        "play": "ठहराव / बजाओ"
    ],
    "bi": [
        "reset": "New Session",
        "tapToSpeak": "Tap to Speak",
        "surprise": "Surprise ME!",
        "speak": "Press & Hold",
        "more": "More Actions",
        "play": "Pause / Play"
    ],
    "bm": [
        "reset": "Sesi Anyi",
        "tapToSpeak": "Tɔ sii nkan kasa",
        "surprise": "Yiyimi!",
        "speak": "Du dɔ",
        "more": "Nni animɔnni",
        "play": "Su tɛntɛn / Tumi"
    ],
    "bn": [
        "reset": "নতুন সেশন",
        "tapToSpeak": "কথা বলতে ট্যাপ করুন",
        "surprise": "আমাকে অবাক করুন!",
        "speak": "চাপ দিন এবং ধরুন",
        "more": "আরও কর্ম",
        "play": "বিরতি / খেলা"
    ],
    "bo": [
        "reset": "གསརང་ཁུལ་གཅིག",
        "tapToSpeak": "གཏུབ་འདུག་བྱེད་པ་ལས",
        "surprise": "ངེ་སྟེང་འཕུར་བ་ངེས་པས་པོ་རོ་མིན!",
        "speak": "གློག་བར་ཐོབ་པ་འདིར",
        "more": "ཆ་འཚོལ་མིན་འདུག",
        "play": "རེའུ་ཤོ་བར་སྦྲུལ་བསྡུས"
    ],
    "br": [
        "reset": "C'hwezh Session",
        "tapToSpeak": "Tap evit Klevout",
        "surprise": "Distagañit me!",
        "speak": "Pouezit ha Stumm",
        "more": "Meur a Dalc'hennoù",
        "play": "Pause / Pren"
    ],
    "bs": [
        "reset": "Nova Sjednica",
        "tapToSpeak": "Dodirnite da govorite",
        "surprise": "Iznenadite me!",
        "speak": "Pritisnite i držite",
        "more": "Više radnji",
        "play": "Pauza / Reproduciraj"
    ],
    "ca": [
        "reset": "Nova Sessió",
        "tapToSpeak": "Premeu per Parlar",
        "surprise": "Sorprenme!",
        "speak": "Premeu i Mantingueu",
        "more": "Més Accions",
        "play": "Pausa / Reproduïu"
    ],
    "ce": [
        "reset": "Номард цахна",
        "tapToSpeak": "УцI веделашкIа",
        "surprise": "Ма оццалло хIар",
        "speak": "Техха а локъ",
        "more": "Дийцашка малша",
        "play": "Пауза / Тухалш"
    ],
    "ch": [
        "reset": "Nihaan Session",
        "tapToSpeak": "Tap to Speak",
        "surprise": "Surprise ME!",
        "speak": "Press & Hold",
        "more": "More Actions",
        "play": "Pause / Play"
    ],
    "co": [
        "reset": "Nova Sessió",
        "tapToSpeak": "Premeu per Parlar",
        "surprise": "Sorprenme!",
        "speak": "Premeu i Mantingueu",
        "more": "Més Accions",
        "play": "Pausa / Reproduïu"
    ],
    "cr": [
        "reset": "ᓂᑭᐁᐧᐣ ᓂᑲᐡ",
        "tapToSpeak": "ᑖᑕᒥᐅᑯᔭᖔᓚᐅᔾ",
        "surprise": "ᒐᐠᔨᔾᔨ!",
        "speak": "ᑕᓂᐃᐢᑐᖅᓚᐅᔾ",
        "more": "ᒫᑦᑐᒃ ᓂᐱᕐᖅᐸᑦ",
        "play": "ᓄᐃᕐᖅ / ᒧᑦᑐᖅᑦ"
    ],
    "cs": [
        "reset": "Nová Session",
        "tapToSpeak": "Klepněte pro Mluvení",
        "surprise": "Překvap mě!",
        "speak": "Stiskněte a Držte",
        "more": "Více Akcí",
        "play": "Pauza / Přehrát"
    ],
    "cu": [
        "reset": "новѫ сесі́ѩ",
        "tapToSpeak": "Кликнѹти за глаголити",
        "surprise": "Возглагољ мѧ!",
        "speak": "Натїскати и држати",
        "more": "Вицѣ дѣла",
        "play": "Пауса / Разграђивати"
    ],
    "cv": [
        "reset": "Ячӑк сесси",
        "tapToSpeak": "Юрӑк ҫир",
        "surprise": "Ми шупашалла!",
        "speak": "Тып ҫир",
        "more": "Чулах ҫуратем",
        "play": "Пауза / Исӳн"
    ],
    "cy": [
        "reset": "Sesiwn Newydd",
        "tapToSpeak": "Pwyntiwch i Siarad",
        "surprise": "Synnu fi!",
        "speak": "Pwyntiwch a Dalwch",
        "more": "Rhagor o Weithredoedd",
        "play": "Sesiwn Newydd"
    ],
    "da": [
        "reset": "Ny Session",
        "tapToSpeak": "Tryk for at Tale",
        "surprise": "Overrask mig!",
        "speak": "Tryk og Hold",
        "more": "Flere Handlinger",
        "play": "Pause / Afspil"
    ],
    "de": [
        "reset": "Neue Sitzung",
        "tapToSpeak": "Tippen, um zu Sprechen",
        "surprise": "Überrasche mich!",
        "speak": "Drücken und Halten",
        "more": "Mehr Aktionen",
        "play": "Pause / Abspielen"
    ],
    "dv": [
        "reset": "ނަމާ ސެސްފަނު",
        "tapToSpeak": "ފުރަތަމަ އެސްޕަލް ކަލާ",
        "surprise": "މައުދިތާ ކުރެވިފަ!",
        "speak": "ދިވެހި އުކުރެވިފަ",
        "more": "ހިތާ މަތި ކުރެވިފަ",
        "play": "ޕަހެ / ހެއްދަސް"
    ],
    "dz": [
        "reset": "མིང་གསརང་གཅིག",
        "tapToSpeak": "བརྗོད་ཀླད་བཀོད་པ་གློག",
        "surprise": "ངེ་བརྟན་མེད!",
        "speak": "བཀོད་པ་ཡིན་བ",
        "more": "སྐུགས་ཆད་མིན་འདུག",
        "play": "ལེགས་སྡུས་ / བསྡུས་"
    ],
    "ee": [
        "reset": "Fɔsɔ Seshie",
        "tapToSpeak": "Tɔ kasa",
        "surprise": "W'ani m'ani!",
        "speak": "Tɔe & Kɛn",
        "more": "Ɛkɔkɔ dze",
        "play": "Tɔ me / Trɔwe"
    ],
    "el": [
        "reset": "Νέα Συνεδρία",
        "tapToSpeak": "Πατήστε για Ομιλία",
        "surprise": "Εκπληξέ με!",
        "speak": "Πατήστε & Κρατήστε",
        "more": "Περισσότερες Ενέργειες",
        "play": "Παύση / Αναπαραγωγή"
    ],
    "en": [
        "reset": "New Session",
        "tapToSpeak": "Tap to Speak",
        "surprise": "Surprise ME!",
        "speak": "Press & Hold",
        "more": "More Actions",
        "play": "Pause / Play"
    ],
    "eo": [
        "reset": "Nova Seanco",
        "tapToSpeak": "Frapi por Paroli",
        "surprise": "Miregos min!",
        "speak": "Premu kaj Tenu",
        "more": "Pli Agoj",
        "play": "Paŭzo / Ludu"
    ],
    "es": [
        "reset": "Nueva Sesión",
        "tapToSpeak": "Toca para Hablar",
        "surprise": "¡Sorpréndeme!",
        "speak": "Presiona y Mantén",
        "more": "Más Acciones",
        "play": "Pausa / Reproducir"
    ],
    "et": [
        "reset": "Uus Seanss",
        "tapToSpeak": "Puuduta rääkimiseks",
        "surprise": "Üllata mind!",
        "speak": "Vajuta ja hoia",
        "more": "Rohkem Tegevusi",
        "play": "Paus / Mängi"
    ],
    "eu": [
        "reset": "Berreskuratu",
        "tapToSpeak": "Sakatu Hizketa egiteko",
        "surprise": "Bertan beharrezkoa",
        "speak": "Sakatu eta eutsi",
        "more": "Ekintza gehiago",
        "play": "Pausa / Erreproduzitu"
    ],
    "fa": [
        "reset": "نشست جدید",
        "tapToSpeak": "برای صحبت کردن ضربه بزنید",
        "surprise": "من را شگفت زده کن!",
        "speak": "فشار دهید و نگه دارید",
        "more": "عملکردهای بیشتر",
        "play": "توقف / پخش"
    ],
    "ff": [
        "reset": "Bind yeesaay",
        "tapToSpeak": "Toɓ ko maat",
        "surprise": "Woppula ma!",
        "speak": "Fuɗɗita e haalde",
        "more": "Ngoon afaan",
        "play": "Cukk / Nopp"
    ],
    "fi": [
        "reset": "Uusi istunto",
        "tapToSpeak": "Kosketa puhuaksesi",
        "surprise": "Yllätä minut!",
        "speak": "Paina ja pidä",
        "more": "Lisää toimintoja",
        "play": "Tauko / Toista"
    ],
    "fj": [
        "reset": "Vaivola vakayalo",
        "tapToSpeak": "Touya me vakayacora",
        "surprise": "Dodonu au!",
        "speak": "Touya & Waita",
        "more": "Era Vakayacora",
        "play": "Pausa / Vakayacora"
    ],
    "fo": [
        "reset": "Nýggj Sessión",
        "tapToSpeak": "Rakna fyri at tosa",
        "surprise": "Yvirraska meg!",
        "speak": "Trykk og Halda",
        "more": "Meira Áskoðanir",
        "play": "Pás / Spæl"
    ],
    "fr": [
        "reset": "Nouvelle Session",
        "tapToSpeak": "Appuyez pour Parler",
        "surprise": "Surprenez-moi !",
        "speak": "Appuyez et Maintenez",
        "more": "Plus d'Actions",
        "play": "Pause / Lecture"
    ],
    "ga": [
        "reset": "Seisiún Nua",
        "tapToSpeak": "Brúigh chun Labhairt",
        "surprise": "Súirprísigh mé!",
        "speak": "Brúigh agus Coinnigh",
        "more": "Tuilleadh Gníomhaíochtaí",
        "play": "Sos / Seinn"
    ],
    "gd": [
        "reset": "Sèisean Ùr",
        "tapToSpeak": "Briog airson Labhairt",
        "surprise": "Iompaich mi!",
        "speak": "Briog is Cum",
        "more": "Barrachd Ghnìomhan",
        "play": "Sàs / Cluich"
    ],
    "gl": [
        "reset": "Nova Sesión",
        "tapToSpeak": "Toca para Falar",
        "surprise": "Sorpréndeme!",
        "speak": "Preme e Mantén",
        "more": "Máis Accións",
        "play": "Pausa / Reproducir"
    ],
    "gn": [
        "reset": "Ojeata ñemboguasu",
        "tapToSpeak": "Tembogua ha'ỹte",
        "surprise": "Pegua niko!",
        "speak": "Tekove ha ohenda",
        "more": "Añetegua hasẽ",
        "play": "Pausa / Pyhare"
    ],
    "gu": [
        "reset": "નવું સેશન",
        "tapToSpeak": "બોલવા માટે દબાણ",
        "surprise": "આશ્ચર્ય મને!",
        "speak": "દબાણ અને ધરાવ",
        "more": "વધુ ક્રિયાઓ",
        "play": "રુક્ક / ચલાવો"
    ],
    "gv": [
        "reset": "Sessiyn Noa",
        "tapToSpeak": "Taish lesh Gloyr",
        "surprise": "Dy jarroo mee!",
        "speak": "Taish as Tunnag",
        "more": "Barrant Eddyr-gharey",
        "play": "Steih / Clou"
    ],
    "ha": [
        "reset": "Sabuwar Gudun",
        "tapToSpeak": "Danna don Magana",
        "surprise": "Yi min asali!",
        "speak": "Danna da Janye",
        "more": "Kuma Minti",
        "play": "Shirya / Mai Shirya"
    ],
    "he": [
        "reset": "מפגש חדש",
        "tapToSpeak": "לחץ לדבר",
        "surprise": "הפתיע אותי!",
        "speak": "לחץ והחזק",
        "more": "פעולות נוספות",
        "play": "השהייה / השמעה"
    ],
    "hi": [
        "reset": "नई सत्र",
        "tapToSpeak": "बोलने के लिए टैप करें",
        "surprise": "मुझे चौंका दो!",
        "speak": "दबाएं और धरें",
        "more": "और क्रियाएँ",
        "play": "रोकें / चलाएं"
    ],
    "ho": [
        "reset": "Fale Fakamotu Hifo",
        "tapToSpeak": "Tufaki ke Fakatā",
        "surprise": "Fakahā ha'u!",
        "speak": "Tufaki mo Tokoni",
        "more": "Ha'a Fakamatala",
        "play": "Loto / Tukuatu"
    ],
    "hr": [
        "reset": "Nova Sesija",
        "tapToSpeak": "Dodirnite da Biste Govorili",
        "surprise": "Iznenadite me!",
        "speak": "Pritisnite i Držite",
        "more": "Više Akcija",
        "play": "Pauza / Reproduciraj"
    ],
    "ht": [
        "reset": "Nouvo Session",
        "tapToSpeak": "Touche pou Pale",
        "surprise": "Siprizem!",
        "speak": "Pese e Kenbe",
        "more": "Plis Aksyon",
        "play": "Poz / Jwe"
    ],
    "hu": [
        "reset": "Új Munkamenet",
        "tapToSpeak": "Koppintson a Beszéléshez",
        "surprise": "Leplezzen meg engem!",
        "speak": "Nyomja meg és tartsa lenyomva",
        "more": "További Műveletek",
        "play": "Szünet / Lejátszás"
    ],
    "hy": [
        "reset": "Նոր Համակարգ",
        "tapToSpeak": "Սեղմեք խոսելու համար",
        "surprise": "Ուղղեք ինձ!",
        "speak": "Սեղմեք և հնարավորեք",
        "more": "Ավելին գործողություններ",
        "play": "Դադարեք / Պահպանեք"
    ],
    "hz": [
        "reset": "Kutonda Vekuti",
        "tapToSpeak": "Pinda Kukhuluma",
        "surprise": "Pindurai ini!",
        "speak": "Pinda uye Pindura",
        "more": "Zvikonzero Zvakawanda",
        "play": "Kuverenga / Kugadzirisa"
    ],
    "ia": [
        "reset": "Nova Sessione",
        "tapToSpeak": "Tocca pro Parlar",
        "surprise": "Surprinde me!",
        "speak": "Tocca e Tene",
        "more": "Pli Actiones",
        "play": "Pause / Reproduce"
    ],
    "id": [
        "reset": "Sesi Baru",
        "tapToSpeak": "Ketuk untuk Bicara",
        "surprise": "Kejutkan saya!",
        "speak": "Tekan dan Tahan",
        "more": "Lebih Banyak Tindakan",
        "play": "Jeda / Putar"
    ],
    "ie": [
        "reset": "Nova Session",
        "tapToSpeak": "Toca por Parlar",
        "surprise": "Surprende me!",
        "speak": "Toca e Tén",
        "more": "Mai Actions",
        "play": "Paùsa / Reproduire"
    ],
    "ig": [
        "reset": "Ọdịnaya Ọhụrụ",
        "tapToSpeak": "Kpọtara iji Hụ",
        "surprise": "Nwee m!",
        "speak": "Kpọtara na Tụtụ",
        "more": "Ọzọ Kachasị",
        "play": "Kpọtara / Mmekọ"
    ],
    "ii": [
        "reset": "ꀠꑭꆏ ꄘꋳ",
        "tapToSpeak": "ꂵꅝꃅꋪ ꇁꏏꅐ",
        "surprise": "ꆏꏉꁵꅐ!",
        "speak": "ꂵꃅꄘꃃ ꇁꏏꅐ",
        "more": "ꁱꆏꋊ ꋂꆩ",
        "play": "ꂶ / ꅐꋊ"
    ],
    "ik": [
        "reset": "Iñuun Ixsaŋgat",
        "tapToSpeak": "Taatuut imqanun",
        "surprise": "Una iik!",
        "speak": "Taatuut & Ayuuq",
        "more": "Qanruyut Aqulallruut",
        "play": "Atsan / Aturyaaq"
    ],
    "io": [
        "reset": "Nova Sesiono",
        "tapToSpeak": "Takar por Parolar",
        "surprise": "Surprizoy me!",
        "speak": "Takar e Tenar",
        "more": "Plu Akcioni",
        "play": "Pauso / Reproduktar"
    ],
    "is": [
        "reset": "Ný Skipti",
        "tapToSpeak": "Snertu til að Tala",
        "surprise": "Dásamlegg mig!",
        "speak": "Ýttu og Hald",
        "more": "Fleiri Aðgerðir",
        "play": "Pása / Spila"
    ],
    "it": [
        "reset": "Nuova Sessione",
        "tapToSpeak": "Tocca per Parlare",
        "surprise": "Sorprendimi!",
        "speak": "Tocca e Tieni",
        "more": "Altre Azioni",
        "play": "Pausa / Riproduci"
    ],
    "iu": [
        "reset": "ᐊᒡᒋᐊᖃᑎᒌᖓ",
        "tapToSpeak": "ᐅᖄᓰᑦ ᐃᓄᒃᑎᑐᑦ",
        "surprise": "ᐊᑐᖕ!",
        "speak": "ᐊᒡᔪᖅ ᖁᒃᑖᓐᓂ",
        "more": "ᓴᐃᒪᓂᓇᖅ",
        "play": "ᐃᓄᑖᖅ / ᓇᓗᑦᑎᖅ"
    ],
    "ja": [
        "reset": "新しいセッション",
        "tapToSpeak": "話すためにタップ",
        "surprise": "私を驚かせて！",
        "speak": "押して押し続けて",
        "more": "もっとアクション",
        "play": "一時停止 / 再生"
    ],
    "jv": [
        "reset": "Sesi Anyar",
        "tapToSpeak": "Tekuk kanggo Ngomong",
        "surprise": "Sorotake aku!",
        "speak": "Tekuk lan Terus",
        "more": "Aksi Luwih",
        "play": "Pause / Mainake"
    ],
    "ka": [
        "reset": "ახალი სესია",
        "tapToSpeak": "ჩაწერეთ ლაპარაკობს",
        "surprise": "შემშლელე!",
        "speak": "დააჭირე და დამარცხეთ",
        "more": "მეტი ქმედება",
        "play": "პაუზა / ითამაშე"
    ],
    "kg": [
        "reset": "Sessyon Mpya",
        "tapToSpeak": "Gonga kwa Kusema",
        "surprise": "Nishtue!",
        "speak": "Gonga na Shika",
        "more": "Vitendo Zaidi",
        "play": "Sitisha / Cheza"
    ],
    "ki": [
        "reset": "Igitondo Gihuriye",
        "tapToSpeak": "Kwikira Guhurira",
        "surprise": "Nshengeye!",
        "speak": "Kwikira Uragukiza",
        "more": "Guhari Zindi",
        "play": "Kwarikiza / Kwiyumva"
    ],
    "kj": [
        "reset": "Oshilungi Noolo",
        "tapToSpeak": "Oyena Ekwa Lifasa",
        "surprise": "Kuza Kuete!",
        "speak": "Oyena na Lifutu",
        "more": "Yakala Tuyende",
        "play": "Kulongola / Kulokolonge"
    ],
    "kk": [
        "reset": "Жаңа сессия",
        "tapToSpeak": "Сөйлесу үшін басыңыз",
        "surprise": "Мені өкінішке алдыр!",
        "speak": "Басып жатырсыз",
        "more": "Толығырақ әрекеттер",
        "play": "Тоқтату / Ойнату"
    ],
    "kl": [
        "reset": "Nutaat Katersugaasivi",
        "tapToSpeak": "Aasaqqutisoq",
        "surprise": "Inuit nukkummat!",
        "speak": "Aasaqqutit pissutaasut",
        "more": "Pisaraq atuarsinnaavit",
        "play": "Pissutaat / Pisaraq"
    ],
    "km": [
        "reset": "សម័យ​ថ្មី",
        "tapToSpeak": "ចុច​ដើម្បី​និយាយ",
        "surprise": "ឲ្យ​ខ្លាំងខ្លាំង​ខ្លាំង!",
        "speak": "ចុច​ហើយ​ទេញនៅ",
        "more": "សកម្ម​បន្ថែម",
        "play": "ផ្អាក / លេងម្ដង"
    ],
    "kn": [
        "reset": "ಹೊಸ ಸೆಷನ್",
        "tapToSpeak": "ಮಾತನಾಡಲು ಟ್ಯಾಪ್ ಮಾಡಿ",
        "surprise": "ನನಗೆ ಆಶ್ಚರ್ಯವಾಗಿಸು!",
        "speak": "ನೊಂದು ಹಿಡಿದು",
        "more": "ಹೆಚ್ಚು ಕ್ರಿಯೆಗಳು",
        "play": "ನಿಲ್ಲಿಸು / ಆಡಿಸು"
    ],
    "ko": [
        "reset": "새 세션",
        "tapToSpeak": "말하기 위해 탭하세요",
        "surprise": "저를 놀래 주세요!",
        "speak": "누르고 누르세요",
        "more": "더 많은 작업",
        "play": "일시 정지 / 재생"
    ],
    "kr": [
        "reset": "Sesiyon Nouvo",
        "tapToSpeak": "Touche pou Pale",
        "surprise": "Siprizemi!",
        "speak": "Touche ak Kenbe",
        "more": "Plis Aksyon",
        "play": "Poz / Jwe"
    ],
    "ks": [
        "reset": "نوین سیشن",
        "tapToSpeak": "گٹھ کر بولنے کے لئے ٹیپ کریں",
        "surprise": "مجھے حیران کریں!",
        "speak": "ڈب کر رکھیں اور چلائیں",
        "more": "مزید کارروائیاں",
        "play": "رکیں / چلائیں"
    ],
    "ku": [
        "reset": "Sesiyona Nû",
        "tapToSpeak": "Daketin ji bo Hînbûnê",
        "surprise": "Ez bişkînin!",
        "speak": "Daketin û Asteng bike",
        "more": "Kariyerek zêde",
        "play": "Tomar / Lê bibe"
    ],
    "kv": [
        "reset": "Новая сессия",
        "tapToSpeak": "Потынткше для говоронга",
        "surprise": "Пукшем ён!",
        "speak": "Толыш шав ма узи кучеш",
        "more": "Пле дома кармалази",
        "play": "Капча / Дара кармам"
    ],
    "kw": [
        "reset": "Sessyon Nowydh",
        "tapToSpeak": "Tappya dhe Gevrans",
        "surprise": "Kodhav anay!",
        "speak": "Tappya ha Kewsel",
        "more": "Lemmyniow Aksyonow",
        "play": "Potgarga / Plewjya"
    ],
    "ky": [
        "reset": "Жаңы Сессия",
        "tapToSpeak": "Сөздөгөн үчүн басыңыз",
        "surprise": "Мени көңгүлтүргөн!",
        "speak": "Басып жатасыз",
        "more": "Өткүнчү Кызматтар",
        "play": "Токтотуу / Чалып"
    ],
    "la": [
        "reset": "Nova Sessio",
        "tapToSpeak": "Tange ad Eloqüer",
        "surprise": "Eloqüe me!",
        "speak": "Tange e Tene",
        "more": "Plus Actions",
        "play": "Pauser / Joer"
    ],
    "lb": [
        "reset": "Nächst Sëssio'n",
        "tapToSpeak": "Fir ze schwätzen, tippt",
        "surprise": "Elo si!",
        "speak": "Tippt a Halen",
        "more": "Méi Aktiounen",
        "play": "Paus / Spill"
    ],
    "lg": [
        "reset": "Sessawo Ezituukirizibwa",
        "tapToSpeak": "Ekuyimba Nti",
        "surprise": "Wumanyire!",
        "speak": "Ekuluma Omubiri Gwaayita",
        "more": "Ebifo Byonna",
        "play": "Okusima / Okujaguza"
    ],
    "li": [
        "reset": "Nuuj Sessie",
        "tapToSpeak": "Tip om te Proate",
        "surprise": "Verbas me!",
        "speak": "Tip en Vasjhalde",
        "more": "Mie Acties",
        "play": "Pauzeer / Speel"
    ],
    "ln": [
        "reset": "Session N° Bongisa",
        "tapToSpeak": "Kokoma Koyokana",
        "surprise": "Sombela ngai!",
        "speak": "Kokoma na Kosakola",
        "more": "Mikolo Mingi",
        "play": "Tetama / Pesa"
    ],
    "lo": [
        "reset": "ຄົນສົ່ງໃຫມ່",
        "tapToSpeak": "ກົດເພື່ອເບິ່ງ",
        "surprise": "ຮັບເບິ່ງຂ້າງສິ້ນ!",
        "speak": "ກົດແລ້ວເປັນ",
        "more": "ການດິນດີ",
        "play": "ສິ້ນສຸດ / ເຮັດເບິ່ງ"
    ],
    "lt": [
        "reset": "Nauja Sesiija",
        "tapToSpeak": "Paspauskite, kad kalbėti",
        "surprise": "Nuostabus mane!",
        "speak": "Spauskite ir laikykite",
        "more": "Daugiau veiksmų",
        "play": "Pauzė / Groja"
    ],
    "lu": [
        "reset": "Néi Sessioun",
        "tapToSpeak": "Tippt fir ze schwätzen",
        "surprise": "Ferwinnt mech!",
        "speak": "Tippt an Hält",
        "more": "Méi Aktiounen",
        "play": "Pause / Spill"
    ],
    "lv": [
        "reset": "Jauna Sesija",
        "tapToSpeak": "Pieskarieties, lai runātu",
        "surprise": "Pārsteidz mani!",
        "speak": "Nospiediet un turiet",
        "more": "Vairāk darbību",
        "play": "Pauze / Atskaņot"
    ],
    "mg": [
        "reset": "Sesiova Vaovao",
        "tapToSpeak": "Tsoahy ho miresaka",
        "surprise": "Ahoana!",
        "speak": "Tsoahy sy Ampy",
        "more": "Ny Zavatra Hafa",
        "play": "Mihentra / Mitodika"
    ],
    "mh": [
        "reset": "Kōmmān N̄an Kōḷlōn",
        "tapToSpeak": "Emmān Kōmmān Lōñ",
        "surprise": "Iọkwe e!",
        "speak": "Emmān im Wōt Wōt",
        "more": "Booj Booj",
        "play": "Pāḷō / Jijet"
    ],
    "mi": [
        "reset": "Taki Hou",
        "tapToSpeak": "Pāwhiritia ki te Kōrero",
        "surprise": "Whakatauira ahau!",
        "speak": "Pāwhiritia me Whakarite",
        "more": "Rautaki Anō",
        "play": "Whakakikorua / Hanga"
    ],
    "mk": [
        "reset": "Нова Сесија",
        "tapToSpeak": "Допрете за да Зборувате",
        "surprise": "Изненадете ме!",
        "speak": "Допрете и Држете",
        "more": "Повеќе Акции",
        "play": "Пауза / Свирај"
    ],
    "ml": [
        "reset": "പുതിയ സെഷൻ",
        "tapToSpeak": "പറയാൻ ടാപ്പ് ചെയ്യുക",
        "surprise": "ഞാൻ ആകാശം!",
        "speak": "അമർത്തുക",
        "more": "കൂടുതൽ ക്രിയകൾ",
        "play": "ഒഴിവാക്കു / പ്രവർത്തിപ്പിക്കു"
    ],
    "mn": [
        "reset": "Шинэ Сесси",
        "tapToSpeak": "Ярихын товчлуур",
        "surprise": "Би манайг анхаараа!",
        "speak": "Товшино уу Дараац",
        "more": "Илүү Үйлдэл",
        "play": "Зогсоо / Тоглуулаарай"
    ],
    "mr": [
        "reset": "नवीन सत्र",
        "tapToSpeak": "बोलण्यासाठी टॅप करा",
        "surprise": "मला आश्चर्यचकित करा!",
        "speak": "टॅप करा आणि ठेवा",
        "more": "अधिक क्रिया",
        "play": "थांबवा / खेळा"
    ],
    "ms": [
        "reset": "Sesi Baru",
        "tapToSpeak": "Ketik untuk Bercakap",
        "surprise": "Kejutkan saya!",
        "speak": "Ketik dan Tahan",
        "more": "Lebih Banyak Tindakan",
        "play": "Jeda / Main"
    ],
    "mt": [
        "reset": "Sessioni Ġdida",
        "tapToSpeak": "Ikklikkja biex Titkellem",
        "surprise": "Isorprendimi!",
        "speak": "Ikklikkja u Żomm",
        "more": "Azzjonijiet iżjed",
        "play": "Pawsa / Ippjega"
    ],
    "my": [
        "reset": "နောက်ဆုံးစံပယ်",
        "tapToSpeak": "စကားရွေးရန်နှိပ်ပါ",
        "surprise": "အားလုံးကြာ!",
        "speak": "နှိပ်ရန်နှိပ်ပါ",
        "more": "ပြန်လည်သုံးစွဲများ",
        "play": "ပေါက် / ဖိုင်း"
    ],
    "na": [
        "reset": "New Session",
        "tapToSpeak": "Tap to Speak",
        "surprise": "Surprise ME!",
        "speak": "Press & Hold",
        "more": "More Actions",
        "play": "Pause / Play"
    ],
    "nb": [
        "reset": "Ny Økt",
        "tapToSpeak": "Trykk for å Snakke",
        "surprise": "Overrask meg!",
        "speak": "Trykk og Hold",
        "more": "Flere Handlinger",
        "play": "Pause / Spill"
    ],
    "nd": [
        "reset": "Isisindo Sesishintsha",
        "tapToSpeak": "Kwahla Ukukhuluma",
        "surprise": "Bopha Nami!",
        "speak": "Kwahla Le-Khalitha",
        "more": "Izinto Eziyinzuzo",
        "play": "Susa / Dlala"
    ],
    "ne": [
        "reset": "नयाँ सत्र",
        "tapToSpeak": "बोल्नको लागि ट्याप गर्नुहोस्",
        "surprise": "म चौंकाउनु!",
        "speak": "ट्याप गर्नुहोस् र सम्म धर्नुहोस्",
        "more": "थप क्रियाकलापहरू",
        "play": "रोक / प्ले गर्नुहोस्"
    ],
    "ng": [
        "reset": "Sesi Putha",
        "tapToSpeak": "Thatha ukuKhuluma",
        "surprise": "Ngiyakuthokoza!",
        "speak": "Thatha futhi Jikeleza",
        "more": "Izinto Ezinzima",
        "play": "Ihlola / Loya"
    ],
    "nl": [
        "reset": "Nieuwe Sessie",
        "tapToSpeak": "Tik om te Spreken",
        "surprise": "Verras Mij!",
        "speak": "Tik en Vasthouden",
        "more": "Meer Acties",
        "play": "Pauze / Afspelen"
    ],
    "nn": [
        "reset": "Ny Økt",
        "tapToSpeak": "Trykk for å Snakke",
        "surprise": "Overrask meg!",
        "speak": "Trykk og Hold",
        "more": "Flere Handlinger",
        "play": "Pause / Spill"
    ],
    "no": [
        "reset": "Ny Økt",
        "tapToSpeak": "Trykk for å Snakke",
        "surprise": "Overrask meg!",
        "speak": "Trykk og Hold",
        "more": "Flere Handlinger",
        "play": "Pause / Spill"
    ],
    "nr": [
        "reset": "Isisindo Sesishintsha",
        "tapToSpeak": "Kwahla Ukukhuluma",
        "surprise": "Bopha Nami!",
        "speak": "Kwahla Le-Khalitha",
        "more": "Izinto Eziyinzuzo",
        "play": "Susa / Dlala"
    ],
    "nv": [
        "reset": "Tʼáá hwó ají tʼáá dóó asdzą́ą́",
        "tapToSpeak": "Kwii nił chʼil yiltsa doo hwó ají tʼáá dóó asdzą́ą́",
        "surprise": "Woozh yiltsa!",
        "speak": "Kwii nił chʼil yiltsa doo hwó ají tʼáá dóó asdzą́ą́",
        "more": "Hózhǫǫgo akʼehígíí",
        "play": "Tłʼiish / Hózhǫǫgo"
    ],
    "ny": [
        "reset": "Session Yachilendo",
        "tapToSpeak": "Gwiritsa ntchito kuti ukhale wachilendo",
        "surprise": "Lakudalitsani!",
        "speak": "Gwiritsa ntchito kuti ukhale wachilendo",
        "more": "Zinthu Zambiri",
        "play": "Kwezga / Sankha"
    ],
    "oc": [
        "reset": "Sesion Nòva",
        "tapToSpeak": "Tòca per Parlar",
        "surprise": "Surprèn-me!",
        "speak": "Tòca e Mantèn",
        "more": "Mai d'Accions",
        "play": "Pausa / Joga"
    ],
    "oj": [
        "reset": "Opichi Kahbeekan",
        "tapToSpeak": "Ozhi-bibaaniman",
        "surprise": "Nimkomendam!",
        "speak": "Ozhi-bibaaniman ji-zhaak",
        "more": "Niibwaakawinan",
        "play": "Opichik / Biibaakawaa"
    ],
    "om": [
        "reset": "Seessoonni Barbaadda",
        "tapToSpeak": "Taapheen Boqote",
        "surprise": "Ijoollee fayyaa!",
        "speak": "Taapheen Boqote Nanneeffata",
        "more": "Adeemsa Barbaadda",
        "play": "Pawusii / Galatoomaa"
    ],
    "or": [
        "reset": "ନୂତନ ସେଷନ",
        "tapToSpeak": "କେହିବା ଟିପ୍‌ କରନ୍ତୁ",
        "surprise": "ମୁଁ ଆଶ୍ଚର୍ଯ୍ୟ!",
        "speak": "ଟିପ୍‌ କରନ୍ତୁ ଓ ଧରଣ କରନ୍ତୁ",
        "more": "ଆମଣାଆମି କ୍ରିୟା",
        "play": "ବାଧ ଦେବା / ପ୍ଲେ କରନ୍ତୁ"
    ],
    "os": [
        "reset": "Нова Сесси",
        "tapToSpeak": "Айрын зӕрцы мæн кæлыг",
        "surprise": "Соны фыг!",
        "speak": "Айрын зӕрцы мæн кæлыг",
        "more": "Дæлон агуым",
        "play": "Тæнджаг / Фыггæтаг"
    ],
    "pa": [
        "reset": "ਨਵਾਂ ਸੈਸ਼ਨ",
        "tapToSpeak": "ਗੱਲਾਂ ਕਰਨ ਲਈ ਟੈਪ ਕਰੋ",
        "surprise": "ਮੈਨੂੰ ਚੌਂਕਾ ਦਿਓ!",
        "speak": "ਟੈਪ ਕਰੋ ਅਤੇ ਰੱਖੋ",
        "more": "ਹੋਰ ਕਰਮ",
        "play": "ਰੁਕੋ / ਚੱਲੋ"
    ],
    "pi": [
        "reset": "नवा सत्र",
        "tapToSpeak": "बोल्नको लागि ट्याप गरा",
        "surprise": "मला आश्चर्यचकित करा!",
        "speak": "ट्याप गरा आणि ठेवा",
        "more": "अधिक क्रिया",
        "play": "रोका / प्ले करा"
    ],
    "pl": [
        "reset": "Nowa Sesja",
        "tapToSpeak": "Kliknij, aby Mówić",
        "surprise": "Zaskocz mnie!",
        "speak": "Kliknij i Trzymaj",
        "more": "Więcej Działań",
        "play": "Pauza / Odtwórz"
    ],
    "ps": [
        "reset": "نوی سیشن",
        "tapToSpeak": "دغه ورځ دړیا کړئ",
        "surprise": "زما راځه ووژئ!",
        "speak": "دغه ورځ دړیا کړئ",
        "more": "نور کارونه",
        "play": "توقف / ورته وائے"
    ],
    "pt": [
        "reset": "Nova Sessão",
        "tapToSpeak": "Toque para Falar",
        "surprise": "Surpreenda-me!",
        "speak": "Toque e Segure",
        "more": "Mais Ações",
        "play": "Pausar / Reproduzir"
    ],
    "qu": [
        "reset": "Huk Allin Kawsay",
        "tapToSpeak": "Kichariy Kani",
        "surprise": "Mana Waranqa!",
        "speak": "Kichariy Kani Qepariy",
        "more": "Asqa Kani",
        "play": "Lluqsiy / Kaniy"
    ],
    "rm": [
        "reset": "Nova Sessiun",
        "tapToSpeak": "Fai Tap per Parlar",
        "surprise": "Surpraisa Me!",
        "speak": "Fai Tap e Tegna",
        "more": "Plirs Actiuns",
        "play": "Pausa / Gioga"
    ],
    "rn": [
        "reset": "Sesyon Nuvèl",
        "tapToSpeak": "Pousé Pou Pale",
        "surprise": "Surprezé Mwen!",
        "speak": "Pousé e Kenbe",
        "more": "Plis Aksyon",
        "play": "Meté an Pòz / Jwe"
    ],
    "ro": [
        "reset": "Sesiune Nouă",
        "tapToSpeak": "Atingeți pentru a Vorbi",
        "surprise": "Surprinde-mă!",
        "speak": "Atingeți și Mențineți",
        "more": "Mai Multe Acțiuni",
        "play": "Pauză / Redare"
    ],
    "ru": [
        "reset": "Новая Сессия",
        "tapToSpeak": "Коснитесь, чтобы Говорить",
        "surprise": "Удиви меня!",
        "speak": "Коснитесь и Удерживайте",
        "more": "Дополнительные Действия",
        "play": "Пауза / Воспроизвести"
    ],
    "rw": [
        "reset": "Sesheni Nshya",
        "tapToSpeak": "Gusaba Kwandika",
        "surprise": "Gufyondora!",
        "speak": "Gusaba Kwandika Ukwandike",
        "more": "Ibihano Byo Kora",
        "play": "Gutanga / Kubara"
    ],
    "sa": [
        "reset": "नवा सत्र",
        "tapToSpeak": "बोल्नको लागि ट्याप गरा",
        "surprise": "मां विस्मयम्!",
        "speak": "ट्याप गरा रक्षः",
        "more": "अधिक क्रियाः",
        "play": "स्थाप्य / वद्ध"
    ],
    "sc": [
        "reset": "Sessión Nova",
        "tapToSpeak": "Clichia pro faeddare",
        "surprise": "Ispantzaime!",
        "speak": "Clichia e Mantea",
        "more": "Azziones Pius",
        "play": "Pausa / Afunna"
    ],
    "sd": [
        "reset": "نئي ڏورو",
        "tapToSpeak": "ٽيپ ڪرڻ لاءِ ڪريو",
        "surprise": "مون کي حیران ڪريو!",
        "speak": "ٽيپ ڪريو ۽ رکو",
        "more": "کئي ڪارروائيون",
        "play": "روڪيو / ڀڍيو"
    ],
    "se": [
        "reset": "Oažžut Session",
        "tapToSpeak": "Tappat Dahkat",
        "surprise": "Oaidne Mu!",
        "speak": "Tappat Dahkat Leage",
        "more": "Goit Aktivitehtat",
        "play": "Audehusat / Hearvahuvvut"
    ],
    "sg": [
        "reset": "Séans Nau",
        "tapToSpeak": "Tòke pa Palé",
        "surprise": "Sôpri Man!",
        "speak": "Tòke e Si",
        "more": "Plis Aksyon",
        "play": "Poz / Jwe"
    ],
    "si": [
        "reset": "නව සැසිය",
        "tapToSpeak": "කරන්න පිටවන්ද",
        "surprise": "මම ආහාරයි!",
        "speak": "පිටවන්ද වෙත හෝඩියට",
        "more": "තව ක්රියාවන්",
        "play": "නැවතත් / සෝකයන්"
    ],
    "sk": [
        "reset": "Nová Session",
        "tapToSpeak": "Kliknite pre Hovorenie",
        "surprise": "Prekvap ma!",
        "speak": "Kliknite a Držte",
        "more": "Viac Akcií",
        "play": "Pauza / Prehrať"
    ],
    "sl": [
        "reset": "Nova seja",
        "tapToSpeak": "Dotaknite se za Pogovor",
        "surprise": "Preseneti me!",
        "speak": "Dotaknite se in Držite",
        "more": "Več Dejanj",
        "play": "Premor / Predvajaj"
    ],
    "sm": [
        "reset": "Tusifili Malamalama Fou",
        "tapToSpeak": "Tapa e Alofa e Malamalama",
        "surprise": "Fa'a'ititi i'a ia te au!",
        "speak": "Tapa ma Tautau",
        "more": "Aumaia Aoga",
        "play": "Amitu / Pese"
    ],
    "sn": [
        "reset": "Ruregerera Session",
        "tapToSpeak": "Kuvhara kweKuvhara",
        "surprise": "Ndega!",
        "speak": "Kuvhara kweKuvhara uye Kukumbira",
        "more": "MaAction Aanoratidza",
        "play": "Kukanganwirwa / Kupfekedza"
    ],
    "so": [
        "reset": "Cashan Session",
        "tapToSpeak": "Dab Qofka Siyaabo loo Eegin",
        "surprise": "Ka Bax!",
        "speak": "Dab iyo Xerista",
        "more": "Falcelinta Kale",
        "play": "Dhamaadka / Ciyaar"
    ],
    "sq": [
        "reset": "Sesioni i Ri",
        "tapToSpeak": "Trokit për të Folur",
        "surprise": "Më Beftë Paqe!",
        "speak": "Trokit dhe Mbani",
        "more": "Më Shumë Veprime",
        "play": "Pusho / Luaje"
    ],
    "sr": [
        "reset": "Нова Сесија",
        "tapToSpeak": "Додирните за Говор",
        "surprise": "Изненади ме!",
        "speak": "Додирните и Држите",
        "more": "Више Акција",
        "play": "Пауза / Пустите"
    ],
    "ss": [
        "reset": "I-Seshini Yomsindo",
        "tapToSpeak": "Casha ukuze Ukhulume",
        "surprise": "Lungisa Ngami!",
        "speak": "Casha ukuze Ukhulume",
        "more": "Izinto Ezinzima",
        "play": "Yekela / Dlala"
    ],
    "st": [
        "reset": "Lerato La Kapa",
        "tapToSpeak": "Hlahla Ho Hlahla",
        "surprise": "Khutsitse Kea!",
        "speak": "Hlahla Ho Hlahla Le Ho Hlokomela",
        "more": "Mafolofolo A Mangata",
        "play": "Hlompha / Hloleha"
    ],
    "su": [
        "reset": "Sesi Sedulur",
        "tapToSpeak": "Klik Kanggo Nuturkeun",
        "surprise": "Kagabut!",
        "speak": "Klik sareng Tahan",
        "more": "Lebih Aktivitas",
        "play": "Berhenti / Main"
    ],
    "sv": [
        "reset": "Nytt Session",
        "tapToSpeak": "Tryck för Att Tala",
        "surprise": "Överraska Mig!",
        "speak": "Tryck och Håll",
        "more": "Fler Åtgärder",
        "play": "Pausa / Spela"
    ],
    "sw": [
        "reset": "Kikao Kipya",
        "tapToSpeak": "Bonyeza Kuzungumza",
        "surprise": "Nishangaze!",
        "speak": "Bonyeza na Shikilia",
        "more": "Vitendo Zaidi",
        "play": "Acha / Cheza"
    ],
    "ta": [
        "reset": "புதிய அமர்வெட்டு",
        "tapToSpeak": "பேச கிளிக் செய்யவும்",
        "surprise": "என்னுடைய ஆச்சரியம்!",
        "speak": "கிளிக் மற்றும் நீக்கு",
        "more": "மேலும் செய்திகள்",
        "play": "இடைநிறுத்தம் / விளக்கு"
    ],
    "te": [
        "reset": "కొత్త సెషన్",
        "tapToSpeak": "మాట్లాడడానికి నొక్కండి",
        "surprise": "ఆకట్టుకో!",
        "speak": "నొక్కండి మరియు ఉంచండి",
        "more": "మరింత చర్యలు",
        "play": "ఉపవేశించు / ఆడండి"
    ],
    "tg": [
        "reset": "Сесияи Нав",
        "tapToSpeak": "Барои Суҳбат Зани Нишон Диҳед",
        "surprise": "Манро Та'ҷҷуб Кун!",
        "speak": "Барои Гуфтани Занг Диҳед",
        "more": "Корҳои Дигар",
        "play": "Вақт / Игра"
    ],
    "th": [
        "reset": "เซสชันใหม่",
        "tapToSpeak": "แตะเพื่อพูด",
        "surprise": "ประหลาดใจฉัน!",
        "speak": "แตะและถือ",
        "more": "การกระทำเพิ่มเติม",
        "play": "หยุด / เล่น"
    ],
    "ti": [
        "reset": "ናይ ዕብየት",
        "tapToSpeak": "ንምስጥራይ ኣይነቕርን",
        "surprise": "እዚ'ኳ ግን!",
        "speak": "ናይ ዝርከብ",
        "more": "ተመዝገብ እዩ",
        "play": "ናይ ግዜ / ክበር"
    ],
    "tk": [
        "reset": "Taze Sessiýa",
        "tapToSpeak": "Aýdym etmek üçin Bas",
        "surprise": "Meni Görk!",
        "speak": "Basyp Ýum",
        "more": "Dowamly äs",
        "play": "Durdur / Oýna"
    ],
    "tl": [
        "reset": "Bagong Session",
        "tapToSpeak": "I-tap Upang Magsalita",
        "surprise": "I-Surpresa Ako!",
        "speak": "I-tap at I-hold",
        "more": "Karagdagang Mga Aksyon",
        "play": "Itigil / I-play"
    ],
    "tn": [
        "reset": "Sesishini Esha",
        "tapToSpeak": "Hlasa Ukuthumelela",
        "surprise": "Sekukhuthaze!",
        "speak": "Hlasa futhi Vikezela",
        "more": "Imisebenzi Eningi",
        "play": "Ukupuma / Ukudlala"
    ],
    "to": [
        "reset": "ʻOtuhaka Hou",
        "tapToSpeak": "Lomi Ke Fai Ke Manatu",
        "surprise": "ʻOtuʻu Kihe Meʻa!",
        "speak": "Lomi Pea Ho",
        "more": "Faingataʻa Hake",
        "play": "ʻUngo / Fai"
    ],
    "tr": [
        "reset": "Yeni Oturum",
        "tapToSpeak": "Konuşmak İçin Dokun",
        "surprise": "Şaşırt Beni!",
        "speak": "Dokun ve Tut",
        "more": "Daha Fazla Eylem",
        "play": "Durdur / Oyna"
    ],
    "ts": [
        "reset": "Ntlhontšo Ea Moea",
        "tapToSpeak": "Lapa Ho Șea",
        "surprise": "Nka Boile!",
        "speak": "Hlapa Le Ho Lefa",
        "more": "Tšepe E Tla Di Hlōka",
        "play": "Hlōka / Di Hlōka"
    ],
    "tt": [
        "reset": "Yaña Ğalım",
        "tapToSpeak": "Tatıq Tavır İtele",
        "surprise": "Minı Sawıla!",
        "speak": "Tatıq İtele",
        "more": "Äfäsçıq Bul",
        "play": "Sawma / Yıqrı"
    ],
    "tw": [
        "reset": "Nkɔmbɔ Nkeka",
        "tapToSpeak": "Suo Firi Kasa",
        "surprise": "Akye M'ase!",
        "speak": "Suo Firi Na Nnyɛ",
        "more": "Nsu Me",
        "play": "Nnyɛ / Ma"
    ],
    "ty": [
        "reset": "Session Nouvelle",
        "tapToSpeak": "Toucher pour Parler",
        "surprise": "Surprends-moi!",
        "speak": "Appuyer et Maintenir",
        "more": "Plus d'Actions",
        "play": "Arrêter / Jouer"
    ],
    "ug": [
        "reset": "يېڭى سىستېما",
        "tapToSpeak": "سۆز قىلىش ۋاسىتىسى",
        "surprise": "مەنى سورپىزلى!",
        "speak": "باسقىچ ۋە توت",
        "more": "تۆۋەندىكى ۋەزىپەلىر",
        "play": "توقتاش / ئويناش"
    ],
    "uk": [
        "reset": "Нова Сесія",
        "tapToSpeak": "Клацніть, щоб Говорити",
        "surprise": "Здивуй Мене!",
        "speak": "Натисніть і Тримайте",
        "more": "Більше Дій",
        "play": "Зупинити / Грати"
    ],
    "ur": [
        "reset": "نیا سیشن",
        "tapToSpeak": "بولنے کے لئے ٹیپ کریں",
        "surprise": "مجھے حیران کریں!",
        "speak": "ٹپ کریں اور رکھیں",
        "more": "مزید کارروائیاں",
        "play": "رکوائی / کھیلو"
    ],
    "uz": [
        "reset": "Yangi Seans",
        "tapToSpeak": "Gaplashish uchun bosing",
        "surprise": "Meni taajjub qil!",
        "speak": "Bosing va tuting",
        "more": "Ko'proq Harakatlar",
        "play": "To'xtatish / O'ynatish"
    ],
    "ve": [
        "reset": "Ricila Uṱḓeni",
        "tapToSpeak": "Husa uyo ṋeyela",
        "surprise": "Lugadzama!",
        "speak": "Yoḓa uyo ḓeya",
        "more": "Zwidodo Zwine",
        "play": "Fhadza / Tshimbila"
    ],
    "vi": [
        "reset": "Thiết Lập Mới",
        "tapToSpeak": "Chạm Để Nói",
        "surprise": "Làm Bất Ngờ Tôi!",
        "speak": "Chạm Và Giữ",
        "more": "Thêm Tác Vụ",
        "play": "Dừng / Phát"
    ],
    "vo": [
        "reset": "Novi Sekvos",
        "tapToSpeak": "Klikön Plo Tefön",
        "surprise": "Pleasami!",
        "speak": "Klikön e Tenu",
        "more": "Plu Veiks",
        "play": "Stopön / Plöyön"
    ],
    "wa": [
        "reset": "Noûvele Sessi",
        "tapToSpeak": "Touké po Parler",
        "surprise": "Stirez-m'!",
        "speak": "Touké et Tén",
        "more": "D'Ziès A L' Mode",
        "play": "Arèster / Djouwer"
    ],
    "wo": [
        "reset": "Noppin Wër",
        "tapToSpeak": "Noppin Leer",
        "surprise": "Loxo Ma!",
        "speak": "Noppin & Luñ",
        "more": "Luñ Jëfandikat",
        "play": "Sumbel / Nopp"
    ],
    "xh": [
        "reset": "Sesha Entsatsi",
        "tapToSpeak": "Qhusela Ukuthetha",
        "surprise": "Dlisa Undiphethe!",
        "speak": "Qhusela Futhi Qhaphela",
        "more": "Izinto Ezingaphezu",
        "play": "Dala / Dlala"
    ],
    "yi": [
        "reset": "נייַע סעסיע",
        "tapToSpeak": "טאַץ אום צו רעדן",
        "surprise": "וואַנדער מיך!",
        "speak": "טאַץ און האַלטן",
        "more": "מער אַקציעס",
        "play": "האַלטן / שפּילן"
    ],
    "yo": [
        "reset": "Tun Tọwọ Nọyẹ",
        "tapToSpeak": "Tun Lọ Lọ",
        "surprise": "Rọ Daju!",
        "speak": "Tun Lọ ati Gba",
        "more": "Nọmbẹ Kọkọkan",
        "play": "Tun / Se Gbo"
    ],
    "za": [
        "reset": "Xeuhdouh Nyeuz Gyoq",
        "tapToSpeak": "Giexm Ziqq Hnyiq",
        "surprise": "Xyozq Mez Yeuq!",
        "speak": "Giexm Ziqq Hnyiq",
        "more": "Dauhgyauh Yeuq",
        "play": "Lwuoq / Lwouz"
    ],
    "zh": [
        "reset": "新会话",
        "tapToSpeak": "触摸以发言",
        "surprise": "给我一个惊喜！",
        "speak": "触摸并保持",
        "more": "更多操作",
        "play": "停止/播放"
    ],
    "zu": [
        "reset": "Setha Okuthile",
        "tapToSpeak": "Thatha Ukukhuluma",
        "surprise": "Ngicabange!",
        "speak": "Thatha Futhi Vikezele",
        "more": "Okuningi Amakhasi",
        "play": "Dala / Dlala"
    ]
]
