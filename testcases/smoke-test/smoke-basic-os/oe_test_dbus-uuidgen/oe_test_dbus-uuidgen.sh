#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2022/06/08
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of dbus-uuidgen
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    dbus-uuidgen
    CHECK_RESULT $? 0 0 "Failed to execute dbus-uuidgen"
    dbus-uuidgen | wc -L | grep 32
    CHECK_RESULT $? 0 0 "Failed to get the number of uuids"
    LOG_INFO "End to run test."
}

main "$@"
