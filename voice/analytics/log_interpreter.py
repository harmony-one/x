import sys
import re

def omit_logger_header(text):
    pattern = r"^\[\d{2}/\d{2}/\d{4}, \d{2}:\d{2}:\d{2}\.\d+\s*[APM]*\] \[[^\]]+\]"
    result = re.sub(pattern, '', text, count=1)

    return result

def find_last_float(text):
    float_pattern = r'\b\d+(?:\.\d+)?\b'

    matches = re.findall(float_pattern, text)

    return float(matches[-1]) if matches else None

def write_to_outfile(log_file, out_filename):
    parsed_transcript = []
    with open(log_file, 'r') as infile:
        for line in infile:
            if "[Query]" in line:
                parsed_transcript.append({
                    'user': omit_logger_header(line.strip()).strip()
                })
            elif "[Complete Response]" in line:
                parsed_transcript.append({
                    'voiceAI': omit_logger_header(line.strip()).strip()
                })
            elif "Request latency:" in line:
                parsed_transcript.append({
                    'request_latency': find_last_float(line)
                })

    file_text = []
    total_latencies = 0
    num_latencies = 0
    total_responses = 0
    total_requests = 0

    for line in parsed_transcript:
            key, value = list(line.items())[0]
            match key:
                case "user":
                    file_text.append("User: " + value)
                    total_requests += 1
                case "voiceAI":
                    file_text.append("VoiceAI: " + value)
                    total_responses += 1
                case "request_latency":
                    total_latencies += float(value)
                    num_latencies += 1

    file_text.reverse()

    with open(out_filename, 'w') as outfile:
        outfile.write("===== METRICS =====\n")
        outfile.write("Average Latency: " + str(total_latencies/num_latencies) + " secs\n")
        outfile.write("Total User Requests: " + str(total_requests) + "\n")
        outfile.write("Total VoiceAI Responses: " + str(total_responses) + "\n")
        outfile.write("Session Length: ")
        outfile.write("\n===== TRANSCRIPT =====\n")

        outfile.writelines(line + '\n\n' for line in file_text)

if __name__ == "__main__":
    log_file = str(sys.argv[1])
    out_filename = 'parsed_transcript.txt'
    write_to_outfile(log_file, out_filename)