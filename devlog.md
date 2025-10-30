# Devlog

## 30-10-2025

The image build was failing at step 5/7 with this message:

```
/bin/bash: brew: No such file or directory
The command '/bin/sh -c /bin/bash brew install lazygit' returned a non-zero code: 127
```

Looks like the image builds in an 'intermediate container' until it succeeds,
at which point it is tagged with the provided name.

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
