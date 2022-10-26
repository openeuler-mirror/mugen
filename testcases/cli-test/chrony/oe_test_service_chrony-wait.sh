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
# @Desc      :   Test chrony-wait.service restart
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    P_SSH_CMD --cmd "cp /etc/chrony.conf /etc/chrony.conf_bak;sed -i 's/^pool/#pool/' /etc/chrony.conf;sed -i 's/^#allow.*/allow all/' /etc/chrony.conf;sed -i 's/^#local.*/local/' /etc/chrony.conf;systemctl restart chronyd.service;systemctl stop firewalld.service" --node 2
    cp /etc/chrony.conf /etc/chrony.conf_bak
    sed -i 's/^pool.*/server '${NODE2_IPV4}' iburst minpoll 3 maxpoll 3/' /etc/chrony.conf
    sed -i 's/^#allow.*/allow all/' /etc/chrony.conf
    sed -i 's/^#local/local/' /etc/chrony.conf
    systemctl restart chronyd.service
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution chrony-wait.service
    test_reload chrony-wait.service
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop chrony-wait.service
    \cp -f /etc/chrony.conf_bak /etc/chrony.conf
    systemctl restart chronyd.service
    P_SSH_CMD --cmd "\cp -f /etc/chrony.conf_bak /etc/chrony.conf;systemctl restart chronyd.service;systemctl start firewalld.service" --node 2
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
