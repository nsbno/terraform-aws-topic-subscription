provider "aws" {
  profile = "linio"
}

resource "aws_sns_topic" "publisher" {
  name = "my-special-topic"
  // trivy:ignore:AVD-AWS-0136 # This is just a simple example. Not to be used directly
  kms_master_key_id = "alias/aws/sns"
}

resource "aws_sqs_queue" "consumer" {
  name                    = "consumer"
  sqs_managed_sse_enabled = true
}

module "publisher_subscriptions" {
  source = "../../"

  topic = aws_sns_topic.publisher

  sqs_queues = {
    consumer = {
      arn                  = aws_sqs_queue.consumer.arn
      raw_message_delivery = false

      // Example of how to filter Events on the Attributes
      filter_policy = jsonencode({
        event_type = ["order_placed", "order_cancelled"]
        store_id   = [{ prefix = "store-eu-" }]
        priority   = [{ numeric = [">=", 1, "<=", 5] }]
      })
      filter_policy_scope = "MessageAttributes"
    }
    only_some_messages = {
      arn                  = aws_sqs_queue.consumer.arn
      raw_message_delivery = true

      // Example to how filter Events on the Payload itself
      filter_policy = jsonencode({
        detail = {
          store_id = [{ prefix = "store-eu-" }]
          priority = [{ numeric = [">=", 1, "<=", 5] }]
        }
      })
      filter_policy_scope = "MessageBody"
    }
  }
}
