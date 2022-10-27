#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   @meitingli
#@Contact   	:   bubble_mt@outlook.com
#@Date      	:   2020-12-21
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test mount fs on loop device
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    cur_date=$(date +%Y%m%d%H%M%S)
    virtualfs="/mnt/virtualfs_"$cur_date
    dd if=/dev/zero of=$virtualfs bs=1024 count=30720
    point="/mnt/point_"$cur_date
    mkdir $point
    list=('ext3' 'ext4' 'xfs')
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    for var in ${list[@]}; do
        loop=$(losetup -f)
        mknod -m 0660 $loop b 7 0
        losetup $loop $virtualfs
        if [[ "$var" =~ "ext" ]];then
            mkfs -t $var -m 1 -v $loop
        else
            mkfs -t $var -d name=$loop -f
        fi 
        CHECK_RESULT $? 0 0 "mkfs $var for $loop failed."
        mount -t $var $loop $point
        df -T | grep $loop | grep $var
        CHECK_RESULT $? 0 0 "Mount fs $var on $loop failed."
        umount $point
        CHECK_RESULT $? 0 0 "Umount fs $var on $loop failed."
        losetup -d $loop
        rm -rf $loop
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf $loop $point $virtualfs
    LOG_INFO "End to restore the test environment."
}

main "$@"

