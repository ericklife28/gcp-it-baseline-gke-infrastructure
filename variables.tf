variable "build_project_id" {
  type = string
}

variable "environments_project_id" {
  type = string
}

variable "organization" {
  type = string 
}

variable "deploy" {
  type    = bool
  default = false
}