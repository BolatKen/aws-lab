#!/usr/bin/env bash
# Usage: ./deploy.sh <stack-name> <image-tag> [dev|prod]
set -euo pipefail
STACK=${1:?stack name}
TAG=${2:?image tag}
ENV=${3:-dev}
REPO=$(aws cloudformation describe-stacks --stack-name orders-ecr --region us-east-1 \
  --query "Stacks[0].Outputs[?OutputKey=='RepoName'].OutputValue" --output text)
aws cloudformation deploy \
  --stack-name "$STACK" \
  --template-file templates/app.yaml \
  --region us-east-1 \
  --parameter-overrides Env="$ENV" RepoName="$REPO" ImageTag="$TAG" \
  --capabilities CAPABILITY_IAM
