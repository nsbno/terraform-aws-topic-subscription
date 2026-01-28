Allow send to SQS
===

Defines the permissions necessary for SNS to send messages to an SQS Queue

**Example - Simple**:

```terraform
data "aws_sqs_queue" "this" {
  for_each = var.sqs_queues
  name = "my-queue"
}

module "allow_send_to_sqs" {
  source = "./modules/allow_send_to_sqs"

  topic_arn = "aws:sns:::my-topic"
  // Simplest is to feed the whole aws_sqs_queue resource
  queue = data.aws_sqs_queue.this
}
```