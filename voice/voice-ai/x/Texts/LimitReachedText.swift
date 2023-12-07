import Foundation

//func getLimitReachedText(for languageCode: String) -> String? {
//    return limitReachedText[languageCode]
//}

let limitReachedText: [String: String] = [
    "aa": "Qof walba wuxuu gaaray go'aankaaga, fadlan sug 10 daqiiqo",
    "ab": "Агәжгәлқәой ихналажыу, 10 минуты рыхьыгъуа",
    "ae": "𐎠𐎰𐎢𐎴 𐎴𐎶𐎦𐎡𐎲𐎢𐎠 𐎺𐏍𐏓 𐎶𐏃𐎢𐎼𐎴𐎠, 𐎶𐎡𐎯𐎠𐎢 𐎦𐏂𐎶𐎠 𐎡𐏂𐎦𐏐𐎡𐎡𐏂𐏁𐎠",
    "af": "Jy het jou limiet bereik, wag asseblief 10 minute",
    "ak": "Woama woatumi amane, mesrɛ wo mpɔn 10 minute",
    "am": "ከባቢያ የሚቆጠር ነገር ነሽ, እባክህ 10 ደቂቃ ጠብቀኸው",
    "an": "Has aplegau o límit d'usura, aguaita 10 minutas",
    "ar": "لقد وصلت إلى حدك، يرجى الانتظار 10 دقائق",
    "as": "আপোনি আপোনাৰ সীমা পৰা যাওঁছে, অনুগ্ৰহ কৰি 10 মিনিটৰ বাবে বাখিৱা দি",
    "av": "Чечимаш къуларкӀан 10 минута паца истигъларгӀа, къан 10 минута истин гӀанкъалур",
    "ay": "Janiw ukhamaru phanqayxa jupampi, qillqanxa 10 munitu",
    "az": "Siz limitinizə çatmısınız, xahiş edirik 10 dəqiqə gözləyin",
    "ba": "Сез һиҡ йис калауҙа, итеге 10 минут күтегеҙ һалыҡ",
    "be": "Вы дасягнулі свайго ліміту, калі ласка, пачакайце 10 хвілін",
    "bg": "Достигнахте вашия лимит, моля, изчакайте 10 минути",
    "bi": "Yufala i talem oli limit, plis wait 10 minit",
    "bm": "Moo nni yaɓɓe makun damni, tunayol 10 minti",
    "bn": "আপনি আপনার সীমা পৌঁছেছেন, দয়া করে 10 মিনিট অপেক্ষা করুন",
    "bo": "ཁྱོད་ཚང་གིས་ཡོང་བསྡུ་ནས་དང་པོ་གཅིག་འཚོ་, སློབ་མ 10 སྐར་ཚན་བར་རེ་འཆག་ཡོད་པ།",
    "br": "D'ar c'hentañ e tleoc'h, gortozit 10 munutenn",
    "bs": "Dosegli ste svoj limit, molim vas sačekajte 10 minuta",
    "ca": "Heu arribat al vostre límit, si us plau, espereu 10 minuts",
    "ce": "Хьажгаар оццалла, товаарш 10 минуташ гочушакха",
    "ch": "Ha'alal la mechas limit-mu, fa'pos finatto 10 minutos",
    "co": "Avete raggiunto u vostru limete, per piacè, aspettate 10 minuti",
    "cr": "Ni wîcewâsahihikoyahk, kîspin 10 minit",
    "cs": "Dosáhli jste svého limitu, prosím, počkejte 10 minut",
    "cu": "Истиглъ еси краѥ нашъ, подажди десѧть минутъ",
    "cv": "Чĕтрен чăччи пушкан чухав хут тух паллӑш",
    "cy": "Rydych chi wedi cyrraedd eich terfyn, aroswch 10 munud",
    "da": "Du har nået din grænse, vent venligst 10 minutter",
    "de": "Sie haben Ihr Limit erreicht, bitte warten Sie 10 Minuten",
    "dv": "މިއީށުންއަތް ފުޅުލެއަކަށް މިނިދަ 10 މިނުކަތް ކޮޕީ",
    "dz": "ཁྱུང་ཁྲམ་དུ་རྩོམ་འཚོ་, 10 སྐར་ཚན་འགུང་",
    "ee": "Nehi wo yagbee korla, 10 minitewo ka yi ɖe dzi",
    "el": "Έχετε φτάσει το όριό σας, παρακαλώ περιμένετε 10 λεπτά",
    "en": "You have reached your limit, please wait 10 minutes",
    "eo": "Vi atingis vian limon, bonvolu atendi 10 minutojn",
    "es": "Has alcanzado tu límite, por favor, espera 10 minutos",
    "et": "Olete jõudnud oma piirini, palun oodake 10 minutit",
    "eu": "Lortu duzu mugara, itxaron 10 minutu",
    "fa": "شما به محدودیت خود رسیده‌اید، لطفاً ۱۰ دقیقه صبر کنید",
    "ff": "Ndankoo gaa fi, taw horee benn 10 minit",
    "fi": "Olet saavuttanut rajasi, odota 10 minuuttia",
    "fj": "O sa yaco ga vei iko, vakacegu 10 miniti",
    "fo": "Tú hevur náað tína mørku, vænta væl 10 minuttir",
    "fr": "Vous avez atteint votre limite, veuillez patienter 10 minutes",
    "fy": "Jo binne jo grins berikt, wachtsje 10 minuten",
    "ga": "Tá tú tarraing do teorainn, fan le do thoil 10 nóiméad",
    "gd": "Thàinig thu gu d'ionnsuidh, thoiridh 10 mionaid",
    "gl": "Alcanzou o seu límite, agarde 10 minutos",
    "gn": "Jepokône mba'e he'i ha'u, porã 10 minutos",
    "gu": "તમે તમારી મર્યાદા મુકી લીધી છો, મુકાબલે 10 મિનિટ રહો",
    "gv": "T'eh er ny smoo currit, cur-yn-geayrt 10 minnid",
    "ha": "Ka yi kowa ku koma, don Allah buga minti 10",
    "he": "הגעת למגבלתך, אנא המתן 10 דקות",
    "hi": "आपने अपनी सीमा तक पहुँच गए हैं, कृपया 10 मिनट इंतजार करें",
    "ho": "Lomu kwai mwariwari gure, roka 10 mitimiti",
    "hr": "Dosegli ste svoj limit, molim vas sačekajte 10 minuta",
    "ht": "Ou rive nan limit ou, tanpri tann 10 minit",
    "hu": "Elérted a limitet, kérlek várj 10 percet",
    "hy": "Դուք հասեցիք ձեր սահմանը, խնդրում եմ սպասեք 10 րոպե",
    "hz": "Ongwoka omombura unene, tateka okondjatu 10.",
    "ia": "Tu ha attingite tu limite, attende 10 minutas",
    "id": "Anda telah mencapai batas Anda, harap tunggu 10 menit",
    "ie": "Tu have atingit to limite, plu attende 10 minutas",
    "ig": "Ị na-achị mma ịrụ ọrụ gị, biko wepụtara 10 nkeji",
    "ii": "ꎹꆯꋪꉙꀸ, ꎭꎵꆛꄷꋌꉛ 10 ꂱ",
    "ik": "Qavalunauqsisima qanipiallaallru, 10 nalliiniakuni",
    "io": "Vu atenis to limo, plea attendar 10 minutulo",
    "is": "Þú hefur náð þínu takmörkuðu, bíddu í 10 mínútur",
    "it": "Hai raggiunto il tuo limite, attendi 10 minuti",
    "iu": "ᑲᓇᑦᑐᖅᑕᐅᓯᒪ ᑭᓇᓕᒐᖅ, ᑲᓴᑉᐸᑦ 10 ᓴᑦᑐᖅ",
    "ja": "制限に達しました、10分お待ちください",
    "jv": "Sampeyan wis nyampe limit sampeyan, monggo nunggu 10 menit",
    "ka": "თქვენ მიაღწევენ თქვენი ლიმიტი, გთხოვთ, დაიცვათ 10 წუთი",
    "kg": "Monyɔngaɔ onwumela owu, nyɛ 10 minit",
    "ki": "Ũngirũhana aturute gukira, wendo 10 meneti",
    "kj": "Ū nā chi ɖu e, biko jiri 10 nísa",
    "kk": "Сіз жоғалып табылдыңыз, 10 минут күтіңіз",
    "kl": "Allanngorpoq qanoq ilimillu, oqaatigisimmi 10 minutsit",
    "km": "អ្នកបានដាក់កន្លែងខ្លះរួចហើយ, សូមរង់ចាំ 10 នាទី",
    "kn": "ನೀವು ನಿಮ್ಮ ಹಿಗ್ಗಿದ ಮಿತಿಗೆ ಬಂದಿದ್ದೀರಿ, ದಯವಿಟ್ಟು 10 ನಿಮಿಷ ಕಾಯುತ್ತೀರಿ",
    "ko": "제한에 도달했습니다, 10 분 기다려주세요",
    "kr": "O na ejọ mmadụ gị, biko welitere 10 nọta",
    "ks": "توهاڑ سیمہ بٹھگیا، براہ کرم 10 منٹوں تک انتظار کریں",
    "ku": "Hûn sînorê xwe yê asta me, ji kerema xwe biçûke 10 deqîqeyan",
    "kv": "Восков эшты кесем, мияськаш 10 минут",
    "kw": "A's dha welledhasowgh orth dhe vos dhewlagas, orth dhe wul 10 mynysen",
    "ky": "Сиз жеткиликке жеттіңіз, 10 минут күтіңіз",
    "la": "Tu ad limitum pervenisti, decem minutos exspecta",
    "lb": "Dir sidd un Ärregrenz, waard 10 Minutten",
    "lg": "Ojja kufikira mu lukalala lwo, gya linya 10",
    "li": "Gesjaf dien grens bereik, wach 10 minute",
    "ln": "Bamɛi ko teyaki bɔngɔ na yo, tosali 10 minute",
    "lo": "ທ່ານໄດ້ການຂຽນຄົນແຈ່ນ, ກະລຸນາຖ້າ 10 ນາທີ",
    "lt": "Jūs pasiekėte savo ribą, palaukite 10 minučių",
    "lu": "Bana bakobela ebele, bualo 10 mwinu",
    "lv": "Jūs esat sasniedzis savu robežu, lūdzu, uzgaidiet 10 minūtes",
    "mg": "Efa nahazoana ny fivoahanao, aza hadino 10 minitra",
    "mh": "Elikkar nan aer ruwe, kajin 10 meniit",
    "mi": "I tae koe ki to rātou whāinga, whakarongo 10 meneti",
    "mk": "Го постигнавте вашиот лимит, ве молам почекајте 10 минути",
    "ml": "നിനക്ക് നിന്നെത്തിച്ചിരിക്കുക, 10 മിനിറ്റ് കാത്തിരിക്കുക",
    "mn": "Та таны хязгаарлалаа хүртэл хүрсэн байна, 10 минут хүлээн авч үйлчилнэ үү",
    "mr": "तुम्हाला तुमच्या मर्यादेत पोहोचल्याचं आहे, कृपया 10 मिनिट थांबा",
    "ms": "Anda telah mencapai had anda, sila tunggu 10 minit",
    "mt": "Inti laħaq it-limitu tiegħek, jekk jogħġbok stenna 10 minuti",
    "my": "သင့်ရဲ့အက္ခရာကိုတွင် ရှာရန်ကျန်နှုန်း 10 မိနစ်ကြာနိုင်ပါ",
    "na": "Koe auno lo adai gigo, laung 10 minut",
    "nb": "Du har nådd grensen din, vent 10 minutter",
    "nd": "Ufikile kuqala kwakho, sicela umsindo we-10 imizuzwana",
    "ne": "तपाईंले आफ्नो सीमा पुग्यौं, कृपया 10 मिनेट पुर्खाउनुहोस्",
    "ng": "I ṅwekdedekwani e we, ahara 10 tekitan",
    "nl": "Je hebt je limiet bereikt, wacht alsjeblieft 10 minuten",
    "nn": "Du har nådd grensen din, vent 10 minutter",
    "no": "Du har nådd grensen din, vent 10 minutter",
    "nr": "Ufikile kuqala kwakho, sicela umsindo we-10 imizuzwana",
    "nv": "Áádóó nanááná, nihinéézóó bee 10 daaztsaaz dah",
    "ny": "Mulandireni kukoma, chonde linyoza masiku atatu",
    "oc": "Avètz arribat a la vòstra limita, esperatz 10 minutas",
    "oj": "Niin endaayaa wayiinyaan, jibwaa 10 zhagaa",
    "om": "Kana irratti raawwatu, fuula 10 daqiiqaa",
    "or": "ଆପଣ ଆପଣଙ୍କ ସୀମା ପାଇଁ ପହଞ୍ଚିଛନ୍ତି, ଦୟାକରି 10 ମିନିଟ ଅପେକ୍ଷା କରନ୍ତୁ",
    "os": "Фӕртыххы буас дыхуылъёг, 10 минуты фыстындырын",
    "pa": "ਤੁਸੀਂ ਆਪਣੇ ਸੀਮਾ ਤੱਕ ਪਹੁੰਚ ਗਏ ਹੋ, ਕਿਰਪਾ ਕਰਕੇ 10 ਮਿੰਟ ਰੁਕੋ",
    "pi": "अभिवादयि ज्ज्हान्तु तत्त्वं, तुणि 10 मिणिट थाह्याः",
    "pl": "Osiągnąłeś swoje ograniczenie, poczekaj 10 minut",
    "ps": "تاسو د سيمه ته رسۍ، 10 دقیقې تر انتظار وکړئ",
    "pt": "Você atingiu seu limite, aguarde 10 minutos",
    "qu": "Anchaqmi qanmi ñuqaqa, tukuy 10 minutu",
    "rm": "Vus hai attegnì vus limit, paita 10 minutas",
    "rn": "Mukunda iyi niba ushoboye, subiza iminota 10",
    "ro": "Ai atins limita, așteaptă 10 minute",
    "ru": "Вы достигли свой предел, подождите 10 минут",
    "rw": "Mwahuye ku bupiganwa bwanyu, subira iminota 10",
    "sa": "आपत्सु सीमा प्राप्ता, कृपया 10 मिनट अपेक्षा करें।",
    "sc": "Asatzus ispigatzos est itzis, cumprendhe 10 minutos.",
    "sd": "توهان جو حد ڪيو ويو آهيو، 10 منٽ انتظار ڪريو",
    "se": "Leat oaidnán do oidnemii, rávket 10 minuhtat",
    "sg": "M'atáá o fê, múfu 10 mḿnûû",
    "si": "ඔබ ඔබේ සීමා සඳහා එය ලබා ඇත, 10 මිනිත්තු මංකොල්ලා කරන්න",
    "sk": "Dosiahli ste svoj limit, počkajte 10 minút",
    "sl": "Dosegli ste svojo mejo, počakajte 10 minut",
    "sm": "Uo te teuteu, fa'amolemole avea 10 miniti",
    "sn": "Ndakugadzirwa maitiro ako, bvisa 10 kaviri",
    "so": "Waad gaadhay limitkaada, fadlan sug 10 daqiiqo",
    "sq": "Keni arritur kufirin tuaj, ju lutem prisni 10 minuta",
    "sr": "Достигли сте своју границу, сачекајте 10 минута",
    "ss": "Ufunile ezilimini zakho, sicela 10 imizuzu",
    "st": "Uo o ntshitse leoto la hau, ka kopo bophara ba 10",
    "su": "Nu ti heunteu, mangga 10 menit nunggu",
    "sv": "Du har nått din gräns, vänta 10 minuter",
    "sw": "Umeifikia kikomo chako, tafadhali subiri dakika 10",
    "ta": "உங்கள் வரம்பை அடைந்துவிட்டீர்கள், 10 நிமிடம் காத்திருங்கள்",
    "te": "మీరు మీ పరిమితిని చేసుకున్నారు, దయచేసి 10 నిమిషాలు ఎదురుచూయుండండి",
    "tg": "Шумо до ҳудуди худ расидед, лутфан 10 дақиқа интизор кунед",
    "th": "คุณได้ถึงขีดจำกัดของคุณ โปรดรอ 10 นาที",
    "ti": "እዚ መድሊድኡ ንዝኽሪ ይትግብር 10 ደቂቕ።",
    "tk": "Siz tälimiňize çenli yetiňiz, 10 minut goşup beýjaň",
    "tl": "Nakapagtatapos ka na sa iyong limitasyon, maghintay ng 10 minuto",
    "tn": "Ufunile ezokwenza izinto zakho, sicela uqale 10 amaminithi",
    "to": "ʻU fika ʻi hono mafola, fakataha ʻe 10 miniti",
    "tr": "Sınıra ulaştınız, lütfen 10 dakika bekleyin",
    "ts": "Uo hlawulekisa xikongomelo xa wena, ndza tiva 10 ndzimana",
    "tt": "Сезгә калаучыныз, 10 минут күтеп биткән булсын",
    "tw": "Wɔgye wo nkɔso mu, mesrɛ wo mpɔn 10 minutes.",
    "ty": "Ua pau to rahi o te taime e tae mai ia teie nei, faatupu atu i te 10 miniti.",
    "ug": "سىز چېتىدىڭىزنى چېقىشتىن كېيىن 10 مىنۇتتىكى كۈتەيملىككە بارىڭ",
    "uk": "Ви досягли свого ліміту, будь ласка, зачекайте 10 хвилин",
    "ur": "آپ نے اپنی حد تک پہنچ گئے ہیں، براہ کرم 10 منٹ کا انتظار کریں",
    "uz": "Сиз чегирасиз, илтимос, 10 дақиқани кутиб туринг",
    "ve": "U vha vhonani u shumelela u siama, tshi khou itela 10 ndila.",
    "vi": "Bạn đã đạt đến giới hạn, vui lòng đợi 10 phút",
    "vo": "O yu nüno lefi, please ten bosi 10 minutes.",
    "wa": "Vos avoz atinde vostre limite, s'î vous plait, atindez 10 minutes.",
    "wo": "Nopp na xale yi melni, nopp na neen 10 munite.",
    "xh": "Ubonisa uluhla lwakho, qhubeka uqale izikhathi ezilishumi",
    "yi": "איר האט גערייכט פֿאַרן לימיט, ביטע ווארטן 10 מינוטן",
    "yo": "Ọ ti ṣiṣẹtọ fún rẹ, jọwọ pe le 10 ogo",
    "za": "Hnyangz duxtuiqj whaengh namj, veijsiengh nyeixl 10 cinz.",
    "zh": "您已达到上限，请等待10分钟",
    "zu": "Ubonisa uluhla lwakho, sicela uqale izikhathi ezilishumi"
]
