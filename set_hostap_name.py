import os
import re
from netifaces import ifaddresses, AF_INET, AF_LINK

class WiFi(object):
    def __init__(self, interface, hostapd_config="/etc/hostapd/hostapd.conf", hostname_config='/etc/hostname'):
        self.interface = interface
        self.hostapd_path = hostapd_config
        self.hostname_path = hostname_config

    def get_device_mac(self):
        try:
            return ifaddresses(self.interface)[AF_LINK][0]['addr']
        except KeyError:
            return "00:00:00:00:00:00"

    def get_device_ip(self):
        try:
            return ifaddresses(self.interface)[AF_INET][0]['addr']
        except KeyError:
            return "127.0.0.1"

    def replace(self, pattern, text, file):
        with open(file, 'r', 0) as data_file:
            data = data_file.read()
        old = re.search(pattern, data, re.MULTILINE).group(0)
        with open(file, 'w', 0) as data_file:
            data_file.write(data.replace(old, text))
            data_file.flush()
            os.fsync(data_file)

    def set_hostap_name(self, name='reach'):
        mac_addr = self.get_device_mac()[-6:]
        self.replace("^ssid=.*", "ssid={}{}".format(name, mac_addr), self.hostapd_path)

if __name__ == '__main__':
    wifi = WiFi('wlan0')
    print(wifi.get_device_ip())
    print(wifi.get_device_mac())

