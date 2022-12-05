REZILION_EXECUTABLE_URL="https://validate-ci-instrument.s3.eu-west-1.amazonaws.com/validate_ci_agent_v2.4.0"
REZILION_OUTPUTS_FOLDER=/tmp/rezilion/outputs
REZILION_AGENT_PATH=/tmp/rezilion/validate_ci_agent

if [ -f $REZILION_AGENT_PATH ]; then
  echo "Rezilion is already installed, skipping installation..."
  exit 0
fi

mkdir -p $REZILION_OUTPUTS_FOLDER

# curl isn't installed
if ! command -v curl > /dev/null 2>&1 ; then
  # install curl with apt-get
  if command -v apt-get > /dev/null 2>&1 ; then
    apt-get update
    apt-get install curl -y

  # install curl with yum
  elif command -v yum > /dev/null 2>&1 ; then
    yum install curl -y

  else
    echo "Impossible to install Rezilion without curl"
    exit 1
  fi
fi

curl -s $REZILION_EXECUTABLE_URL --output $REZILION_AGENT_PATH

chmod +x $REZILION_AGENT_PATH || true