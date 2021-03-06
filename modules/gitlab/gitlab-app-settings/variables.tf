variable "gitlab_project_id" {
  type        = string
  description = "An unique identifier of the project."
}

variable "extraEnv" {
  // there is key-value map, represented by encoded JSON to hack terraform
  type = object({
    global = string
    dev    = string
    production = object({
      DATABASE_URL = string
    })
  })
}