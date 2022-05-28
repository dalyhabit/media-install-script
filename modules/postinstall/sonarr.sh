#!/bin/bash
apiKey=$(curl 'http://localhost:8989/initialize.js' -H 'Accept: */*' --insecure | grep apiKey | sed -rn "s~apiKey:\s+'(.+)',~\1~ip")

curl 'http://localhost:8989/api/v3/downloadclient?' \
  -H 'Content-Type: application/json' \
  -H "X-Api-Key: $apiKey" \
  --data-raw '{"enable":true,"protocol":"torrent","priority":1,"removeCompletedDownloads":true,"removeFailedDownloads":true,"name":"transmission","fields":[{"name":"host","value":"transmission"},{"name":"port","value":9091},{"name":"useSsl","value":false},{"name":"urlBase","value":"/transmission/"},{"name":"username"},{"name":"password"},{"name":"movieCategory"},{"name":"movieDirectory"},{"name":"recentMoviePriority","value":0},{"name":"olderMoviePriority","value":0},{"name":"addPaused","value":false}],"implementationName":"Transmission","implementation":"Transmission","configContract":"TransmissionSettings","infoLink":"https://wiki.servarr.com/radarr/supported#transmission","tags":[]}'