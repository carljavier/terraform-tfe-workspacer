terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.31.0"
    }
  }

  experiments = [module_variable_optional_attrs]
}

provider "tfe" {
  hostname = var.tfe_hostname
}

module "workspacer" {
  source = "../.."

  organization        = var.organization
  workspace_name      = "workspacer-module-full-test"
  workspace_desc      = "Created by Terraform Workspacer module."
  workspace_tags      = ["module-ci", "test", "aws"]
  execution_mode      = "remote"
  auto_apply          = false
  terraform_version   = "1.2.3"
  working_directory   = "/"
  global_remote_state = true

  tfvars = {
    teststring = "iamstring"
    testlist   = ["1", "2", "3"]
    testmap    = { "a" = "1", "b" = "2", "c" = { "nest1key" = "nest1value" } }
  }

  tfvars_sensitive = {
    secret      = "secstring"
    secret_list = ["sec1", "sec2", "sec3"]
    secret_map  = { "x" = "sec4", "y" = "sec5", "z" = "sec6" }
  }

  envvars = {
    AWS_ACCESS_KEY_ID = "TH1$ISNOTAREAL@CCESSKEY"
  }

  envvars_sensitive = {
    AWS_SECRET_ACCESS_KEY = "THI$ISNOTAREALSECRETKEY123!@#"
    AWS_SESSION_TOKEN     = "THI$ISNOTAREALSESSIONTOKEN123456789$%^&*"
  }

  team_access = {
    "dev-team"     = "read"
    "release-team" = "write"
  }

  custom_team_access = {
    custom-team-1 = {
      runs              = "read"
      variables         = "read"
      state_versions    = "read-outputs"
      sentinel_mocks    = "read"
      workspace_locking = true
    }
    custom-team-2 = {
      runs              = "read"
      variables         = "write"
      state_versions    = "read"
      sentinel_mocks    = "none"
      workspace_locking = false
    }
  }

  notifications = [
    {
      name             = "test-notification-webhook"
      destination_type = "generic"
      url              = "https://example.com"
      token            = "abcdefg1234567"
      triggers         = ["run:completed", "run:errored"]
      enabled          = true
    }
  ]

  # Workspaces must already exist
  run_trigger_source_workspaces = [
    "rt-src1",
    "rt-src2"
  ]
}