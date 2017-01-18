#!/bin/sh -e
cd /terraform

for key in AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY; do
  if [ -z "$(eval 'echo $'$key)" ]; then
    echo Environment ${key} must setting
    exit
  fi
done

set -x

/usr/bin/terraform remote config \
  -backend=s3 \
  -backend-config="bucket=${S3_BUCKET}" \
  -backend-config="key=report-uri/terraform.tfstate" \
  -backend-config="region=${AWS_DEFAULT_REGION}" \
  -backend-config="encrypt=1"

/usr/bin/terraform get
/usr/bin/terraform $@
/usr/bin/terraform remote push
