#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test network.service restart
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    P_SSH_CMD --cmd "dnf install -y network-scripts" --node 2
    service=network.service
    log_time=$(date '+%Y-%m-%d %T')
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    P_SSH_CMD --cmd "systemctl restart ${service}" --node 2
    CHECK_RESULT $? 0 0 "${service} restart failed"
    SLEEP_WAIT 5
    P_SSH_CMD --cmd "systemctl status ${service} | grep 'Active: active'" --node 2
    CHECK_RESULT $? 0 0 "${service} restart failed"
    P_SSH_CMD --cmd "journalct --since '${log_time}' -u ${service} | grep -i 'fail\|error' | grep -v -i 'DEBUG\|INFO\|WARNING'" --node 2
    CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
    P_SSH_CMD --cmd "systemctl start ${service}
    systemctl reload ${service} 2>&1 | grep 'Job type reload is not applicable'" --node 2
    CHECK_RESULT $? 0 0 "Job type reload is not applicable for unit ${service}"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    P_SSH_CMD --cmd "dnf remove -y network-scripts" --node 2
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
