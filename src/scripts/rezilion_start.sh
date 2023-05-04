REZILION_JOB_FOLDER=/tmp/rezilion/outputs
REZILION_AGENT_PATH=/tmp/rezilion/validate_ci_agent

JOB_NAME=$CIRCLE_JOB
if [[ $CIRCLE_NODE_TOTAL -gt 1 ]] ; then
  JOB_NAME="$JOB_NAME"_"$CIRCLE_NODE_INDEX"
fi
mkdir -p "$REZILION_JOB_FOLDER"

MINERS_LOG_PATH="${REZILION_JOB_FOLDER}/${CIRCLE_JOB}_miners.log"

echo "$REZILION_USER_COMMAND"

if [ -f /tmp/rezilion/stop_mining ]; then
  rm /tmp/rezilion/stop_mining
fi

$REZILION_AGENT_PATH --license-key "$REZILION_LICENSE_KEY" --ci-environment circleci miners --container-image-name "$REZILION_IMAGE_TO_SCAN" --current-job-name "$JOB_NAME" --miners-directory "$REZILION_JOB_FOLDER" --stop-dynamic-mining-flag-path /tmp/rezilion/stop_mining --shell-command-to-mine "$REZILION_USER_COMMAND" --shell-command-output-file-path /tmp/rezilion/shell_command_output --shell-command-exit-code-file-path /tmp/rezilion/shell_command_exit_code >> "$MINERS_LOG_PATH" 2>&1 || REZILION_FAILED_RUNNING=1

if [ -z "$REZILION_FAILED_RUNNING" ]; then
  cat /tmp/rezilion/shell_command_output
  echo Command Exit Code: "$(cat </tmp/rezilion/shell_command_exit_code)"

  if [[ "$(cat </tmp/rezilion/shell_command_exit_code)" != "0" ]]; then
    echo "Rezilion succeeded but command failed - failing job..."
    exit 1
  fi

else
  echo "Failed running Rezilion, running user command..."
  sh -c "$REZILION_USER_COMMAND"
fi
