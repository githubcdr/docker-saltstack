# Security Fixes

## Overview
This document tracks the CVEs (Common Vulnerabilities and Exposures) that have been identified and fixed in this project.

## Fixed CVEs (January 2026)

### 1. Tornado Package Vulnerabilities

**Previous Configuration**: `tornado` (unpinned version)
**Fixed Configuration**: `tornado>=6.5`

**Vulnerabilities Fixed**:

- **CVE-2024-52804**: Open Redirect Vulnerability
  - **Severity**: Medium
  - **Affected Versions**: Tornado < 6.4.2
  - **Description**: Tornado had an open redirect vulnerability that could allow attackers to redirect users to malicious sites.
  - **Fixed in**: 6.4.2

- **Excessive Logging DoS**
  - **Severity**: Medium
  - **Affected Versions**: Tornado < 6.5
  - **Description**: Malformed multipart form data could cause excessive logging, leading to denial of service.
  - **Fixed in**: 6.5

- **HTTP Cookie Parsing DoS**
  - **Severity**: Medium
  - **Affected Versions**: Tornado <= 6.4.1
  - **Description**: Specially crafted HTTP cookies could cause denial of service through parsing vulnerabilities.
  - **Fixed in**: 6.4.2

### 2. Jinja2 Package Vulnerabilities

**Previous Configuration**: `jinja2` (unpinned version)
**Fixed Configuration**: `jinja2>=3.1.4`

**Vulnerabilities Fixed**:

- **CVE-2024-22195**: Cross-Site Scripting (XSS)
  - **Severity**: Medium
  - **Affected Versions**: Jinja2 < 3.1.3
  - **Description**: XSS vulnerability that could allow attackers to inject malicious scripts.
  - **Fixed in**: 3.1.3

- **CVE-2024-34064**: Cross-Site Scripting (XSS)
  - **Severity**: Medium
  - **Affected Versions**: Jinja2 < 3.1.4
  - **Description**: Additional XSS vulnerability discovered in template rendering.
  - **Fixed in**: 3.1.4

### 3. Cryptography Package Vulnerability

**Previous Configuration**: `cryptography` (unpinned version)
**Fixed Configuration**: `cryptography>=42.0.4`

**Vulnerabilities Fixed**:

- **NULL Pointer Dereference in PKCS12**
  - **Severity**: Medium
  - **Affected Versions**: cryptography >= 38.0.0, < 42.0.4
  - **Description**: NULL pointer dereference when calling `pkcs12.serialize_key_and_certificates` with non-matching certificate and private key with an hmac_hash override.
  - **Fixed in**: 42.0.4

## Impact Assessment

These vulnerabilities could potentially allow:
- **Cross-site scripting (XSS) attacks** via Jinja2 template injection
- **Open redirect attacks** via malicious Tornado redirects
- **Denial of Service (DoS)** via malformed HTTP data or excessive logging
- **Application crashes** via NULL pointer dereferences in cryptography operations

## Remediation

All vulnerabilities have been remediated by pinning the affected packages to minimum safe versions in the Dockerfile. The fix ensures that:
1. Only secure versions of the packages can be installed
2. Future builds will not inadvertently use vulnerable versions
3. The application is protected against all identified vulnerabilities

## Verification

All fixed versions have been verified against the GitHub Advisory Database to ensure no known vulnerabilities exist in the specified versions.

## Recommendations

1. Regularly update dependencies to the latest stable versions
2. Use automated tools like Renovate or Dependabot to track dependency updates
3. Enable security scanning in CI/CD pipelines (e.g., Grype, Trivy, Snyk)
4. Monitor security advisories for all dependencies

## References

- [Tornado Security Advisories](https://github.com/tornadoweb/tornado/security/advisories)
- [Jinja2 Security Advisories](https://github.com/pallets/jinja/security/advisories)
- [Cryptography Security Advisories](https://github.com/pyca/cryptography/security/advisories)
- [GitHub Advisory Database](https://github.com/advisories)
