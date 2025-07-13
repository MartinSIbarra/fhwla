#!/bin/bash
log() {
    local message="$1"

    if [ ! -z "$message" ]; then
        local caller=$(basename "${BASH_SOURCE[1]}")

        local log_max_file_size=$(jq -r '.log.max_file_size' "$PARAMS_FILE")
        [ -z "$log_max_file_size" ] && log_max_file_size=10000  # Default to 10000 lines if not set
        local log_max_quantity_files=$(jq -r '.log.max_quantity_files' "$PARAMS_FILE")
        [ -z "$log_max_quantity_files" ] && log_max_quantity_files=5  # Default to 5 files if not set

        [ -d "$LOG_PATH" ] || mkdir -p "$LOG_PATH"
        local hostname=$(cat /etc/hostname)
        [ -z "$hostname" ] && hostname="unknown"
        local log_file=$(ls -1t $LOG_PATH/*-"$hostname".log 2> /dev/null | head -n1) # Obtiene el ultimo archivo de log para el hostname actual
        [ -z "$log_file" ] && log_file="$LOG_PATH/$( date '+%Y-%m-%d-%H-%M-%S' )-$hostname.log"

        if [ -f "$log_file" ]; then
            local log_size=$(wc -l < "$log_file")

            if [ "$log_size" -ge "$log_max_file_size" ]; then
                log_file="$LOG_PATH/$( date '+%Y-%m-%d-%H-%M-%S' )-$hostname.log"
            fi
        else
            touch "$log_file"
            chown "1000:1000" "$log_file"
            chown "1000:1000" "$LOG_PATH"
        fi

        echo "[$( date '+%Y-%m-%d %H:%M:%S' )][$caller]: $message" >> "$log_file"

        local files=($(ls -1 "$LOG_PATH"/*-"$hostname".log 2>/dev/null | sort))

        local total_files=${#files[@]}

        if [ "$total_files" -gt "$log_max_quantity_files" ]; then
            local files_to_delete=$((total_files - log_max_quantity_files))
            for ((i = 0; i < files_to_delete; i++)); do
                rm -f "${files[$i]}"
            done
        fi
    fi
}

export -f log