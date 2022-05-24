# Etherscan

  1. Sending Pending Ethereum hashes (https://etherscan.io/txsPending) to Blocknative api, for the watch.
  2. Build a Queue system around erlang's `:queue` to handle blocknative API calls with batch of 10.
  3. Send status to Slack Webhook for a hash which have been confirmed
  4. Send status to Slack Webhook for a hash which is still pending after 2 minutes.