#!/bin/bash

### //////////////////////////////////////////////////////
####  methods to support install code ####

print-header () {
   echo ""
   echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
   echo "$1"
   echo ""
}

start-section () {
   echo ""
   echo ">>@ $1 $2 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

}

is-package-installed () {

  ver="--version"
  if [[ $2 != '' ]]; then
    ver=$2
  fi

  if ! command -v $1 $ver >/dev/null; then
     return 1
  fi

  show-version $1 "$ver"
  return 0
}

does-app-exist () {
  if ! which $1 >/dev/null; then
     return 1
  fi
  show-loc $1
  return 0

}

install () {
    echo ""
    echo "!!!!!!!!!!! $1 install start !!!!!!!!!!!!!"
    echo "exec: sudo snap install $1 $2"
   
    sudo snap install $1 $2
   
    echo "~~~~~~~~~~~ $1 install end  ~~~~~~~~~~~~~~"
    echo ""
}

install-apt () {
    echo ""
    echo "!!!!!!!!!!! $1 install start !!!!!!!!!!!!!"
    echo "exec: sudo apt-get -y install $1 $2"
    
    sudo apt-get -y install $1 $2
    
    echo "~~~~~~~~~~~ $1 install end  ~~~~~~~~~~~~~~"
    echo ""
}

install-gem () {
    echo ""
    echo "!!!!!!!!!!! $1 install start !!!!!!!!!!!!!"
    echo "exec: sudo gem install $1 $2"
   
    sudo gem install $1 $2

    echo "~~~~~~~~~~~ $1 install end  ~~~~~~~~~~~~~~"
    echo ""
}

install-npm () {
    echo ""
    echo "!!!!!!!!!!! $1 install start !!!!!!!!!!!!!"
    echo "exec: sudo npm -g install $1 $2"
   
    sudo npm -g install $1 $2

    echo "~~~~~~~~~~~ $1 install end  ~~~~~~~~~~~~~~"
    echo ""
}


show-version () {

  ver="--version"
  if [[ $2 != '' ]]; then
    ver=$2
  fi
  fmt="%-19s%s%-69s\n"
  version=$($1 $ver 2> /dev/null | head -1)

  printf "$fmt" " $1" ": " "$version"
  return 0

}

show-loc () {

  fmt="%-19s%s%s\n"
  printf "$fmt" " $1" ": " "$(which $1)"
  return 0

}

### //////////////////////////////////////////////////////
### actual code of the script #####

print-header "ensure requirements for installation"

if ! is-package-installed snap ; then
    echo "**********"
    echo "snap is required to run this script"
    echo "     install it before running this script"
    exit 0
fi

echo "refreshing snap..."
sudo snap refresh

echo "updating apt-get..."
sudo apt-get -y update

############################################################
print-header "checking your development tools"

start-section "Dev languages"

if ! is-package-installed dotnet ; then
    install dotnet-sdk --classic
    show-version dotnet-sdk
fi

if ! is-package-installed gcc ; then
    install-apt build-essentails
    show-version gcc
fi

if ! is-package-installed go version ; then
    install go --classic
    show-version go version
fi

if ! is-package-installed groovy ; then
    install groovy --classic
    show-version groovy
fi

if ! is-package-installed g++ ; then
    install-apt g++
    show-version g++
fi

if ! is-package-installed javac ; then
    install openjdk
    show-version javac
fi

if ! is-package-installed node ; then
    sudo curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
    show-version node
fi

if ! is-package-installed python3 ; then
    install-apt python3.10
    show-version python3
fi

if ! is-package-installed ruby ; then
    install ruby --classic
    show-version ruby
fi

if ! is-package-installed rustc ; then
    echo "need to install rustc (curl & sh)"
    sudo curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    show-version rustc
fi

if ! is-package-installed tsc ; then
    install-npm typescript --save-dev
    show-version tsc
fi


############################################################
start-section "CLI tools"

if ! is-package-installed aws ; then
    install aws-cli --classic
    show-version aws
fi

if ! is-package-installed az ; then
    sudo curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    show-version az
fi

if ! is-package-installed bazel ; then
    curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg
    sudo mv bazel-archive-keyring.gpg /usr/share/keyrings
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
    sudo apt-get update

    install-apt bazel
    show-version bazel
fi

if ! is-package-installed cdk ; then
    echo "need to install CDK (npm)"
    sudo npm install -g aws-cdk
    show-version cdk
fi

if ! is-package-installed cmake ; then
    install-apt cmake
    show-version cmake
fi

if ! is-package-installed create-react-app ; then
    install-npm create-react-app 
    show-version create-react-app
fi

if ! is-package-installed flutter ; then
    install flutter --classic
    show-version flutter
fi

if ! is-package-installed dart ; then
    echo "TODO: dart should have installed with flutter"
fi


if ! is-package-installed gh ; then
    install gh
    show-version gh
fi

if ! is-package-installed git ; then
    install git-ubuntu --classic
    show-version git
fi

if ! is-package-installed gradle ; then
    install gradle --classic
    show-version gradle
fi

if ! is-package-installed httpie ; then
    install httpie
    show-version httpie
fi

if ! is-package-installed jq ; then
    install jq
    show-version jq
fi

if ! is-package-installed kubectl "version --short"; then
    install kubectl --classic
    show-version kubectl "version --short"
fi

if ! is-package-installed mvn ; then
    install-apt maven
    show-version mvn
fi

if ! is-package-installed newman ; then
    install-npm newman 
    show-version newman
fi

if ! is-package-installed ng version; then
    install-npm @angular/cli 
    show-version ng version
fi

if ! is-package-installed nmap ; then
    install-apt nmap
    show-version nmap
fi

if ! is-package-installed npm ; then
    echo "TODO: npm should have installed with node"
fi

if ! is-package-installed pip3 ; then
    install-apt python3-pip
    show-version pip3
fi

if ! is-package-installed pulumi version ; then
    echo "need to install pulumi (curl & sh)"
    sudo curl -fsSL https://get.pulumi.com | sh
    show-version pulumi version
fi

# need to comment, app doesnt support --version 
#
#if ! is-package-installed openai ; then
#    # https://beta.openai.com/docs/guides/fine-tuning
#    pip install --upgrade openai
#    show-version openai
#
#    # todo: WARNING: The script openai is installed in '~/.local/bin' which is not on PATH.
# fi


#if ! is-package-installed rails ; then
#    install-gem rails 
#    show-version rails
#fi

if ! is-package-installed snyk ; then
    install-npm snyk
    show-version snyk
fi

if ! is-package-installed terraform ; then
    install terraform --classic
    show-version terraform
fi

############################################################
start-section "UI tools"

if ! does-app-exist atom ; then
    install atom --classic
    show-loc atom
fi

if ! is-package-installed code ; then
    install code --classic
    show-version code
fi

if ! is-package-installed gitkraken ; then
    install git-kraken --classic
    show-loc git-kracken
fi

if ! does-app-exist postman ; then
    install postman
    show-loc postman 
fi

if ! does-app-exist slack ; then
    install slack
    show-loc slack
fi

#// not a cli, so we need to test another way
if ! does-app-exist zoom-client ; then
    install zoom-client
    show-loc zoom-client
fi

############################################################
start-section "DB tools"

if ! is-package-installed mariadb ; then
    install-apt mariadb-server
    show-version mariadb
fi

if ! is-package-installed sqlite3 ; then
    install-apt sqlite3
    show-version sqlite3
fi

if ! is-package-installed sqlitebrowser ; then
    install-apt sqlitebrowser
    show-version sqlitebrowser 
fi


print-header "end of install script..."


#if ! is-package-installed notgoingtowork ; then
#    echo "need to install notgoingtowork"
#fi


