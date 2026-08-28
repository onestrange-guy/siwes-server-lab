
# Troubleshooting

**Problem:** `vagrant up` downloads `ubuntu/trusty64` instead of `ubuntu/jammy64`, or says "Machine already provisioned."

**Cause:** Vagrant uses the `Vagrantfile` in your *current directory* — running the command from the wrong folder picks up a leftover project.

**Fix:** Always confirm you're in the correct project folder before running any `vagrant` command:
```bash
pwd    # or "cd" with no arguments on Windows
dir    # confirm Vagrantfile and provision.sh are present
```

---
