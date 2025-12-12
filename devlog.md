# Devlog

## Todo

  - [ ] Micro text editor doesn't correctly integrate with system clipboard within container
  	- it's actually impossible to copy text out of Micro at all, you need a workaround like `cat {filename}`
  - [ ] Setup Brewfile
	- [ ] Figure out why `cd` by itself sends you to an empty dir from which there is no return
	- [ ] fix unicode symbols not working in tmux
	- [ ] Set up VSCode DevContainers extension
	  - [ ] Add to readme
	- [ ] Add "development servers" section to readme
	- [ ] Fix Homebrew install (not consistently working)
	  - Seems like Homebrew doesn't like being run as root user. Need to create a 'brew' user and install Homebrew with that.
	- [ ] Convert fish functions to shell scripts
	- [ ] Make it easier to copy stuff into and out of container
	- [x] Set up SSH agent forwarding
	  - [ ] Add to readme
	- [x] Allocate more memory to VM and container

---

## 20251205

Working on a better system for SSH.

1. Create dedicated keypair for container

1. Start ssh-agent:

	- Fish: `eval (ssh-agent -c)`
	- Bash: `eval "$(ssh-agent -s)"`

1. Add the key to the agent, and verify it's available to the host:

`ssh-add ~/.ssh/keyname`

`ssh-add -l`

1. Start docker container with mounted socket

This is where things got tricky. 

First, you need to run colima with `--ssh-agent` to enable agent forwarding.

Next, create the container. These two commands worked for me:

```
set COLIMA_SSH_AUTH_SOCK $(colima ssh eval 'echo $SSH_AUTH_SOCK')
docker run -it -m 8g -p 3000:3000 -v $COLIMA_SSH_AUTH_SOCK:$COLIMA_SSH_AUTH_SOCK -e SSH_AUTH_SOCK=$COLIMA_SSH_AUTH_SOCK --name <container> airlock
```

Referenced these resources:
- https://github.com/abiosoft/colima/issues/127#issuecomment-1014474574
- https://github.com/gustavoguarda/ssh-agent-forward-colima/blob/main/docker-compose.yml

1. Inside the container, test that the ssh-agent is being forwarded:

`ssh-add -l`

Then test authentication with Github:

`ssh -T git@github.com`.

Success!

## 17-11-2025

Turns out
[this StackExchange thread](https://askubuntu.com/questions/410048/utf-8-character-not-showing-properly-in-tmux)
(remember StackExchange?) had the answer to the tmux Unicode issue.
Run tmux with the `-u` flag to force it to display Unicode symbols.
There's probably a way to fix this with environment variables, but I've been down that road before without success.
For now, I'm just aliasing `tmux` to `tmux -u`.

## 13-11-2025

Created the `al` fish function to quickly add new terminals:

```fish
function al
    if test (count $argv) -eq 0
        echo "Usage: al <container-name>"
        return 1
    end
    docker exec -it $argv /home/linuxbrew/.linuxbrew/bin/fish
end
```

## 4-11-2025

Troubleshooting the unicode symbols issue.

|               | Normal environment | Within Docker     |
| ------------- | ------------------ | ----------------- |
| Normal shell  | Correct symbols    | Correct           |
| Within tmux   | Correct            | Incorrect symbols |

## 31-10-2025 🎃

Ran `locale` and found that everything was set to basic POSIX, 
which maybe explains the lack of Unicode symbol support.

Adding this to Dockerfile: `ENV LANG=C.UTF-8 LC_ALL=C.UTF-8`

## 30-10-2025

Localhost isn't forwarded automatically, so my Docusaurus dev server at
`http://localhost:3000` was inaccessible outside the container.
This is a feature of Docker's network isolation.

Fixed by adding `--host 0.0.0.0` to my `yarn start` command.

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
