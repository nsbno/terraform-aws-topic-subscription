provider "aws" {
  profile = "linio"
}

resource "aws_sns_topic" "publisher" {
  name = "my-special-topic"
}

resource "aws_sqs_queue" "consumer" {
  name = "consumer"
}

resource "aws_sqs_queue" "secondary_consumer" {
  name = "secondary-consumer"
}

module "publisher_subscriptions" {
  source = "../"

  topic = aws_sns_topic.publisher

  sqs_queues = {
    consumer  = aws_sqs_queue.consumer
    secondary = { arn = aws_sqs_queue.secondary_consumer.arn, raw_message_delivery = true }
  }
}
