REZILION_OUTPUTS_FOLDER=/tmp/rezilion/outputs
REZILION_AGENT_PATH=/tmp/rezilion/validat_ci_agent

if [[ -z "$(ls -A $REZILION_OUTPUTS_FOLDER)" ]]; then
  echo "Rezilion found no images to validate..."
  exit 0
fi

ARTIFACT_PATH=/tmp/rezilion/artifacts
mkdir -p $ARTIFACT_PATH

for dir in "$REZILION_OUTPUTS_FOLDER"/*/
  do
    ENCODED_DIR=$(basename -- "${dir%*/}")

    if [[ $REZILION_IMAGE_TO_SCAN == "no_image" ]] ; then
      IMAGE_NAME_DECODED=$(echo "$ENCODED_DIR" | base64 --decode) || true
    else
      IMAGE_NAME_DECODED=$REZILION_IMAGE_TO_SCAN
    fi

    NORMALIZED_IMAGE_NAME=$(basename -- "$IMAGE_NAME_DECODED")
    VALIDATE_COMMAND="$REZILION_AGENT_PATH --log-path $REZILION_OUTPUTS_FOLDER/$ENCODED_DIR/validate_$NORMALIZED_IMAGE_NAME.log --license-key $REZILION_LICENSE_KEY validate --ci-environment circleci --tests-directory $REZILION_OUTPUTS_FOLDER/$ENCODED_DIR --html-report-path $ARTIFACT_PATH/report_$NORMALIZED_IMAGE_NAME.html --json-report-path $ARTIFACT_PATH/report_$NORMALIZED_IMAGE_NAME.json --container-image-name $IMAGE_NAME_DECODED --scanner-name trivy"
    echo "$VALIDATE_COMMAND"

    if [[ -n "$REZILION_DONT_SAVE_TEST_LOGS" ]]; then
      $VALIDATE_COMMAND &> /dev/null
    else
      $VALIDATE_COMMAND
    fi

  done

if [[ -z "$REZILION_DONT_SAVE_TEST_LOGS" ]]; then
  tar cfz $ARTIFACT_PATH/logs.tar.gz $REZILION_OUTPUTS_FOLDER
fi
