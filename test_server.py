import requests


with open('ip_address.txt', 'r') as file:
    data = file.read().replace('\n', '')

def main():
    make_request("car")
    make_request("bike")
    make_request("foot")


def make_request(vehicle_type):
    r = requests.get("http://" + data + "/route?point=33.732321,-84.283587&point=33.704363,-84.30834&vehicle=" + vehicle_type)
    print(r.text)

    

if __name__ == "__main__":
    main()
