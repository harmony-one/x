import {StackLimited} from "../../utils/stack-limited";

interface Options {
  stream: MediaStream
  intervalMs?: number
  durationMs?: number
  threshold?: number
  onUpdate?: (value: number) => void
  onDetect: (flag: boolean) => void
}

export function watchMicAmplitude(options: Options): () => void {
  const { stream, intervalMs = 50, durationMs = 500, threshold = 1, onDetect } = options;

  const audioContext = new window.AudioContext();
  const analyser = audioContext.createAnalyser();
  const dataArray = new Uint8Array(analyser.frequencyBinCount);
  analyser.fftSize = 256;

  const source = audioContext.createMediaStreamSource(stream);
  source.connect(analyser);

  const stackLimit = Math.round(durationMs / intervalMs)
  const micData = new StackLimited(stackLimit)

  let isThresholdReached = false;

  function measureMicrophoneLevel(): ReturnType<typeof setTimeout> {
    analyser.getByteFrequencyData(dataArray);

    const average = dataArray.reduce((acc, value) => acc + value, 0) / dataArray.length;

    micData.push(average)

    const avgByDuration = micData.stack.reduce((acc, value) => acc + value, 0) / micData.stack.length

    options.onUpdate && options.onUpdate(avgByDuration)

    if (micData.size() === stackLimit && avgByDuration >= threshold && !isThresholdReached) {
      isThresholdReached = true
      onDetect(isThresholdReached)
    }

    if (avgByDuration < threshold && isThresholdReached) {
      isThresholdReached = false
      setTimeout(() => onDetect(isThresholdReached), 0)
    }

    return setTimeout(measureMicrophoneLevel, intervalMs)
  }

  const timeout = measureMicrophoneLevel();

  return () => clearTimeout(timeout);
}