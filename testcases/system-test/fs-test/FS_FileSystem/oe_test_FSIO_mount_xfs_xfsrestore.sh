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
#@Desc      	:   Take the test mount xfs
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL xfsdump
    cur_date=$(date +%Y%m%d%H%M%S)
    point_list=($(CREATE_FS xfs))
    xfs_point=${point_list[1]}
    testFile1="testFile1"$cur_date
    testFile2="testFile2"$cur_date
    echo "Test xfs tmp1" > $xfs_point/$testFile1
    echo "Test xfs tmp2" > $xfs_point/$testFile2
    temp=/tmp/test_tmp$cur_date
    mkdir $temp
    disk=$(lsblk | grep disk | awk '{print $1}' | tail -n 1)
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    xfsdump -f $temp/xfs_dump $xfs_point -L dump_test -M $disk
    rm -rf $xfs_point/$testFile2
    xfsrestore -f $temp/xfs_dump $xfs_point
    CHECK_RESULT $? 0 0 "Restore data for xfs failed."
    ls $xfs_point | grep $testFile2
    CHECK_RESULT $? 0 0 "Check file exist for xfs failed."
    grep "xfs tmp2" $xfs_point/$testFile2
    CHECK_RESULT $? 0 0 "Check files for xfs failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    list=$(echo ${point_list[@]})
    REMOVE_FS "$list"
    rm -rf $temp
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"

