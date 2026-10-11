variable "certificates_management_certificates" {
  description = <<EOT
Map of certificates_management_certificates, attributes below
Required:
    - compartment_id
    - name
    - certificate_config (block):
        - cert_chain_pem (optional)
        - certificate_pem (optional)
        - certificate_profile_type (optional)
        - config_type (required)
        - csr_pem (optional)
        - issuer_certificate_authority_id (optional)
        - key_algorithm (optional)
        - private_key_pem (optional)
        - private_key_pem_passphrase (optional)
        - signature_algorithm (optional)
        - stage (optional)
        - subject (optional, block):
            - common_name (required)
            - country (optional)
            - distinguished_name_qualifier (optional)
            - domain_component (optional)
            - generation_qualifier (optional)
            - given_name (optional)
            - initials (optional)
            - locality_name (optional)
            - organization (optional)
            - organizational_unit (optional)
            - pseudonym (optional)
            - serial_number (optional)
            - state_or_province_name (optional)
            - street (optional)
            - surname (optional)
            - title (optional)
            - user_id (optional)
        - subject_alternative_names (optional, block):
            - type (required)
            - value (required)
        - validity (optional, block):
            - time_of_validity_not_after (required)
            - time_of_validity_not_before (optional)
        - version_name (optional)
Optional:
    - current_version_number
    - defined_tags
    - description
    - freeform_tags
    - certificate_rules (block):
        - advance_renewal_period (required)
        - renewal_interval (required)
        - rule_type (required)
    - timeouts (block):
        - create (optional)
        - delete (optional)
        - update (optional)
EOT

  type = map(object({
    compartment_id         = string
    name                   = string
    current_version_number = optional(string)
    defined_tags           = optional(map(string))
    description            = optional(string)
    freeform_tags          = optional(map(string))
    certificate_config = object({
      cert_chain_pem                  = optional(string)
      certificate_pem                 = optional(string)
      certificate_profile_type        = optional(string)
      config_type                     = string
      csr_pem                         = optional(string)
      issuer_certificate_authority_id = optional(string)
      key_algorithm                   = optional(string)
      private_key_pem                 = optional(string)
      private_key_pem_passphrase      = optional(string)
      signature_algorithm             = optional(string)
      stage                           = optional(string)
      subject = optional(object({
        common_name                  = string
        country                      = optional(string)
        distinguished_name_qualifier = optional(string)
        domain_component             = optional(string)
        generation_qualifier         = optional(string)
        given_name                   = optional(string)
        initials                     = optional(string)
        locality_name                = optional(string)
        organization                 = optional(string)
        organizational_unit          = optional(string)
        pseudonym                    = optional(string)
        serial_number                = optional(string)
        state_or_province_name       = optional(string)
        street                       = optional(string)
        surname                      = optional(string)
        title                        = optional(string)
        user_id                      = optional(string)
      }))
      subject_alternative_names = optional(list(object({
        type  = string
        value = string
      })))
      validity = optional(object({
        time_of_validity_not_after  = string
        time_of_validity_not_before = optional(string)
      }))
      version_name = optional(string)
    })
    certificate_rules = optional(list(object({
      advance_renewal_period = string
      renewal_interval       = string
      rule_type              = string
    })))
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      update = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.certificates_management_certificates : (
        contains([for v in ["ISSUED_BY_INTERNAL_CA", "MANAGED_EXTERNALLY_ISSUED_BY_INTERNAL_CA", "IMPORTED"] : lower(v)], lower(v.certificate_config.config_type))
      )
    ])
    error_message = "must be one of: \"ISSUED_BY_INTERNAL_CA\", \"MANAGED_EXTERNALLY_ISSUED_BY_INTERNAL_CA\", \"IMPORTED\""
  }
  validation {
    condition = alltrue([
      for k, v in var.certificates_management_certificates : (
        v.certificate_rules == null || alltrue([for item in v.certificate_rules : (contains([for v in ["CERTIFICATE_RENEWAL_RULE"] : lower(v)], lower(item.rule_type)))])
      )
    ])
    error_message = "must be one of: \"CERTIFICATE_RENEWAL_RULE\""
  }
}

