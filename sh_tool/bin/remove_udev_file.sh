#!/bin/bash
#
# @brief   UDEV rule generator
# @version ver.2.0
# @date    Thu 02 Dec 2021 01:18:25 AM CET
# @company None, free software to use 2021
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#

declare -A REMOVE_UDEV_RULE_USAGE=(
    [USAGE_TOOL]="__remove_udev_file"
    [USAGE_ARG1]="[UDEV FILE] Path to UDEV rule file"
    [USAGE_EX_PRE]="# Removing UDEV rule file"
    [USAGE_EX]="__remove_udev_file \$UDEVN"
)

#
# @brief  Remove UDEV rule
# @param  None
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __remove_udev_file $UDEVN
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
function __remove_udev_file {
    local UDEVN=$1
    if [ -n "${UDEVN}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        local CFG="${GEN_RULE_HOME}/conf/${config_gen_rule_util[UDEVN]}"
        declare -A rule_names=()
        load_util_conf "$CFG" rule_names
        STATUS=$?
        if [ $STATUS -eq $NOT_SUCCESS ]; then
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$GEN_RULE_TOOL"
            return $NOT_SUCCESS
        fi
        local UDEVDIR=${config_gen_rule_util[UDEVD]}
        local UDEVF="${UDEVDIR}/${rule_names[${UDEVN}]}"
        if [ -e "${UDEVF}" ]; then
            rm -f "${UDEVF}"
            STATUS=$?
            if [ $STATUS -ne 0 ]; then
                MSG="Failed to remove file [${UDEVF}]"
                info_debug_message "$MSG" "$FUNC" "$GEN_RULE_TOOL"
                MSG="Force exit!"
                info_debug_message_end "$MSG" "$FUNC" "$GEN_RULE_TOOL"
                return $NOT_SUCCESS
            fi
            MSG="Removed file [${UDEVF}]"
            info_debug_message "$MSG" "$FUNC" "$GEN_RULE_TOOL"
            info_debug_message_end "Done" "$FUNC" "$GEN_RULE_TOOL"
            return $SUCCESS
        fi
        MSG="Check file [${UDEVF}]"
        info_debug_message "$MSG" "$FUNC" "$GEN_RULE_TOOL"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$GEN_RULE_TOOL"
        return $NOT_SUCCESS
    fi
    usage REMOVE_UDEV_RULE_USAGE
    return $NOT_SUCCESS
}

