# DNS
netsh advfirewall firewall add rule name="LANCache DNS UDP 53 (LAN only)" dir=in action=allow protocol=UDP localport=53 remoteip=192.168.50.0/24
netsh advfirewall firewall add rule name="LANCache DNS TCP 53 (LAN only)" dir=in action=allow protocol=TCP localport=53 remoteip=192.168.50.0/24

# HTTP
netsh advfirewall firewall add rule name="LANCache HTTP 80 (LAN only)" dir=in action=allow protocol=TCP localport=80 remoteip=192.168.50.0/24

# HTTPS
netsh advfirewall firewall add rule name="LANCache HTTPS 443 (LAN only)" dir=in action=allow protocol=TCP localport=443 remoteip=192.168.50.0/24
