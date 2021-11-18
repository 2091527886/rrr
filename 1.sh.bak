#!/bin/bash
set -o errexit
CURL="/usr/bin/curl"
REPO_DIST="https://gerrit.googlesource.com/git-repo"
REPO_PATH="${HOME}/bin"
REPO="${REPO_PATH}/repo"
BUILDID="$1"
if [ -z "$CAF_URL" ]; then
  if [ ${BUILDID:0:11} == "LE.UM.2.4.1" ]; then
    CAF_URL="ssh://git@git.codeaurora.org:9222/external/private_CAF_2.4.1/le/manifest.git"
  elif [ ${BUILDID:0:11} == "LE.UM.5.3.2" ]; then
    CAF_URL="ssh://git@git.codeaurora.org:9222/external/private_le/le/manifest.git"
  else
    CAF_URL="git://codeaurora.org/quic/le/le/manifest.git"
  fi
fi
URL="$CAF_URL"
if [ -z "$BRANCH" ]; then
  BRANCH="release"
fi
TARGET="$2"
JOB=8
ERR_MSG="A list of valid IDs can be found at https://source.codeaurora.org/quic/le/le/manifest/log/?h=release".
if [ -z "${BUILDID}" ]; then
  echo "Please supply a Build ID."
  echo "${ERR_MSG}"
  echo "Example Usage: ./syncbuild.sh IOT.LE.1.0-04802-8x53"
  exit 1
else
  MANIFEST="${BUILDID}.xml"
fi
mkdir -p "${REPO_PATH}"
if [ ! -f "${REPO}" ]; then
  ${CURL} "${REPO_DIST}" > "${REPO}"
fi
chmod +x "${REPO}"
if [ ! -d .repo ]; then
  ${REPO} init -u ${URL} -b ${BRANCH} -m ${MANIFEST} --repo-url=https://mirrors.tuna.tsinghua.edu.cn/git/git-repo --repo-branch=caf-stable
fi
if [ ! -f ".repo/manifests/${MANIFEST}" ]; then
  echo "ERROR: An Invalid Build ID was supplied."
  echo "${ERR_MSG}"
  exit 2
fi
${REPO} sync --no-tags -j ${JOB}
