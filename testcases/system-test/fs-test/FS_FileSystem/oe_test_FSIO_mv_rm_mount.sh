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
#@Desc      	:   Take the test mv/rm mounted point
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    cur_lang=$LANG
    export LANG=en_US.UTF-8
    point_list=($(CREATE_FS ext3))
    ext3_point=${point_list[1]}
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    mv $ext3_point /mnt/testmv$cur_date 2>&1 | grep "Device or resource busy"
    CHECK_RESULT $? 0 0 "Move mounted point unexpectly."
    rm -rf $ext3_point 2>&1 | grep "Device or resource busy"
    CHECK_RESULT $? 0 0 "Remove mounted point unexpectly."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    list=$(echo ${point_list[@]})
    REMOVE_FS "$list"
    rm -rf /mnt/testmv$cur_date
    export LANG=$cur_lang
    LOG_INFO "End to restore the test environment."
}

main "$@"

