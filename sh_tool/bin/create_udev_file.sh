#!/bin/bash
#
# @brief   UDEV rule creator
# @version ver.4.0
# @date    Thu 02 Dec 2021 01:18:25 AM CET
# @company None, free software to use 2021
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
UTIL_ROOT=/root/scripts
UTIL_VERSION=ver.1.0
UTIL=${UTIL_ROOT}/sh_util/${UTIL_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/check_tool.sh
.    ${UTIL}/bin/load_util_conf.sh

GEN_RULE_TOOL=gen_rule
GEN_RULE_VERSION=ver.4.0
GEN_RULE_HOME=${UTIL_ROOT}/${GEN_RULE_TOOL}/${GEN_RULE_VERSION}

declare -A GEN_RULE_CREATE_UDEV_RULE_USAGE=(
    [USAGE_TOOL]="__create_udev_file"
    [USAGE_ARG1]="[UDEV_TOOL] Name of target board"
    [USAGE_ARG2]="[TARGET_DEVICE] Name of target board"
    [USAGE_ARG3]="[CFG_TEMPLATES] Config file with templates"
    [USAGE_ARG4]="[UDEV_FILE] Name of UDEV rule file to create"
    [USAGE_EX_PRE]="# Creating UDEV rule file"
    [USAGE_EX]="__create_udev_file \$UDEV_SETUP"
)

#
# @brief  Creating UDEV rule in system
# @param  Value required UDEV setup configuration
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __create_udev_file $UDEV_SETUP
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
function __create_udev_file {
    local -n UDEV_SETUP=$1
    declare -A MISSING_VALUES=()
    if [ -z "${UDEV_SETUP[UDEV_TOOL]}" ]; then MISSING_VALUES+=("UDEV_TOOL"); fi
    if [ -z "${UDEV_SETUP[TARGET_DEVICE]}" ]; then MISSING_VALUES+=("TARGET_DEVICE"); fi
    if [ -z "${UDEV_SETUP[CFG_TEMPLATES]}" ]; then MISSING_VALUES+=("CFG_TEMPLATES"); fi
    if [ -z "${UDEV_SETUP[UDEV_FILE]}" ]; then MISSING_VALUES+=("UDEV_FILE"); fi
    if [ ${#MISSING_VALUES[@]} -ne 0 ]; then
        usage GEN_RULE_CREATE_UDEV_RULE_USAGE
        return $NOT_SUCCESS
    fi
    local FUNC=${FUNCNAME[0]} MSG="None" STATUS
    MSG="Generate udev rule!"
    info_debug_message "$MSG" "$FUNC" "$GEN_RULE_TOOL"
    declare -A rule_templates=()
    load_util_conf "${UDEV_SETUP[CFG_TEMPLATES]}" rule_templates
    STATUS=$?
    if [ $STATUS -eq $NOT_SUCCESS ]; then
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$GEN_RULE_TOOL"
        return $NOT_SUCCESS
    fi
    local UDEVT="${rule_templates[${UDEV_SETUP[TARGET_DEVICE]}]}" H="#"
    local UDEVTF="${GEN_RULE_HOME}/conf/${UDEVT}"
    MSG="Generate file [${UDEV_SETUP[UDEV_FILE]}]"
    info_debug_message "$MSG" "$FUNC" "$GEN_RULE_TOOL"
    while read UDEVL
    do
        eval echo "${UDEVL}" >> ${UDEV_SETUP[UDEV_FILE]}
    done < ${UDEVTF}
    MSG="Set permission!"
    info_debug_message "$MSG" "$FUNC" "$GEN_RULE_TOOL"
    eval "chmod 644 ${UDEV_SETUP[UDEV_FILE]}"
    local UDEVTOOL=${UDEV_SETUP[UDEV_TOOL]}
    check_tool "${UDEVTOOL}"
    STATUS=$?
    if [ $STATUS -eq $SUCCESS ]; then
        eval "${UDEVTOOL}"
    else
        MSG="Generate file [${UDEV_SETUP[UDEV_FILE]}] with udevadm"
        info_debug_message "$MSG" "$FUNC" "$GEN_RULE_TOOL"
        eval "udevadm control --reload"
    fi
    info_debug_message_end "Done" "$FUNC" "$GEN_RULE_TOOL"
    return $SUCCESS
}

