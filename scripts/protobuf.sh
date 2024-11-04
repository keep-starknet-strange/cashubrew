#!/bin/bash

TMP_DIR="tmp-protobuf"
RAW_LNRPC_PROTO_URL="https://raw.githubusercontent.com/lightningnetwork/lnd/refs/tags/v0.18.3-beta/lnrpc/lightning.proto"

mkdir $TMP_DIR
cd $TMP_DIR

curl $RAW_LNRPC_PROTO_URL > "lightning.proto"
protoc --elixir_opt=package_prefix=Cashubrew --elixir_out=plugins=grpc:./ lightning.proto
mv lightning.pb.ex ../lib/cashubrew/lightning/lnd_rpc.pb.ex

cd ..
rm -rf $TMP_DIR
