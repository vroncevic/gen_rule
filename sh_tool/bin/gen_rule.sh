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

.    ${UTIL}/bin/check_root.sh
.    ${UTIL}/bin/check_tool.sh
.    ${UTIL}/bin/check_op.sh
.    ${UTIL}/bin/logging.sh
.    ${UTIL}/bin/load_conf.sh
.    ${UTIL}/bin/load_util_conf.sh
.    ${UTIL}/bin/progress_bar.sh
.    ${UTIL}/bin/display_logo.sh

GEN_RULE_TOOL=gen_rule
GEN_RULE_VERSION=ver.4.0
GEN_RULE_HOME=${UTIL_ROOT}/${GEN_RULE_TOOL}/${GEN_RULE_VERSION}
GEN_RULE_CFG=${GEN_RULE_HOME}/conf/${GEN_RULE_TOOL}.cfg
GEN_RULE_UTIL_CFG=${GEN_RULE_HOME}/conf/${GEN_RULE_TOOL}_util.cfg
GEN_RULE_LOGO=${GEN_RULE_HOME}/conf/${GEN_RULE_TOOL}.logo
GEN_RULE_LOG=${GEN_RULE_HOME}/log

.    ${GEN_RULE_HOME}/bin/remove_udev_file.sh
.    ${GEN_RULE_HOME}/bin/create_udev_file.sh
.    ${GEN_RULE_HOME}/bin/list_udev_files.sh

declare -A GEN_RULE_USAGE=(
    [USAGE_TOOL]="${GEN_RULE_TOOL}"
    [USAGE_ARG1]="[OPERATION] install | uninstall | list"
    [USAGE_ARG2]="[TARGET DEVICE] Target device board"
    [USAGE_EX_PRE]="# Instaling UDEV rule for AVR Dragon board"
    [USAGE_EX]="${GEN_RULE_TOOL} install avr_dragon"
)

declare -A GEN_RULE_LOGGING=(
    [LOG_TOOL]="${GEN_RULE_TOOL}"
    [LOG_FLAG]="info"
    [LOG_PATH]="${GEN_RULE_LOG}"
    [LOG_MSGE]="None"
)

declare -A PB_STRUCTURE=(
    [BW]=50
    [MP]=100
    [SLEEP]=0.01
)

declare -A GEN_RULE_LOGO_DATA=(
    [OWNER]="vroncevic"
    [REPO]="${GEN_RULE_TOOL}"
    [VERSION]="${GEN_RULE_VERSION}"
    [LOGO]="${GEN_RULE_LOGO}"
)

TOOL_DBG="false"
TOOL_LOG="false"
TOOL_NOTIFY="false"

#
# @brief   Main function
# @params  Values required option and target device
# @exitval Function __gen_rule exit with integer value
#            0   - tool finished with success operation
#            128 - missing argument(s) from cli
#            129 - failed to load tool script configuration from files
#            130 - wrong option
#            131 - falied to create UDEV rule file
#            132 - falied to remove UDEV rule file
#            133 - failed to list target devices
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __gen_rule install avr_dragon
#
function __gen_rule {
    local OP=$1 TD=$2
    if [[ -z "${OP}" ]]; then
        usage GEN_RULE_USAGE
        exit 128
    fi
    display_logo GEN_RULE_LOGO_DATA
    local FUNC=${FUNCNAME[0]} MSG="None"
    local STATUS_CONF STATUS_CONF_UTIL STATUS
    MSG="Loading basic and util configuration!"
    info_debug_message "$MSG" "$FUNC" "$GEN_RULE_TOOL"
    progress_bar PB_STRUCTURE
    declare -A config_gen_rule=()
    load_conf "$GEN_RULE_CFG" config_gen_rule
    STATUS_CONF=$?
    declare -A config_gen_rule_util=()
    load_util_conf "$GEN_RULE_UTIL_CFG" config_gen_rule_util
    STATUS_CONF_UTIL=$?
    declare -A STATUS_STRUCTURE=([1]=$STATUS_CONF [2]=$STATUS_CONF_UTIL)
    check_status STATUS_STRUCTURE
    STATUS=$?
    if [ $STATUS -eq $NOT_SUCCESS ]; then
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$GEN_RULE_TOOL"
        exit 129
    fi
    TOOL_DBG=${config_gen_rule[DEBUGGING]}
    TOOL_LOG=${config_gen_rule[LOGGING]}
    TOOL_NOTIFY=${config_gen_rule[EMAILING]}
    local OPERATIONS=${config_gen_rule_util[UDEV_OPERATIONS]}
    IFS=' ' read -ra OPS <<< "${OPERATIONS}"
    check_op "${OP}" "${OPS[*]}"
    STATUS=$?
    if [ $STATUS -eq $NOT_SUCCESS ]; then
        usage GEN_RULE_USAGE
        exit 130
    fi
    if [ "${OP}" == "install" ]; then
        declare -A udev_setup=(
            [UDEV_TOOL]="${config_gen_rule_util[UDEV]}"
            [TARGET_DEVICE]="${TD}"
            [CFG_TEMPLATES]="${GEN_RULE_HOME}/conf/${config_gen_rule_util[UDEVT]}"
            [UDEV_FILE]="${config_gen_rule_util[UDEVD]}/${TD}.rules"
        )
        __create_udev_file udev_setup
        STATUS=$?
        if [ $STATUS -eq $NOT_SUCCESS ]; then
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$GEN_RULE_TOOL"
            exit 131
        fi
        MSG="Instaling udev rule for ${TD}"
        GEN_RULE_LOGGING[LOG_FLAG]="info"
        GEN_RULE_LOGGING[LOG_MSGE]=$MSG
        logging GEN_RULE_LOGGING
    elif [ "${OP}" == "uninstall" ]; then
        __remove_udev_file "${config_gen_rule_util[UDEVD]}/${TD}.rules"
        STATUS=$?
        if [ $STATUS -eq $NOT_SUCCESS ]; then
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$GEN_RULE_TOOL"
            exit 132
        fi
        MSG="Uninstall udev rule for ${TD}"
        GEN_RULE_LOGGING[LOG_FLAG]="info"
        GEN_RULE_LOGGING[LOG_MSGE]=$MSG
        logging GEN_RULE_LOGGING
    elif [ "${OP}" == "list" ]; then
        declare -A list_setup=(
            [RULE_DIR]="${config_gen_rule_util[UDEVD]}"
            [RULE_CFG]="${GEN_RULE_HOME}/conf/${config_gen_rule_util[UDEVN]}"
        )
        __list_udev_files list_setup
        STATUS=$?
        if [ $STATUS -eq $NOT_SUCCESS ]; then
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$GEN_RULE_TOOL"
            exit 133
        fi
    fi
    info_debug_message_end "Done" "$FUNC" "$GEN_RULE_TOOL"
    exit 0
}

#
# @brief   Main entry point of script tool
# @params  Values required option and target device
# @exitval Script tool gen_rule exit with integer value
#            0   - tool finished with success operation
#            127 - run tool script as root user from cli
#            128 - missing argument(s) from cli
#            129 - failed to load tool script configuration from files
#            130 - wrong option
#            131 - falied to create UDEV rule file
#            132 - falied to remove UDEV rule file
#            133 - failed to list target devices
#
printf "\n%s\n%s\n\n" "${GEN_RULE_TOOL} ${GEN_RULE_VERSION}" "`date`"
check_root
STATUS=$?
if [ $STATUS -eq $SUCCESS ]; then
    __gen_rule $1 $2
fi

exit 127
