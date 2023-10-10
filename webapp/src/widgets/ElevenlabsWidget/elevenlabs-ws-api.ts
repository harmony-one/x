import { decode } from 'base64-arraybuffer';

const voiceId = "21m00Tcm4TlvDq8ikWAM"; // replace with your voice_id
const model = 'eleven_monolingual_v1';
const wsUrl = `wss://api.elevenlabs.io/v1/text-to-speech/${voiceId}/stream-input?model_id=${model}`;

let startTime = 0;

const sleep = (ms: number) => new Promise(res => setTimeout(res, ms));

export class ElevenlabsApi {
    socket: WebSocket;

    isSocketOpen = false;
    audioContext: AudioContext | undefined;

    initAudioContext = async () => {
        await navigator.mediaDevices.getUserMedia({ audio: true });

        this.audioContext = new AudioContext();

        await this.audioContext.resume()
    }

    constructor() {
        this.socket = new WebSocket(wsUrl);

        // 5. Handle server responses
        this.socket.onmessage = async (event) => {
            const response = JSON.parse(event.data);

            console.log("Server response:", response);

            if (response.audio) {
                // decode and handle the audio data (e.g., play it)
                // const audioChunk = atob(response.audio);  // decode base64
                console.log("Received audio chunk");

                if (!this.audioContext) {
                    await this.initAudioContext();
                }

                if (this.audioContext) {
                    const audioContext = this.audioContext;

                    audioContext.decodeAudioData(decode(response.audio), (buffer) => {
                        var source = audioContext.createBufferSource();
                        source.buffer = buffer;
                        source.connect(audioContext.destination);

                        console.log(111, startTime);

                        source.start(startTime);
                        startTime += buffer.duration;
                    });
                }
            } else {
                console.log("No audio data in the response");
            }

            if (response.isFinal) {
                // the generation is complete
            }

            if (response.normalizedAlignment) {
                // use the alignment info if needed
            }
        };

        // Handle errors
        this.socket.onerror = function (error) {
            console.error(`WebSocket Error: ${error}`);
        };

        // Handle socket closing
        this.socket.onclose = (event) => {
            this.isSocketOpen = false;

            if (event.wasClean) {
                console.info(`Connection closed cleanly, code=${event.code}, reason=${event.reason}`);
            } else {
                console.warn('Connection died');
            }
        };


        this.socket.onopen = (event) => this.isSocketOpen = true;
    }

    textToSpeach = async (text: string) => {
        while (!this.isSocketOpen) {
            await sleep(500);
        }

        const bosMessage = {
            "text": " ",
            "voice_settings": {
                "stability": 0.5,
                "similarity_boost": true
            },
            "xi_api_key": process.env.REACT_APP_SECRET_ELEVENLABS, // replace with your API key
        };

        this.socket.send(JSON.stringify(bosMessage));

        // 3. Send the input text message ("Hello World")
        const textMessage = {
            "text": text,
            "try_trigger_generation": true,
        };

        this.socket.send(JSON.stringify(textMessage));

        // 4. Send the EOS message with an empty string
        const eosMessage = {
            "text": ""
        };

        this.socket.send(JSON.stringify(eosMessage));
    }

    startStream = async () => {
        while (!this.isSocketOpen) {
            await sleep(500);
        }

        const bosMessage = {
            "text": " ",
            "voice_settings": {
                "stability": 0.5,
                "similarity_boost": true
            },
            "xi_api_key": process.env.REACT_APP_SECRET_ELEVENLABS, // replace with your API key
        };

        this.socket.send(JSON.stringify(bosMessage));
    }

    sendChunkToStream = async (text: string) => {
        // 3. Send the input text message ("Hello World")
        const textMessage = {
            "text": text,
            "try_trigger_generation": true,
        };

        this.socket.send(JSON.stringify(textMessage));
    }

    stopStream = async () => {
        // 4. Send the EOS message with an empty string
        const eosMessage = {
            "text": ""
        };

        this.socket.send(JSON.stringify(eosMessage));
    }
}
