# Buildkite Build Retry Webhook

An example [Buildkite](https://buildkite.com/) webhook endpoint for retrying builds `n` number of times if they have the `RETRY_BUILDS` meta-data build property present.

## Usage

1. **Deploy it to Heroku** <br>[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

2. **Find the secret:** In your new Heroku app go to Settings → Config Variables → Reveal Config Variables, and copy the `secret` variable value.

3. **Set up the webhook:** In Buildkite go to Settings → Notifications → Webhooks and add a new webhook pointing to your new Heroku app, adding `?secret=your-secret` to the end. For example: `https://your-app-name.herokuapp.com/?secret=your-secret`

4. **Trigger a build with metadata retry_build=n** :tada:

## License

See the [LICENSE](LICENSE.md) file for license rights and limitations (MIT).
