resource "azuread_conditional_access_policy" "block_untrusted_access" {
  display_name = "Block Non-Compliant Devices from Untrusted Locations"
  state        = "enabled"

  conditions {
    users {
      included_users = ["All"]
      excluded_users = ["GuestsOrExternalUsers"]
    }

    sign_in_risk_levels = ["medium", "high"]
    user_risk_levels    = ["medium"]
    client_app_types    = ["browser", "mobileAppsAndDesktopClients"]

    applications {
      included_applications = ["All"]
    }

    devices {
      filter {
        mode = "exclude"
        rule = "device.operatingSystem eq \"Windows 7\""
      }
    }

    locations {
      included_locations = ["All"]
      excluded_locations = ["AllTrusted"]
    }

    platforms {
      included_platforms = ["android", "iOS", "windows"]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["mfa"]
  }

  session_controls {
    application_enforced_restrictions_enabled = true
    sign_in_frequency                         = 10
    sign_in_frequency_period                  = "hours"
    cloud_app_security_policy                 = "monitorOnly"
    disable_resilience_defaults               = false
  }
}

  session_controls {
    application_enforced_restrictions_enabled = true
    sign_in_frequency                         = 10
    sign_in_frequency_period                  = "hours"
    cloud_app_security_policy                 = "monitorOnly"
    disable_resilience_defaults               = false
  }
}

