#!/bin/bash
init_dir=/usr/local/src

function conda(){
        if [ `id -u` -eq 0 ];then
                if [ `pwd` != $init_dir ];then
                        mv Anaconda3-4.2.0-Linux-x86_64.sh $init_dir
                fi
                if [ -d $init_dir/anaconda3 ];then
                        rm -rf $init_dir/anaconda3
                fi
                bash $init_dir/Anaconda3-4.2.0-Linux-x86_64.sh
                return 0
        else
                echo "Please switch to root and execute the script!!!"
                exit 1
        fi   
}

function pycharm(){
        conda
        if [ $? -eq 0 ];then
                if [ `pwd` != $init_dir ];then
                        mv pycharm-community-2019.1.2.tar.gz $init_dir
                fi
                tar -zxf ${init_dir}/pycharm-community-2019.1.2.tar.gz -C $init_dir
                return 0
        fi
}

pycharm
if [ $? -eq 0 ];then
        . ~/.bashrc
        if [ $? -eq 0 ];then
                python -m pip install --upgrade pip
                echo "installed successfully!!!"
                if [ $? -eq 0 ];then
                        if [ `pip -V | cut -f 2 -d " "`=="19.1.1" -a `pip -V | cut -f 4 -d " " | cut -f 7 -d "/"`=="python3.5" ];then
                                pip install --upgrade tensorflow
                                echo "tensorflow installed successfully!!!"
                                exit 1
                        fi
                fi        
        fi
        exit 1
fi



