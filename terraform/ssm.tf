resource "aws_ssm_parameter" "auth_token" {
  name        = "/tabwriter/${local.environment}/auth-token"
  description = "API Key to access the tokengenerator backend"
  type        = "SecureString"
  value       = var.auth_token
  overwrite   = true

  tags = {
    Application = local.application
  }
}

resource "aws_ssm_parameter" "apple_music_private_key" {
  name        = "/tabwriter/${local.environment}/apple-music-private-key"
  description = "Private key to generate tokens for access to Apple Music API."
  type        = "SecureString"
  value       = var.apple_music_private_key
  overwrite   = true

  tags = {
    Application = local.application
  }
}

resource "aws_ssm_parameter" "apple_music_key_identifier" {
  name        = "/tabwriter/${local.environment}/apple-music-key-identifier"
  description = "Identifier for Apple Music private key"
  type        = "SecureString"
  value       = var.apple_music_key_identifier
  overwrite   = true

  tags = {
    Application = local.application
  }
}

resource "aws_ssm_parameter" "apple_music_team_id" {
  name        = "/tabwriter/${local.environment}/apple-music-team-id"
  description = "Team ID used to create Apple Music access tokens"
  type        = "SecureString"
  value       = var.apple_music_team_id
  overwrite   = true

  tags = {
    Application = local.application
  }
}