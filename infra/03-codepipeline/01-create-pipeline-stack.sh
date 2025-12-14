01-create-pipeline-stack.sh
#!/usr/bin/env bash
set -euo pipefail

STACK_NAME="python-hello-world-cicd-stack"
TEMPLATE_FILE="codepipeline-template.yml"
REGION="us-east-2"

ODEPIPELINE_ROLE_ARN="arn:aws:iam::111111111111:role/demo-codepipeline-role"
PIPELINE_BUCKET="demo-codebuild-bucket"
GIT_CONNECTION_ARN="arn:aws:codeconnections:us-east-2:111111111111:connection/demo-connection"
GIT_FULL_REPO_ID="username/demo-repo"
GIT_BRANCH="main"
CLOUDFORMATION_EXEC_ROLE_ARN="arn:aws:iam::111111111111:demo-cloudformation-role"
DEFAULT_APPLICATION_NAME="demo-helloworld-app"
DEFAULT_DEPLOYMENT_GROUP_NAME="demo-ec2-deployment"

echo "Validating CloudFormation template: $TEMPLATE_FILE"
aws cloudformation validate-template \
  --template-body file://"$TEMPLATE_FILE"

echo "Template validation passed. Deploying stack..."

aws cloudformation deploy \
  --stack-name "$STACK_NAME" \
  --template-file "$TEMPLATE_FILE" \
  --capabilities CAPABILITY_NAMED_IAM \
  --region "$REGION" \
  --parameter-overrides \
      CodePipelineRoleArn="$CODEPIPELINE_ROLE_ARN" \
      PipelineBucket="$PIPELINE_BUCKET" \
      GitConnectionArn="$GIT_CONNECTION_ARN" \
      GitFullRepoId="$GIT_FULL_REPO_ID" \
      GitBranch="$GIT_BRANCH" \
      CloudFormationExecutionRoleArn="$CLOUDFORMATION_EXEC_ROLE_ARN" \
      DefaultApplicationName="$DEFAULT_APPLICATION_NAME" \
      DefaultDeploymentGroupName="$DEFAULT_DEPLOYMENT_GROUP_NAME"

echo "Waiting for CloudFormation stack to complete..."

aws cloudformation wait stack-create-complete \
  --stack-name "$STACK_NAME" \
  --region "$REGION"

echo "Stack deployment finished. Outputs:"
aws cloudformation describe-stacks \
  --stack-name "$STACK_NAME" \
  --region "$REGION" \
  --query "Stacks[0].Outputs"
