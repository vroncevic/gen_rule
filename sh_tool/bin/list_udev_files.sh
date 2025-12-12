#!/bin/bash
#
# @brief   UDEV rule generator
# @version ver.4.0
# @date    Thu 02 Dec 2021 01:18:25 AM CET
# @company None, free software to use 2021
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
UTIL_ROOT=/root/scripts
UTIL_VERSION=ver.1.0
UTIL=${UTIL_ROOT}/sh_util/${UTIL_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/load_util_conf.sh

GEN_RULE_TOOL=gen_rule

declare -A GEN_RULE_LIST_UDEV_FILES_USAGE=(
    [USAGE_TOOL]="__list_udev_files"
    [USAGE_ARG1]="[RULE_DIR] Rule install directory"
    [USAGE_ARG1]="[RULE_CFG] Configuration file path"
    [USAGE_EX_PRE]="# Listing UDEV rules"
    [USAGE_EX]="__list_udev_files \$LIST_SETUP"
)

#
# @brief  List UDEV rule files
# @param  Required list setup (rule install dir and rule configuration file)
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __list_udev_files $LIST_SETUP
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function __list_udev_files {
    local -n LIST_SETUP=$1
    if [ -z "${LIST_SETUP[RULE_DIR]}" || -z "${LIST_SETUP[RULE_CFG]}" ]; then
        usage GEN_RULE_LIST_UDEV_FILES_USAGE
        return $NOT_SUCCESS
    fi
    local FUNC=${FUNCNAME[0]} MSG="None" STATUS I
    MSG="Listing udev rule templates"
    info_debug_message "$MSG" "$FUNC" "$GEN_RULE_TOOL"
    declare -A rule_names=()
    load_util_conf "${LIST_SETUP[RULE_CFG]}" rule_names
    STATUS=$?
    if [ $STATUS -eq $NOT_SUCCESS ]; then
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$GEN_RULE_TOOL"
        return $NOT_SUCCESS
    fi
    for I in "${!rule_names[@]}"
    do
        local rule_file="${LIST_SETUP[RULE_DIR]}/${rule_names[$I]}"
        if [ -e "${rule_file}" ]; then
            printf "%s\n" "Target device board [${I}] rule installed"
        else
            printf "%s\n" "Target device board [${I}] rule NOT installed"
        fi
    done
    info_debug_message_end "Done" "$FUNC" "$GEN_RULE_TOOL"
    return $SUCCESS
}

