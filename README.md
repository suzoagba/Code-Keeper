
# DevOps Audit-Ready: GitLab CI/CD + Ansible + Terraform

## What this repository includes
- **CI/CD (GitLab):** `.gitlab-ci.yml` — Build, Test, Scan, Containerize, Deploy to Staging, Approval, Deploy to Production. Triggers restricted to protected branches.
- **Ansible (GitLab & Runner):** `ansible/gitlab.yml` with `ansible/inventory.ini` to deploy GitLab and register a Docker executor runner.
- **Infrastructure Pipeline (Terraform):** `infra-pipeline/.gitlab-ci.yml` with stages: Init, Validate, Plan, Apply Staging, Approval, Apply Production; workspaces for `staging` and `production`.

## Stakeholder Roleplay (DevOps)
Be prepared to answer:
- DevOps concepts and benefits; collaboration improvements.
- Practices used: IaC, CI/CD, automated testing, containerization, security scans.
- Automation tools: GitLab CI, Ansible, Terraform, Docker.
- CI/CD value: faster, safer delivery with approvals.
- IaC value: consistency and reproducibility.
- Security: protected branches, least privilege, secrets via variables; scanning steps.
- Challenges & mitigations; cost optimization; GitLab & Runners purpose; Ansible advantages; Terraform use; CI/CD for each repo; CD stages.

## How to use

### Ansible — deploy GitLab and Runner
```bash
ansible-playbook -i ansible/inventory.ini ansible/gitlab.yml --list-tasks
# On the target:
sudo gitlab-ctl status
sudo systemctl status gitlab-runner
```

### Application Pipeline (in this repo)
- Commits to `develop`: Build → Test → Scan → Containerize → Deploy to Staging → Approval
- Commits to `main`: Approval → Deploy to Production
- Set GitLab CI Variables: `CI_REGISTRY_USER`, `CI_REGISTRY_PASSWORD`, and cloud creds.

### Infrastructure Pipeline
- In `infra-pipeline/`, GitLab CI stages: Init → Validate → Plan → Apply Staging → Approval → Apply Production
- Two environments kept similar via workspaces and `env/*.tfvars`.

## Security Checklist
- **Protected branches** only deploy (see `.gitlab-ci.yml` rules).
- **Credentials** are not stored in code; use GitLab CI variables or a vault.
- **Least privilege** for service accounts and cloud IAM.
- **Dependency updates** via scheduled scans.

## Documentation coverage
- README provides prerequisites, setup, configuration, and usage.
- Diagrams can be added as `docs/diagram.png` if required.

## Notes
- Replace placeholders in `ansible/inventory.ini` and CI variables before running.
- Connect `infra-pipeline/terraform/main.tf` to your real modules for `cloud-design` infra and `crud-master` app.


### Security & Quality Scans
- **Trivy**: The `scan` job runs `trivy fs` (file-system scan) and optionally `trivy image` if an image tag exists.
- **SonarQube** (optional): `sonar_scan` runs when `SONAR_HOST_URL`, `SONAR_TOKEN`, and `SONAR_PROJECT_KEY` are defined in GitLab CI variables. Configure `sonar-project.properties` at the repo root.

### Required/Recommended CI Variables
- Container registry: `CI_REGISTRY_USER`, `CI_REGISTRY_PASSWORD` (or use GitLab-provided auth).
- SonarQube (optional): `SONAR_HOST_URL`, `SONAR_TOKEN`, `SONAR_PROJECT_KEY` (and `SONAR_ORG` if using SonarCloud).
- Terraform: backend creds if using remote state; set `TF_VAR_cloud_design_module_source` to point to your real infra module, and `TF_VAR_region` if not `eu-west-1`.
- Protected branches: ensure `main` and `develop` are marked protected in **Settings → Repository → Protected Branches**.

### Diagram
See `docs/diagram.txt` for the pipeline and tooling flow.

# Author:
Samuel Uzoagba