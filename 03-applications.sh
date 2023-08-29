#!/bin/bash

(crontab -l ; echo "@hourly /home/tim/twio/scripts/recurring/hourly.sh") | crontab -
(crontab -l ; echo "@daily /home/tim/twio/scripts/recurring/daily.sh") | crontab -


# Set up letsencrypt directory with user permissions
sudo mkdir /letsencrypt
sudo chown -R tim:tim /letsencrypt
