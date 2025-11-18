# Security Policy

## Supported Versions

We release patches for security vulnerabilities. Currently supported versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

The Sheikh AI team takes security bugs seriously. We appreciate your efforts to responsibly disclose your findings, and will make every effort to acknowledge your contributions.

### Where to Report

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, please report them via email to:

**Email:** likhonsexikh@gmail.com

**Subject:** [SECURITY] Brief description of the vulnerability

### What to Include

Please include the following information in your report:

- **Type of issue** (e.g., buffer overflow, SQL injection, cross-site scripting, etc.)
- **Full paths of source file(s)** related to the manifestation of the issue
- **Location of the affected source code** (tag/branch/commit or direct URL)
- **Step-by-step instructions** to reproduce the issue
- **Proof-of-concept or exploit code** (if possible)
- **Impact of the issue**, including how an attacker might exploit it

### Response Timeline

- **Initial Response:** Within 48 hours
- **Status Update:** Within 7 days
- **Resolution Timeline:** Depends on severity
  - Critical: 7-14 days
  - High: 14-30 days
  - Medium: 30-60 days
  - Low: 60-90 days

### What to Expect

1. **Acknowledgment:** We'll confirm receipt of your vulnerability report
2. **Assessment:** We'll assess the vulnerability and determine its impact
3. **Communication:** We'll keep you informed of our progress
4. **Resolution:** We'll develop and test a fix
5. **Disclosure:** We'll coordinate disclosure timing with you
6. **Credit:** We'll acknowledge your contribution (if desired)

## Security Best Practices

### For Users

1. **Keep Updated:** Always use the latest version
2. **Secure Configuration:**
   - Change default passwords
   - Use strong JWT secrets
   - Enable HTTPS in production
   - Limit network exposure
3. **Environment Variables:** Never commit `.env` files
4. **API Keys:** Rotate API keys regularly
5. **Monitoring:** Enable logging and monitoring

### For Developers

1. **Dependencies:** Regularly update dependencies
2. **Code Review:** All changes must be reviewed
3. **Input Validation:** Validate and sanitize all inputs
4. **Authentication:** Use secure authentication mechanisms
5. **Authorization:** Implement proper access controls
6. **Encryption:** Encrypt sensitive data at rest and in transit
7. **Secrets Management:** Use environment variables, not hardcoded secrets
8. **SQL Injection:** Use parameterized queries
9. **XSS Prevention:** Sanitize user inputs in frontend
10. **CSRF Protection:** Implement CSRF tokens

## Security Features

### Current Implementation

- **JWT Authentication:** Secure token-based authentication
- **Password Hashing:** bcrypt for password storage
- **CORS Configuration:** Configurable CORS policies
- **Rate Limiting:** API rate limiting to prevent abuse
- **Input Validation:** Pydantic models for data validation
- **Sandbox Isolation:** Isolated code execution environment
- **Environment-based Secrets:** Configuration through environment variables

### Planned Enhancements

- [ ] Two-factor authentication (2FA)
- [ ] API key rotation
- [ ] Advanced intrusion detection
- [ ] Security audit logging
- [ ] Automated vulnerability scanning

## Security Checklist for Deployment

### Before Production Deployment

- [ ] Change all default passwords
- [ ] Generate unique SECRET_KEY and JWT_SECRET
- [ ] Enable HTTPS/TLS
- [ ] Configure firewall rules
- [ ] Set up MongoDB authentication
- [ ] Enable Redis password protection
- [ ] Configure rate limiting
- [ ] Set up monitoring and alerting
- [ ] Enable security headers
- [ ] Disable debug mode
- [ ] Review and minimize exposed ports
- [ ] Set up regular backups
- [ ] Configure log rotation
- [ ] Implement intrusion detection
- [ ] Perform security audit

### Configuration Examples

#### Strong Secret Generation

```bash
# Generate SECRET_KEY
openssl rand -hex 32

# Generate JWT_SECRET
openssl rand -base64 32
```

#### Nginx Security Headers

```nginx
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
add_header Content-Security-Policy "default-src 'self'" always;
```

#### Docker Security

```yaml
# docker-compose.yml security settings
services:
  backend:
    read_only: true
    security_opt:
      - no-new-privileges:true
    cap_drop:
      - ALL
```

## Known Vulnerabilities

We maintain transparency about known vulnerabilities. Check our [GitHub Security Advisories](https://github.com/likhonsexikh/sheikh-ai/security/advisories) for current information.

## Security Updates

Security patches are released as:
- **Patch versions** (e.g., 1.0.1) for minor vulnerabilities
- **Minor versions** (e.g., 1.1.0) for moderate vulnerabilities
- **Major versions** (e.g., 2.0.0) for significant security overhauls

Subscribe to our releases to stay informed about security updates.

## Third-Party Dependencies

We regularly audit our dependencies for vulnerabilities:

```bash
# Backend security audit
pip-audit

# Frontend security audit
npm audit
```

## Compliance

Sheikh AI is designed with security best practices in mind, but users are responsible for ensuring their deployment meets their specific compliance requirements (GDPR, HIPAA, SOC2, etc.).

## Bug Bounty Program

Currently, we do not have a formal bug bounty program. However, we greatly appreciate security researchers who responsibly disclose vulnerabilities and will acknowledge contributions in our release notes and documentation.

## Hall of Fame

We recognize security researchers who have helped make Sheikh AI more secure:

<!-- Contributors will be listed here -->

*Your name could be here! Report vulnerabilities responsibly.*

## Contact

For security-related inquiries:
- **Email:** likhonsexikh@gmail.com
- **Subject Line:** [SECURITY] Your subject here

For general questions:
- **GitHub Discussions:** https://github.com/likhonsexikh/sheikh-ai/discussions
- **Issues:** https://github.com/likhonsexikh/sheikh-ai/issues

---

**Thank you for helping keep Sheikh AI and our users safe!**
