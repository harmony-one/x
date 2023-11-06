import AVFoundation
import Combine
import Speech

protocol SpeechRecognitionProtocol {
    func reset()
    func reset(feedback: Bool?)
    func randomFacts()
    func isPaused() -> Bool
    func continueSpeech()
    func pause(feedback: Bool?)
    func repeate()
    func speak()
    func stopSpeak()
}

extension SpeechRecognitionProtocol {
    func reset() {
        reset(feedback: true)
    }
    
    func pause() {
        pause(feedback: true)
    }
}

class SpeechRecognition: NSObject, ObservableObject, SpeechRecognitionProtocol {
    // MARK: - Properties
    
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    private var messageInRecongnition = ""
    private let recognitionLock = DispatchSemaphore(value: 1)
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var isAudioSessionSetup = false
    var audioSession: AVAudioSessionProtocol = AVAudioSessionWrapper()
    let textToSpeechConverter = TextToSpeechConverter()
    static let shared = SpeechRecognition()
    
    private var speechDelimitingPunctuations = [Character("."), Character("?"), Character("!"), Character(","), Character("-"), Character(";")]
   
    var pendingOpenAIStream: OpenAIStreamService?
    
    private var conversation: [Message] = []
    private let greetingText = "Hey!"

    // TODO: to be used later to distinguish didFinish event triggered by greeting v.s. others
    //    private var isGreatingFinished = false
    
    private let audioPlayer = AudioPlayer()
    
    private var isRequestingOpenAI = false
    private var requestInitiatedTimestamp: Int64 = 0
    
    private var resumeListeningTimer: Timer? = nil
//    private var silenceTimer: Timer?
    private var isCapturing = false
    
    @Published private var _isPaused = false
    var isPausedPublisher: Published<Bool>.Publisher {
        $_isPaused
    }
    
    @Published private var _isPlaying = false
    var isPlaingPublisher: Published<Bool>.Publisher {
        $_isPlaying
    }
    
    private var isPlayingWorkItem: DispatchWorkItem?
        
    // Current message being processed
        
    // MARK: - Initialization and Setup

    func setup() {
        checkPermissionsAndSetupAudio()
        textToSpeechConverter.convertTextToSpeech(text: greetingText)
        isCapturing = true
//        startSpeechRecognition()
    }
    
    private func checkPermissionsAndSetupAudio() {
        Permission().setup()
        registerTTS()
        setupAudioSession()
        setupAudioEngine()
    }
    
    // MARK: - Audio Session Management

     func setupAudioSession() {
        guard !isAudioSessionSetup else { return }
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            isAudioSessionSetup = true
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
    }
    
    // Function to setup the audio engine
    func setupAudioEngine() {
        if !audioEngine.isRunning {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                print("Error setting up audio engine: \(error.localizedDescription)")
            }
        }
    }
    
    // Internal getter for audioEngine
    internal func getAudioEngine() -> AVAudioEngine {
        return audioEngine
    }
    
    internal func getISAudioSessionSetup() -> Bool {
        return isAudioSessionSetup
    }
    
    // MARK: - Speech Recognition
    
    func startSpeechRecognition() {
        print("[SpeechRecognition][startSpeechRecognition]")
        
        setupAudioSession()
        cleanupRecognition()
        
        let inputNode = audioEngine.inputNode
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.shouldReportPartialResults = true
        handleRecognition(inputNode: inputNode)
    }
    
    private func handleRecognition(inputNode: AVAudioNode) {
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            guard let result = result else {
                self.handleRecognitionError(error)
                return
            }
            
            let message = result.bestTranscription.formattedString
            print("[SpeechRecognition][handleRecognition] \(message)")
            print("[SpeechRecognition][handleRecognition] isFinal: \(result.isFinal)")
            
            if !message.isEmpty {
                self.recognitionLock.wait()
                self.messageInRecongnition = message
                self.recognitionLock.signal()
            }
            // isFinal does not work mid-speech. See https://stackoverflow.com/a/42925643/1179349
            // Note: not using this. Instead, use stopSpeak() to trigger finalization instead
//            if result.isFinal {
//                self.recognitionLock.wait()
//                let message = self.messageInRecongnition
//                self.messageInRecongnition = ""
//                self.recognitionLock.signal()
//                self.handleFinalRecognition(inputNode: inputNode, message: message)
//            }
            
//            self.silenceTimer?.invalidate()
//            self.silenceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
//                if !message.isEmpty {
//                    self.handleFinalRecognition(inputNode: inputNode, message: message)
//                }
//            }
        }
    
        installTapAndStartEngine(inputNode: inputNode)
    }
    
    private func handleRecognitionError(_ error: Error?) {
        if let error = error {
            print("[SpeechRecognition][handleRecognitionError][ERROR]: \(error)")
            let nsError = error as NSError
            if nsError.domain == "kAFAssistantErrorDomain" && nsError.code == 1110 {
                print("No speech was detected. Please speak again.")
                // Notify the user in a suitable manner, possibly with UI updates or a popup.
                return
            }
            // General cleanup process
            let inputNode = audioEngine.inputNode
            inputNode.removeTap(onBus: 0)
            recognitionRequest = nil
            recognitionTask = nil
        }
    }
    
    // TODO: remove
//    private func handleFinalRecognition(inputNode: AVAudioNode, message: String) {
    ////        inputNode.removeTap(onBus: 0)
    ////        recognitionRequest = nil
    ////        recognitionTask = nil
//        if !message.isEmpty {
//            makeQuery(message)
//        }
//    }
    
    private func installTapAndStartEngine(inputNode: AVAudioNode) {
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        do {
            audioEngine.prepare()
            try audioEngine.start()
            print("[SpeechRecognition] Audio engine started")
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }
    }
    
    func getCurrentTimestamp() -> Int64 {
        return Int64(NSDate().timeIntervalSince1970 * 1000)
    }
    
    func makeQuery(_ text: String) {
        if isRequestingOpenAI {
            return
        }
        var completeResponse = [String]()
        var buf = [String]()
        
        func flushBuf() {
            let response = buf.joined()
            guard !response.isEmpty else {
                return
            }
            
            registerTTS()
            textToSpeechConverter.convertTextToSpeech(text: response)
            
            completeResponse.append(response)
            print("[SpeechRecognition] flush response: \(response)")
            buf.removeAll()
        }
        
        if conversation.count == 0 {
            conversation.append(contentsOf: OpenAIStreamService.setConversationContext())
        }
        
        print("[SpeechRecognition] query: \(text)")
        
        conversation.append(Message(role: "user", content: text))
        requestInitiatedTimestamp = self.getCurrentTimestamp()
        
        audioPlayer.playSound()
        pauseCapturing()
        isRequestingOpenAI = true
        
        // Initial Flush to reduce perceived latency
//        var initialFlush = false
        let boundLength = 10
        var currWord = ""
        
        pendingOpenAIStream = OpenAIStreamService { res, err in
            guard err == nil else {
                let nsError = err! as NSError
                self.isRequestingOpenAI = false
                if nsError.code == -999 {
                    print("[SpeechRecognition] OpenAI Cancelled")
                    return
                }
                print("[SpeechRecognition] OpenAI error: \(nsError)")
                buf.removeAll()
                self.registerTTS()
                self.textToSpeechConverter.convertTextToSpeech(text: "Oh, my neuron network ran into an error. Can you try again?")
                return
            }
            
            guard let res = res else {
                return
            }
            
            if res == "[DONE]" {
                buf.append(currWord)
                flushBuf()
                self.isRequestingOpenAI = false
                print("[SpeechRecognition] OpenAI Response Complete")
                print("[SpeechRecognition] Complete Response text", completeResponse.joined())
                if !completeResponse.isEmpty {
                    self.conversation.append(Message(role: "assistant", content: completeResponse.joined()))
                }
                return
            }
            
            print("[SpeechRecognition] OpenAI Response received: \(res)")
            
            // Append received streams to currWord instead of buf directly
            if res.first == " " {
                buf.append(currWord)
                
                // buf should only contain complete words
                // ensure streams that do not have a whitespace in front are appended to the previous one (part of the previous stream)
                if self.speechDelimitingPunctuations.contains(currWord.last!) || buf.count == boundLength {
                    flushBuf()
                }
                
                currWord = res
                guard res.last != nil else {
                    return
                }
                
            } else {
                currWord.append(res)
            }
        }
        pendingOpenAIStream?.query(conversation: conversation)
    }
    
    func pauseCapturing() {
        guard isCapturing else {
            return
        }
        isCapturing = false
        print("[SpeechRecognition][pauseCapturing]")
        recognitionTask?.finish()
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest?.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
    }
    
    func resumeCapturing() {
        guard !isCapturing else {
            return
        }
        isCapturing = true
        print("[SpeechRecognition][resumeCapturing]")
        setupAudioSession()
        setupAudioEngine()
        startSpeechRecognition()
    }
    
    func registerTTS() {
        if textToSpeechConverter.synthesizer.delegate == nil {
            textToSpeechConverter.synthesizer.delegate = self
        }
    }
    
    func reset(feedback: Bool? = true) {
        print("[SpeechRecognition][reset]")
        
        // Perform all UI updates on the main thread
        DispatchQueue.main.async {
            self.textToSpeechConverter.stopSpeech()
            self._isPaused = false
            self.conversation.removeAll()
        }
        
        // Perform all cleanup tasks in the background
        DispatchQueue.global(qos: .userInitiated).async {
            self.pauseCapturing()
            self.stopGPT()
            
            // No need to reset the audio session if you're going to set it up again immediately after
            // self.isAudioSessionSetup = false
            
            // Call these setup functions only if they are necessary. If they are not changing state, you don't need to call them.
            self.setupAudioSession()
            self.setupAudioEngineIfNeeded()
            
            // If TTS needs to be registered again, do it in the background
            self.registerTTS()
            
            DispatchQueue.main.async {
                if feedback == true{
                    // Play the greeting text
                    self.textToSpeechConverter.convertTextToSpeech(text: self.greetingText)
                }
            }
        }
    }

    func setupAudioEngineIfNeeded() {
        guard !audioEngine.isRunning else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            // Only start the audio engine if it's not already running
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print("Error setting up audio engine: \(error.localizedDescription)")
        }
    }


    private func stopGPT() {
        pendingOpenAIStream?.cancelOpenAICall()
        pendingOpenAIStream = nil
        audioPlayer.stopSound()
    }
    
    private func cleanupRecognition() {
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest?.endAudio()
    }
    
    func isPaused() -> Bool {
        return _isPaused
    }
    
    func isPlaying() -> Bool {
        return _isPlaying
    }
    
    func pause(feedback: Bool? = true) {
        print("[SpeechRecognition][pause]")
        
        if textToSpeechConverter.synthesizer.isSpeaking {
            _isPaused = true
            textToSpeechConverter.pauseSpeech()
        } else {
            if !isRequestingOpenAI && feedback! {
                audioPlayer.playSound(false)
            }
        }
    }
    
    func continueSpeech() {
        print("[SpeechRecognition][continueSpeech]")
        
        if textToSpeechConverter.synthesizer.isSpeaking {
            _isPaused = false
            textToSpeechConverter.continueSpeech()
        } else {
            if !isRequestingOpenAI {
                audioPlayer.playSound(false)
            }
        }
    }
    
    func randomFacts() {
        print("[SpeechRecognition][randomFacts]")
        stopGPT()
        textToSpeechConverter.stopSpeech()
        _isPaused = false
        let topArticles = ["123Movies","1917 (2019 film)","2000 United States presidential election","2003 invasion of Iraq","2004 Indian Ocean earthquake and tsunami","2004 United States presidential election","2008 United States presidential election","2009 flu pandemic","2010 FIFA World Cup","2011 Tōhoku earthquake and tsunami","2012 Summer Olympics","2012 United States presidential election","2014 FIFA World Cup","2016 Summer Olympics","2016 United States presidential election","2018 FIFA World Cup","2019–20 Wuhan coronavirus outbreak","2019–20 coronavirus outbreak","2019–20 coronavirus pandemic","2019–20 coronavirus pandemic by country and territory","2020 Democratic Party presidential primaries","2020 Formula One World Championship","2020 NFL Draft","2020 Summer Olympics","2020 United States presidential election","2020 coronavirus pandemic in India","2020 coronavirus pandemic in Italy","2020 coronavirus pandemic in the United States","2021 Formula One World Championship","2021 ICC Men's T20 World Cup","2021 West Bengal Legislative Assembly election","2021 in film","2021 storming of the United States Capitol","2021–22 UEFA Champions League","2022 FIFA World Cup","2022 FIFA World Cup qualification","2022 Russian invasion of Ukraine","365 Days (2020 film)","6ix9ine","87th Academy Awards","92nd Academy Awards","93rd Academy Awards","A Brief History of Time","A Game of Thrones","A Quiet Place Part II","A Song of Ice and Fire","A.C. Milan","ABBA","AC/DC","Aaliyah","Aaron Burr","Aaron Hernandez","Aaron Rodgers","Abraham","Abraham Lincoln","Academy Awards","Adam Driver","Adam Sandler","Adele","Adolf Hitler","Afghanistan","Africa","Al Capone","Al Pacino","Albert Einstein","Albus Dumbledore","Alec Baldwin","Alex Trebek","Alexander Hamilton","Alexander the Great","Alexandria Ocasio-Cortez","Alfred the Great","Alice's Adventures in Wonderland","Alpha Centauri","Amazon (company)","Amazon River","Amber Heard","American Civil War","American Horror Story","American Revolutionary War","Americas","Among Us","Amy Coney Barrett","Ana de Armas","Andhra Pradesh","Andrew Cuomo","Andrew Garfield","Android (operating system)","Andromeda Galaxy","Angelina Jolie","Animal","Animal Farm","Anne Heche","Anne, Princess Royal","Ansel Adams","Antarctica","Anthony Bourdain","Anthony Fauci","Antifa (United States)","Anya Taylor-Joy","Apollo","Apple","Apple Inc.","Apple Network Server","Aretha Franklin","Argentina national football team","Ariana Grande","Aristotle","Armie Hammer","Army of the Dead","Arnold Schwarzenegger","Arsenal F.C.","Art","Ashoka","Asia","Aston Villa F.C.","Atlantic Ocean","Atomic bombings of Hiroshima and Nagasaki","Attack on Pearl Harbor","Attack on Titan","Attack on Titan (season 4)","Audrey Hepburn","Augustus","Australia","Avatar","Avatar: The Last Airbender","Avengers: Endgame","Avengers: Infinity War","Avicii","Awkwafina","BBC World Service","BF","BTS","Backstreet Boys","Bad Boys for Life","Balkans","Barack Obama","Barron Trump","Batman","Batman: Arkham Knight","Battle for France","Battle of Britain","Battle of Dunkirk","Battle of Midway","Battle of Stalingrad","Battle of Waterloo","Battle of the Bulge","Bear","Beau Biden","Bee Gees","Ben Affleck","Bermuda Triangle","Bernie Sanders","Better Call Saul","Betty White","Beyoncé","Bhad Bhabie","Bible","Big Bang","Bill Clinton","Bill Gates","Billie Eilish","Bird","Birds of Prey (2020 film)","Bitcoin","Black Death","Black Lives Matter","Black Widow (2021 film)","Black hole","Blake Lively","Blue Ocean Strategy","Bo Burnham","Bob Marley","Bob Saget","Boris Johnson","Borussia Dortmund","Bosnian War","Boxer Rebellion","Brad Pitt","Brave New World","Brazil national football team","Breaking Bad","Bridgerton","Britney Spears","Brittany Murphy","Brock Lesnar","Brooklyn","Brooklyn Nine-Nine","Bruce Lee","CEO","COVID-19","COVID-19 pandemic","COVID-19 pandemic by country and territory","COVID-19 pandemic in India","COVID-19 pandemic in the United States","COVID-19 vaccine","Caitlyn Jenner","California","Caligula","Cameron Boyce","Cameron Diaz","Camilla, Duchess of Cornwall","Canada","Canary Islands","Candace Owens","Canelo Álvarez","Captain America","Cardi B","Carey Mulligan","Carol Danvers","Carole Baskin","Caroline Flack","Carrie Fisher","Cat","Catherine O'Hara","Catherine the Great","Cattle","Cecil Hotel (Los Angeles)","Ceres (dwarf planet)","Chadwick Boseman","Charlemagne","Charles III","Charles Manson","Charles Sobhraj","Charles, Prince of Wales","Charli D'Amelio","Charlie Sheen","Charlize Theron","Cheetah","Chelsea F.C.","Chernobyl disaster","Chester Bennington","Chicken","China","Chris Cuomo","Chris Evans (actor)","Chris Hemsworth","Chris Kyle","Chris Pratt","Christopher Nolan","Chupacabra","Clash of Civilizations","Cleopatra","Climate change","Clint Eastwood","Cobra Kai","Coca-Cola","Code Geass","Cold War","Coldplay","Columbine High School massacre","Coming 2 America","Confucius","Conor McGregor","Contagion (2011 film)","Continent","Coronavirus","Coronavirus disease 2019","Cougar","Crash Landing on You","Creative Commons Attribution","Crimea","Crimean War","Crisis on Infinite Earths (Arrowverse)","Cristiano Ronaldo","Critical race theory","Cruella (film)","Crusades","Cryptocurrency","Cthulhu","Cyberpunk 2077","DMX (rapper)","Daft Punk","Dakota Johnson","Dan Levy (Canadian actor)","Daniel Craig","Dark (TV series)","Dark energy","Dark matter","Darth Vader","Das Kapital","David","David Beckham","David Bowie","David Koresh","Deadpool","Death Stranding","Death of Elisa Lam","Death of George Floyd","Deaths in 2020","Debbie Reynolds","Demi Lovato","Democratic Party (United States)","Demon Slayer: Kimetsu no Yaiba","Dennis Nilsen","Dennis Rodman","Derek Chauvin","Design Patterns","Dexter","Diana, Princess of Wales","Diego Maradona","Dilip Kumar","Dinosaur","Diriliş: Ertuğrul","Doctor Strange","Doctor Strange in the Multiverse of Madness","Doctor Who","Dodo","Dog","Dogecoin","Doja Cat","Dolly Parton","Dolphin","Don Quixote","Don't Look Up (2021 film)","Donald J. Harris","Donald Trump","Donald Trump Jr.","Donda (album)","Doordarshan","Doppelgänger","Douglas Emhoff","Dracula","Dragon","Drake (musician)","Dua Lipa","Dune","Dune (2021 film)","Dune (novel)","Dunkirk evacuation","Dwayne Johnson","Earth","Earthquake","Ebola virus disease","Eclipse","Ed Sheeran","Ed and Lorraine Warren","Eddie Van Halen","Edward Snowden","Edward VIII","Elephant","Elizabeth I","Elizabeth II","Elizabeth Olsen","Elliot Page","Elon Musk","Elton John","Elvis Presley","Emily Blunt","Eminem","Emma Raducanu","Emma Roberts","Emma Stone","Emma Watson","England national football team","English language","Erling Haaland","Ernest Hemingway","Eternals (film)","European Union","Eurovision Song Contest 2021","Event horizon","Evolution","Exo","Extraction (2020 film)","F5 Networks","F9 (film)","FC Barcelona","FC Bayern Munich","FIFA World Cup","Facebook","Falklands War","Fallout 4","Family Guy","Family of Donald Trump","Fascism","Fast & Furious","Fifty Shades of Grey","Final Fantasy XV","Finn Wolfhard","Fleetwood Mac","Florence Pugh","Floyd Mayweather Jr.","Flying Spaghetti Monster","Foo Fighters","Ford v Ferrari","Foundations of Geopolitics","France","France national football team","Frank Sinatra","Frankenstein","Franklin D. Roosevelt","Freakonomics","Freddie Mercury","Free Guy","French Revolution","French and Indian War","Friends","Gal Gadot","Galaxy","Game of Thrones","Ganges","Gaten Matarazzo","Gautama Buddha","Gaza Strip","Generation Z","Genghis Khan","George Floyd","George H. W. Bush","George Harrison","George Michael","George Soros","George V","George VI","George W. Bush","George Washington","Germany","Germany national football team","Getting Things Done","Ghislaine Maxwell","Giannis Antetokounmpo","Gigi Hadid","Gillian Anderson","Giraffe","Girls' Generation","Glee","God","God of War (2018 video game)","Godzilla","Godzilla vs. Kong","Golden State Warriors","Google","Google Classroom","Google Translate","Google logo","Gordon Ramsay","Gorillaz","Grace Hopper","Grand Canyon","Grand Theft Auto IV","Grand Theft Auto V","Grand Theft Auto: San Andreas","Gray's Anatomy","Great Depression","Greek alphabet","Green Bay Packers","Green Day","Greta Thunberg","Grey's Anatomy","Grimes (musician)","Guerrilla marketing","Gulf War","Guns N' Roses","Guns, Germs, and Steel","HTTP 404","HTTP cookie","Hailee Steinfeld","Halley's Comet","Halsey (singer)","Halston","Hamas","Hamilton (musical)","Hannibal","Harley Quinn","Harry Kane","Harry Potter","Harry Potter (film series)","Harry Potter and the Deathly Hallows","Harry Styles","Harshad Mehta","Harvey Weinstein","Hawkeye (2021 TV series)","Heath Ledger","Helen McCrory","Helena Bonham Carter","Henry Cavill","Henry V of England","Henry VIII","Henry VIII of England","High School DxD","Himalayas","Horizon Zero Dawn","Horse","House","House of Gucci","How I Met Your Mother","How to Win Friends and Influence People","Human","Hundred Years' War","Hunter Biden","Hurricane Katrina","ICC Men's T20 World Cup","IOS","IP address blocking","Ice Age","Index.html","India","Indian Rebellion of 1857","Industrial Revolution","Inferno","Instagram","Inter Milan","Internet","Invincible (TV series)","Iran","Iran–Iraq War","Iraq War","Iron Maiden","Iron Man","Irrfan Khan","Isabela Merced","Israel","Israeli–Palestinian conflict","It","Italy","Italy national football team","Ivanka Trump","Ivermectin","J. Robert Oppenheimer","Jackie Evancho","Jacob Tremblay","Jadon Sancho","Jaguar","Jake Gyllenhaal","Jake Paul","James, Viscount Severn","Japan","Jason Bateman","Jason Momoa","Jason Statham","Jason Sudeikis","JavaScript","Jay-Z","Jeff Bezos","Jeffrey Dahmer","Jeffrey Epstein","Jen Psaki","Jenna Ortega","Jennifer Aniston","Jennifer Lawrence","Jennifer Lopez","Jessica Jones","Jesus","Jill Biden","Jim Carrey","Jimmy Carter","Jimmy Hoffa","JoJo Siwa","Joan of Arc","Joaquin Phoenix","Joaquín El Chapo Guzmán","Joe Biden","Joe Exotic","Joe Rogan","John Cena","John F. Kennedy","John Krasinski","John Lennon","John McCain","John Travolta","Johnny Depp","Jojo Rabbit","Jojo Siwa","Joker (2019 film)","Jonas Brothers","Joseph Stalin","Journey to the Center of the Earth","Judy Garland","Juice Wrld","Jujutsu Kaisen","Julia Roberts","Julius Caesar","Juneteenth","Jupiter","Justice League (film)","Justin Bieber","Juventus F.C.","Kama Sutra","Kamala Harris","Kanye West","Kargil War","Kate Winslet","Katrina Kaif","Katy Perry","Kayleigh McEnany","Keanu Reeves","Kelly Preston","Ken Miles","Kenosha unrest shooting","Kepler's Supernova","Khabib Nurmagomedov","Killing of George Floyd","Kim Jong-un","Kim Kardashian","King Arthur","Kirk Douglas","Kiss","Knives Out","Kobe Bryant","Kobe Bryant sexual assault case","Korean War","Kosovo War","Krishna","Kristen Stewart","Ku Klux Klan","Kylie Jenner","LaMelo Ball","Lady Gaga","Lady Louise Windsor","Lali Espósito","Laptop","Larry King","LeBron James","League of Legends","Led Zeppelin","Leicester F.C.","Leonardo DiCaprio","Leonardo da Vinci","Les Misérables","Leviathan","Lewis Hamilton","Lightning","Lil Nas X","Lil Pump","Lil Wayne","Lily Collins","Lily James","Lin-Manuel Miranda","Linkin Park","Lion","Lionel Messi","Lisa Marie Presley","Little Women (2019 film)","Liverpool F.C.","Logan Paul","Loki (TV series)","Lolita","London","Long Island","Lord Voldemort","Los Angeles Lakers","Lost","Louis Mountbatten, 1st Earl Mountbatten of Burma","Lovecraft Country (TV series)","Lucifer (TV series)","Luka Magnotta","Luke Cage","Luke Perry","Lunar eclipse","MacOS","Macaulay Culkin","Machine Gun Kelly (musician)","Mackenzie Foy","Madam C. J. Walker","Maddie Ziegler","Madonna","Magna Carta","Maharashtra","Mahatma Gandhi","Maize","Malcolm X","Malware","Mammal","Manchester City F.C.","Manchester United F.C.","Manifest (TV series)","Manny Pacquiao","Marco Polo","Marcus Aurelius","Mare of Easttown","Margaret Thatcher","Margot Robbie","Mariah Carey","Marie Curie","Marilyn Manson","Marilyn Monroe","Mario","Marjorie Taylor Greene","Mark Wahlberg","Mark Zuckerberg","Mars","Martin Luther King Jr.","Marvel Cinematic Universe","Marvel Cinematic Universe: Phase Four","Mary, Queen of Scots","Matthew McConaughey","Matthew Perry","Maurizio Gucci","Maya Harris","Mayim Bialik","Mckenna Grace","Media","Megan Fox","Megan Thee Stallion","Meghan Markle","Meghan, Duchess of Sussex","Mein Kampf","Melania Trump","Men Are from Mars, Women Are from Venus","Mercury (planet)","Metal Gear Solid V: The Phantom Pain","Metallica","Mexican–American War","Mia Khalifa","Michael Bloomberg","Michael Jackson","Michael Jordan","Michael Oher","Michael Phelps","Michael Schumacher","Mickey Mouse","Microsoft Office","Microsoft Teams","Microsoft Windows","Midsommar (film)","Miguel Ángel Félix Gallardo","Mike Pence","Mike Tyson","Mila Kunis","Miley Cyrus","Milky Way","Millennials","Millie Bobby Brown","Minecraft","Mississippi","Mitch McConnell","Modern Family","Money Heist","Moon","Mortal Kombat (2021 film)","Moses","Mount Everest","Muhammad","Muhammad Ali","Mulan (2020 film)","Myanmar","N.W.A","NCIS","Nancy Pelosi","Naomi Osaka","Napoleon","Napoleonic Wars","Narendra Modi","Naruto","Natalie Portman","Naya Rivera","Nelson Mandela","Neptune","Nero","Netflix","Netherlands","New England Patriots","New York City","New York Yankees","New Zealand","Newcastle United F.C.","Neymar","Nick Jonas","Nicki Minaj","Nicolas Cage","Nicole Kidman","Nikola Tesla","Nile","Nineteen Eighty-Four","Nipsey Hussle","Nirvana","No Man's Sky","No Time to Die","Noah Cyrus","Nomadland (film)","Non-fungible token","Norm Macdonald","Normandy landings","North America","Notre-Dame de Paris","Novak Djokovic","Null","O. J. Simpson","Ocean","Octopus","Old (film)","Olivia Newton-John","Olivia Rodrigo","Olivia Wilde","Omegle","On the Origin of Species","Once Upon a Time in Hollywood","One Direction","OnlyFans","Oppenheimer (film)","Osama bin Laden","Ottoman Empire","Outlander (TV series)","Outliers","Outlook.com","Ozark (TV series)","Pablo Escobar","Pacific Ocean","Pakistan","Palau","Pandemic","Parasite (2019 film)","Paris Saint-Germain F.C.","Patrick Mahomes","Patrizia Reggiani","Paul McCartney","Paul Walker","Peaky Blinders (TV series)","Periodic table","Persona 5","Pete Buttigieg","Pete Davidson","Peyton Manning","Phil Jackson","Philippines","Photosynthesis","Pink Floyd","Pirates of the Caribbean (film series)","Pizzagate conspiracy theory","Plato","Platypus","PlayerUnknown's Battlegrounds","Pluto","Pokémon Go","Polar bear","Pop Smoke","Pornhub","Post Malone","Potato","Premier League","President of the United States","Pride and Prejudice","Prince","Prince (musician)","Prince Andrew, Duke of York","Prince Edward, Earl of Wessex","Prince George of Cambridge","Prince Harry, Duke of Sussex","Prince Philip, Duke of Edinburgh","Prince William, Duke of Cambridge","Princess Charlotte of Cambridge","Princess Margaret, Countess of Snowdon","Priyanka Chopra","Prometheus","Promising Young Woman","Proud Boys","Puneeth Rajkumar","QAnon","Qasem Soleimani","Queen","Queen Victoria","Quentin Tarantino","Rabbit","Raccoon","Rachel McAdams","Rachel Weisz","Rafael Nadal","Ragnar Lodbrok","Rami Malek","Rangers F.C.","Rashida Jones","Raya and the Last Dragon","Real Madrid C.F.","Red Dead Redemption","Red Dead Redemption 2","Red Hot Chili Peppers","Red states and blue states","Regé-Jean Page","Remdesivir","Republican Party (United States)","Resident Evil 7: Biohazard","Rhea Chakraborty","Rich Dad Poor Dad","Richard Jewell","Richard Nixon","Richard Ramirez","Rihanna","Rishi Kapoor","Rishi Sunak","River Phoenix","Robert De Niro","Robert Downey Jr.","Robert Pattinson","Robin Hood","Robin Williams","Roblox","Roger Federer","Roman Polanski","Romelu Lukaku","Ronald Reagan","Ronaldinho","Ronaldo","Ronda Rousey","Rosamund Pike","Russia","Russo-Ukrainian War","Ruth Bader Ginsburg","Ryan Reynolds","Sacha Baron Cohen","Sachin Tendulkar","Salma Hayek","Sandra Bullock","Santa Claus","Sapiens: A Brief History of Humankind","Sarah Paulson","Satan","Saturn","Scarlett Johansson","Schitt's Creek","Scottie Pippen","Sean Connery","Search engine","Second Boer War","Selena","Selena Gomez","September 11 attacks","Serena Williams","Seven deadly sins","Severe acute respiratory syndrome","Severe acute respiratory syndrome coronavirus 2","Sex","Sex Education (TV series)","Shadow and Bone (TV series)","Shailene Woodley","Shakira","Shakuntala Devi","Shang-Chi and the Legend of the Ten Rings","Shaquille O'Neal","Shark","Sharon Tate","Sherlock","Shia LaBeouf","Shooting of Breonna Taylor","Shyamala Gopalan","Sidharth Shukla","Silent Spring","Simone Biles","Simu Liu","Singapore","Sinéad O'Connor","Sirius","Six-Day War","Skathi (moon)","Slipknot","Snake","Snoop Dogg","Socrates","Solar System","Solar eclipse","Sonic the Hedgehog (film)","Sons of Anarchy","South Africa","South America","Soviet Union","Soviet-Afghan War","Space Jam: A New Legacy","Spain national football team","Spanish Civil War","Spanish flu","Spartacus","Spice Girls","Spider","Spider-Man","Spider-Man: No Way Home","Squid Game","Sridevi","Stan Lee","Stanley Tucci","Star Wars","Star Wars: The Force Awakens","Star Wars: The Rise of Skywalker","State of Palestine","States and union territories of India","Stephen Curry","Stephen Hawking","Steve Jobs","Stranger Things","Succession (TV series)","Suez Canal","Suicide methods","Sun","Supernovae","Susan Wojcicki","Sushant Singh Rajput","Sword Art Online","Sylvester Stallone","Syrian civil war","Taika Waititi","Taiwan","Taliban","Tamil Nadu","Tanhaji","Tasuku Honjo","Taylor Swift","Ted Bundy","Ted Kaczynski","Ted Lasso","Ten Commandments","Tenet (film)","Thanos","The 48 Laws of Power","The 7 Habits of Highly Effective People","The Art of War","The Avengers","The Beatles","The Bell Curve","The Big Bang Theory","The Big Short","The Boys (2019 TV series)","The Catcher in the Rye","The Communist Manifesto","The Conjuring: The Devil Made Me Do It","The Crown (TV series)","The Dark Knight Rises","The Elder Scrolls V: Skyrim","The Falcon and the Winter Soldier","The Girl with the Dragon Tattoo","The Good Doctor (TV series)","The Great Gatsby","The Handmaid's Tale","The Handmaid's Tale (TV series)","The Haunting of Bly Manor","The Hobbit","The Holocaust","The Hunger Games","The Idol (TV series)","The Invisible Man (2020 film)","The Irishman","The Last Duel (2021 film)","The Last of Us","The Last of Us Part II","The Legend of Zelda: Breath of the Wild","The Lord of the Rings","The Mandalorian","The Matrix","The Matrix Resurrections","The New Mutants (film)","The Picture of Dorian Gray","The Pirate Bay","The Prince","The Queen's Gambit (miniseries)","The Rolling Stones","The Simpsons","The Suicide Squad (film)","The Tipping Point","The Tomorrow War","The Troubles","The Umbrella Academy (TV series)","The Undertaker","The Undoing (miniseries)","The Vampire Diaries","The Walking Dead","The Walking Dead (TV series)","The Wealth of Nations","The Weeknd","The Wheel of Time","The Winds of Winter","The Witcher (TV series)","The Witcher 3: Wild Hunt","The World Is Flat","The World's Billionaires","Theodore Roosevelt","Think and Grow Rich","Thomas Jefferson","Thor","Tiger","Tiger King: Murder, Mayhem and Madness","Tiger Woods","TikTok","Timothée Chalamet","Tina Turner","Titan (moon)","Titanic","To Kill a Mockingbird","Tobey Maguire","Tom Brady","Tom Cruise","Tom Hanks","Tom Hardy","Tom Holland","Tom Petty","Tom Selleck","Tomato","Tottenham Hotspur F.C.","Travis Barker","Travis Scott","Triple H","Trojan War","Tsunami","Tupac Shakur","Turkey","Turkish Radio and Television Corporation","Turmeric","Tutankhamun","Twitter","Tyrannosaurus","Tyson Fury","U.S. state","UEFA Champions League","UEFA Euro 2020","UEFA European Championship","Ukraine","Uncut Gems","United Kingdom","United States","United States Electoral College","United States presidential election, 2016","Universe","Until Dawn","Uranus","Usain Bolt","Uttar Pradesh","Val Kilmer","Vampire","Venom: Let There Be Carnage","Venus","Vicky Kaushal","Vietnam War","Vikram Batra","Vin Diesel","Virat Kohli","Virus","Vladimir Putin","Volcano","Waco siege","WandaVision","War in Afghanistan (2001–2021)","War of 1812","Watchmen","Watts family murders","Wayne Rooney","West Ham United F.C.","Westworld (TV series)","What If...? (TV series)","WhatsApp","Who Moved My Cheese?","Wiki","Wikipedia","Will Smith","William Shakespeare","William Wallace","William the Conqueror","Willow Smith","Windows 10 version history","Winston Churchill","Winter War","Winter solstice","Wonder Woman","Wonder Woman 1984","World Health Organization","World War I","World War II","World War III","World of Warcraft","WrestleMania 36","WrestleMania 37","X-Men: Evolution","XXX","XXX (2002 film)","XXX (film series)","XXX: Return of Xander Cage","XXXTentacion","XXXX","Yara Shahidi","Yellowstone (American TV series)","Yellowstone National Park","Yom Kippur War","You (TV series)","YouTube","YouTube Music","YouTube Premium","Zac Efron","Zack Snyder's Justice League","Zendaya","Zion Williamson","Zlatan Ibrahimovic","Zlatan Ibrahimović","Zodiac","Zodiac Killer","Zooey Deschanel","Zoom Video Communications","xHamster"]
        let randomIndex = Int.random(in: 0..<topArticles.count)
        let randomTitle = topArticles[randomIndex]
        let query = "Summarize \(randomTitle) from Wikipedia"
        makeQuery(query)
    }
    
    func speak() {
        print("[SpeechRecognition][speak]")
        pauseCapturing()
        stopGPT()
        textToSpeechConverter.stopSpeech()
        cleanupRecognition()
        isAudioSessionSetup = false
        resumeCapturing()
    }
    
    func stopSpeak() {
        if audioEngine.isRunning {
            recognitionTask?.finish()
        }
        
        if !messageInRecongnition.isEmpty {
            recognitionLock.wait()
            let message = messageInRecongnition
            messageInRecongnition = ""
            recognitionLock.signal()
            makeQuery(message)
        } else {
            audioPlayer.playSound(false)
        }
        
        pauseCapturing()
    }
    
    func cancelSpeak() {
        pauseCapturing()
    }
    
    func repeate() {
        textToSpeechConverter.stopSpeech()
        pauseCapturing()
        print("repeate", conversation)
        _isPaused = false
        if let m = conversation.last(where: { $0.role == "assistant" && $0.content != "" }) {
            print("repeate content", m.content ?? "")
            textToSpeechConverter.convertTextToSpeech(text: m.content ?? "")
        } else {
            textToSpeechConverter.convertTextToSpeech(text: greetingText)
        }
    }
}

// Extension for AVSpeechSynthesizerDelegate

extension SpeechRecognition: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        isPlayingWorkItem?.cancel()
        isPlayingWorkItem = DispatchWorkItem { [weak self] in
            if ((self?._isPlaying) != nil) {
                print("[SpeechRecognition][synthesizeFinish]")
                self?._isPlaying = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35, execute: isPlayingWorkItem!)
        
        
        // TODO: to be used later for automatically resuming capturing when agent is not speaking
        //        resumeListeningTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
        //            print("[SpeechRecognition][speechSynthesizer][didFinish] Starting capturing again")
        //            DispatchQueue.main.async {
        //                if self.isGreatingFinished {
        //                    self.resumeCapturing()
        //                }
        //                self.isGreatingFinished = true
        //            }
        //        }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        
        
        isPlayingWorkItem?.cancel()
        isPlayingWorkItem = DispatchWorkItem { [weak self] in
            if self?._isPlaying == false {
                print("[SpeechRecognition][synthesizeStart]")
                self?._isPlaying = true
            }
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: isPlayingWorkItem!)
        
        audioPlayer.stopSound()
        pauseCapturing()
        resumeListeningTimer?.invalidate()
    }
}
