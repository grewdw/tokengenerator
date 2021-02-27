variable "environment" {
  type    = string
  default = "dev"
}

variable "tag" {
  type    = string
  default = "dev"
}

variable "host" {
  type    = string
  default = ""
}

variable "domain" {
  type    = string
  default = "tabwriter.uk"
}

variable "enable_encryption" {
  type    = bool
  default = false
}

variable "auth_token" {
  type    = string
  default = "abc"
}

variable "apple_music_private_key" {
  type    = string
  default = "MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgehkNPJsJvFVlMgKEuK9pMaTScKiC266yEHxYAGrgk3ygCgYIKoZIzj0DAQehRANCAASkK7QGzhxO9ZuTuEhbzkfLSylvirNW8b/+UYcwCuvKtIiyV/mVy+dV6hiFKHXUFz4zx2WKASnFyRPSz1DPtDyv"
}

variable "apple_music_key_identifier" {
  type    = string
  default = "def"
}

variable "apple_music_team_id" {
  type    = string
  default = "ghi"
}