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
ufw default allow incoming
ufw default allow outgoing
ufw default allow FORWARD

# Permettere traffico locale tra container nella rete MZ
ufw allow from 172.22.0.0/16 to any
ufw allow from 172.22.0.0/16 to 172.22.0.0/16

ufw allow proto icmp

# Blocca gli IP di Facebook (aggiorna dinamicamente)
for ip in $(dig +short facebook.com); do
    ufw deny out to $ip
    iptables -A OUTPUT -d $ip -j DROP
    iptables -A FORWARD -d $ip -j DROP
done

# Applica le regole e riavvia il firewall
ufw --force enable
ufw reload

# Mantieni il container attivo
tail -f /dev/null
