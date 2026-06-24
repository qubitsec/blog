#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

BUILD_DIR=""
cleanup() {
  if [[ -n "${BUILD_DIR:-}" && -d "$BUILD_DIR" ]]; then
    rm -rf "$BUILD_DIR"
  fi
}
trap cleanup EXIT
trap 'echo "ERROR: build stopped at line ${LINENO}" >&2' ERR

echo "Pulling latest changes from Git..."
git pull --autostash --rebase origin main

echo "Building Hugo site in a temporary directory..."
BUILD_DIR="$(mktemp -d "${ROOT_DIR}/.public-build.XXXXXX")"
hugo --destination "$BUILD_DIR" --gc --logLevel info

echo "Injecting Naver Analytics script..."
FILES=(
  "$BUILD_DIR/ko/index.html"
  "$BUILD_DIR/ja/index.html"
)

for file in "${FILES[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "ERROR: required output file is missing: $file" >&2
    exit 1
  fi

  if ! grep -q 'wcslog.js' "$file"; then
    sed -i '/<\/head>/i\
<script type="text/javascript" src="//wcs.naver.net/wcslog.js"></script>\
<script type="text/javascript">\
if (typeof wcs_add === "undefined") { var wcs_add = {}; }\
wcs_add["wa"] = "69ad6b58cb0908";\
if (window.wcs) { wcs_do(); }\
</script>' "$file"
  fi
done

echo "Creating language-detecting index.html..."
cat > "$BUILD_DIR/index.html" <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Redirecting...</title>
  <script>
    const lang = navigator.language || navigator.userLanguage;
    let redirectTo = "/en/";

    if (lang.startsWith("ko")) {
      redirectTo = "/ko/";
    } else if (lang.startsWith("ja")) {
      redirectTo = "/ja/";
    }

    const currentPath = window.location.pathname;
    if (!/^\/(ko|ja|en)\//.test(currentPath)) {
      window.location.replace(redirectTo);
    }
  </script>
</head>
<body>
  Redirecting...
</body>
</html>
EOF

echo "Publishing verified output..."
command -v rsync >/dev/null 2>&1 || {
  echo "ERROR: rsync is required for safe publishing." >&2
  exit 1
}

echo "Publishing verified output..."

mkdir -p "$ROOT_DIR/public"

rsync -a --delete \
  "$BUILD_DIR/" \
  "$ROOT_DIR/public/"

# mktemp 디렉터리의 700 권한이 public에 전파되는 것을 방지
find "$ROOT_DIR/public" -type d -exec chmod 755 {} +
find "$ROOT_DIR/public" -type f -exec chmod 644 {} +

# SELinux 컨텍스트 복구
if command -v restorecon >/dev/null 2>&1; then
  restorecon -RF "$ROOT_DIR/public"
fi

echo "Build and publish completed successfully."
