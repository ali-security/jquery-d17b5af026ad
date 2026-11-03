#!/bin/sh
# Seal: keep the job open until Travis has archived this job's log up to
# this point, so the log harvested right after the build finishes contains
# the test results. Travis archives log parts asynchronously, often minutes
# behind the job. Runs in after_script, which cannot change the job result.
MARK="seal-log-sync-${TRAVIS_JOB_ID}-done"
echo "$MARK"
URL="https://api.travis-ci.com/v3/job/${TRAVIS_JOB_ID}/log.txt"
i=0
while [ "$i" -lt 120 ]; do
  if curl -fsSL "$URL" 2>/dev/null | grep -q "$MARK"; then
    echo "Travis log archived through the test results (after ${i} polls)"
    exit 0
  fi
  i=$((i + 1))
  sleep 20
done
echo "Travis log archive still incomplete after 40 minutes"
exit 0
