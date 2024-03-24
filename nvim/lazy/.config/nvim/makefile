installdeps-fedora:
	#install lemonade to handle ssh clipboards
	go install github.com/lemonade-command/lemonade@latest
	sudo dnf install fzf

verifydeps:
	lemonade --help

install:
	yes | cp -rvf ./* ~/.config/nvim/

adopt:
	yes | cp -rvf ~/.config/nvim/* ./
