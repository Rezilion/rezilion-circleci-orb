REZILION_OUTPUTS_FOLDER=/tmp/rezilion/outputs
REZILION_AGENT_PATH=/tmp/rezilion/validate_ci_agent

BASE64_IMAGE=$(echo "$REZILION_IMAGE_TO_SCAN" | base64)
REZILION_JOB_FOLDER=$REZILION_OUTPUTS_FOLDER/$BASE64_IMAGE/$CIRCLE_JOB

if [[ $CIRCLE_NODE_TOTAL -gt 1 ]] ; then
  REZILION_JOB_FOLDER="$REZILION_JOB_FOLDER"_"$CIRCLE_NODE_INDEX"
fi
mkdir -p "$REZILION_JOB_FOLDER"

REZILION_LDPRELOAD_OUTPUT_DIRECTORY=$REZILION_JOB_FOLDER/ldpreload
MINERS_STATUS_FILE_PATH=$REZILION_JOB_FOLDER/miners_status

$REZILION_AGENT_PATH --license-key "$REZILION_LICENSE_KEY" --ci-environment circleci miners --db-path "$REZILION_JOB_FOLDER/db" --ld-preload-output-directory "$REZILION_LDPRELOAD_OUTPUT_DIRECTORY" --miners-status-file "$MINERS_STATUS_FILE_PATH" &> "$REZILION_JOB_FOLDER/miners.log" &

(i=0; while [[ $(wc -l <"$MINERS_STATUS_FILE_PATH") != 2 ]] && [[ $i -lt 120 ]]; do sleep 1; i=$((i+1)); done) &> /dev/null

if [ ! -f "$MINERS_STATUS_FILE_PATH" ] ; then
  echo "Failed running Rezilion Validate"
fi