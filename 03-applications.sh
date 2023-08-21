#!/bin/bash

(crontab -l ; echo "@hourly /home/tim/twio/scripts/recurring/hourly.sh") | crontab -
(crontab -l ; echo "@daily /home/tim/twio/scripts/recurring/daily.sh") | crontab -

