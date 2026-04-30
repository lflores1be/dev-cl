import requests
import time

TARGETS = ["https://pasarela.pago-veloz.com/"]
TIMEOUT = 5
RETRIES = 3

def monitor_endpoints():
    for url in TARGETS:
        latencies = []
        for _ in range(RETRIES):
            try:
                start = time.time()
                r = requests.get(url, timeout=TIMEOUT)
                latencies.append(time.time() - start)
            except Exception:
                latencies.append(None)
        
        valid_latencies = [l for l in latencies if l is not None]
        if valid_latencies:
            avg_lat = sum(valid_latencies) / len(valid_latencies)
            print(f"URL: {url} | Status: OK | Avg Latency: {avg_lat:.4f}s")
        else:
            print(f"URL: {url} | Status: DOWN")

if __name__ == "__main__":
    monitor_endpoints()