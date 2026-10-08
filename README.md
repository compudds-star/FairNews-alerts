# FairNews alerts

Scheduled job that sends breaking-news push notifications for the FairNews
iPhone app. Every ~10 minutes it checks out the (private) app repository with
a read-only deploy key, builds its alert job, and runs it: fetch public news
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

Secrets: `FAIRNEWS_DEPLOY_KEY`, `DEVICE_TOKEN`, `APNS_KEY`, `APNS_KEY_ID`.

To check that alerts still reach the phone, run the workflow by hand with
**Send one test alert** checked (Actions › Breaking news alerts › Run workflow).
