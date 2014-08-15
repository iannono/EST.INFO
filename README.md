EST.INFO
========

# STEP

```
ruby lib/crawler/dgtle.rb
# then start server, see what you have got!
```

## delayed job

```
rails generate deloyed_job:active_record
rake db:migrate
```

## add cron job

```
whenever -i --set 'environment=development'
see cron log at '/log/cron.log'
```

## remove job

```
crontab -r
```

## delayed job
```
rake jobs:work
``` 
