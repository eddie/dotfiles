

function set_dnf_max_parallel() {
  if ! grep -q "^max_parallel_downloads=10" /etc/dnf/dnf.conf; then
    echo "Setting max_parallel_downloads=10 in dnf.conf"
    echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf > /dev/null
  fi
}

