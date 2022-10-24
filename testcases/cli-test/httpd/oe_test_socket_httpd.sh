#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zengcongwei
# @Contact   :   735811396@qq.com
# @Date      :   2020/12/29
# @License   :   Mulan PSL v2
# @Desc      :   Test httpd.socket restart
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL httpd
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    test_execution httpd.socket
    test_reload httpd.socket
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop httpd.socket
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
