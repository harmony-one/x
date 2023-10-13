import {StackLimited} from "../../utils/stack-limited";

interface Options {
  stream: MediaStream
  intervalMs?: number
  durationMs?: number
  threshold?: number
  callback: (flag: boolean) => void
}

export function watchMicAmplitude(options: Options) {
  const { stream, intervalMs = 100, durationMs = 1000, threshold = 3, callback } = options;

  const audioContext = new window.AudioContext();
  const analyser = audioContext.createAnalyser();
  const dataArray = new Uint8Array(analyser.frequencyBinCount);
  analyser.fftSize = 256;

  const source = audioContext.createMediaStreamSource(stream);
  source.connect(analyser);

  const limit = Math.round(durationMs / intervalMs)
  const micData = new StackLimited(limit)

  let isThresholdReached = false;

  function measureMicrophoneLevel() {
    analyser.getByteFrequencyData(dataArray);

    const average = dataArray.reduce((acc, value) => acc + value, 0) / dataArray.length;

    micData.push(average)

    // console.log('### micData', micData.size());
    const avgByDuration = micData.stack.reduce((acc, value) => acc + value, 0) / micData.stack.length


    if (micData.size() === limit && avgByDuration >= threshold && !isThresholdReached) {
      isThresholdReached = true
      callback(isThresholdReached)
    }

    if (avgByDuration < threshold && isThresholdReached) {
      isThresholdReached = false
      callback(isThresholdReached)
    }

    setTimeout(measureMicrophoneLevel, intervalMs)

    // requestAnimationFrame(measureMicrophoneLevel);

  }

  measureMicrophoneLevel();

  return;
}