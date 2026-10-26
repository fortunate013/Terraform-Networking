variable "aws_region" {
  description = "AWS region used for the networking lab"
  type        = string
  default     = "af-south-1"
}

variable "project" {
  description = "Project name used for AWS resource tags"
  type        = string
  default     = "mzu-day10"
}
