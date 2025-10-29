FROM node:20-slim

WORKDIR /airlock

# install standard CLI tools
RUN apt-get update && apt-get install -y \
	git \ 
	tmux \
	curl \
	micro \
	nethogs \
	bash

# install Homebrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install Homebrew packages not in included package manager
RUN brew install lazygit

# install Claude Code
RUN npm install -g @anthropic-ai/claude-code

CMD ["/bin/bash"]
