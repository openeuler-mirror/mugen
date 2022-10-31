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
#@Date      	:   2020-12-10
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test mount xfs
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL xfsdump
    cur_date=$(date +%Y%m%d%H%M%S)
    point_list=($(CREATE_FS xfs))
    vggroup=${point_list[0]}
    xfs_point=${point_list[1]}
    testFile="testFile"$cur_date
    echo "Test xfs tmp" >$xfs_point/$testFile
    temp=/tmp/test_tmp$cur_date
    mkdir $temp
    disk=$(lsblk | grep disk | awk '{print $1}' | tail -n 1)
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    xfsdump -f $temp/dumpfile $xfs_point -L dump_test -M $disk
    test -f $temp/dumpfile
    CHECK_RESULT $? 0 0 "Dump files for xfs failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    REMOVE_FS $xfs_point
    rm -rf $temp
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"

