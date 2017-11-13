#!/bin/bash
# This handles unit testing our terraform configurations.

# Generate URL of Circle CI Build URL
BUILD_URL="https://circleci.com/gh/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/$CIRCLE_BUILD_NUM"

# Generate Github commit URL
GITHUB_URL="https://api.github.com/repos/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/commits/$CIRCLE_SHA1/comments"

# Add terraform directory to the PATH env variable
PATH="$PATH:$HOME/terraform"

EXIT_STATUS=0

for example_dir in `find . -type d -name example`; do
  pushd $example_dir

  terraform init

  # If init successful, run plan
  if [[ $? -ne 1 ]]; then
    terraform plan -refresh=true

    TEMP_STATUS=$?

    # Only update the EXIT_STATUS if there are no errors.
    if [[ $EXIT_STATUS -ne 1 ]]; then
      EXIT_STATUS=$TEMP_STATUS
    fi
  else
    EXIT_STATUS=1
  fi
  popd
done

exit $EXIT_STATUS
