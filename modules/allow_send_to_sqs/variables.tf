variable "queue" {
  type = object({
    name   = string
    region = optional(string)
  })
  nullable    = false
  description = "The Queue that should permit receiving messages"
}

variable "topic_arn" {
  type        = string
  nullable    = false
  description = "The SNS topic that is allowed to send messages"
}