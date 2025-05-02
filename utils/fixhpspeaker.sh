#!/usr/bin/env bash

until [ -e /dev/snd/hwC0D0 ]; do
		sleep 1;
done

sudo hda-verb /dev/snd/hwC0D0 0x01 SET_GPIO_DIR 0x01
sudo hda-verb /dev/snd/hwC0D0 0x01 SET_GPIO_MASK 0x01
sudo hda-verb /dev/snd/hwC0D0 0x01 SET_GPIO_DATA 0x01
sudo hda-verb /dev/snd/hwC0D0 0x01 SET_GPIO_DATA 0x00
