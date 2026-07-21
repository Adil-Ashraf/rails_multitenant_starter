# Rails Multi-tenant Starter

A production-minded Rails baseline for multi-tenant SaaS products. It ships with first-party authentication, account membership and roles, strict tenant scoping, PostgreSQL, Docker, Tailwind CSS, CI, and security checks.

## Stack

- Ruby 3.4 and Rails 8.1
- PostgreSQL 17
- Hotwire, Importmap, and Tailwind CSS
- Rails-native session authentication with `bcrypt`
- Minitest, RuboCop, Brakeman, and bundler-audit
- Docker Compose for local development

## Start with Docker

```bash
docker compose build
docker compose up
```

Open <http://localhost:3000>. The web container runs `db:prepare` automatically. Load the optional demo account with `docker compose run --rm web bin/rails db:seed`, then sign in with `owner@example.com` and `password123`. Never use seed credentials in production.

## Local setup

Install Ruby from `.ruby-version`, PostgreSQL, and libvips, then run `bin/setup` followed by `bin/dev`. Database configuration comes from `DB_HOST`, `DB_PORT`, `DB_USER`, and `DB_PASSWORD`. Production uses `DATABASE_URL` and `RAILS_MASTER_KEY`.

## Tenant architecture

`Account` is the tenant. Users join accounts through `Membership`, which carries the `member`, `admin`, or `owner` role. `Current.account` is established from the authenticated user's memberships for every request.

Tenant-owned models should include `AccountScoped` and have an `account_id` foreign key:

```ruby
class Project < ApplicationRecord
  include AccountScoped
end
```

The concern deliberately fails closed when `Current.account` is absent. Background jobs must set context explicitly: `Current.set(account: account) { Project.find(project_id) }`. Use `unscoped` only in carefully reviewed administrative code. For higher-assurance systems, add PostgreSQL row-level security as a second isolation layer.

## Quality checks

Run `bin/rails test`, `bin/rubocop`, `bin/brakeman --quiet --no-pager`, and `bin/bundler-audit`. The generated GitHub Actions workflow runs these checks. Review `SECURITY.md` before publishing or deploying.

## License

Available under the MIT License.
