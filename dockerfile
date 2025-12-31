FROM node:20-slim

ENV HOME=/airlock
WORKDIR /airlock

# Set UTF
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# For React to use instead of localhost, which is unavailable
ENV HOST=0.0.0.0

# install CLI tools
RUN apt-get update && apt-get install -y \
  jq \
	git \ 
	tmux \
	curl \
	micro \
	fish \
	bash \
	# Clean up package lists
	&& rm -rf /var/lib/apt/lists/*

# Homebrew setup
# --------------
# turned off, currently failing for some reason
# install Homebrew
# RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# RUN /bin/bash echo >> /root/.bashrc \
# 	echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /root/.bashrc \
# 	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" 

# install packages that are in Homebrew but not apt
# RUN /bin/bash brew install lazygit

# install Claude Code
# RUN npm install -g @anthropic-ai/claude-code

CMD ["bash"]
