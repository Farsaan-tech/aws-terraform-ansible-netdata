# Screenshot evidence

These images are extracted from the user's source PDF. They are evidence of what the source document showed, not validation of the improved repository code.

| File | Source page | Content | Recommended use |
|---|---:|---|---|
| `aws-instances.png` | 4 | AWS console showing Ansible control node and the two project instances running | README deployment evidence, after redaction/review |
| `ansible-connectivity.png` | 5 | `ansible all -m ping` success output | Connectivity verification |
| `nginx-playbook.png` | 7 | Nginx playbook execution recap | Configuration evidence |
| `netdata-playbook.png` | 8 | Netdata playbook execution recap | Backend configuration evidence |
| `netdata-dashboard.png` | 9 | Netdata UI opened through the frontend public address on port 19999 in the source run | Final application evidence; note that the source URL/port differs from the improved port-80 design |

Before publishing, inspect screenshots for public IP addresses, account identifiers, usernames, and other operational details. Redact any information you do not want public. For the best portfolio presentation, replace these source-PDF captures with fresh screenshots from a clean run of this repository, showing the Terraform plan/apply, generated inventory with addresses redacted, CI checks, and browser access through `http://FRONTEND_PUBLIC_IP/`.
