#!/bin/sh

ip route replace default via 172.22.0.3

# Keep the container running
tail -f /dev/null