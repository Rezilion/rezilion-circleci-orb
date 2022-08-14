REZILION_EXECUTABLE_URL="https://validate-ci-instrument.s3.eu-west-1.amazonaws.com/validate_ci_agent_v2.0.1"
REZILION_OUTPUTS_FOLDER=/tmp/rezilion/outputs
REZILION_AGENT_PATH=/tmp/rezilion/validat_ci_agent

mkdir -p $REZILION_OUTPUTS_FOLDER

if command -v curl > /dev/null; then
  curl -s $REZILION_EXECUTABLE_URL --output $REZILION_AGENT_PATH
fi || true

if ! command -v curl > /dev/null; then
  if command -v apt-get ; then
    apt-get update
    apt-get install curl -y
    curl -s $REZILION_EXECUTABLE_URL --output $REZILION_AGENT_PATH
    apt-get remove curl -y

  elif command -v yum > /dev/null; then
    yum install curl -y
    curl -s $REZILION_EXECUTABLE_URL --output $REZILION_AGENT_PATH
    yum remove curl -y
  fi

fi || true

chmod +x $REZILION_AGENT_PATH || true