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
    --php "8.1" \
    --via nginx \
    --webroot public \
    --name "$1"
  
# new 
lando start
lando ssh --user root --command "apt-get update && apt-get install wget && wget https://get.symfony.com/cli/installer -O - | bash"
lando ssh --user root --command "git config --global user.email 'aziz.sa03@gmail.com' &&   git config --global user.name 'abdulaziz zaid'"
lando ssh --user root --command "mv /root/.symfony5/bin/symfony /usr/local/bin/symfony && cd /app && symfony new $1 --version='6.1.*' --webapp"
lando ssh --user root --command "mv /app/$1/* /app && mv /app/$1/.* /app"

# old
#_type_composer_create_symfony () {
#    mv website-skeleton/* ./
#    mv website-skeleton/.* ./
#    rm -rf website-skeleton
#}
#_type_composer_create_symfony

lando composer self-update
#lando composer require mailgun-mailer
lando rebuild -y
