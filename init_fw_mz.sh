#!/bin/sh

ip route replace default via 172.23.0.4

# Keep the container running
tail -f /dev/null