#!/usr/bin/with-contenv bash

minute=$(echo $RANDOM % 60 | bc)
hour=$(echo $RANDOM % 23 | bc)
day=$(echo $RANDOM % 27 + 1 | bc)

CRON_FREQUENCY=${CRON_FREQUENCY:-"$minute $hour $day * *"}

echo "$CRON_FREQUENCY run-parts /etc/periodic/once_per_day" >> /etc/crontabs/root