#!/bin/bash

# Installare UFW, dnsutils e iptables
apt-get update
apt-get install -y ufw dnsutils iptables

echo "1" > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Passare a iptables-legacy per evitare problemi di compatibilità
update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
update-alternatives --set iptables-restore /usr/sbin/iptables-legacy-restore
update-alternatives --set iptables-save /usr/sbin/iptables-legacy-save

# Politiche predefinite
ufw default deny incoming
ufw default deny outgoing
ufw default allow FORWARD

# Permettere traffico locale tra container nella rete MZ
ufw allow from 172.23.0.0/16 to any
ufw allow from 172.23.0.0/16 to 172.23.0.0/16

# Disabilitare tutte le connessioni in uscita (ad eccezione di quelle necessarie internamente)
ufw default deny outgoing

ufw allow proto icmp

# Abilitare UFW
ufw --force enable

# Mantenere il container in esecuzione
tail -f /dev/null