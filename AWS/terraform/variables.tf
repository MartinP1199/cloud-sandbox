# --- root/variables.tf ---

variable "script_file_path" {
  type = string
  default = "scripts/script.sh"
}

variable "instances_count" {
  type = number
  default = 1
}

variable "key_name" {
  type = string
  default = "leonidas"
}