REZILION_MINERS_OUTPUT_FOLDER=/tmp/rezilion/outputs
REZILION_AGENT_PATH=/tmp/rezilion/validate_ci_agent

if [[ -z "$(ls -A $REZILION_MINERS_OUTPUT_FOLDER)" ]]; then
  echo "Rezilion found no images to validate..."
  exit 0
fi

ARTIFACT_PATH=/tmp/rezilion/artifacts
mkdir -p $ARTIFACT_PATH

if [[ -z "$REZILION_DONT_SAVE_TEST_LOGS" ]]; then
  tar cfz $ARTIFACT_PATH/logs.tar.gz $REZILION_MINERS_OUTPUT_FOLDER || true
fi

export REZILION_BACKEND_API_GATEWAY_URL="https://api.rezilion.com"
export REZILION_BACKEND_API_EUROPE_GATEWAY_URL="https://api.eu.rezilion.com"

for dir in "$REZILION_MINERS_OUTPUT_FOLDER"/*/
  do
    ENCODED_DIR="$(basename -- "${dir%*/}")"
    IMAGE_NAME_DECODED=$(echo -n "$ENCODED_DIR" | base64 --decode)
    NORMALIZED_IMAGE_NAME="$(basename -- "$IMAGE_NAME_DECODED")"

    VALIDATE_COMMAND="$REZILION_AGENT_PATH --log-path "$REZILION_MINERS_OUTPUT_FOLDER/$ENCODED_DIR/$NORMALIZED_IMAGE_NAME"_validate.log --license-key $REZILION_LICENSE_KEY --ci-environment circleci validate --tests-directory $REZILION_MINERS_OUTPUT_FOLDER/$ENCODED_DIR --html-report-path $ARTIFACT_PATH/report_$NORMALIZED_IMAGE_NAME.html --json-report-path $ARTIFACT_PATH/report_$NORMALIZED_IMAGE_NAME.json --cyclonedx-report-path $ARTIFACT_PATH/cyclonedx_report_$NORMALIZED_IMAGE_NAME.json --container-image-name $IMAGE_NAME_DECODED --scanner-name Rezilion"

    if [[ -n "$REZILION_DONT_SAVE_TEST_LOGS" ]]; then
      $VALIDATE_COMMAND &> /dev/null || true
    else
      $VALIDATE_COMMAND || true
    fi

  done

if [[ -z "$REZILION_DONT_SAVE_TEST_LOGS" ]]; then
  tar cfz $ARTIFACT_PATH/logs.tar.gz $REZILION_MINERS_OUTPUT_FOLDER || true
fi