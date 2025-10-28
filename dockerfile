FROM node:20-slim

WORKDIR /airlock

RUN apt-get update && apt-get install -y \
	git \ 
	tmux \
	curl \
	micro \
	nethogs \
	bash

RUN npm install -g @anthropic-ai/claude-code

CMD ["/bin/bash"]
