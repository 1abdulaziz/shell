#! /bin/sh

sudo apt install cowsay

if [ -z "$1" ];
  then
        exit "Kaboom"
fi

 
echo "🎉🎉 Salam! Go to make a coffie this process will take around 5-7 minutes 🎉🎉"

mkdir "$1" \
  && cd "$1" \
  && lando init \
    --source cwd \
    --recipe drupal9 \
    --webroot web \
    --name "$1"
    
# Create latest drupal9 project via composer
lando composer create-project drupal/recommended-project:9.x tmp && cp -r tmp/. . && rm -rf tmp

# Start it up
lando start

# Install a site local drush
lando composer require drush/drush

# Install drupal
lando drush site:install --db-url=mysql://drupal9:drupal9@database/drupal9 -y

# List information about this app
lando info

cowsay Hello $USER  
