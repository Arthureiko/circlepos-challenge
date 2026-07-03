# CirclePOS Candidate Challenge — Part 1: Monthly Comparison Dashboard

Personal challenge submission (not a Starbem project). Built with **Ruby on Rails 7 + Hotwire (Turbo + Stimulus)**.

## What it does

Shop-owner-facing dashboard comparing monthly sales and gross profit (ex-tax) for the current year vs. the previous year, against the challenge-only CirclePOS API (`https://challenge.circlepos.com/api/challenge`).

- Filters: store, time range (24/36 months), category, channel.
- Year-over-year deltas highlighted per month and in the summary cards (▲ green / ▼ red / → neutral).
- Loading, empty, and error states.
- Responsive layout (mobile → desktop).
- Supports both the 24-month baseline and the 36-month stretch goal.

## Why Rails + Hotwire

The API has no CORS headers, so a pure client-side SPA fetching it directly from the browser would be blocked. Rails fetches the data server-side (`app/services/circle_pos_client.rb`) and renders it as HTML; Turbo Frames handle filter changes without a full page reload, and a small Stimulus controller (`app/javascript/controllers/loading_controller.js`) toggles the busy/loading state during those frame requests. No client-side JS framework or build step needed beyond import maps.

## Running locally

```bash
bin/setup   # or: bundle install
bin/dev     # starts Rails + Tailwind watcher on http://localhost:3000
```

Requires Ruby 3.3+ (see `.ruby-version`).

## Key files

- `app/services/circle_pos_client.rb` — server-side API client (stores, filters, monthly comparison).
- `app/controllers/dashboard_controller.rb` — resolves filters, fetches data, decides loading/empty/error/ok state.
- `app/views/dashboard/show.html.erb` — filters form (GET, targets the Turbo Frame).
- `app/views/dashboard/_results.html.erb` — summary cards + comparison table, state-driven rendering.
- `app/javascript/controllers/loading_controller.js` — busy-state toggle on the results frame.
