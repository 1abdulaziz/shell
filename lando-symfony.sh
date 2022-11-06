#/bin/sh

if [ -z "$1" ];
  then
        exit "blablablabla"
fi

mkdir "$1" \
  && cd "$1" \
  && lando init \
    --source cwd \
    --recipe symfony \
    --webroot public \
    --name "$1"
  
# new 
lando start
lando composer self-update
# lando ssh --user root --command "apt-get update && apt-get install wget && wget https://get.symfony.com/cli/installer -O - | bash"
# lando ssh --user root --command "git config --global user.email 'aziz.sa03@gmail.com' && git config --global user.name 'abdulaziz zaid'"
# lando ssh --user root --command "mv /root/.symfony5/bin/symfony /usr/local/bin/symfony"
lando ssh --user root --command "cd /app && symfony new --website $1 --webapp"
lando ssh --user root --command "mv /app/$1/* /app"
lando ssh --user root --command "mv /app/$1/.* /app"

# oldmv /app/ly6/* /app
#_type_composer_create_symfony () {
#    lando composer create-project symfony/skeleton:"6.1.*"
#    mv skeleton/* ./
#    mv skeleton/.* ./
#    rm -rf skeleton
#}
#_type_composer_create_symfony

#lando composer require mailgun-mailer
lando rebuild -y


/bin/sh

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
  php: 8.1
END
}

_create_lando_file
  
# new 
lando start
lando composer self-update
#lando ssh --user root --command "apt-get update && apt-get install wget && wget https://get.symfony.com/cli/installer -O - | bash"
#lando ssh --user root --command "git config --global user.email 'aziz.sa03@gmail.com' && git config --global user.name 'abdulaziz zaid'"
#lando ssh --user root --command "mv /root/.symfony5/bin/symfony /usr/local/bin/symfony"
lando ssh --user root --command "cd /app && composer create-project symfony/skeleton"
lando ssh --user root --command "cd /app && mv skeleton/* /app && cd /app && mv skeleton/.* /app"

#lando composer require mailgun-mailer
#lando rebuild -y


