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
#@Date      	:   2020-12-11
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test mount on character device
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    cur_lang=$LANG
    export LANG=en_US.UTF-8
    cur_date=$(date +%Y%m%d%H%M%S)
    vggroup=$(CREATE_VG)
    lv1="test_lv1"$cur_date
    lv2="test_lv2"$cur_date
    lv3="test_lv3"$cur_date
    lvcreate -n $lv1 -L 2G $vggroup -y >/dev/null
    lvcreate -n $lv2 -L 2G $vggroup -y >/dev/null
    lvcreate -n $lv3 -L 2G $vggroup -y >/dev/null
    mkfs.ext3 /dev/$vggroup/$lv1
    mkfs.ext4 /dev/$vggroup/$lv2
    mkfs.xfs /dev/$vggroup/$lv3
    charc="/mnt/testc"$cur_date
    mknod $charc c  1 1
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    mount /dev/$vggroup/$lv1 $charc 2>&1 | grep "mount point is not a directory"
    CHECK_RESULT $? 0 0 "mount ext3 on character block unexpectly."
    mount /dev/$vggroup/$lv2 $charc 2>&1 | grep "mount point is not a directory"
    CHECK_RESULT $? 0 0 "mount ext4 on character block unexpectly."
    mount /dev/$vggroup/$lv3 $charc 2>&1 | grep "mount point is not a directory"
    CHECK_RESULT $? 0 0 "mount xfs on character block unexpectly."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf $charc 
    DELETE_LV /dev/$vggroup/$lv1 
    DELETE_LV /dev/$vggroup/$lv2 
    DELETE_LV /dev/$vggroup/$lv3
    export LANG=$cur_lang
    LOG_INFO "End to restore the test environment."
}

main "$@"

