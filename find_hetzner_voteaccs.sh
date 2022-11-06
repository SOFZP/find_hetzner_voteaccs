#!/bin/bash

LAST_EPOCH=384

ALL_TESTNET_VALIDATORS=$(solana validators -ut --output json | jq -r '.validators[] | select(.delinquent==true)')


for i in $(echo "$ALL_TESTNET_VALIDATORS" | jq -r '' | jq -r '.identityPubkey')
do
	KYC_API_VERCEL_I=$(curl -s 'https://kyc-api.vercel.app/api/validators/details?pk='$i'&epoch='${LAST_EPOCH})
	if [[ $(curl -s 'https://kyc-api.vercel.app/api/validators/details?pk='$i'&epoch=384' | jq -r '.stats.epoch_data_center.asn') == 24940 ]]; then
		echo "$ALL_TESTNET_VALIDATORS" | jq -r '. | select(.identityPubkey=="'$i'")' | jq -r '.voteAccountPubkey'
	fi
done
