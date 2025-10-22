`feat(userdata): add nginx bootstrap script`

#!/bin/bash
set -euxo pipefail

# Keep User Data free of secrets
apt-get update -y
apt-get install -y nginx
systemctl enable nginx
systemctl start nginx

cat >/var/www/html/index.html <<'HTML'
<!doctype html>
<html>
<head><meta charset="utf-8"><title>EC2/EBS Micro Stack</title></head>
<body>
<h1>It works! EC2 + EBS (Encrypted) + IMDSv2 + Snapshots</h1>
<p>Phase 1 baseline deployment.</p>
</body>
</html>
HTML
