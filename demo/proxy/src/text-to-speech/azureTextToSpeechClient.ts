import * as sdk from 'microsoft-cognitiveservices-speech-sdk';

/**
 * Node.js server code to convert text to speech
 * @returns stream
 * @param {*} key your resource key
 * @param {*} region your resource region
 * @param {*} text text to convert to audio/speech
 * @param {*} filename optional - best for long text - temp file for converted speech/audio
 */
export const textToSpeechAzure =
    async (key, region, text, filename?): Promise<string | Uint8Array | null | undefined> => {

        // convert callback function to promise
        return new Promise((resolve, reject) => {

            const speechConfig = sdk.SpeechConfig.fromSubscription(key, region);
            speechConfig.speechSynthesisOutputFormat = 5; // mp3

            let audioConfig = null;

            if (filename) {
                audioConfig = sdk.AudioConfig.fromAudioFileOutput(filename);
            }

            const synthesizer = new sdk.SpeechSynthesizer(speechConfig, audioConfig);

            synthesizer.speakTextAsync(
                text,
                result => {

                    const { audioData } = result;

                    synthesizer.close();

                    resolve(new Uint8Array(audioData));
                },
                error => {
                    synthesizer.close();
                    reject(error);
                });
        });
    };