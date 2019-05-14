#!/bin/bash
#author:elegant
#date:20190514
printf "
#######################################################################
#                      View server startup status                     #
#######################################################################
"
while :; do echo
  echo "Enter servername:(执行：ctrl+c可强制退出)"
  echo -e "\033[31m \t${CMSG}1${CEND}. nginx-rtmp-service \033[0m"
  echo -e "\033[31m \t${CMSG}2${CEND}. emqx-service \033[0m"
  echo -e "\033[31m \t${CMSG}3${CEND}. ftp-service \033[0m"
  echo -e "\033[31m \t${CMSG}4${CEND}. sql-service \033[0m"
  echo -e "\033[31m \t${CMSG}5${CEND}. redis-service \033[0m"
  read -e -p "Please input a number: " number
  if [ "$number" = '1' ]; then
    systemctl status nginx.service
    echo -e "\033[32;49;1m ******************************************************************************* \033[39;49;0m"
  elif [ "$number" = '2' ]; then
    systemctl status emqx
    echo -e "\033[32;49;1m ******************************************************************************* \033[39;49;0m"
  elif [ "$number" = '3' ]; then
    service pureftpd status
    echo -e "\033[32;49;1m ******************************************************************************* \033[39;49;0m"
  elif [ "$number" = '4' ]; then
    service mssql-server status
    echo -e "\033[32;49;1m ******************************************************************************* \033[39;49;0m"
  elif [ "$number" = '5' ]; then
    systemctl status redis-server.service
  else
    exit 1
  fi
done
