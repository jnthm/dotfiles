#path
export OOYALA_REPO_ROOT=/Users/jmettu/repos
export VENDOR_PATH=$OOYALA_REPO_ROOT/vendor
export PATH=/usr/local/Cellar/sbt/0.13.8/bin/:$PATH
#export PATH=/usr/local/Cellar/go/1.5.1/bin:$PATH
export PATH=/usr/local/go/bin:$PATH
#export GOROOT=/usr/local/go
export GOROOT=/usr/local/go
export GOPATH=/usr/local/go
#export PATH=$GOROOT/bin:$PATH
export PATH=$PATH:$HOME/src/go-tools/bin
export GOBIN=$GOPATH/bin
export JUNIT_HOME=/Users/jmettu/IdeaProjects/Junit
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_79.jdk/Contents/Home
export PATH=$JUNIT_HOME/junit-4.12.jar:$PATH
#export PYTHONPATH=$PYTHONPATH:'/Users/jmettu/repos/wario'
export PYTHONPATH=$PYTHONPATH:/System/Library/Frameworks/Python.framework/Versions/2.7/Extras/lib/python
export PATH=$PATH:/usr/local/mysql/bin

#sources
source ~/.hadooprc
source ~/.bash_prompt

#aliases
alias lss='ls -lhtrG'
alias lsa='ls -lhtraG'
alias 'ee="/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl"'
alias grep='grep --color'
alias h='history'
alias c='clear'
alias myBash='source ~/.bash_profile'
alias e="/usr/local/Cellar/emacs/24.5/Emacs.app/Contents/MacOS/Emacs"
alias en="/usr/local/Cellar/emacs/24.5/Emacs.app/Contents/MacOS/Emacs -nw"
alias gitlog="git log --pretty=format:\"%h %s\" HEAD~3..HEAD"
alias godep="/Users/jmettu/src/go-tools/bin/godep"
export STORM_HOME="/Users/jmettu/repos/oss/apache-storm-0.9.2-incubating/"
export PATH=$STORM_HOME/bin:$PATH

#pers
complete -W '`ls $HOME/.dsh/group`' pdsh -g
complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh
eval "$(rbenv init -)"
export HISTTIMEFORMAT="%d/%m/%y %T "
export VAGRANT_DEFAULT_PROVIDER=virtualbox
eval "$(rbenv init -)"
export CHEF_REPO=/Users/jmettu/repos/chef/chef-repo
export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >> ~/.logs/bash-history-$(date "+%Y-%m-%d").log; fi'

export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
export PATH=/Users/jmettu/repos/oss/activator-1.3.10-minimal/bin:$PATH

export CASSANDRA_HOME=/Users/jmettu/repos/oss/apache-cassandra-3.7
export PATH=$CASSANDRA_HOME/bin:$PATH

function stash() {
  originUrl=`git config --get remote.origin.url`
  echo $originUrl
  if [[ $originUrl == *"git.corp"* ]]
  then
    open $(git config --get remote.origin.url | sed "s#.*/\(.*\)/\(.*\)\.git#https://git.corp.ooyala.com/projects/\1/repos/\2"#)
  else
    open http://$(git config --get remote.origin.url | tr : /)

  fi
}

eval "$(thefuck --alias fuck)"	

#==================DOCKER====================
export HOST_IP=192.168.99.100

function docker_start
{
		docker-machine env default
		eval $(docker-machine env default)
}
function mesos_master
{
		docker run --net="host" \
					 --name mesos_master \
					 -p 5050:5050 \
					 -e "MESOS_HOSTNAME=${HOST_IP}" \
					 -e "MESOS_IP=${HOST_IP}" \
					 -e "MESOS_ZK=zk://${HOST_IP}:2181/mesos" \
					 -e "MESOS_PORT=5050" \
					 -e "MESOS_LOG_DIR=/var/log/mesos" \
					 -e "MESOS_QUORUM=1" \
					 -e "MESOS_REGISTRY=in_memory" \
					 -e "MESOS_WORK_DIR=/var/lib/mesos" \
					 -it -d garland/mesosphere-docker-mesos-master
}

function mesos_slave
{
		docker run -d \
					 --name mesos_slave_1 \
					 --entrypoint="mesos-slave" \
					 -e "MESOS_MASTER=zk://${HOST_IP}:2181/mesos" \
					 -e "MESOS_LOG_DIR=/var/log/mesos" \
					 -e "MESOS_LOGGING_LEVEL=INFO" \
					 garland/mesosphere-docker-mesos-master:latest
}

function zookeeper
{
		docker run -d \
					 --name zookeeper \
					 -p 2181:2181 \
					 -p 2888:2888 \
					 -p 3888:3888 \
					 garland/zookeeper
}

function mesos_marathon
{
		docker run \
					 --name mesos_marathon \
					 -d \
					 -p 8080:8080 \
					 garland/mesosphere-docker-marathon --master zk://${HOST_IP}:2181/mesos --zk zk://${HOST_IP}:2181/marathon
}

function docker_ps
{
		docker ps -a --format "{{.ID}}, {{.Names}}: {{.Command}}, {{.Status}}, {{.Ports}}"
}


function wario_mariadb
{
		docker run --name wario_mariadb -p 3306:3306 -e MYSQL_ALLOW_EMPTY_PASSWORD=YES -d mariadb:latest
}
