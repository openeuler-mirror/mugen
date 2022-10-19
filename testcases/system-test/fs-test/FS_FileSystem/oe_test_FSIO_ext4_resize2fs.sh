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
#@Date      	:   2020-12-08
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test mount ext3
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    point_list=($(CREATE_FS ext3))
    vggroup=${point_list[0]}
    ext4_point=${point_list[1]}
    lv=$(lsblk | grep $vggroup | awk '{print $1}' | cut -d '-' -f 2)
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    size1=$(df -i | grep /dev/mapper/$vggroup-$lv | awk '{print $2}')
    umount /dev/$vggroup/$lv
    e2fsck -fp /dev/$vggroup/$lv
    lvresize -L +1G /dev/$vggroup/$lv
    resize2fs /dev/$vggroup/$lv 6262
    CHECK_RESULT $? 0 0 "Change size of ext3 failed."
    mount /dev/$vggroup/$lv $ext4_point
    size2=$(df -i | grep /dev/mapper/$vggroup-$lv | awk '{print $2}')
    [[ "$size1" -ne "$size2" ]]
    CHECK_RESULT $? 0 0 "Resize for ext3 failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    list=$(echo ${point_list[@]})
    REMOVE_FS "$list"
    LOG_INFO "End to restore the test environment."
}

main "$@"

