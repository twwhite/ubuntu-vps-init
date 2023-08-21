#!/bin/bash

# Services
sudo chmod a+x ./services/user/*

cd ./services/user/
for service in *.service; do
	cp $service /etc/systemd/system/
	sudo systemctl enable $service
	sudo systemctl start $service
done
