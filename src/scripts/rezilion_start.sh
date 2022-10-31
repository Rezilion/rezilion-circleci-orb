REZILION_OUTPUTS_FOLDER=/tmp/rezilion/outputs
REZILION_AGENT_PATH=/tmp/rezilion/validate_ci_agent

BASE64_IMAGE=$(echo -n "$REZILION_IMAGE_TO_SCAN" | base64)
REZILION_JOB_FOLDER=$REZILION_OUTPUTS_FOLDER/$BASE64_IMAGE/$CIRCLE_JOB

if [[ $CIRCLE_NODE_TOTAL -gt 1 ]] ; then
  REZILION_JOB_FOLDER="$REZILION_JOB_FOLDER"_"$CIRCLE_NODE_INDEX"
fi
mkdir -p "$REZILION_JOB_FOLDER"

REZILION_LDPRELOAD_OUTPUT_DIRECTORY=$REZILION_JOB_FOLDER/ldpreload
MINERS_STATUS_FILE_PATH=$REZILION_JOB_FOLDER/miners_status

echo "$REZILION_USER_COMMAND"

if [ -f /tmp/rezilion/stop_mining ]; then
  rm /tmp/rezilion/stop_mining
fi

$REZILION_AGENT_PATH --license-key "$REZILION_LICENSE_KEY" --ci-environment circleci miners --db-path "$REZILION_JOB_FOLDER/db" --ld-preload-output-directory "$REZILION_LDPRELOAD_OUTPUT_DIRECTORY" --miners-status-file "$MINERS_STATUS_FILE_PATH" --stop-dynamic-mining-flag-path /tmp/rezilion/stop_mining --shell-command-to-mine "$REZILION_USER_COMMAND" --shell-command-output-file-path /tmp/rezilion/shell_command_output --shell-command-exit-code-file-path /tmp/rezilion/shell_command_exit_code &>> "$REZILION_JOB_FOLDER/miners.log" || REZILION_FAILED_RUNNING=1

if [ -z "$REZILION_FAILED_RUNNING" ]; then
  cat /tmp/rezilion/shell_command_output
  echo "Command Exit Code: $(</tmp/rezilion/shell_command_exit_code)"

  if [[ $(< /tmp/rezilion/shell_command_exit_code) != "0" ]]; then
    echo "Rezilion succeeded but command failed - failing job..."
    exit 1
  fi

else
  echo "Failed running Rezilion, running user command..."
  sh -c "$REZILION_USER_COMMAND"
fi
