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
#@Date      	:   2020-12-15
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test change fs
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    cur_date=$(date +%Y%m%d%H%M%S)
    vggroup=$(CREATE_VG)
    lv1="test_lv1"$cur_date
    lvcreate -n $lv1 -L 2G $vggroup -y >/dev/null
    mkfs.ext3 /dev/$vggroup/$lv1
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo y | mkfs.ext4 /dev/$vggroup/$lv1
    CHECK_RESULT $? 0 0 "mkfs from ext3 to ext4 failed."
    echo y | mkfs.ext3 /dev/$vggroup/$lv1
    CHECK_RESULT $? 0 0 "mkfs from ext4 to ext3 failed."
    mkfs.xfs /dev/$vggroup/$lv1 -f
    CHECK_RESULT $? 0 0 "mkfs from ext3 to xfs failed."
    echo y | mkfs.ext4 /dev/$vggroup/$lv1
    CHECK_RESULT $? 0 0 "mkfs from xfs to ext4 failed."
    LOG_INFO "End to run test."
}

main "$@"

