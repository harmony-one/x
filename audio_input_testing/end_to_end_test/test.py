import pyaudio
import numpy as np
import speech_recognition as sr

# Initialize PyAudio
pa = pyaudio.PyAudio()

# Constants
FORMAT = pyaudio.paInt16
CHANNELS = 1
RATE = 11000
CHUNK_SIZE = 2048

# Open an audio stream
stream = pa.open(format=FORMAT,
                 channels=CHANNELS,
                 rate=RATE,
                 input=True,
                 frames_per_buffer=CHUNK_SIZE,
                 input_device_index=1)

def transcribe_audio(data, sample_rate=RATE):
    r = sr.Recognizer()
    
    # Recognize the audio data
    audio_data = sr.AudioData(data.tobytes(), sample_rate, data.itemsize)
    
    try:
        text = r.recognize_google(audio_data)
        return text
    except sr.UnknownValueError:
        return "Could not understand audio"
    except sr.RequestError as e:
        return f"Could not request results; {e}"

# Function to read and display audio data
def audio_stream():
    try:
        consecutive_below_threshold = 0
        test_word_threshold = 0
        while True:
            data = np.frombuffer(stream.read(CHUNK_SIZE), dtype=np.int16)
            yield data
            # Check if the maximum value in the data buffer is below 1000
            if np.max(data) < 1000:
                consecutive_below_threshold += 1
                test_word_threshold += 1
                if test_word_threshold >= (RATE // CHUNK_SIZE * 0.2):
                    # print(test_word_threshold)
                    print(transcribe_audio(data))
                    test_word_threshold = 0
                # If consecutive_below_threshold reaches 2 seconds (e.g., 44 samples), stop recording
                if consecutive_below_threshold >= (RATE // CHUNK_SIZE * 2):
                    print("Audio below 1000 for 2 seconds. Stopping recording...")
                    break
            else:
                consecutive_below_threshold = 0
    except KeyboardInterrupt:
        print("Interrupted, closing the stream...")
    finally:
        stream.stop_stream()
        stream.close()
        pa.terminate()

# Start the audio streaming
for audio_data in audio_stream():
    # You can process or visualize the audio data here
    pass
