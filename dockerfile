FROM node:20-slim

WORKDIR /airlock

# install standard CLI tools
RUN apt-get update && apt-get install -y \
	git \ 
	tmux \
	curl \
	micro \
	procps \
	bash

	# Uncomment the below line if you want to clean up package lists
	# && rm -rf /var/lib/apt/lists/*

# install Homebrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Homebrew setup
# RUN /bin/bash echo >> /root/.bashrc \
# 	echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /root/.bashrc \
# 	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" 

# install packages that are in Homebrew but not apt
# currently failing for some reason
# RUN /bin/bash brew install lazygit

# install Claude Code
RUN npm install -g @anthropic-ai/claude-code

CMD ["/bin/bash"]
