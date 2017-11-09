#!/bin/bash
# This handles testing our terraform configurations.  It creates a commit
# message if their are any changes to be applied.

# Generate URL of Circle CI Build URL
BUILD_URL="https://circleci.com/gh/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/$CIRCLE_BUILD_NUM"

# Generate Github commit URL
GITHUB_URL="https://api.github.com/repos/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/commits/$CIRCLE_SHA1/comments"

# Add terraform directory to the PATH env variable
PATH="$PATH:$HOME/terraform"

for example_dir in `find . -type d -name example`; do
  pushd $example_dir

  terraform init

  # If init successful, run plan
  if [[ $? -ne 1 ]]; then
    # Display output and pump into file for future use.
    terraform plan -refresh=true

    TEMP_STATUS=$?

    # Only update the EXIT_STATUS if it isn't already set to output
    if [[ $EXIT_STATUS -ne 1 ]]; then
      EXIT_STATUS=$TEMP_STATUS
    fi
  else
    EXIT_STATUS=1
  fi
  popd
done

exit $EXIT_STATUS
