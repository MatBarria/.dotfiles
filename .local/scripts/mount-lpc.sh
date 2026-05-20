#!/bin/bash

MOUNTPOINT="/home/truga/projects/nobackup_lpc"
REMOTE="mbarrial@cmslpc-el9.fnal.gov:/uscms_data/d1/mbarrial/"

mkdir -p "$MOUNTPOINT"

sshfs -p 22 "$REMOTE" "$MOUNTPOINT" \
  -o reconnect \
  -o ServerAliveInterval=15 \
  -o ServerAliveCountMax=3 \
  -o TCPKeepAlive=yes \
  -o auto_cache \
  -o kernel_cache \
  -o follow_symlinks

echo "nobackup_lpc mounted!"

