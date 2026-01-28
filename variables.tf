variable "topic" {
  description = "Points to the SNS topic we want to attach the subscriptions."
  type = object({
    arn = string
  })
  nullable = false
}

variable "sqs_queues" {
  description = "SQS Queues that should subscribe to the SNS topic."

  nullable = true
  // Using a nested object, so that we have the flexibility to expand the configuration parts of the module later,
  // without introducing breaking changes.
  type = map(object({
    arn                  = string
    raw_message_delivery = optional(bool, false)
    filter_policy        = optional(string, null)
    filter_policy_scope  = optional(string, null)
  }))
  default = null
}
