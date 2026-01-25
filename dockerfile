FROM node:24-slim

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

# Node memory limits
ENV NODE_OPTIONS="--max-old-space-size=4096"

# Create non-root user
RUN useradd -m -s /bin/fish -d /airlock dev

# Set ownership of workspace
RUN mkdir -p /airlock && chown dev:dev /airlock

# Prep Homebrew directory (Homebrew can't run as root, but dev can't create this directory)
RUN mkdir -p /home/linuxbrew/.linuxbrew && chown -R dev:dev /home/linuxbrew

USER dev
WORKDIR /airlock
ENV HOME=/airlock

# install and setup homebrew
RUN NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

# install packages that are in Homebrew but not apt
# RUN brew install lazygit

# install Claude Code
# RUN npm install -g @anthropic-ai/claude-code

CMD ["fish"]
