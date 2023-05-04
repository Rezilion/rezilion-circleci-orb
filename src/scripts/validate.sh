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

VALIDATE_COMMAND="$REZILION_AGENT_PATH --log-path $REZILION_MINERS_OUTPUT_FOLDER/validate.log --license-key $REZILION_LICENSE_KEY --ci-environment circleci validate --tests-directory $REZILION_MINERS_OUTPUT_FOLDER --output-directory $ARTIFACT_PATH --scanner-name Rezilion"

if [[ -n "$REZILION_DONT_SAVE_TEST_LOGS" ]]; then
  $VALIDATE_COMMAND &> /dev/null
else
  $VALIDATE_COMMAND
fi

if [[ -z "$REZILION_DONT_SAVE_TEST_LOGS" ]]; then
  tar cfz $ARTIFACT_PATH/logs.tar.gz $REZILION_MINERS_OUTPUT_FOLDER || true
fi