#!/bin/bash

MPD=${1-localhost}

curl -d '{"jsonrpc": "2.0", "id": 1, "method": "core.playback.get_state"}' -H 'Content-Type: application/json' http://$MPD:6680/mopidy/rpc
