# Workstation installation setup

Install a workstation from scratch by executing entry.sh.

	curl -L -o entry.sh https://bit.ly/svaworkstation && chmod +x entry.sh && ./entry.sh

For local testing:

	vagrant up

## Things to think about before reinstalling

* make sure everything is backed up
* added software? -- zgrep " install " /var/log/apt/history.log*
* printer config?
* added wifi networks?
* dotfiles?
* /etc/hosts?
* vscode extensions -- code --list-extensions

***This repo is intended to be run headless as root***

