# google_dynamic_dns_updater

Expects a config file in `~/.google_domains.yaml` looking like:

```
---
:domains:
  - my.domain.com:
    :username: 'google_domain_creds'
    :password: 'google_domain_creds'
```


The `google_dns_update.rb` script will read this, and loop through them updating each domain with your current puclib IP (via `https://domains.google.com/checkip` )

Cron it, or whatever you want
