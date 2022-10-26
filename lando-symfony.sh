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
    
    
_type_composer_create_symfony () {
    lando composer create-project symfony/website-skeleton -n
    mv website-skeleton/* ./
    mv website-skeleton/.* ./
    rm -rf website-skeleton
}

_type_composer_create_symfony

lando composer self-update
lando composer require mailgun-mailer
lando rebuild -y
