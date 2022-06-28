variable "cluster_name" {
  default     = "6over6"
  description = "The cluster name of this project"
}

variable "container_image" {
  description = "The docker image to be used by fargate"
  type        = string
  default     = "berkil/6over6:task"
}

variable "cpu" {
  description = "The CPU for fargate task"
  type        = string
  default     = "512"
}

variable "memory" {
  description = "The memory for fargate task"
  type        = string
  default     = "1024"
}

variable "sos_cidr" {
  description = "The vpc's first 2 octets"
  type        = string
  default     = "10.110"
}
