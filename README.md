# FairNews alerts

Scheduled job that sends breaking-news push notifications for the FairNews
iPhone app. Every 10 minutes a cron job on the Oracle hub starts the workflow
through the GitHub API (`~/fairnews-dispatch.sh`, failures logged to
`~/fairnews-dispatch.log`; GitHub's own schedule ran only 3-4 times a day). It
checks out the (private) app repository with
a read-only deploy key, builds its alert job on a Linux runner (Swift package in
`Package.swift`, adding swift-crypto), and runs it: fetch public news
feeds, group articles into stories, and alert when 5+ outlets from more than
one side of the spectrum report the same story within 2 hours.

This repository is public so GitHub Actions minutes are free. It contains only
the workflow; credentials (push key, device token, deploy key) are encrypted
repository secrets and never appear in logs. Run logs show news headlines only.

## Settings (repository variables)

| Variable | Meaning | Default |
|---|---|---|
| `MIN_OUTLETS` | Outlets that must report a story within 2 hours | `5` |
| `TOPICS` | Comma list: `top` (all), `world`, `business`, `tech`, `ai`, `science`, `health` | `top` |
| `DRY_RUN` | `1` to detect without sending | unset |
| `APNS_SANDBOX` | `1` for apps installed from Xcode | `1` |
| `APNS_TEAM_ID` | Apple Developer team ID | — |

Secrets: `FAIRNEWS_DEPLOY_KEY`, `DEVICES_DEPLOY_KEY`, `DEVICE_TOKEN`, `DEVICE_TOKENS`, `APNS_KEY`, `APNS_KEY_ID`.

Each alert goes to every phone in the private compudds-star/FairNews-devices
repository (read with the `DEVICES_DEPLOY_KEY` deploy key). The app registers
itself there on launch once alerts are on (Settings › Breaking News shows
"Registered"), so a new phone needs nothing beyond turning alerts on. Delete a
phone's file there to stop alerts to it. Phones can also be listed by hand in
`DEVICE_TOKEN` (the first phone) or `DEVICE_TOKENS` (a comma list), using
**Copy device token** in the app. An alert that reaches at least one phone
isn't retried; failed sends to a phone show in the run log and mark the run as
failed.

The hub's trigger uses a fine-grained token (this repository only, Actions
read/write) stored in `~/.fairnews-dispatch-token`. If alerts stop, check
`~/fairnews-dispatch.log` there; HTTP 401 means the token expired.

To test detection without sending or saving anything, run the workflow with
**Detect breaking news without sending or saving anything** checked.

Some outlets' feeds block GitHub's servers (Cloudflare bot checks), so the job
doesn't see them: Washington Times and Washington Post on any runner, and Axios
on Linux. The run log's "Failed:" line lists them. The app on a phone still
fetches them.

To check that alerts still reach every phone, run the workflow by hand with
**Send one test alert** checked (Actions › Breaking news alerts › Run workflow).
