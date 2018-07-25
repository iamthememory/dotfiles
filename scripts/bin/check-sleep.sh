#!/usr/bin/env bash

# Check whether to sleep.

sleepthresh=10

acpi -b | awk -F'[,:%]' '{print $2, $3}' | {
  read -r status capacity

  if [ "$status" = "Discharging" -a "$capacity" -lt "$sleepthresh" ]
  then
    logger "Discharged below critical battery threshold (${sleepthresh}%), suspending..."
    systemctl suspend
  fi
}
