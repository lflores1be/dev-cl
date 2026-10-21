import requests
import xml.etree.ElementTree as ET

# bucket de pruebas migracion (fase T) - listado publico, no requiere keys
BUCKET_URL = "https://andino-docs.s3.sa-east-1.amazonaws.com/"
PREFIXES = ["migracion/", "finanzas_y_legal/", "operaciones/", "politicas/", "otros/"]
NS = {"s3": "http://s3.amazonaws.com/doc/2006-03-01/"}
TIMEOUT = 10

def list_prefix(prefix):
    objects, size, token = 0, 0, None
    while True:
        params = {"list-type": "2", "prefix": prefix}
        if token:
            params["continuation-token"] = token
        r = requests.get(BUCKET_URL, params=params, timeout=TIMEOUT)
        r.raise_for_status()
        root = ET.fromstring(r.content)
        for obj in root.findall("s3:Contents", NS):
            objects += 1
            size += int(obj.find("s3:Size", NS).text)
        if root.findtext("s3:IsTruncated", namespaces=NS) != "true":
            return objects, size
        token = root.findtext("s3:NextContinuationToken", namespaces=NS)

def migration_status():
    for prefix in PREFIXES:
        try:
            objects, size = list_prefix(prefix)
            print(f"{prefix:<18} | Objects: {objects:>5} | {size / (1024**2):.2f} MB")
        except Exception as e:
            print(f"{prefix:<18} | ERROR: {e}")

if __name__ == "__main__":
    migration_status()
