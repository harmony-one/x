## Audio Processing in Streaming Conversational Speech System

### Conventional Systems

Conventional speech-based conversational agents (a.k.a. bot, AI) process information by turns:

1. As the user speaks, the agent stays idle and capture the speech into audio signals. 
2. When the user finishes speaking, the agent converts the captured audio signals into text. 
3. After the text-to-speech (STT) conversation is completed, the agent generates a text-based response (via language models). 
4. Afterwards, the agent converts the entire text response into audio signals (TTS). 
5. In the end, the audio signals are played using a media player provided by the operating system.

Implementing a baseline system like the above does not require complex audio processing: we only need a simple audio recording and playback framework (such as web [AudioContext](https://developer.mozilla.org/en-US/docs/Web/API/AudioContext) or [Expo Audio](https://docs.expo.dev/versions/latest/sdk/audio)), and we can safely save intermediary results as files between "turns". Despite a frustrating user experience, the baseline system works, thought the user would have to awkwardly wait for a few seconds between each step. And the user would have to [patiently and painfully wait](https://youtu.be/YOXQM87fy4c?si=6Y4GfNzb3iuZwba6&t=49) for the agent to finish its entire response before telling the agent the next step, even if the agent produces the wrong result. 

### Streaming, Interrupts, and Multi-Response

Apparently, the five steps could be executed simultaneously just like what humans do: as soon as the agent captures enough audio signals (e.g. a few phonemes), the STT system can begin producing some text based on the audio captured so far. Subsequently, the text could be streamed to language models which generates a stream of output text, which pipes into TTS and produces a stream of audio signals, playable as an audio stream. 

But the agent has the potential to perform much better than humans in understanding, processing, and producing speeches. The agent could maintain duplicate audio signals into buffers of different sizes, and formulate the responses (and speeches) using multiple backend systems. Larger buffers and higher quality backend systems are slower to generate results. The agent may need to produce the fast result first (in speech), interrupts itself speaking when a much better result is obtained, then "speaks" the better result.

Similarly, when the agent has no result to present, it needs to ease the awkward silence using some icebreaker or filler sentences, and interrupts itself when results become ready. When these interruptions occur, the agent should handle them smoothly: that means to finish the current word (or phoneme) it is uttering, indicate a sudden transition is about to occur (e.g. say "ah!"), before speaking about the new result. 

In practice, the user may frequently interrupt the agent (via voice commands) and to provide new or additional context. Sometimes the interruptions could come from the operating system (e.g. incoming calls, notification, alerts, other high priority apps). In these scenarios, the agent may also need to fade its speaking volume as soon as possible while simultaneously listen to the user (if not forced to temporarily pause audio capturing), producing new or additional streams of responses. It may even need to interrupt the user at some point when it has a reasonable confidence that it already has all the information needed to produce a response and the user is not adding anything useful.

### Audio Processing Capabilities

To build a conversational agent with a pleasant user experience, we need to choose the right audio processing system that provides sophisticated control and compatibility with streaming, queueing, interruptions, volume control, position seeking, priority setting, recording sample rates and playback quality. It should be capable of providing high throughput callbacks with state and data updates, and fine control over unexpected interruptions and audio sessions.

Not all features are needed from day one, but ideally we should know ahead of time which libraries and framework are only good temporarily, and at which point we would need to switch to more lower-level, platform-specific framework (such as AVFoundation for macOS / iOS) as opposed to platform-agnostic libraries with simple interfaces (such as Expo). At the minimum, the library or framework should support streaming and access to the underlying data buffer, since that would significantly reduce user wait time and improve the user experience. 

### Audio Libraries

Here is a list of libraries and frameworks I have researched so far. I prioritized on React Native libraries, but it seems none of them meet the long term requirements.

The lack of audio support in React Native has been a long-standing issue: https://github.com/facebook/react-native/issues/1179

#### React Native Libraries

##### Expo

A well-maintained platform-agnostic library with iOS, Android, and web support. Expo has basic controls for playback (position seeking, play, stop, volume), but does not support streaming for recording., but controls are asynchronous and does not seem to have guarantee of success. No callback on interrupts or immediate state change feedback, only supports periodical status reporting

- Documentation: https://docs.expo.dev/versions/latest/sdk/audio/
- Package: https://www.npmjs.com/package/expo-av
- Code: https://github.com/expo/expo/tree/sdk-49/packages/expo-av

##### React Native Sound

An outdated library (last update 2-4 years ago), not supporting streaming due to underlying (outdated) native library limitation (https://github.com/zmxv/react-native-sound/issues/353). The author recommends using https://github.com/react-native-video/react-native-video for streaming audio

Code and documentation: https://github.com/zmxv/react-native-sound

##### React Native Audio Toolkit

A stalled project (see [issue](https://github.com/react-native-audio-toolkit/react-native-audio-toolkit/issues/83)). It supports streaming but only for simple sources (e.g. http destination), not necessarily local buffers https://github.com/react-native-audio-toolkit/react-native-audio-toolkit/blob/master/docs/SOURCES.md

Code and documentation: https://github.com/react-native-audio-toolkit/react-native-audio-toolkit

##### React Native Video

It has more complete support for sources, but does not explicitly support buffer as source https://github.com/react-native-video/react-native-video/blob/master/API.md#source. The instance may be set in "audio only" mode https://github.com/react-native-video/react-native-video/blob/master/API.md#configurable-props

Code and documentation: https://github.com/react-native-video/react-native-video

##### React Native Audio Recorder Player

The library is more actively maintained, has both audio player and recorder, but does not support streaming; Only supports writing audio data to file
It has flooding (crash) issues when status updates (without data) is requested at a high frequency https://github.com/hyochan/react-native-audio-recorder-player/issues/273

Code and documentation:  https://github.com/hyochan/react-native-audio-recorder-player/

##### React Native Microphone Stream

The library is out-of-maintenance, and is allegedly not working https://stackoverflow.com/questions/59880942/how-to-capture-microphone-audio-on-react-native-and-stream-it-to-icecast-endpoin

Code and documentation: https://github.com/chadsmith/react-native-microphone-stream

#### iOS / macOS Native Framework

The audio is based on AVFoundation, and has extensive documentation (Swift / Objective-C) https://developer.apple.com/av-foundation/

For example, there is explicit support for streaming in Core Audio: https://developer.apple.com/library/archive/documentation/MusicAudio/Conceptual/CoreAudioOverview/CoreAudioEssentials/CoreAudioEssentials.html#//apple_ref/doc/uid/TP40003577-CH10-SW33

Detailed documentation for recording and playing (interruptable) audio using Audio Queue with stream: https://developer.apple.com/library/archive/documentation/MusicAudio/Conceptual/CoreAudioOverview/CoreAudioEssentials/CoreAudioEssentials.html#//apple_ref/doc/uid/TP40003577-CH10-SW32

Audio buffer is directly accessible when audio is captured via stream, see Stackoverflow post: https://stackoverflow.com/questions/49517532/can-i-use-avaudiorecorder-for-sending-a-stream-of-recordings-to-server

Audio can be played by streaming a local buffer or file Streaming playback support: https://developer.apple.com/library/archive/qa/qa1634/_index.html

Audio interruption can be controlled and communicated with the operating system: https://developer.apple.com/library/archive/documentation/MusicAudio/Conceptual/CoreAudioOverview/CoreAudioEssentials/CoreAudioEssentials.html#//apple_ref/doc/uid/TP40003577-CH10-SW41

Full documentation of Core Audio: https://developer.apple.com/library/archive/documentation/MusicAudio/Conceptual/CoreAudioOverview/CoreAudioEssentials/CoreAudioEssentials.html#//apple_ref/doc/uid/TP40003577-CH10-SW1