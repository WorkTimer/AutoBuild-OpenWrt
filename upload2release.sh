#!/bin/bash

#set -e
#set -o pipefail

# Ensure that the GITHUB_TOKEN secret is included
if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Set the GITHUB_TOKEN env variable."
  exit 1
fi

# Only upload to non-draft releases
IS_DRAFT=$(jq --raw-output '.release.draft' $GITHUB_EVENT_PATH)
if [ "$IS_DRAFT" = true ]; then
  echo "This is a draft, so nothing to do!"
  exit 0
fi

# Build the Upload URL from the various pieces
echo GITHUB_EVENT_PATH = $GITHUB_EVENT_PATH
cat $GITHUB_EVENT_PATH
RELEASE_ID=$(jq --raw-output '.release.id' $GITHUB_EVENT_PATH)
echo RELEASE_ID = $RELEASE_ID
if [[ -z "${RELEASE_ID}" ]]; then
  echo "There was no release ID in the GitHub event. Are you using the release event type?"
  exit 1
fi

# Prepare the headers
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"
echo AUTH_HEADER = $AUTH_HEADER

CONTENT_TYPE_HEADER="Content-Type: application/zip"
echo CONTENT_TYPE_HEADER = $CONTENT_TYPE_HEADER

#CONTENT_LENGTH_HEADER="Content-Length: $(stat -c%s "${1}")"

#if [[ -z "$2" ]]; then
#  CONTENT_TYPE_HEADER="Content-Type: ${2}"
#else
#  CONTENT_TYPE_HEADER="Content-Type: application/zip"
#fi



#FILENAME=$(basename $1)
#UPLOAD_URL="https://uploads.github.com/repos/${GITHUB_REPOSITORY}/releases/${RELEASE_ID}/assets?name=${FILENAME}"
#echo "$UPLOAD_URL"

## Upload the file
#curl \
#  -sSL \
#  -XPOST \
#  -H "${AUTH_HEADER}" \
#  -H "${CONTENT_LENGTH_HEADER}" \
#  -H "${CONTENT_TYPE_HEADER}" \
#  --upload-file "${1}" \
#  "${UPLOAD_URL}"

