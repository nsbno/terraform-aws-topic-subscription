data "aws_sqs_queue" "this" {
  name   = var.queue.name
  region = var.queue.region
}

data "aws_iam_policy_document" "allow_sns_send" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [data.aws_sqs_queue.this.arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [var.topic_arn]
    }
  }
}

resource "aws_sqs_queue_policy" "allow_sns_send" {
  queue_url = data.aws_sqs_queue.this.id

  policy = data.aws_iam_policy_document.allow_sns_send.json
  region = var.queue.region
}
