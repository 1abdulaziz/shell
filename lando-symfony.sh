#/bin/sh

if [ -z "$1" ];
  then
        exit "blablablabla"
fi

_projectShortName=$1

# we will create a new folder so we can run Lando to use composer from lando
# create new directory for this project
mkdir $_projectShortName
cd $_projectShortName

_create_lando_file () {
cat <<END >.lando.yml
name: $_projectShortName
recipe: symfony
config:
  webroot: web
  php: "8.0"
END
}

_create_lando_file
  
# new 
lando start
lando composer self-update
lando ssh --user root --command "apt-get update && apt-get install wget && wget https://get.symfony.com/cli/installer -O - | bash"
lando ssh --user root --command "git config --global user.email 'aziz.sa03@gmail.com' && git config --global user.name 'abdulaziz zaid'"
lando ssh --user root --command "mv /root/.symfony5/bin/symfony /usr/local/bin/symfony"
lando symfony new --webapp $_projectShortName 
mv $_projectShortName/* ./ 
mv $_projectShortName/.* ./ 

lando composer require mailgun-mailer
lando rebuild -y