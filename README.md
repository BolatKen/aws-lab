# Orders IaC (CloudFormation)

SNS -> SQS (+DLQ) -> Lambda consumer (idempotent via DynamoDB conditional write),
and an ECS Fargate API behind an ALB. Everything is in `templates/`.

## Manual prerequisites (one time, per account)
1. AWS CLI configured (`aws configure`), Docker installed.
2. Deploy the ECR stack:
   `aws cloudformation deploy --stack-name orders-ecr --template-file templates/ecr.yaml --region us-east-1`
3. Build and push the image, tagged with the git short SHA (tags are immutable):
   `TAG=$(git rev-parse --short HEAD)`; build `./app` and push to the repo from the stack output.

## Deploy (the one command)
`./deploy.sh <stack-name> <image-tag>`
Example: `./deploy.sh orders-defence 438e46b`

## Teardown
`aws cloudformation delete-stack --stack-name <stack-name> --region us-east-1`
Delete app stacks first, the ECR stack last.
