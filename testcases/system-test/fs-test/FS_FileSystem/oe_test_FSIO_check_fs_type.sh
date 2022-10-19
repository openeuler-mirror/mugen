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
#@Date      	:   2020-12-07
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test check fs type which OS supports
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    config=$(ls /lib/modules)
    ls /lib/modules/$config/kernel/fs | grep ext4
    CHECK_RESULT $? 0 0 "The system doesn't support ext4."
    ls /lib/modules/$config/kernel/fs | grep xfs
    CHECK_RESULT $? 0 0 "The system doesn't support xfs."
    ls /lib/modules/$config/kernel/fs | grep nfs
    CHECK_RESULT $? 0 0 "The system doesn't support nfs."
    ls /lib/modules/$config/kernel/fs | grep overlayfs
    CHECK_RESULT $? 0 0 "The system doesn't support overlayfs."
    LOG_INFO "End to run test."
}

main "$@"

