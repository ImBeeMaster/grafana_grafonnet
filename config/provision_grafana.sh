#! /bin/bash


cp -R $(dirname ${0})/* /etc/grafana/ && systemctl restart grafana-server