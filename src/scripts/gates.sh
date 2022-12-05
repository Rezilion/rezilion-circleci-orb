if [[ ! -n "$REZILION_SEVERITY_GATE" ]]; then
    echo "No gates found, skipping..."
    exit 0
fi

REZILION_OUTPUTS_FOLDER=/tmp/rezilion/outputs
REZILION_AGENT_PATH=/tmp/rezilion/validate_ci_agent

if [[ -z "$(ls -A $REZILION_OUTPUTS_FOLDER)" ]]; then
  echo "Rezilion found no images to validate..."
  exit 0
fi

ARTIFACT_PATH=/tmp/rezilion/artifacts
for dir in "$REZILION_OUTPUTS_FOLDER"/*/
  do
    ENCODED_DIR=$(basename -- "${dir%*/}")

    if [[ $REZILION_IMAGE_TO_SCAN == "0" ]] ; then
      IMAGE_NAME_DECODED=$(echo -n "$ENCODED_DIR" | base64 --decode)
    else
      IMAGE_NAME_DECODED=$REZILION_IMAGE_TO_SCAN
    fi

    NORMALIZED_IMAGE_NAME=$(basename -- "$IMAGE_NAME_DECODED")
    $REZILION_AGENT_PATH --license-key "$REZILION_LICENSE_KEY" --ci-environment circleci gates --severity-gate "$REZILION_SEVERITY_GATE" --json-report-path $ARTIFACT_PATH/report_$NORMALIZED_IMAGE_NAME.json

  done