# Buildkite Build Retry Webhook

An example [Buildkite](https://buildkite.com/) webhook endpoint for retrying builds `n` number of times if they have the `RETRY_BUILDS` meta-data build property present.

## Usage

1. **Deploy it to Heroku** <br>[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

2. **Find the secret:** In your new Heroku app go to Settings → Config Variables → Reveal Config Variables, and copy the `WEBHOOK_TOKEN` variable value.

3. **Set up the webhook:** In Buildkite go to Settings → Notifications → Webhooks and add a new webhook pointing to your new Heroku app, and using the token you copied from your Heroku app’s config.

4. **Trigger a build via the API**: Be sure to include `"meta-data": {"retry_build": n}` :tada:

## License

See the [LICENSE](LICENSE.md) file for license rights and limitations (MIT).
