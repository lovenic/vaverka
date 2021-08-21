Log-based database with a HashMap indexing.

Start server:

- `bin/vaverka init`

Other commands:

- `bin/vaverka get some_key`
- `bin/vaverka insert some_key some_value`

Requests to server:

- `GET localhost:5678/insert?key=some_key&value=some_value`
- `GET localhost:5678/get?key=some_key`

Links:

- https://lokalise.com/blog/create-a-ruby-gem-basics/#Gemfile
- https://dry-rb.org/gems/dry-cli/0.6/
- https://blog.appsignal.com/2016/11/23/ruby-magic-building-a-30-line-http-server-in-ruby.html
- DDIA book
