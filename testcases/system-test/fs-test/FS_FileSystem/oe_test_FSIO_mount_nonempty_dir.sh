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
#@Desc      	:   Take the test mount fs on non-empty directory
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    cur_date=$(date +%Y%m%d%H%M%S)
    vggroup=$(CREATE_VG)
    list=('ext3' 'ext4' 'xfs')
    count=1
    for var in ${list[@]}; do
        lvcreate -n lv$count$cur_date -L 2G $vggroup -y >/dev/null 
        mkfs -t $var /dev/$vggroup/lv$count$cur_date
        mkdir /mnt/point$count$cur_date
        echo "test" > /mnt/point$count$cur_date/testFile
        count=$(($count+1))
    done
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    count=1
    for var in ${list[@]}; do
        mount /dev/$vggroup/lv$count$cur_date /mnt/point$count$cur_date
        CHECK_RESULT $? 0 0 "Mount $var on non-empty directory failed."
        test -f /mnt/point$count$cur_date/testFile
        CHECK_RESULT $? 1 0 "Check file on $var after mount failed."
        umount /mnt/point$count$cur_date
        CHECK_RESULT $? 0 0 "Umount $var on non-empty directory failed."
        grep "test" /mnt/point$count$cur_date/testFile
        CHECK_RESULT $? 0 0 "Check file on $var after umount failed."
        count=$(($count+1))
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /mnt/point1$cur_date /mnt/point2$cur_date /mnt/point3$cur_date
    LOG_INFO "End to restore the test environment."
}

main "$@"
