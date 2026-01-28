terraform-aws-sns-subscription
===

Gives you the necessary configuration abilities and permissions to consume events
from an SNS Topic.

Replaces the SNS Subscription alternatives in [terraform-aws-queue](https://github.com/nsbno/terraform-aws-queue/blob/master/variables.tf#L32).

<!-- TOC -->
* [Usage](#usage)
* [Examples](#examples)
<!-- TOC -->

# Usage

Remember to look at [variables](./variables.tf) to see all options.

```terraform
module "publisher_subscriptions" {
  source = "github.com/nsbno/terraform-aws-sns-subscription?ref=<version>"

  topic = aws_sns_topic.publisher

  sqs_queues = {
    consumer  = aws_sqs_queue.consumer.arn
  }
}
```

# Examples

1. [Simple Setup between SNS and SQS](./examples/simple/main.tf)
1. [More advanced, with more config](./examples/advanced/main.tf)
