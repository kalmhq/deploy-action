#!/bin/sh -l

cat <<EOF > data.json
{
    "deployKey":     "${INPUT_KALM_DEPLOY_KEY}",
    "application":   "${INPUT_KALM_APP}",
    "componentName": "${INPUT_KALM_COMPONENT}",
    "imageTag":      "${INPUT_KALM_COMPONENT_IMG_TAG}"
}
EOF

resp_code=$(curl -s -o resp.log -w "%{http_code}" -XPOST -H "Content-Type: application/json" -H "Authorization: Bearer ${INPUT_KALM_DEPLOY_KEY}" -d "@data.json" ${INPUT_KALM_API_ADDRESS}/webhook/components)

rm data.json

resp=$(cat resp.log)

echo "response from webhook: $resp"
echo "::set-output name=resp::$resp"

if [ $resp_code == 200 ]
then
    exit 0
else
    exit 1
fi