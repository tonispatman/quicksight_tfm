ACCOUNT=942486875728
REGION=us-east-1

# Source template (the one you already have in Q)
SRC_TEMPLATE_ID=saas-sales-template
SRC_VERSION=2

# New env "clone" template we’ll create from JSON
NEW_ENV=stg
NEW_TEMPLATE_ID="saas-sales-template-$NEW_ENV"
NEW_TEMPLATE_NAME="SaaS Sales Template ($NEW_ENV)"


1) Export the Definition of the source template (AWS CLI)

# Full versioned definition payload
aws quicksight describe-template-definition \
  --aws-account-id "$ACCOUNT" \
  --template-id "$SRC_TEMPLATE_ID" \
  --version-number "$SRC_VERSION" \
  --region "$REGION" \
  --output json > /tmp/${SRC_TEMPLATE_ID}_v${SRC_VERSION}_full.json

# Extract ONLY the Definition object (this is what we can re-import)
jq '.Definition' /tmp/${SRC_TEMPLATE_ID}_v${SRC_VERSION}_full.json \
  > /tmp/${SRC_TEMPLATE_ID}_v${SRC_VERSION}_definition.json

2) Create a new template from the exported JSON (AWS CLI)

aws quicksight create-template \
  --aws-account-id "$ACCOUNT" \
  --template-id "$NEW_TEMPLATE_ID" \
  --name "$NEW_TEMPLATE_NAME" \
  --definition file:///tmp/${SRC_TEMPLATE_ID}_v${SRC_VERSION}_definition.json \
  --version-description "imported from ${SRC_TEMPLATE_ID} v${SRC_VERSION}" \
  --region "$REGION"

Quick Check 
aws quicksight describe-template --aws-account-id "$ACCOUNT" --template-id "$NEW_TEMPLATE_ID" --region "$REGION" --output table
aws quicksight list-template-aliases --aws-account-id "$ACCOUNT" --template-id "$NEW_TEMPLATE_ID" --region "$REGION"
