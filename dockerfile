FROM node:20-slim

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
	procps \
	htop \
	# Clean up package lists
	&& rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -s /bin/fish -d /airlock dev

# Set ownership of workspace
RUN mkdir -p /airlock && chown dev:dev /airlock

# Node memory limits
ENV NODE_OPTIONS="--max-old-space-size=4096"

USER dev
WORKDIR /airlock
ENV HOME=/airlock

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

CMD ["fish"]
