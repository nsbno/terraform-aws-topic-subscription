provider "aws" {
  profile = "linio"
}

resource "aws_sns_topic" "publisher" {
  name = "my-special-topic"
  // trivy:ignore:AVD-AWS-0136 # This is just a simple example. Not to be used directly
  kms_master_key_id = "alias/aws/sns"
}

resource "aws_sqs_queue" "consumer" {
  name = "consumer"
  sqs_managed_sse_enabled = true
}

module "publisher_subscriptions" {
  source = "../../"

  topic = aws_sns_topic.publisher

  sqs_queues = {
    consumer = {
      arn                  = aws_sqs_queue.consumer
      raw_message_delivery = true
      filter_policy = jsonencode({

      })
    }
  }
}
