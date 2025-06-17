# 🛡️ Securi-Tester

A deliberately vulnerable repo designed to test:

- SAST tools (Semgrep, SonarQube, Bandit)
- DAST tools (ZAP, Burp)
- SCA tools (npm audit, Snyk)
- Secrets scanners (TruffleHog, GitLeaks)
- Runtime/Infra scanners (Checkov, tfsec, Snyk IaC)

All API keys used here are FAKE and follow the simple format to get flagged by tools  


# Some of the findings that should be flagged.

| Type                         | File / Path             | Issue                                                               |
|:-----------------------------|:------------------------|:--------------------------------------------------------------------|
| Secrets                      | public/exposed.env      | AWS, Stripe, SendGrid, Firebase keys                                |
| Secrets                      | config/settings.json    | JWT secret, DB password, Azure/GCP tokens                           |
| Secrets                      | app/main.py, auth.js    | Hardcoded API keys and tokens                                       |
| Secrets                      | README.md comments      | SSH keys, Heroku/CircleCI tokens                                    |
| SAST: SQL Injection          | app/main.py             | f-string SQL query with unsanitized user input                      |
| SAST: Command Injection      | utils.py, main.py       | Shell command execution from user input                             |
| SAST: XSS                    | web.js                  | Reflected XSS via HTML injection                                    |
| SAST: Insecure JWT           | auth.js                 | Hardcoded secret, unsigned tokens                                   |
| SAST: Open Redirect          | main.py                 | Redirect using unvalidated user input                               |
| SAST: Forced Browsing        | main.py                 | Admin page lacks access control                                     |
| SAST: Logging PII            | main.py                 | Sensitive credit card data printed to logs                          |
| DAST: SQL Injection          | /login route            | Injection through user and pass query params                        |
| DAST: Command Injection      | /ping route             | Remote execution through host parameter                             |
| DAST: Reflected XSS          | /greet route            | HTML output reflects user input                                     |
| DAST: Insecure Cookies       | web.js                  | Cookies lack Secure and HttpOnly flags                              |
| DAST: Open Redirect          | /redirect route         | Redirect endpoint lacks validation                                  |
| DAST: Forced Browsing        | /admin route            | Publicly accessible admin functionality                             |
| SCA: Python deps             | requirements.txt        | Insecure versions of Flask, Jinja2, requests, pyjwt                 |
| SCA: Node deps               | package.json            | Outdated lodash, handlebars, angular, debug                         |
| Runtime: EOL Node            | Dockerfile, runtime.txt | Node.js 10.24.1 is end-of-life                                      |
| Runtime: EOL Python          | runtime.txt, Dockerfile | Python 2.7 is deprecated                                            |
| Runtime: EOL OpenSSL         | Dockerfile              | Version 1.0.1f vulnerable to Heartbleed                             |
| Runtime: Deprecated Packages | Dockerfile              | openssh-server=6.6, php-5.4, mysql                                  |
| IaC: Insecure Terraform      | terraform.tf            | Legacy AWS provider, deprecated AMI, outdated packages in user_data |
