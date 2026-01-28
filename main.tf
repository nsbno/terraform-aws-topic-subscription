resource "aws_sns_topic_subscription" "sqs" {
  for_each = var.sqs_queues != null ? var.sqs_queues : {}

  protocol  = "sqs"
  endpoint  = each.value.arn
  topic_arn = var.topic.arn

  raw_message_delivery = each.value.raw_message_delivery
}

data "aws_sqs_queue" "this" {
  for_each = var.sqs_queues
  // Ugly hack to extract name from arn,
  //
  name = regex("[^:]+$", each.value.arn)
}

module "allow_send_to_sqs" {
  source   = "./modules/allow_send_to_sqs"
  for_each = data.aws_sqs_queue.this

  topic_arn = var.topic.arn
  queue     = each.value
}
