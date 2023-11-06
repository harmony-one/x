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
        let topArticles = [
            "2003 invasion of Iraq",
            "2004 Indian Ocean earthquake and tsunami",
            "2010 FIFA World Cup",
            "2011 Tōhoku earthquake and tsunami",
            "2012 Summer Olympics",
            "2014 FIFA World Cup",
            "2016 Summer Olympics",
            "2016 United States presidential election",
            "2018 FIFA World Cup",
            "2020 Summer Olympics",
            "2020 United States presidential election",
            "2022 FIFA World Cup",
            "2022 Russian invasion of Ukraine",
            "A Brief History of Time",
            "A Game of Thrones",
            "A Song of Ice and Fire",
            "A.C. Milan",
            "ABBA",
            "AC/DC",
            "Abraham",
            "Abraham Lincoln",
            "Academy Awards",
            "Adele",
            "Adolf Hitler",
            "Africa",
            "Albert Einstein",
            "Albus Dumbledore",
            "Alexander Hamilton",
            "Alexander the Great",
            "Alfred the Great",
            "Alice's Adventures in Wonderland",
            "Alpha Centauri",
            "Amazon River",
            "American Civil War",
            "American Horror Story",
            "American Revolutionary War",
            "Americas",
            "Among Us",
            "Andromeda Galaxy",
            "Angelina Jolie",
            "Animal",
            "Animal Farm",
            "Antarctica",
            "Apollo",
            "Apple",
            "Argentina national football team",
            "Ariana Grande",
            "Aristotle",
            "Arnold Schwarzenegger",
            "Arsenal F.C.",
            "Ashoka",
            "Asia",
            "Aston Villa F.C.",
            "Atlantic Ocean",
            "Atomic bombings of Hiroshima and Nagasaki",
            "Attack on Pearl Harbor",
            "Augustus",
            "Australia",
            "Avatar",
            "Avengers: Endgame",
            "Avengers: Infinity War",
            "BTS",
            "Backstreet Boys",
            "Balkans",
            "Barack Obama",
            "Barron Trump",
            "Batman",
            "Batman: Arkham Knight",
            "Battle for France",
            "Battle of Britain",
            "Battle of Dunkirk",
            "Battle of Midway",
            "Battle of Stalingrad",
            "Battle of Waterloo",
            "Battle of the Bulge",
            "Bear",
            "Bee Gees",
            "Bermuda Triangle",
            "Beyoncé",
            "Bhad Bhabie",
            "Bible",
            "Big Bang",
            "Bill Clinton",
            "Bill Gates",
            "Billie Eilish",
            "Bird",
            "Black Death",
            "Black hole",
            "Blue Ocean Strategy",
            "Bob Marley",
            "Borussia Dortmund",
            "Bosnian War",
            "Boxer Rebellion",
            "Brad Pitt",
            "Brave New World",
            "Brazil national football team",
            "Breaking Bad",
            "Britney Spears",
            "Brock Lesnar",
            "Bruce Lee",
            "COVID-19 pandemic",
            "Caitlyn Jenner",
            "Caligula",
            "Canada",
            "Canary Islands",
            "Captain America",
            "Carol Danvers",
            "Cat",
            "Cattle",
            "Ceres (dwarf planet)",
            "Charlemagne",
            "Charles III",
            "Charles Manson",
            "Charli D'Amelio",
            "Cheetah",
            "Chelsea F.C.",
            "Chernobyl disaster",
            "Chicken",
            "China",
            "Chupacabra",
            "Clash of Civilizations",
            "Cleopatra",
            "Climate change",
            "Clint Eastwood",
            "Code Geass",
            "Cold War",
            "Coldplay",
            "Columbine High School massacre",
            "Confucius",
            "Conor McGregor",
            "Continent",
            "Coronavirus",
            "Cougar",
            "Creative Commons Attribution",
            "Crimea",
            "Crimean War",
            "Cristiano Ronaldo",
            "Crusades",
            "Cthulhu",
            "Cyberpunk 2077",
            "Daft Punk",
            "Dark energy",
            "Dark matter",
            "Darth Vader",
            "Das Kapital",
            "David",
            "David Beckham",
            "David Bowie",
            "Deadpool",
            "Death Stranding",
            "Demi Lovato",
            "Design Patterns",
            "Dexter",
            "Diana, Princess of Wales",
            "Dinosaur",
            "Doctor Strange",
            "Doctor Who",
            "Dodo",
            "Dog",
            "Dolphin",
            "Don Quixote",
            "Donald Trump",
            "Doppelgänger",
            "Dracula",
            "Dragon",
            "Dune",
            "Dunkirk evacuation",
            "Dwayne Johnson",
            "Earth",
            "Earthquake",
            "Eclipse",
            "Edward VIII",
            "Elephant",
            "Elizabeth I",
            "Elizabeth II",
            "Elon Musk",
            "Elvis Presley",
            "Eminem",
            "Emma Raducanu",
            "Emma Watson",
            "England national football team",
            "Erling Haaland",
            "Event horizon",
            "Evolution",
            "Exo",
            "FC Barcelona",
            "FC Bayern Munich",
            "Facebook",
            "Falklands War",
            "Fallout 4",
            "Family Guy",
            "Fifty Shades of Grey",
            "Final Fantasy XV",
            "Finn Wolfhard",
            "Fleetwood Mac",
            "Flying Spaghetti Monster",
            "Foo Fighters",
            "Foundations of Geopolitics",
            "France",
            "France national football team",
            "Frankenstein",
            "Franklin D. Roosevelt",
            "Freakonomics",
            "Freddie Mercury",
            "French Revolution",
            "French and Indian War",
            "Friends",
            "Galaxy",
            "Game of Thrones",
            "Ganges",
            "Gaten Matarazzo",
            "Gautama Buddha",
            "Genghis Khan",
            "George H. W. Bush",
            "George VI",
            "George W. Bush",
            "George Washington",
            "Germany",
            "Germany national football team",
            "Getting Things Done",
            "Giraffe",
            "Girls' Generation",
            "Glee",
            "God",
            "God of War (2018 video game)",
            "Godzilla",
            "Golden State Warriors",
            "Google",
            "Gorillaz",
            "Grand Canyon",
            "Grand Theft Auto IV",
            "Grand Theft Auto V",
            "Grand Theft Auto: San Andreas",
            "Gray's Anatomy",
            "Great Depression",
            "Green Bay Packers",
            "Green Day",
            "Greta Thunberg",
            "Grey's Anatomy",
            "Guerrilla marketing",
            "Gulf War",
            "Guns N' Roses",
            "Guns, Germs, and Steel",
            "Halley's Comet",
            "Hannibal",
            "Harley Quinn",
            "Harry Potter",
            "Harry Potter and the Deathly Hallows",
            "Heath Ledger",
            "Henry V of England",
            "Henry VIII",
            "Henry VIII of England",
            "High School DxD",
            "Himalayas",
            "Horizon Zero Dawn",
            "Horse",
            "House",
            "How I Met Your Mother",
            "How to Win Friends and Influence People",
            "Human",
            "Hundred Years' War",
            "Hurricane Katrina",
            "Ice Age",
            "India",
            "Indian Rebellion of 1857",
            "Industrial Revolution",
            "Inferno",
            "Inter Milan",
            "Iran–Iraq War",
            "Iraq War",
            "Iron Maiden",
            "Iron Man",
            "Isabela Merced",
            "Israel",
            "Israeli–Palestinian conflict",
            "It",
            "Italy national football team",
            "Jackie Evancho",
            "Jacob Tremblay",
            "Jadon Sancho",
            "Jaguar",
            "James, Viscount Severn",
            "Japan",
            "Jay-Z",
            "Jeffrey Dahmer",
            "Jenna Ortega",
            "Jennifer Aniston",
            "Jennifer Lawrence",
            "Jennifer Lopez",
            "Jessica Jones",
            "Jesus",
            "Joan of Arc",
            "Joe Biden",
            "John Cena",
            "John F. Kennedy",
            "John Lennon",
            "Johnny Depp",
            "Jojo Siwa",
            "Jonas Brothers",
            "Joseph Stalin",
            "Journey to the Center of the Earth",
            "Julius Caesar",
            "Jupiter",
            "Justin Bieber",
            "Juventus F.C.",
            "Kama Sutra",
            "Kamala Harris",
            "Kanye West",
            "Kargil War",
            "Katy Perry",
            "Keanu Reeves",
            "Kepler's Supernova",
            "Kim Kardashian",
            "King Arthur",
            "Kiss",
            "Kobe Bryant",
            "Korean War",
            "Kosovo War",
            "Krishna",
            "Kristen Stewart",
            "LaMelo Ball",
            "Lady Gaga",
            "Lady Louise Windsor",
            "Lali Espósito",
            "LeBron James",
            "League of Legends",
            "Led Zeppelin",
            "Leicester F.C.",
            "Leonardo DiCaprio",
            "Leonardo da Vinci",
            "Les Misérables",
            "Leviathan",
            "Lightning",
            "Lil Pump",
            "Lil Wayne",
            "Linkin Park",
            "Lion",
            "Lionel Messi",
            "Liverpool F.C.",
            "Lolita",
            "Long Island",
            "Lord Voldemort",
            "Los Angeles Lakers",
            "Lost",
            "Luke Cage",
            "Lunar eclipse",
            "Mackenzie Foy",
            "Maddie Ziegler",
            "Madonna",
            "Magna Carta",
            "Mahatma Gandhi",
            "Maize",
            "Malware",
            "Mammal",
            "Manchester City F.C.",
            "Manchester United F.C.",
            "Manny Pacquiao",
            "Marco Polo",
            "Marcus Aurelius",
            "Margaret Thatcher",
            "Mariah Carey",
            "Marilyn Monroe",
            "Mario",
            "Mark Wahlberg",
            "Mark Zuckerberg",
            "Mars",
            "Mckenna Grace",
            "Megan Fox",
            "Meghan Markle",
            "Meghan, Duchess of Sussex",
            "Mein Kampf",
            "Men Are from Mars, Women Are from Venus",
            "Mercury (planet)",
            "Metal Gear Solid V: The Phantom Pain",
            "Metallica",
            "Mexican–American War",
            "Michael Jackson",
            "Michael Jordan",
            "Michael Oher",
            "Michael Phelps",
            "Mickey Mouse",
            "Mike Tyson",
            "Mila Kunis",
            "Miley Cyrus",
            "Milky Way",
            "Millie Bobby Brown",
            "Minecraft",
            "Mississippi",
            "Modern Family",
            "Moon",
            "Moses",
            "Mount Everest",
            "Muhammad",
            "Muhammad Ali",
            "N.W.A",
            "NCIS",
            "Napoleonic Wars",
            "Naruto",
            "Natalie Portman",
            "Nelson Mandela",
            "Neptune",
            "Nero",
            "New England Patriots",
            "New York City",
            "New York Yankees",
            "Newcastle United F.C.",
            "Neymar",
            "Nicki Minaj",
            "Nile",
            "Nineteen Eighty-Four",
            "Nirvana",
            "No Man's Sky",
            "Noah Cyrus",
            "Normandy landings",
            "North America",
            "Novak Djokovic",
            "O. J. Simpson",
            "Ocean",
            "Octopus",
            "Olivia Rodrigo",
            "On the Origin of Species",
            "One Direction",
            "Outliers",
            "Pablo Escobar",
            "Pacific Ocean",
            "Palau",
            "Paris Saint-Germain F.C.",
            "Persona 5",
            "Peyton Manning",
            "Photosynthesis",
            "Pink Floyd",
            "Plato",
            "Platypus",
            "Pluto",
            "Pokémon Go",
            "Polar bear",
            "Pop Smoke",
            "Potato",
            "Pride and Prejudice",
            "Prince",
            "Prince (musician)",
            "Prince George of Cambridge",
            "Prince Philip, Duke of Edinburgh",
            "Princess Charlotte of Cambridge",
            "Princess Margaret, Countess of Snowdon",
            "Prometheus",
            "Queen",
            "Queen Victoria",
            "Rabbit",
            "Raccoon",
            "Rafael Nadal",
            "Ragnar Lodbrok",
            "Rangers F.C.",
            "Real Madrid C.F.",
            "Red Dead Redemption",
            "Red Dead Redemption 2",
            "Red Hot Chili Peppers",
            "Resident Evil 7: Biohazard",
            "Rich Dad Poor Dad",
            "Rihanna",
            "Robin Hood",
            "Robin Williams",
            "Roblox",
            "Roger Federer",
            "Ronald Reagan",
            "Ronaldinho",
            "Ronaldo",
            "Ronda Rousey",
            "Russia",
            "Russo-Ukrainian War",
            "Ryan Reynolds",
            "Sachin Tendulkar",
            "Santa Claus",
            "Sapiens: A Brief History of Humankind",
            "Satan",
            "Saturn",
            "Scarlett Johansson",
            "Search engine",
            "Second Boer War",
            "Selena Gomez",
            "September 11 attacks",
            "Serena Williams",
            "Sex",
            "Shaquille O'Neal",
            "Shark",
            "Sherlock",
            "Silent Spring",
            "Singapore",
            "Sirius",
            "Six-Day War",
            "Skathi (moon)",
            "Slipknot",
            "Snake",
            "Snoop Dogg",
            "Socrates",
            "Solar System",
            "Solar eclipse",
            "Sons of Anarchy",
            "South America",
            "Soviet-Afghan War",
            "Spain national football team",
            "Spanish Civil War",
            "Spanish flu",
            "Spartacus",
            "Spice Girls",
            "Spider",
            "Spider-Man",
            "Star Wars",
            "Stephen Curry",
            "Stephen Hawking",
            "Steve Jobs",
            "Stranger Things",
            "Sun",
            "Supernovae",
            "Sword Art Online",
            "Sylvester Stallone",
            "Syrian civil war",
            "Taylor Swift",
            "Ted Bundy",
            "Thanos",
            "The 48 Laws of Power",
            "The 7 Habits of Highly Effective People",
            "The Art of War",
            "The Avengers",
            "The Beatles",
            "The Bell Curve",
            "The Big Bang Theory",
            "The Big Short",
            "The Catcher in the Rye",
            "The Communist Manifesto",
            "The Dark Knight Rises",
            "The Elder Scrolls V: Skyrim",
            "The Girl with the Dragon Tattoo",
            "The Great Gatsby",
            "The Handmaid's Tale",
            "The Hobbit",
            "The Holocaust",
            "The Hunger Games",
            "The Last of Us",
            "The Last of Us Part II",
            "The Legend of Zelda: Breath of the Wild",
            "The Lord of the Rings",
            "The Picture of Dorian Gray",
            "The Prince",
            "The Rolling Stones",
            "The Simpsons",
            "The Tipping Point",
            "The Troubles",
            "The Undertaker",
            "The Vampire Diaries",
            "The Walking Dead",
            "The Walking Dead (TV series)",
            "The Wealth of Nations",
            "The Winds of Winter",
            "The Witcher 3: Wild Hunt",
            "The World Is Flat",
            "Think and Grow Rich",
            "Thor",
            "Tiger",
            "Tiger Woods",
            "Titan (moon)",
            "Titanic",
            "To Kill a Mockingbird",
            "Tom Brady",
            "Tom Cruise",
            "Tom Hanks",
            "Tom Hardy",
            "Tomato",
            "Tottenham Hotspur F.C.",
            "Triple H",
            "Trojan War",
            "Tsunami",
            "Tupac Shakur",
            "Turmeric",
            "Tutankhamun",
            "Tyrannosaurus",
            "UEFA Euro 2020",
            "United Kingdom",
            "United States",
            "Universe",
            "Until Dawn",
            "Uranus",
            "Usain Bolt",
            "Vampire",
            "Venus",
            "Vietnam War",
            "Virat Kohli",
            "Virus",
            "Vladimir Putin",
            "Volcano",
            "War in Afghanistan (2001–2021)",
            "War of 1812",
            "Watchmen",
            "Wayne Rooney",
            "West Ham United F.C.",
            "Who Moved My Cheese?",
            "Wikipedia",
            "Will Smith",
            "William Shakespeare",
            "William Wallace",
            "William the Conqueror",
            "Willow Smith",
            "Winston Churchill",
            "Winter War",
            "Winter solstice",
            "Wonder Woman",
            "World War I",
            "World War II",
            "World of Warcraft",
            "X-Men: Evolution",
            "XXXX",
            "Yara Shahidi",
            "Yellowstone National Park",
            "Yom Kippur War",
            "YouTube",
            "Zion Williamson",
            "Zlatan Ibrahimovic",
            "xHamster"
        ]
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
