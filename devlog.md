# Devlog

## 29-10-2025

Homebrew warns the following on startup:

```
Warning: Your CPU architecture (arm64) is not supported. We only support
x86_64 CPU architectures. You will be unable to use binary packages (bottles).

This is a Tier 2 configuration:
  https://docs.brew.sh/Support-Tiers#tier-2
You can report Tier 2 unrelated issues to Homebrew/* repositories!
Read the above document before opening any issues or PRs.
```

I get this output when running the container today:

```
/home/linuxbrew/.linuxbrew/Homebrew/Library/Homebrew/cmd/shellenv.sh: line 18: /bin/ps: No such file or directory
```
