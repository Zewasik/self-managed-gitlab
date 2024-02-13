curl --request POST --header "PRIVATE-TOKEN: ${PRIVATE_TOKEN}" "${CI_API_V4_URL}/groups/movie-service/variables" --form "key=${1}" --form "value=${2}:${3}"
curl --request PUT --header "PRIVATE-TOKEN: ${PRIVATE_TOKEN}" "${CI_API_V4_URL}/groups/movie-service/variables/${1}" --form "value=${2}:${3}"
