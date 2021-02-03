# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

## Getting search to work

1. copied across a bunch of files from age uk ox
2. set up route / pages_controller
3. removed dob/opas id references in search.html.erb, search_cache and spec
4. added `SearchCache.refresh` to seed.rb + ran this
5. works in console `SearchCache.get_people_ids("wi").records`
6. `yarn install debounced`,
7. add to app/javascript/packs/application.js

```
import debounced from "debounced";
debounced.initialize();
```
