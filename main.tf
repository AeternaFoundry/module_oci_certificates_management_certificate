resource "oci_certificates_management_certificate" "certificates_management_certificates" {
  for_each = var.certificates_management_certificates

  compartment_id         = each.value.compartment_id
  name                   = each.value.name
  current_version_number = each.value.current_version_number
  defined_tags           = each.value.defined_tags
  description            = each.value.description
  freeform_tags          = each.value.freeform_tags

  certificate_config {
    cert_chain_pem                  = each.value.certificate_config.cert_chain_pem
    certificate_pem                 = each.value.certificate_config.certificate_pem
    certificate_profile_type        = each.value.certificate_config.certificate_profile_type
    config_type                     = each.value.certificate_config.config_type
    csr_pem                         = each.value.certificate_config.csr_pem
    issuer_certificate_authority_id = each.value.certificate_config.issuer_certificate_authority_id
    key_algorithm                   = each.value.certificate_config.key_algorithm
    private_key_pem                 = each.value.certificate_config.private_key_pem
    private_key_pem_passphrase      = each.value.certificate_config.private_key_pem_passphrase
    signature_algorithm             = each.value.certificate_config.signature_algorithm
    stage                           = each.value.certificate_config.stage
    dynamic "subject" {
      for_each = each.value.certificate_config.subject != null ? [each.value.certificate_config.subject] : []
      content {
        common_name                  = subject.value.common_name
        country                      = subject.value.country
        distinguished_name_qualifier = subject.value.distinguished_name_qualifier
        domain_component             = subject.value.domain_component
        generation_qualifier         = subject.value.generation_qualifier
        given_name                   = subject.value.given_name
        initials                     = subject.value.initials
        locality_name                = subject.value.locality_name
        organization                 = subject.value.organization
        organizational_unit          = subject.value.organizational_unit
        pseudonym                    = subject.value.pseudonym
        serial_number                = subject.value.serial_number
        state_or_province_name       = subject.value.state_or_province_name
        street                       = subject.value.street
        surname                      = subject.value.surname
        title                        = subject.value.title
        user_id                      = subject.value.user_id
      }
    }
    dynamic "subject_alternative_names" {
      for_each = each.value.certificate_config.subject_alternative_names != null ? each.value.certificate_config.subject_alternative_names : []
      content {
        type  = subject_alternative_names.value.type
        value = subject_alternative_names.value.value
      }
    }
    dynamic "validity" {
      for_each = each.value.certificate_config.validity != null ? [each.value.certificate_config.validity] : []
      content {
        time_of_validity_not_after  = validity.value.time_of_validity_not_after
        time_of_validity_not_before = validity.value.time_of_validity_not_before
      }
    }
    version_name = each.value.certificate_config.version_name
  }

  dynamic "certificate_rules" {
    for_each = each.value.certificate_rules != null ? each.value.certificate_rules : []
    content {
      advance_renewal_period = certificate_rules.value.advance_renewal_period
      renewal_interval       = certificate_rules.value.renewal_interval
      rule_type              = certificate_rules.value.rule_type
    }
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}

