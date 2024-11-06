defmodule Cashubrew.Lnrpc.OutputScriptType do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:SCRIPT_TYPE_PUBKEY_HASH, 0)
  field(:SCRIPT_TYPE_SCRIPT_HASH, 1)
  field(:SCRIPT_TYPE_WITNESS_V0_PUBKEY_HASH, 2)
  field(:SCRIPT_TYPE_WITNESS_V0_SCRIPT_HASH, 3)
  field(:SCRIPT_TYPE_PUBKEY, 4)
  field(:SCRIPT_TYPE_MULTISIG, 5)
  field(:SCRIPT_TYPE_NULLDATA, 6)
  field(:SCRIPT_TYPE_NON_STANDARD, 7)
  field(:SCRIPT_TYPE_WITNESS_UNKNOWN, 8)
  field(:SCRIPT_TYPE_WITNESS_V1_TAPROOT, 9)
end

defmodule Cashubrew.Lnrpc.CoinSelectionStrategy do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:STRATEGY_USE_GLOBAL_CONFIG, 0)
  field(:STRATEGY_LARGEST, 1)
  field(:STRATEGY_RANDOM, 2)
end

defmodule Cashubrew.Lnrpc.AddressType do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:WITNESS_PUBKEY_HASH, 0)
  field(:NESTED_PUBKEY_HASH, 1)
  field(:UNUSED_WITNESS_PUBKEY_HASH, 2)
  field(:UNUSED_NESTED_PUBKEY_HASH, 3)
  field(:TAPROOT_PUBKEY, 4)
  field(:UNUSED_TAPROOT_PUBKEY, 5)
end

defmodule Cashubrew.Lnrpc.CommitmentType do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:UNKNOWN_COMMITMENT_TYPE, 0)
  field(:LEGACY, 1)
  field(:STATIC_REMOTE_KEY, 2)
  field(:ANCHORS, 3)
  field(:SCRIPT_ENFORCED_LEASE, 4)
  field(:SIMPLE_TAPROOT, 5)
end

defmodule Cashubrew.Lnrpc.Initiator do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:INITIATOR_UNKNOWN, 0)
  field(:INITIATOR_LOCAL, 1)
  field(:INITIATOR_REMOTE, 2)
  field(:INITIATOR_BOTH, 3)
end

defmodule Cashubrew.Lnrpc.ResolutionType do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:TYPE_UNKNOWN, 0)
  field(:ANCHOR, 1)
  field(:INCOMING_HTLC, 2)
  field(:OUTGOING_HTLC, 3)
  field(:COMMIT, 4)
end

defmodule Cashubrew.Lnrpc.ResolutionOutcome do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:OUTCOME_UNKNOWN, 0)
  field(:CLAIMED, 1)
  field(:UNCLAIMED, 2)
  field(:ABANDONED, 3)
  field(:FIRST_STAGE, 4)
  field(:TIMEOUT, 5)
end

defmodule Cashubrew.Lnrpc.NodeMetricType do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:UNKNOWN, 0)
  field(:BETWEENNESS_CENTRALITY, 1)
end

defmodule Cashubrew.Lnrpc.InvoiceHTLCState do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:ACCEPTED, 0)
  field(:SETTLED, 1)
  field(:CANCELED, 2)
end

defmodule Cashubrew.Lnrpc.PaymentFailureReason do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:FAILURE_REASON_NONE, 0)
  field(:FAILURE_REASON_TIMEOUT, 1)
  field(:FAILURE_REASON_NO_ROUTE, 2)
  field(:FAILURE_REASON_ERROR, 3)
  field(:FAILURE_REASON_INCORRECT_PAYMENT_DETAILS, 4)
  field(:FAILURE_REASON_INSUFFICIENT_BALANCE, 5)
  field(:FAILURE_REASON_CANCELED, 6)
end

defmodule Cashubrew.Lnrpc.FeatureBit do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:DATALOSS_PROTECT_REQ, 0)
  field(:DATALOSS_PROTECT_OPT, 1)
  field(:INITIAL_ROUING_SYNC, 3)
  field(:UPFRONT_SHUTDOWN_SCRIPT_REQ, 4)
  field(:UPFRONT_SHUTDOWN_SCRIPT_OPT, 5)
  field(:GOSSIP_QUERIES_REQ, 6)
  field(:GOSSIP_QUERIES_OPT, 7)
  field(:TLV_ONION_REQ, 8)
  field(:TLV_ONION_OPT, 9)
  field(:EXT_GOSSIP_QUERIES_REQ, 10)
  field(:EXT_GOSSIP_QUERIES_OPT, 11)
  field(:STATIC_REMOTE_KEY_REQ, 12)
  field(:STATIC_REMOTE_KEY_OPT, 13)
  field(:PAYMENT_ADDR_REQ, 14)
  field(:PAYMENT_ADDR_OPT, 15)
  field(:MPP_REQ, 16)
  field(:MPP_OPT, 17)
  field(:WUMBO_CHANNELS_REQ, 18)
  field(:WUMBO_CHANNELS_OPT, 19)
  field(:ANCHORS_REQ, 20)
  field(:ANCHORS_OPT, 21)
  field(:ANCHORS_ZERO_FEE_HTLC_REQ, 22)
  field(:ANCHORS_ZERO_FEE_HTLC_OPT, 23)
  field(:ROUTE_BLINDING_REQUIRED, 24)
  field(:ROUTE_BLINDING_OPTIONAL, 25)
  field(:AMP_REQ, 30)
  field(:AMP_OPT, 31)
end

defmodule Cashubrew.Lnrpc.UpdateFailure do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:UPDATE_FAILURE_UNKNOWN, 0)
  field(:UPDATE_FAILURE_PENDING, 1)
  field(:UPDATE_FAILURE_NOT_FOUND, 2)
  field(:UPDATE_FAILURE_INTERNAL_ERR, 3)
  field(:UPDATE_FAILURE_INVALID_PARAMETER, 4)
end

defmodule Cashubrew.Lnrpc.ChannelCloseSummary.ClosureType do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:COOPERATIVE_CLOSE, 0)
  field(:LOCAL_FORCE_CLOSE, 1)
  field(:REMOTE_FORCE_CLOSE, 2)
  field(:BREACH_CLOSE, 3)
  field(:FUNDING_CANCELED, 4)
  field(:ABANDONED, 5)
end

defmodule Cashubrew.Lnrpc.Peer.SyncType do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:UNKNOWN_SYNC, 0)
  field(:ACTIVE_SYNC, 1)
  field(:PASSIVE_SYNC, 2)
  field(:PINNED_SYNC, 3)
end

defmodule Cashubrew.Lnrpc.PeerEvent.EventType do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:PEER_ONLINE, 0)
  field(:PEER_OFFLINE, 1)
end

defmodule Cashubrew.Lnrpc.PendingChannelsResponse.ForceClosedChannel.AnchorState do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:LIMBO, 0)
  field(:RECOVERED, 1)
  field(:LOST, 2)
end

defmodule Cashubrew.Lnrpc.ChannelEventUpdate.UpdateType do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:OPEN_CHANNEL, 0)
  field(:CLOSED_CHANNEL, 1)
  field(:ACTIVE_CHANNEL, 2)
  field(:INACTIVE_CHANNEL, 3)
  field(:PENDING_OPEN_CHANNEL, 4)
  field(:FULLY_RESOLVED_CHANNEL, 5)
end

defmodule Cashubrew.Lnrpc.Invoice.InvoiceState do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:OPEN, 0)
  field(:SETTLED, 1)
  field(:CANCELED, 2)
  field(:ACCEPTED, 3)
end

defmodule Cashubrew.Lnrpc.Payment.PaymentStatus do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:UNKNOWN, 0)
  field(:IN_FLIGHT, 1)
  field(:SUCCEEDED, 2)
  field(:FAILED, 3)
  field(:INITIATED, 4)
end

defmodule Cashubrew.Lnrpc.HTLCAttempt.HTLCStatus do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:IN_FLIGHT, 0)
  field(:SUCCEEDED, 1)
  field(:FAILED, 2)
end

defmodule Cashubrew.Lnrpc.Failure.FailureCode do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:RESERVED, 0)
  field(:INCORRECT_OR_UNKNOWN_PAYMENT_DETAILS, 1)
  field(:INCORRECT_PAYMENT_AMOUNT, 2)
  field(:FINAL_INCORRECT_CLTV_EXPIRY, 3)
  field(:FINAL_INCORRECT_HTLC_AMOUNT, 4)
  field(:FINAL_EXPIRY_TOO_SOON, 5)
  field(:INVALID_REALM, 6)
  field(:EXPIRY_TOO_SOON, 7)
  field(:INVALID_ONION_VERSION, 8)
  field(:INVALID_ONION_HMAC, 9)
  field(:INVALID_ONION_KEY, 10)
  field(:AMOUNT_BELOW_MINIMUM, 11)
  field(:FEE_INSUFFICIENT, 12)
  field(:INCORRECT_CLTV_EXPIRY, 13)
  field(:CHANNEL_DISABLED, 14)
  field(:TEMPORARY_CHANNEL_FAILURE, 15)
  field(:REQUIRED_NODE_FEATURE_MISSING, 16)
  field(:REQUIRED_CHANNEL_FEATURE_MISSING, 17)
  field(:UNKNOWN_NEXT_PEER, 18)
  field(:TEMPORARY_NODE_FAILURE, 19)
  field(:PERMANENT_NODE_FAILURE, 20)
  field(:PERMANENT_CHANNEL_FAILURE, 21)
  field(:EXPIRY_TOO_FAR, 22)
  field(:MPP_TIMEOUT, 23)
  field(:INVALID_ONION_PAYLOAD, 24)
  field(:INVALID_ONION_BLINDING, 25)
  field(:INTERNAL_FAILURE, 997)
  field(:UNKNOWN_FAILURE, 998)
  field(:UNREADABLE_FAILURE, 999)
end

defmodule Cashubrew.Lnrpc.LookupHtlcResolutionRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:chan_id, 1, type: :uint64, json_name: "chanId")
  field(:htlc_index, 2, type: :uint64, json_name: "htlcIndex")
end

defmodule Cashubrew.Lnrpc.LookupHtlcResolutionResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:settled, 1, type: :bool)
  field(:offchain, 2, type: :bool)
end

defmodule Cashubrew.Lnrpc.SubscribeCustomMessagesRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.CustomMessage do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:peer, 1, type: :bytes)
  field(:type, 2, type: :uint32)
  field(:data, 3, type: :bytes)
end

defmodule Cashubrew.Lnrpc.SendCustomMessageRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:peer, 1, type: :bytes)
  field(:type, 2, type: :uint32)
  field(:data, 3, type: :bytes)
end

defmodule Cashubrew.Lnrpc.SendCustomMessageResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.Utxo do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:address_type, 1, type: Cashubrew.Lnrpc.AddressType, json_name: "addressType", enum: true)
  field(:address, 2, type: :string)
  field(:amount_sat, 3, type: :int64, json_name: "amountSat")
  field(:pk_script, 4, type: :string, json_name: "pkScript")
  field(:outpoint, 5, type: Cashubrew.Lnrpc.OutPoint)
  field(:confirmations, 6, type: :int64)
end

defmodule Cashubrew.Lnrpc.OutputDetail do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:output_type, 1,
    type: Cashubrew.Lnrpc.OutputScriptType,
    json_name: "outputType",
    enum: true
  )

  field(:address, 2, type: :string)
  field(:pk_script, 3, type: :string, json_name: "pkScript")
  field(:output_index, 4, type: :int64, json_name: "outputIndex")
  field(:amount, 5, type: :int64)
  field(:is_our_address, 6, type: :bool, json_name: "isOurAddress")
end

defmodule Cashubrew.Lnrpc.Transaction do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:tx_hash, 1, type: :string, json_name: "txHash")
  field(:amount, 2, type: :int64)
  field(:num_confirmations, 3, type: :int32, json_name: "numConfirmations")
  field(:block_hash, 4, type: :string, json_name: "blockHash")
  field(:block_height, 5, type: :int32, json_name: "blockHeight")
  field(:time_stamp, 6, type: :int64, json_name: "timeStamp")
  field(:total_fees, 7, type: :int64, json_name: "totalFees")

  field(:dest_addresses, 8,
    repeated: true,
    type: :string,
    json_name: "destAddresses",
    deprecated: true
  )

  field(:output_details, 11,
    repeated: true,
    type: Cashubrew.Lnrpc.OutputDetail,
    json_name: "outputDetails"
  )

  field(:raw_tx_hex, 9, type: :string, json_name: "rawTxHex")
  field(:label, 10, type: :string)

  field(:previous_outpoints, 12,
    repeated: true,
    type: Cashubrew.Lnrpc.PreviousOutPoint,
    json_name: "previousOutpoints"
  )
end

defmodule Cashubrew.Lnrpc.GetTransactionsRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:start_height, 1, type: :int32, json_name: "startHeight")
  field(:end_height, 2, type: :int32, json_name: "endHeight")
  field(:account, 3, type: :string)
end

defmodule Cashubrew.Lnrpc.TransactionDetails do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:transactions, 1, repeated: true, type: Cashubrew.Lnrpc.Transaction)
end

defmodule Cashubrew.Lnrpc.FeeLimit do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  oneof(:limit, 0)

  field(:fixed, 1, type: :int64, oneof: 0)
  field(:fixed_msat, 3, type: :int64, json_name: "fixedMsat", oneof: 0)
  field(:percent, 2, type: :int64, oneof: 0)
end

defmodule Cashubrew.Lnrpc.SendRequest.DestCustomRecordsEntry do
  @moduledoc false

  use Protobuf, map: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:key, 1, type: :uint64)
  field(:value, 2, type: :bytes)
end

defmodule Cashubrew.Lnrpc.SendRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:dest, 1, type: :bytes)
  field(:dest_string, 2, type: :string, json_name: "destString", deprecated: true)
  field(:amt, 3, type: :int64)
  field(:amt_msat, 12, type: :int64, json_name: "amtMsat")
  field(:payment_hash, 4, type: :bytes, json_name: "paymentHash")
  field(:payment_hash_string, 5, type: :string, json_name: "paymentHashString", deprecated: true)
  field(:payment_request, 6, type: :string, json_name: "paymentRequest")
  field(:final_cltv_delta, 7, type: :int32, json_name: "finalCltvDelta")
  field(:fee_limit, 8, type: Cashubrew.Lnrpc.FeeLimit, json_name: "feeLimit")
  field(:outgoing_chan_id, 9, type: :uint64, json_name: "outgoingChanId", deprecated: false)
  field(:last_hop_pubkey, 13, type: :bytes, json_name: "lastHopPubkey")
  field(:cltv_limit, 10, type: :uint32, json_name: "cltvLimit")

  field(:dest_custom_records, 11,
    repeated: true,
    type: Cashubrew.Lnrpc.SendRequest.DestCustomRecordsEntry,
    json_name: "destCustomRecords",
    map: true
  )

  field(:allow_self_payment, 14, type: :bool, json_name: "allowSelfPayment")

  field(:dest_features, 15,
    repeated: true,
    type: Cashubrew.Lnrpc.FeatureBit,
    json_name: "destFeatures",
    enum: true
  )

  field(:payment_addr, 16, type: :bytes, json_name: "paymentAddr")
end

defmodule Cashubrew.Lnrpc.SendResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:payment_error, 1, type: :string, json_name: "paymentError")
  field(:payment_preimage, 2, type: :bytes, json_name: "paymentPreimage")
  field(:payment_route, 3, type: Cashubrew.Lnrpc.Route, json_name: "paymentRoute")
  field(:payment_hash, 4, type: :bytes, json_name: "paymentHash")
end

defmodule Cashubrew.Lnrpc.SendToRouteRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:payment_hash, 1, type: :bytes, json_name: "paymentHash")
  field(:payment_hash_string, 2, type: :string, json_name: "paymentHashString", deprecated: true)
  field(:route, 4, type: Cashubrew.Lnrpc.Route)
end

defmodule Cashubrew.Lnrpc.ChannelAcceptRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:node_pubkey, 1, type: :bytes, json_name: "nodePubkey")
  field(:chain_hash, 2, type: :bytes, json_name: "chainHash")
  field(:pending_chan_id, 3, type: :bytes, json_name: "pendingChanId")
  field(:funding_amt, 4, type: :uint64, json_name: "fundingAmt")
  field(:push_amt, 5, type: :uint64, json_name: "pushAmt")
  field(:dust_limit, 6, type: :uint64, json_name: "dustLimit")
  field(:max_value_in_flight, 7, type: :uint64, json_name: "maxValueInFlight")
  field(:channel_reserve, 8, type: :uint64, json_name: "channelReserve")
  field(:min_htlc, 9, type: :uint64, json_name: "minHtlc")
  field(:fee_per_kw, 10, type: :uint64, json_name: "feePerKw")
  field(:csv_delay, 11, type: :uint32, json_name: "csvDelay")
  field(:max_accepted_htlcs, 12, type: :uint32, json_name: "maxAcceptedHtlcs")
  field(:channel_flags, 13, type: :uint32, json_name: "channelFlags")

  field(:commitment_type, 14,
    type: Cashubrew.Lnrpc.CommitmentType,
    json_name: "commitmentType",
    enum: true
  )

  field(:wants_zero_conf, 15, type: :bool, json_name: "wantsZeroConf")
  field(:wants_scid_alias, 16, type: :bool, json_name: "wantsScidAlias")
end

defmodule Cashubrew.Lnrpc.ChannelAcceptResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:accept, 1, type: :bool)
  field(:pending_chan_id, 2, type: :bytes, json_name: "pendingChanId")
  field(:error, 3, type: :string)
  field(:upfront_shutdown, 4, type: :string, json_name: "upfrontShutdown")
  field(:csv_delay, 5, type: :uint32, json_name: "csvDelay")
  field(:reserve_sat, 6, type: :uint64, json_name: "reserveSat")
  field(:in_flight_max_msat, 7, type: :uint64, json_name: "inFlightMaxMsat")
  field(:max_htlc_count, 8, type: :uint32, json_name: "maxHtlcCount")
  field(:min_htlc_in, 9, type: :uint64, json_name: "minHtlcIn")
  field(:min_accept_depth, 10, type: :uint32, json_name: "minAcceptDepth")
  field(:zero_conf, 11, type: :bool, json_name: "zeroConf")
end

defmodule Cashubrew.Lnrpc.ChannelPoint do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  oneof(:funding_txid, 0)

  field(:funding_txid_bytes, 1, type: :bytes, json_name: "fundingTxidBytes", oneof: 0)
  field(:funding_txid_str, 2, type: :string, json_name: "fundingTxidStr", oneof: 0)
  field(:output_index, 3, type: :uint32, json_name: "outputIndex")
end

defmodule Cashubrew.Lnrpc.OutPoint do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:txid_bytes, 1, type: :bytes, json_name: "txidBytes")
  field(:txid_str, 2, type: :string, json_name: "txidStr")
  field(:output_index, 3, type: :uint32, json_name: "outputIndex")
end

defmodule Cashubrew.Lnrpc.PreviousOutPoint do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:outpoint, 1, type: :string)
  field(:is_our_output, 2, type: :bool, json_name: "isOurOutput")
end

defmodule Cashubrew.Lnrpc.LightningAddress do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:pubkey, 1, type: :string)
  field(:host, 2, type: :string)
end

defmodule Cashubrew.Lnrpc.EstimateFeeRequest.AddrToAmountEntry do
  @moduledoc false

  use Protobuf, map: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:key, 1, type: :string)
  field(:value, 2, type: :int64)
end

defmodule Cashubrew.Lnrpc.EstimateFeeRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:AddrToAmount, 1,
    repeated: true,
    type: Cashubrew.Lnrpc.EstimateFeeRequest.AddrToAmountEntry,
    map: true
  )

  field(:target_conf, 2, type: :int32, json_name: "targetConf")
  field(:min_confs, 3, type: :int32, json_name: "minConfs")
  field(:spend_unconfirmed, 4, type: :bool, json_name: "spendUnconfirmed")

  field(:coin_selection_strategy, 5,
    type: Cashubrew.Lnrpc.CoinSelectionStrategy,
    json_name: "coinSelectionStrategy",
    enum: true
  )
end

defmodule Cashubrew.Lnrpc.EstimateFeeResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:fee_sat, 1, type: :int64, json_name: "feeSat")
  field(:feerate_sat_per_byte, 2, type: :int64, json_name: "feerateSatPerByte", deprecated: true)
  field(:sat_per_vbyte, 3, type: :uint64, json_name: "satPerVbyte")
end

defmodule Cashubrew.Lnrpc.SendManyRequest.AddrToAmountEntry do
  @moduledoc false

  use Protobuf, map: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:key, 1, type: :string)
  field(:value, 2, type: :int64)
end

defmodule Cashubrew.Lnrpc.SendManyRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:AddrToAmount, 1,
    repeated: true,
    type: Cashubrew.Lnrpc.SendManyRequest.AddrToAmountEntry,
    map: true
  )

  field(:target_conf, 3, type: :int32, json_name: "targetConf")
  field(:sat_per_vbyte, 4, type: :uint64, json_name: "satPerVbyte")
  field(:sat_per_byte, 5, type: :int64, json_name: "satPerByte", deprecated: true)
  field(:label, 6, type: :string)
  field(:min_confs, 7, type: :int32, json_name: "minConfs")
  field(:spend_unconfirmed, 8, type: :bool, json_name: "spendUnconfirmed")

  field(:coin_selection_strategy, 9,
    type: Cashubrew.Lnrpc.CoinSelectionStrategy,
    json_name: "coinSelectionStrategy",
    enum: true
  )
end

defmodule Cashubrew.Lnrpc.SendManyResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:txid, 1, type: :string)
end

defmodule Cashubrew.Lnrpc.SendCoinsRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:addr, 1, type: :string)
  field(:amount, 2, type: :int64)
  field(:target_conf, 3, type: :int32, json_name: "targetConf")
  field(:sat_per_vbyte, 4, type: :uint64, json_name: "satPerVbyte")
  field(:sat_per_byte, 5, type: :int64, json_name: "satPerByte", deprecated: true)
  field(:send_all, 6, type: :bool, json_name: "sendAll")
  field(:label, 7, type: :string)
  field(:min_confs, 8, type: :int32, json_name: "minConfs")
  field(:spend_unconfirmed, 9, type: :bool, json_name: "spendUnconfirmed")

  field(:coin_selection_strategy, 10,
    type: Cashubrew.Lnrpc.CoinSelectionStrategy,
    json_name: "coinSelectionStrategy",
    enum: true
  )

  field(:outpoints, 11, repeated: true, type: Cashubrew.Lnrpc.OutPoint)
end

defmodule Cashubrew.Lnrpc.SendCoinsResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:txid, 1, type: :string)
end

defmodule Cashubrew.Lnrpc.ListUnspentRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:min_confs, 1, type: :int32, json_name: "minConfs")
  field(:max_confs, 2, type: :int32, json_name: "maxConfs")
  field(:account, 3, type: :string)
end

defmodule Cashubrew.Lnrpc.ListUnspentResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:utxos, 1, repeated: true, type: Cashubrew.Lnrpc.Utxo)
end

defmodule Cashubrew.Lnrpc.NewAddressRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:type, 1, type: Cashubrew.Lnrpc.AddressType, enum: true)
  field(:account, 2, type: :string)
end

defmodule Cashubrew.Lnrpc.NewAddressResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:address, 1, type: :string)
end

defmodule Cashubrew.Lnrpc.SignMessageRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:msg, 1, type: :bytes)
  field(:single_hash, 2, type: :bool, json_name: "singleHash")
end

defmodule Cashubrew.Lnrpc.SignMessageResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:signature, 1, type: :string)
end

defmodule Cashubrew.Lnrpc.VerifyMessageRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:msg, 1, type: :bytes)
  field(:signature, 2, type: :string)
end

defmodule Cashubrew.Lnrpc.VerifyMessageResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:valid, 1, type: :bool)
  field(:pubkey, 2, type: :string)
end

defmodule Cashubrew.Lnrpc.ConnectPeerRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:addr, 1, type: Cashubrew.Lnrpc.LightningAddress)
  field(:perm, 2, type: :bool)
  field(:timeout, 3, type: :uint64)
end

defmodule Cashubrew.Lnrpc.ConnectPeerResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.DisconnectPeerRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:pub_key, 1, type: :string, json_name: "pubKey")
end

defmodule Cashubrew.Lnrpc.DisconnectPeerResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.HTLC do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:incoming, 1, type: :bool)
  field(:amount, 2, type: :int64)
  field(:hash_lock, 3, type: :bytes, json_name: "hashLock")
  field(:expiration_height, 4, type: :uint32, json_name: "expirationHeight")
  field(:htlc_index, 5, type: :uint64, json_name: "htlcIndex")
  field(:forwarding_channel, 6, type: :uint64, json_name: "forwardingChannel")
  field(:forwarding_htlc_index, 7, type: :uint64, json_name: "forwardingHtlcIndex")
end

defmodule Cashubrew.Lnrpc.ChannelConstraints do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:csv_delay, 1, type: :uint32, json_name: "csvDelay")
  field(:chan_reserve_sat, 2, type: :uint64, json_name: "chanReserveSat")
  field(:dust_limit_sat, 3, type: :uint64, json_name: "dustLimitSat")
  field(:max_pending_amt_msat, 4, type: :uint64, json_name: "maxPendingAmtMsat")
  field(:min_htlc_msat, 5, type: :uint64, json_name: "minHtlcMsat")
  field(:max_accepted_htlcs, 6, type: :uint32, json_name: "maxAcceptedHtlcs")
end

defmodule Cashubrew.Lnrpc.Channel do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:active, 1, type: :bool)
  field(:remote_pubkey, 2, type: :string, json_name: "remotePubkey")
  field(:channel_point, 3, type: :string, json_name: "channelPoint")
  field(:chan_id, 4, type: :uint64, json_name: "chanId", deprecated: false)
  field(:capacity, 5, type: :int64)
  field(:local_balance, 6, type: :int64, json_name: "localBalance")
  field(:remote_balance, 7, type: :int64, json_name: "remoteBalance")
  field(:commit_fee, 8, type: :int64, json_name: "commitFee")
  field(:commit_weight, 9, type: :int64, json_name: "commitWeight")
  field(:fee_per_kw, 10, type: :int64, json_name: "feePerKw")
  field(:unsettled_balance, 11, type: :int64, json_name: "unsettledBalance")
  field(:total_satoshis_sent, 12, type: :int64, json_name: "totalSatoshisSent")
  field(:total_satoshis_received, 13, type: :int64, json_name: "totalSatoshisReceived")
  field(:num_updates, 14, type: :uint64, json_name: "numUpdates")
  field(:pending_htlcs, 15, repeated: true, type: Cashubrew.Lnrpc.HTLC, json_name: "pendingHtlcs")
  field(:csv_delay, 16, type: :uint32, json_name: "csvDelay", deprecated: true)
  field(:private, 17, type: :bool)
  field(:initiator, 18, type: :bool)
  field(:chan_status_flags, 19, type: :string, json_name: "chanStatusFlags")

  field(:local_chan_reserve_sat, 20,
    type: :int64,
    json_name: "localChanReserveSat",
    deprecated: true
  )

  field(:remote_chan_reserve_sat, 21,
    type: :int64,
    json_name: "remoteChanReserveSat",
    deprecated: true
  )

  field(:static_remote_key, 22, type: :bool, json_name: "staticRemoteKey", deprecated: true)

  field(:commitment_type, 26,
    type: Cashubrew.Lnrpc.CommitmentType,
    json_name: "commitmentType",
    enum: true
  )

  field(:lifetime, 23, type: :int64)
  field(:uptime, 24, type: :int64)
  field(:close_address, 25, type: :string, json_name: "closeAddress")
  field(:push_amount_sat, 27, type: :uint64, json_name: "pushAmountSat")
  field(:thaw_height, 28, type: :uint32, json_name: "thawHeight")

  field(:local_constraints, 29,
    type: Cashubrew.Lnrpc.ChannelConstraints,
    json_name: "localConstraints"
  )

  field(:remote_constraints, 30,
    type: Cashubrew.Lnrpc.ChannelConstraints,
    json_name: "remoteConstraints"
  )

  field(:alias_scids, 31, repeated: true, type: :uint64, json_name: "aliasScids")
  field(:zero_conf, 32, type: :bool, json_name: "zeroConf")
  field(:zero_conf_confirmed_scid, 33, type: :uint64, json_name: "zeroConfConfirmedScid")
  field(:peer_alias, 34, type: :string, json_name: "peerAlias")
  field(:peer_scid_alias, 35, type: :uint64, json_name: "peerScidAlias", deprecated: false)
  field(:memo, 36, type: :string)
end

defmodule Cashubrew.Lnrpc.ListChannelsRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:active_only, 1, type: :bool, json_name: "activeOnly")
  field(:inactive_only, 2, type: :bool, json_name: "inactiveOnly")
  field(:public_only, 3, type: :bool, json_name: "publicOnly")
  field(:private_only, 4, type: :bool, json_name: "privateOnly")
  field(:peer, 5, type: :bytes)
  field(:peer_alias_lookup, 6, type: :bool, json_name: "peerAliasLookup")
end

defmodule Cashubrew.Lnrpc.ListChannelsResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:channels, 11, repeated: true, type: Cashubrew.Lnrpc.Channel)
end

defmodule Cashubrew.Lnrpc.AliasMap do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:base_scid, 1, type: :uint64, json_name: "baseScid")
  field(:aliases, 2, repeated: true, type: :uint64)
end

defmodule Cashubrew.Lnrpc.ListAliasesRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.ListAliasesResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:alias_maps, 1, repeated: true, type: Cashubrew.Lnrpc.AliasMap, json_name: "aliasMaps")
end

defmodule Cashubrew.Lnrpc.ChannelCloseSummary do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:channel_point, 1, type: :string, json_name: "channelPoint")
  field(:chan_id, 2, type: :uint64, json_name: "chanId", deprecated: false)
  field(:chain_hash, 3, type: :string, json_name: "chainHash")
  field(:closing_tx_hash, 4, type: :string, json_name: "closingTxHash")
  field(:remote_pubkey, 5, type: :string, json_name: "remotePubkey")
  field(:capacity, 6, type: :int64)
  field(:close_height, 7, type: :uint32, json_name: "closeHeight")
  field(:settled_balance, 8, type: :int64, json_name: "settledBalance")
  field(:time_locked_balance, 9, type: :int64, json_name: "timeLockedBalance")

  field(:close_type, 10,
    type: Cashubrew.Lnrpc.ChannelCloseSummary.ClosureType,
    json_name: "closeType",
    enum: true
  )

  field(:open_initiator, 11,
    type: Cashubrew.Lnrpc.Initiator,
    json_name: "openInitiator",
    enum: true
  )

  field(:close_initiator, 12,
    type: Cashubrew.Lnrpc.Initiator,
    json_name: "closeInitiator",
    enum: true
  )

  field(:resolutions, 13, repeated: true, type: Cashubrew.Lnrpc.Resolution)
  field(:alias_scids, 14, repeated: true, type: :uint64, json_name: "aliasScids")

  field(:zero_conf_confirmed_scid, 15,
    type: :uint64,
    json_name: "zeroConfConfirmedScid",
    deprecated: false
  )
end

defmodule Cashubrew.Lnrpc.Resolution do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:resolution_type, 1,
    type: Cashubrew.Lnrpc.ResolutionType,
    json_name: "resolutionType",
    enum: true
  )

  field(:outcome, 2, type: Cashubrew.Lnrpc.ResolutionOutcome, enum: true)
  field(:outpoint, 3, type: Cashubrew.Lnrpc.OutPoint)
  field(:amount_sat, 4, type: :uint64, json_name: "amountSat")
  field(:sweep_txid, 5, type: :string, json_name: "sweepTxid")
end

defmodule Cashubrew.Lnrpc.ClosedChannelsRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:cooperative, 1, type: :bool)
  field(:local_force, 2, type: :bool, json_name: "localForce")
  field(:remote_force, 3, type: :bool, json_name: "remoteForce")
  field(:breach, 4, type: :bool)
  field(:funding_canceled, 5, type: :bool, json_name: "fundingCanceled")
  field(:abandoned, 6, type: :bool)
end

defmodule Cashubrew.Lnrpc.ClosedChannelsResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:channels, 1, repeated: true, type: Cashubrew.Lnrpc.ChannelCloseSummary)
end

defmodule Cashubrew.Lnrpc.Peer.FeaturesEntry do
  @moduledoc false

  use Protobuf, map: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:key, 1, type: :uint32)
  field(:value, 2, type: Cashubrew.Lnrpc.Feature)
end

defmodule Cashubrew.Lnrpc.Peer do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:pub_key, 1, type: :string, json_name: "pubKey")
  field(:address, 3, type: :string)
  field(:bytes_sent, 4, type: :uint64, json_name: "bytesSent")
  field(:bytes_recv, 5, type: :uint64, json_name: "bytesRecv")
  field(:sat_sent, 6, type: :int64, json_name: "satSent")
  field(:sat_recv, 7, type: :int64, json_name: "satRecv")
  field(:inbound, 8, type: :bool)
  field(:ping_time, 9, type: :int64, json_name: "pingTime")
  field(:sync_type, 10, type: Cashubrew.Lnrpc.Peer.SyncType, json_name: "syncType", enum: true)
  field(:features, 11, repeated: true, type: Cashubrew.Lnrpc.Peer.FeaturesEntry, map: true)
  field(:errors, 12, repeated: true, type: Cashubrew.Lnrpc.TimestampedError)
  field(:flap_count, 13, type: :int32, json_name: "flapCount")
  field(:last_flap_ns, 14, type: :int64, json_name: "lastFlapNs")
  field(:last_ping_payload, 15, type: :bytes, json_name: "lastPingPayload")
end

defmodule Cashubrew.Lnrpc.TimestampedError do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:timestamp, 1, type: :uint64)
  field(:error, 2, type: :string)
end

defmodule Cashubrew.Lnrpc.ListPeersRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:latest_error, 1, type: :bool, json_name: "latestError")
end

defmodule Cashubrew.Lnrpc.ListPeersResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:peers, 1, repeated: true, type: Cashubrew.Lnrpc.Peer)
end

defmodule Cashubrew.Lnrpc.PeerEventSubscription do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.PeerEvent do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:pub_key, 1, type: :string, json_name: "pubKey")
  field(:type, 2, type: Cashubrew.Lnrpc.PeerEvent.EventType, enum: true)
end

defmodule Cashubrew.Lnrpc.GetInfoRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.GetInfoResponse.FeaturesEntry do
  @moduledoc false

  use Protobuf, map: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:key, 1, type: :uint32)
  field(:value, 2, type: Cashubrew.Lnrpc.Feature)
end

defmodule Cashubrew.Lnrpc.GetInfoResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:version, 14, type: :string)
  field(:commit_hash, 20, type: :string, json_name: "commitHash")
  field(:identity_pubkey, 1, type: :string, json_name: "identityPubkey")
  field(:alias, 2, type: :string)
  field(:color, 17, type: :string)
  field(:num_pending_channels, 3, type: :uint32, json_name: "numPendingChannels")
  field(:num_active_channels, 4, type: :uint32, json_name: "numActiveChannels")
  field(:num_inactive_channels, 15, type: :uint32, json_name: "numInactiveChannels")
  field(:num_peers, 5, type: :uint32, json_name: "numPeers")
  field(:block_height, 6, type: :uint32, json_name: "blockHeight")
  field(:block_hash, 8, type: :string, json_name: "blockHash")
  field(:best_header_timestamp, 13, type: :int64, json_name: "bestHeaderTimestamp")
  field(:synced_to_chain, 9, type: :bool, json_name: "syncedToChain")
  field(:synced_to_graph, 18, type: :bool, json_name: "syncedToGraph")
  field(:testnet, 10, type: :bool, deprecated: true)
  field(:chains, 16, repeated: true, type: Cashubrew.Lnrpc.Chain)
  field(:uris, 12, repeated: true, type: :string)

  field(:features, 19,
    repeated: true,
    type: Cashubrew.Lnrpc.GetInfoResponse.FeaturesEntry,
    map: true
  )

  field(:require_htlc_interceptor, 21, type: :bool, json_name: "requireHtlcInterceptor")
  field(:store_final_htlc_resolutions, 22, type: :bool, json_name: "storeFinalHtlcResolutions")
end

defmodule Cashubrew.Lnrpc.GetDebugInfoRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.GetDebugInfoResponse.ConfigEntry do
  @moduledoc false

  use Protobuf, map: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:key, 1, type: :string)
  field(:value, 2, type: :string)
end

defmodule Cashubrew.Lnrpc.GetDebugInfoResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:config, 1,
    repeated: true,
    type: Cashubrew.Lnrpc.GetDebugInfoResponse.ConfigEntry,
    map: true
  )

  field(:log, 2, repeated: true, type: :string)
end

defmodule Cashubrew.Lnrpc.GetRecoveryInfoRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.GetRecoveryInfoResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:recovery_mode, 1, type: :bool, json_name: "recoveryMode")
  field(:recovery_finished, 2, type: :bool, json_name: "recoveryFinished")
  field(:progress, 3, type: :double)
end

defmodule Cashubrew.Lnrpc.Chain do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:chain, 1, type: :string, deprecated: true)
  field(:network, 2, type: :string)
end

defmodule Cashubrew.Lnrpc.ConfirmationUpdate do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:block_sha, 1, type: :bytes, json_name: "blockSha")
  field(:block_height, 2, type: :int32, json_name: "blockHeight")
  field(:num_confs_left, 3, type: :uint32, json_name: "numConfsLeft")
end

defmodule Cashubrew.Lnrpc.ChannelOpenUpdate do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:channel_point, 1, type: Cashubrew.Lnrpc.ChannelPoint, json_name: "channelPoint")
end

defmodule Cashubrew.Lnrpc.ChannelCloseUpdate do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:closing_txid, 1, type: :bytes, json_name: "closingTxid")
  field(:success, 2, type: :bool)
end

defmodule Cashubrew.Lnrpc.CloseChannelRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:channel_point, 1, type: Cashubrew.Lnrpc.ChannelPoint, json_name: "channelPoint")
  field(:force, 2, type: :bool)
  field(:target_conf, 3, type: :int32, json_name: "targetConf")
  field(:sat_per_byte, 4, type: :int64, json_name: "satPerByte", deprecated: true)
  field(:delivery_address, 5, type: :string, json_name: "deliveryAddress")
  field(:sat_per_vbyte, 6, type: :uint64, json_name: "satPerVbyte")
  field(:max_fee_per_vbyte, 7, type: :uint64, json_name: "maxFeePerVbyte")
  field(:no_wait, 8, type: :bool, json_name: "noWait")
end

defmodule Cashubrew.Lnrpc.CloseStatusUpdate do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  oneof(:update, 0)

  field(:close_pending, 1,
    type: Cashubrew.Lnrpc.PendingUpdate,
    json_name: "closePending",
    oneof: 0
  )

  field(:chan_close, 3,
    type: Cashubrew.Lnrpc.ChannelCloseUpdate,
    json_name: "chanClose",
    oneof: 0
  )

  field(:close_instant, 4,
    type: Cashubrew.Lnrpc.InstantUpdate,
    json_name: "closeInstant",
    oneof: 0
  )
end

defmodule Cashubrew.Lnrpc.PendingUpdate do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:txid, 1, type: :bytes)
  field(:output_index, 2, type: :uint32, json_name: "outputIndex")
end

defmodule Cashubrew.Lnrpc.InstantUpdate do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.ReadyForPsbtFunding do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:funding_address, 1, type: :string, json_name: "fundingAddress")
  field(:funding_amount, 2, type: :int64, json_name: "fundingAmount")
  field(:psbt, 3, type: :bytes)
end

defmodule Cashubrew.Lnrpc.BatchOpenChannelRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:channels, 1, repeated: true, type: Cashubrew.Lnrpc.BatchOpenChannel)
  field(:target_conf, 2, type: :int32, json_name: "targetConf")
  field(:sat_per_vbyte, 3, type: :int64, json_name: "satPerVbyte")
  field(:min_confs, 4, type: :int32, json_name: "minConfs")
  field(:spend_unconfirmed, 5, type: :bool, json_name: "spendUnconfirmed")
  field(:label, 6, type: :string)

  field(:coin_selection_strategy, 7,
    type: Cashubrew.Lnrpc.CoinSelectionStrategy,
    json_name: "coinSelectionStrategy",
    enum: true
  )
end

defmodule Cashubrew.Lnrpc.BatchOpenChannel do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:node_pubkey, 1, type: :bytes, json_name: "nodePubkey")
  field(:local_funding_amount, 2, type: :int64, json_name: "localFundingAmount")
  field(:push_sat, 3, type: :int64, json_name: "pushSat")
  field(:private, 4, type: :bool)
  field(:min_htlc_msat, 5, type: :int64, json_name: "minHtlcMsat")
  field(:remote_csv_delay, 6, type: :uint32, json_name: "remoteCsvDelay")
  field(:close_address, 7, type: :string, json_name: "closeAddress")
  field(:pending_chan_id, 8, type: :bytes, json_name: "pendingChanId")

  field(:commitment_type, 9,
    type: Cashubrew.Lnrpc.CommitmentType,
    json_name: "commitmentType",
    enum: true
  )

  field(:remote_max_value_in_flight_msat, 10,
    type: :uint64,
    json_name: "remoteMaxValueInFlightMsat"
  )

  field(:remote_max_htlcs, 11, type: :uint32, json_name: "remoteMaxHtlcs")
  field(:max_local_csv, 12, type: :uint32, json_name: "maxLocalCsv")
  field(:zero_conf, 13, type: :bool, json_name: "zeroConf")
  field(:scid_alias, 14, type: :bool, json_name: "scidAlias")
  field(:base_fee, 15, type: :uint64, json_name: "baseFee")
  field(:fee_rate, 16, type: :uint64, json_name: "feeRate")
  field(:use_base_fee, 17, type: :bool, json_name: "useBaseFee")
  field(:use_fee_rate, 18, type: :bool, json_name: "useFeeRate")
  field(:remote_chan_reserve_sat, 19, type: :uint64, json_name: "remoteChanReserveSat")
  field(:memo, 20, type: :string)
end

defmodule Cashubrew.Lnrpc.BatchOpenChannelResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:pending_channels, 1,
    repeated: true,
    type: Cashubrew.Lnrpc.PendingUpdate,
    json_name: "pendingChannels"
  )
end

defmodule Cashubrew.Lnrpc.OpenChannelRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:sat_per_vbyte, 1, type: :uint64, json_name: "satPerVbyte")
  field(:node_pubkey, 2, type: :bytes, json_name: "nodePubkey")
  field(:node_pubkey_string, 3, type: :string, json_name: "nodePubkeyString", deprecated: true)
  field(:local_funding_amount, 4, type: :int64, json_name: "localFundingAmount")
  field(:push_sat, 5, type: :int64, json_name: "pushSat")
  field(:target_conf, 6, type: :int32, json_name: "targetConf")
  field(:sat_per_byte, 7, type: :int64, json_name: "satPerByte", deprecated: true)
  field(:private, 8, type: :bool)
  field(:min_htlc_msat, 9, type: :int64, json_name: "minHtlcMsat")
  field(:remote_csv_delay, 10, type: :uint32, json_name: "remoteCsvDelay")
  field(:min_confs, 11, type: :int32, json_name: "minConfs")
  field(:spend_unconfirmed, 12, type: :bool, json_name: "spendUnconfirmed")
  field(:close_address, 13, type: :string, json_name: "closeAddress")
  field(:funding_shim, 14, type: Cashubrew.Lnrpc.FundingShim, json_name: "fundingShim")

  field(:remote_max_value_in_flight_msat, 15,
    type: :uint64,
    json_name: "remoteMaxValueInFlightMsat"
  )

  field(:remote_max_htlcs, 16, type: :uint32, json_name: "remoteMaxHtlcs")
  field(:max_local_csv, 17, type: :uint32, json_name: "maxLocalCsv")

  field(:commitment_type, 18,
    type: Cashubrew.Lnrpc.CommitmentType,
    json_name: "commitmentType",
    enum: true
  )

  field(:zero_conf, 19, type: :bool, json_name: "zeroConf")
  field(:scid_alias, 20, type: :bool, json_name: "scidAlias")
  field(:base_fee, 21, type: :uint64, json_name: "baseFee")
  field(:fee_rate, 22, type: :uint64, json_name: "feeRate")
  field(:use_base_fee, 23, type: :bool, json_name: "useBaseFee")
  field(:use_fee_rate, 24, type: :bool, json_name: "useFeeRate")
  field(:remote_chan_reserve_sat, 25, type: :uint64, json_name: "remoteChanReserveSat")
  field(:fund_max, 26, type: :bool, json_name: "fundMax")
  field(:memo, 27, type: :string)
  field(:outpoints, 28, repeated: true, type: Cashubrew.Lnrpc.OutPoint)
end

defmodule Cashubrew.Lnrpc.OpenStatusUpdate do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  oneof(:update, 0)

  field(:chan_pending, 1, type: Cashubrew.Lnrpc.PendingUpdate, json_name: "chanPending", oneof: 0)
  field(:chan_open, 3, type: Cashubrew.Lnrpc.ChannelOpenUpdate, json_name: "chanOpen", oneof: 0)
  field(:psbt_fund, 5, type: Cashubrew.Lnrpc.ReadyForPsbtFunding, json_name: "psbtFund", oneof: 0)
  field(:pending_chan_id, 4, type: :bytes, json_name: "pendingChanId")
end

defmodule Cashubrew.Lnrpc.KeyLocator do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:key_family, 1, type: :int32, json_name: "keyFamily")
  field(:key_index, 2, type: :int32, json_name: "keyIndex")
end

defmodule Cashubrew.Lnrpc.KeyDescriptor do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:raw_key_bytes, 1, type: :bytes, json_name: "rawKeyBytes")
  field(:key_loc, 2, type: Cashubrew.Lnrpc.KeyLocator, json_name: "keyLoc")
end

defmodule Cashubrew.Lnrpc.ChanPointShim do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:amt, 1, type: :int64)
  field(:chan_point, 2, type: Cashubrew.Lnrpc.ChannelPoint, json_name: "chanPoint")
  field(:local_key, 3, type: Cashubrew.Lnrpc.KeyDescriptor, json_name: "localKey")
  field(:remote_key, 4, type: :bytes, json_name: "remoteKey")
  field(:pending_chan_id, 5, type: :bytes, json_name: "pendingChanId")
  field(:thaw_height, 6, type: :uint32, json_name: "thawHeight")
  field(:musig2, 7, type: :bool)
end

defmodule Cashubrew.Lnrpc.PsbtShim do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:pending_chan_id, 1, type: :bytes, json_name: "pendingChanId")
  field(:base_psbt, 2, type: :bytes, json_name: "basePsbt")
  field(:no_publish, 3, type: :bool, json_name: "noPublish")
end

defmodule Cashubrew.Lnrpc.FundingShim do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  oneof(:shim, 0)

  field(:chan_point_shim, 1,
    type: Cashubrew.Lnrpc.ChanPointShim,
    json_name: "chanPointShim",
    oneof: 0
  )

  field(:psbt_shim, 2, type: Cashubrew.Lnrpc.PsbtShim, json_name: "psbtShim", oneof: 0)
end

defmodule Cashubrew.Lnrpc.FundingShimCancel do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:pending_chan_id, 1, type: :bytes, json_name: "pendingChanId")
end

defmodule Cashubrew.Lnrpc.FundingPsbtVerify do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:funded_psbt, 1, type: :bytes, json_name: "fundedPsbt")
  field(:pending_chan_id, 2, type: :bytes, json_name: "pendingChanId")
  field(:skip_finalize, 3, type: :bool, json_name: "skipFinalize")
end

defmodule Cashubrew.Lnrpc.FundingPsbtFinalize do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:signed_psbt, 1, type: :bytes, json_name: "signedPsbt")
  field(:pending_chan_id, 2, type: :bytes, json_name: "pendingChanId")
  field(:final_raw_tx, 3, type: :bytes, json_name: "finalRawTx")
end

defmodule Cashubrew.Lnrpc.FundingTransitionMsg do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  oneof(:trigger, 0)

  field(:shim_register, 1, type: Cashubrew.Lnrpc.FundingShim, json_name: "shimRegister", oneof: 0)

  field(:shim_cancel, 2,
    type: Cashubrew.Lnrpc.FundingShimCancel,
    json_name: "shimCancel",
    oneof: 0
  )

  field(:psbt_verify, 3,
    type: Cashubrew.Lnrpc.FundingPsbtVerify,
    json_name: "psbtVerify",
    oneof: 0
  )

  field(:psbt_finalize, 4,
    type: Cashubrew.Lnrpc.FundingPsbtFinalize,
    json_name: "psbtFinalize",
    oneof: 0
  )
end

defmodule Cashubrew.Lnrpc.FundingStateStepResp do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.PendingHTLC do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:incoming, 1, type: :bool)
  field(:amount, 2, type: :int64)
  field(:outpoint, 3, type: :string)
  field(:maturity_height, 4, type: :uint32, json_name: "maturityHeight")
  field(:blocks_til_maturity, 5, type: :int32, json_name: "blocksTilMaturity")
  field(:stage, 6, type: :uint32)
end

defmodule Cashubrew.Lnrpc.PendingChannelsRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:include_raw_tx, 1, type: :bool, json_name: "includeRawTx")
end

defmodule Cashubrew.Lnrpc.PendingChannelsResponse.PendingChannel do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:remote_node_pub, 1, type: :string, json_name: "remoteNodePub")
  field(:channel_point, 2, type: :string, json_name: "channelPoint")
  field(:capacity, 3, type: :int64)
  field(:local_balance, 4, type: :int64, json_name: "localBalance")
  field(:remote_balance, 5, type: :int64, json_name: "remoteBalance")
  field(:local_chan_reserve_sat, 6, type: :int64, json_name: "localChanReserveSat")
  field(:remote_chan_reserve_sat, 7, type: :int64, json_name: "remoteChanReserveSat")
  field(:initiator, 8, type: Cashubrew.Lnrpc.Initiator, enum: true)

  field(:commitment_type, 9,
    type: Cashubrew.Lnrpc.CommitmentType,
    json_name: "commitmentType",
    enum: true
  )

  field(:num_forwarding_packages, 10, type: :int64, json_name: "numForwardingPackages")
  field(:chan_status_flags, 11, type: :string, json_name: "chanStatusFlags")
  field(:private, 12, type: :bool)
  field(:memo, 13, type: :string)
end

defmodule Cashubrew.Lnrpc.PendingChannelsResponse.PendingOpenChannel do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:channel, 1, type: Cashubrew.Lnrpc.PendingChannelsResponse.PendingChannel)
  field(:commit_fee, 4, type: :int64, json_name: "commitFee")
  field(:commit_weight, 5, type: :int64, json_name: "commitWeight")
  field(:fee_per_kw, 6, type: :int64, json_name: "feePerKw")
  field(:funding_expiry_blocks, 3, type: :int32, json_name: "fundingExpiryBlocks")
end

defmodule Cashubrew.Lnrpc.PendingChannelsResponse.WaitingCloseChannel do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:channel, 1, type: Cashubrew.Lnrpc.PendingChannelsResponse.PendingChannel)
  field(:limbo_balance, 2, type: :int64, json_name: "limboBalance")
  field(:commitments, 3, type: Cashubrew.Lnrpc.PendingChannelsResponse.Commitments)
  field(:closing_txid, 4, type: :string, json_name: "closingTxid")
  field(:closing_tx_hex, 5, type: :string, json_name: "closingTxHex")
end

defmodule Cashubrew.Lnrpc.PendingChannelsResponse.Commitments do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:local_txid, 1, type: :string, json_name: "localTxid")
  field(:remote_txid, 2, type: :string, json_name: "remoteTxid")
  field(:remote_pending_txid, 3, type: :string, json_name: "remotePendingTxid")
  field(:local_commit_fee_sat, 4, type: :uint64, json_name: "localCommitFeeSat")
  field(:remote_commit_fee_sat, 5, type: :uint64, json_name: "remoteCommitFeeSat")
  field(:remote_pending_commit_fee_sat, 6, type: :uint64, json_name: "remotePendingCommitFeeSat")
end

defmodule Cashubrew.Lnrpc.PendingChannelsResponse.ClosedChannel do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:channel, 1, type: Cashubrew.Lnrpc.PendingChannelsResponse.PendingChannel)
  field(:closing_txid, 2, type: :string, json_name: "closingTxid")
end

defmodule Cashubrew.Lnrpc.PendingChannelsResponse.ForceClosedChannel do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:channel, 1, type: Cashubrew.Lnrpc.PendingChannelsResponse.PendingChannel)
  field(:closing_txid, 2, type: :string, json_name: "closingTxid")
  field(:limbo_balance, 3, type: :int64, json_name: "limboBalance")
  field(:maturity_height, 4, type: :uint32, json_name: "maturityHeight")
  field(:blocks_til_maturity, 5, type: :int32, json_name: "blocksTilMaturity")
  field(:recovered_balance, 6, type: :int64, json_name: "recoveredBalance")

  field(:pending_htlcs, 8,
    repeated: true,
    type: Cashubrew.Lnrpc.PendingHTLC,
    json_name: "pendingHtlcs"
  )

  field(:anchor, 9,
    type: Cashubrew.Lnrpc.PendingChannelsResponse.ForceClosedChannel.AnchorState,
    enum: true
  )
end

defmodule Cashubrew.Lnrpc.PendingChannelsResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:total_limbo_balance, 1, type: :int64, json_name: "totalLimboBalance")

  field(:pending_open_channels, 2,
    repeated: true,
    type: Cashubrew.Lnrpc.PendingChannelsResponse.PendingOpenChannel,
    json_name: "pendingOpenChannels"
  )

  field(:pending_closing_channels, 3,
    repeated: true,
    type: Cashubrew.Lnrpc.PendingChannelsResponse.ClosedChannel,
    json_name: "pendingClosingChannels",
    deprecated: true
  )

  field(:pending_force_closing_channels, 4,
    repeated: true,
    type: Cashubrew.Lnrpc.PendingChannelsResponse.ForceClosedChannel,
    json_name: "pendingForceClosingChannels"
  )

  field(:waiting_close_channels, 5,
    repeated: true,
    type: Cashubrew.Lnrpc.PendingChannelsResponse.WaitingCloseChannel,
    json_name: "waitingCloseChannels"
  )
end

defmodule Cashubrew.Lnrpc.ChannelEventSubscription do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.ChannelEventUpdate do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  oneof(:channel, 0)

  field(:open_channel, 1, type: Cashubrew.Lnrpc.Channel, json_name: "openChannel", oneof: 0)

  field(:closed_channel, 2,
    type: Cashubrew.Lnrpc.ChannelCloseSummary,
    json_name: "closedChannel",
    oneof: 0
  )

  field(:active_channel, 3,
    type: Cashubrew.Lnrpc.ChannelPoint,
    json_name: "activeChannel",
    oneof: 0
  )

  field(:inactive_channel, 4,
    type: Cashubrew.Lnrpc.ChannelPoint,
    json_name: "inactiveChannel",
    oneof: 0
  )

  field(:pending_open_channel, 6,
    type: Cashubrew.Lnrpc.PendingUpdate,
    json_name: "pendingOpenChannel",
    oneof: 0
  )

  field(:fully_resolved_channel, 7,
    type: Cashubrew.Lnrpc.ChannelPoint,
    json_name: "fullyResolvedChannel",
    oneof: 0
  )

  field(:type, 5, type: Cashubrew.Lnrpc.ChannelEventUpdate.UpdateType, enum: true)
end

defmodule Cashubrew.Lnrpc.WalletAccountBalance do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:confirmed_balance, 1, type: :int64, json_name: "confirmedBalance")
  field(:unconfirmed_balance, 2, type: :int64, json_name: "unconfirmedBalance")
end

defmodule Cashubrew.Lnrpc.WalletBalanceRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:account, 1, type: :string)
  field(:min_confs, 2, type: :int32, json_name: "minConfs")
end

defmodule Cashubrew.Lnrpc.WalletBalanceResponse.AccountBalanceEntry do
  @moduledoc false

  use Protobuf, map: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:key, 1, type: :string)
  field(:value, 2, type: Cashubrew.Lnrpc.WalletAccountBalance)
end

defmodule Cashubrew.Lnrpc.WalletBalanceResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:total_balance, 1, type: :int64, json_name: "totalBalance")
  field(:confirmed_balance, 2, type: :int64, json_name: "confirmedBalance")
  field(:unconfirmed_balance, 3, type: :int64, json_name: "unconfirmedBalance")
  field(:locked_balance, 5, type: :int64, json_name: "lockedBalance")
  field(:reserved_balance_anchor_chan, 6, type: :int64, json_name: "reservedBalanceAnchorChan")

  field(:account_balance, 4,
    repeated: true,
    type: Cashubrew.Lnrpc.WalletBalanceResponse.AccountBalanceEntry,
    json_name: "accountBalance",
    map: true
  )
end

defmodule Cashubrew.Lnrpc.Amount do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:sat, 1, type: :uint64)
  field(:msat, 2, type: :uint64)
end

defmodule Cashubrew.Lnrpc.ChannelBalanceRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.ChannelBalanceResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:balance, 1, type: :int64, deprecated: true)
  field(:pending_open_balance, 2, type: :int64, json_name: "pendingOpenBalance", deprecated: true)
  field(:local_balance, 3, type: Cashubrew.Lnrpc.Amount, json_name: "localBalance")
  field(:remote_balance, 4, type: Cashubrew.Lnrpc.Amount, json_name: "remoteBalance")

  field(:unsettled_local_balance, 5,
    type: Cashubrew.Lnrpc.Amount,
    json_name: "unsettledLocalBalance"
  )

  field(:unsettled_remote_balance, 6,
    type: Cashubrew.Lnrpc.Amount,
    json_name: "unsettledRemoteBalance"
  )

  field(:pending_open_local_balance, 7,
    type: Cashubrew.Lnrpc.Amount,
    json_name: "pendingOpenLocalBalance"
  )

  field(:pending_open_remote_balance, 8,
    type: Cashubrew.Lnrpc.Amount,
    json_name: "pendingOpenRemoteBalance"
  )
end

defmodule Cashubrew.Lnrpc.QueryRoutesRequest.DestCustomRecordsEntry do
  @moduledoc false

  use Protobuf, map: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:key, 1, type: :uint64)
  field(:value, 2, type: :bytes)
end

defmodule Cashubrew.Lnrpc.QueryRoutesRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:pub_key, 1, type: :string, json_name: "pubKey")
  field(:amt, 2, type: :int64)
  field(:amt_msat, 12, type: :int64, json_name: "amtMsat")
  field(:final_cltv_delta, 4, type: :int32, json_name: "finalCltvDelta")
  field(:fee_limit, 5, type: Cashubrew.Lnrpc.FeeLimit, json_name: "feeLimit")
  field(:ignored_nodes, 6, repeated: true, type: :bytes, json_name: "ignoredNodes")

  field(:ignored_edges, 7,
    repeated: true,
    type: Cashubrew.Lnrpc.EdgeLocator,
    json_name: "ignoredEdges",
    deprecated: true
  )

  field(:source_pub_key, 8, type: :string, json_name: "sourcePubKey")
  field(:use_mission_control, 9, type: :bool, json_name: "useMissionControl")

  field(:ignored_pairs, 10,
    repeated: true,
    type: Cashubrew.Lnrpc.NodePair,
    json_name: "ignoredPairs"
  )

  field(:cltv_limit, 11, type: :uint32, json_name: "cltvLimit")

  field(:dest_custom_records, 13,
    repeated: true,
    type: Cashubrew.Lnrpc.QueryRoutesRequest.DestCustomRecordsEntry,
    json_name: "destCustomRecords",
    map: true
  )

  field(:outgoing_chan_id, 14, type: :uint64, json_name: "outgoingChanId", deprecated: false)
  field(:last_hop_pubkey, 15, type: :bytes, json_name: "lastHopPubkey")

  field(:route_hints, 16,
    repeated: true,
    type: Cashubrew.Lnrpc.RouteHint,
    json_name: "routeHints"
  )

  field(:blinded_payment_paths, 19,
    repeated: true,
    type: Cashubrew.Lnrpc.BlindedPaymentPath,
    json_name: "blindedPaymentPaths"
  )

  field(:dest_features, 17,
    repeated: true,
    type: Cashubrew.Lnrpc.FeatureBit,
    json_name: "destFeatures",
    enum: true
  )

  field(:time_pref, 18, type: :double, json_name: "timePref")
end

defmodule Cashubrew.Lnrpc.NodePair do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:from, 1, type: :bytes)
  field(:to, 2, type: :bytes)
end

defmodule Cashubrew.Lnrpc.EdgeLocator do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:channel_id, 1, type: :uint64, json_name: "channelId", deprecated: false)
  field(:direction_reverse, 2, type: :bool, json_name: "directionReverse")
end

defmodule Cashubrew.Lnrpc.QueryRoutesResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:routes, 1, repeated: true, type: Cashubrew.Lnrpc.Route)
  field(:success_prob, 2, type: :double, json_name: "successProb")
end

defmodule Cashubrew.Lnrpc.Hop.CustomRecordsEntry do
  @moduledoc false

  use Protobuf, map: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:key, 1, type: :uint64)
  field(:value, 2, type: :bytes)
end

defmodule Cashubrew.Lnrpc.Hop do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:chan_id, 1, type: :uint64, json_name: "chanId", deprecated: false)
  field(:chan_capacity, 2, type: :int64, json_name: "chanCapacity", deprecated: true)
  field(:amt_to_forward, 3, type: :int64, json_name: "amtToForward", deprecated: true)
  field(:fee, 4, type: :int64, deprecated: true)
  field(:expiry, 5, type: :uint32)
  field(:amt_to_forward_msat, 6, type: :int64, json_name: "amtToForwardMsat")
  field(:fee_msat, 7, type: :int64, json_name: "feeMsat")
  field(:pub_key, 8, type: :string, json_name: "pubKey")
  field(:tlv_payload, 9, type: :bool, json_name: "tlvPayload", deprecated: true)
  field(:mpp_record, 10, type: Cashubrew.Lnrpc.MPPRecord, json_name: "mppRecord")
  field(:amp_record, 12, type: Cashubrew.Lnrpc.AMPRecord, json_name: "ampRecord")

  field(:custom_records, 11,
    repeated: true,
    type: Cashubrew.Lnrpc.Hop.CustomRecordsEntry,
    json_name: "customRecords",
    map: true
  )

  field(:metadata, 13, type: :bytes)
  field(:blinding_point, 14, type: :bytes, json_name: "blindingPoint")
  field(:encrypted_data, 15, type: :bytes, json_name: "encryptedData")
  field(:total_amt_msat, 16, type: :uint64, json_name: "totalAmtMsat")
end

defmodule Cashubrew.Lnrpc.MPPRecord do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:payment_addr, 11, type: :bytes, json_name: "paymentAddr")
  field(:total_amt_msat, 10, type: :int64, json_name: "totalAmtMsat")
end

defmodule Cashubrew.Lnrpc.AMPRecord do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:root_share, 1, type: :bytes, json_name: "rootShare")
  field(:set_id, 2, type: :bytes, json_name: "setId")
  field(:child_index, 3, type: :uint32, json_name: "childIndex")
end

defmodule Cashubrew.Lnrpc.Route do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:total_time_lock, 1, type: :uint32, json_name: "totalTimeLock")
  field(:total_fees, 2, type: :int64, json_name: "totalFees", deprecated: true)
  field(:total_amt, 3, type: :int64, json_name: "totalAmt", deprecated: true)
  field(:hops, 4, repeated: true, type: Cashubrew.Lnrpc.Hop)
  field(:total_fees_msat, 5, type: :int64, json_name: "totalFeesMsat")
  field(:total_amt_msat, 6, type: :int64, json_name: "totalAmtMsat")
end

defmodule Cashubrew.Lnrpc.NodeInfoRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:pub_key, 1, type: :string, json_name: "pubKey")
  field(:include_channels, 2, type: :bool, json_name: "includeChannels")
end

defmodule Cashubrew.Lnrpc.NodeInfo do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:node, 1, type: Cashubrew.Lnrpc.LightningNode)
  field(:num_channels, 2, type: :uint32, json_name: "numChannels")
  field(:total_capacity, 3, type: :int64, json_name: "totalCapacity")
  field(:channels, 4, repeated: true, type: Cashubrew.Lnrpc.ChannelEdge)
end

defmodule Cashubrew.Lnrpc.LightningNode.FeaturesEntry do
  @moduledoc false

  use Protobuf, map: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:key, 1, type: :uint32)
  field(:value, 2, type: Cashubrew.Lnrpc.Feature)
end

defmodule Cashubrew.Lnrpc.LightningNode.CustomRecordsEntry do
  @moduledoc false

  use Protobuf, map: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:key, 1, type: :uint64)
  field(:value, 2, type: :bytes)
end

defmodule Cashubrew.Lnrpc.LightningNode do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:last_update, 1, type: :uint32, json_name: "lastUpdate")
  field(:pub_key, 2, type: :string, json_name: "pubKey")
  field(:alias, 3, type: :string)
  field(:addresses, 4, repeated: true, type: Cashubrew.Lnrpc.NodeAddress)
  field(:color, 5, type: :string)

  field(:features, 6,
    repeated: true,
    type: Cashubrew.Lnrpc.LightningNode.FeaturesEntry,
    map: true
  )

  field(:custom_records, 7,
    repeated: true,
    type: Cashubrew.Lnrpc.LightningNode.CustomRecordsEntry,
    json_name: "customRecords",
    map: true
  )
end

defmodule Cashubrew.Lnrpc.NodeAddress do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:network, 1, type: :string)
  field(:addr, 2, type: :string)
end

defmodule Cashubrew.Lnrpc.RoutingPolicy.CustomRecordsEntry do
  @moduledoc false

  use Protobuf, map: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:key, 1, type: :uint64)
  field(:value, 2, type: :bytes)
end

defmodule Cashubrew.Lnrpc.RoutingPolicy do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:time_lock_delta, 1, type: :uint32, json_name: "timeLockDelta")
  field(:min_htlc, 2, type: :int64, json_name: "minHtlc")
  field(:fee_base_msat, 3, type: :int64, json_name: "feeBaseMsat")
  field(:fee_rate_milli_msat, 4, type: :int64, json_name: "feeRateMilliMsat")
  field(:disabled, 5, type: :bool)
  field(:max_htlc_msat, 6, type: :uint64, json_name: "maxHtlcMsat")
  field(:last_update, 7, type: :uint32, json_name: "lastUpdate")

  field(:custom_records, 8,
    repeated: true,
    type: Cashubrew.Lnrpc.RoutingPolicy.CustomRecordsEntry,
    json_name: "customRecords",
    map: true
  )

  field(:inbound_fee_base_msat, 9, type: :int32, json_name: "inboundFeeBaseMsat")
  field(:inbound_fee_rate_milli_msat, 10, type: :int32, json_name: "inboundFeeRateMilliMsat")
end

defmodule Cashubrew.Lnrpc.ChannelEdge.CustomRecordsEntry do
  @moduledoc false

  use Protobuf, map: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:key, 1, type: :uint64)
  field(:value, 2, type: :bytes)
end

defmodule Cashubrew.Lnrpc.ChannelEdge do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:channel_id, 1, type: :uint64, json_name: "channelId", deprecated: false)
  field(:chan_point, 2, type: :string, json_name: "chanPoint")
  field(:last_update, 3, type: :uint32, json_name: "lastUpdate", deprecated: true)
  field(:node1_pub, 4, type: :string, json_name: "node1Pub")
  field(:node2_pub, 5, type: :string, json_name: "node2Pub")
  field(:capacity, 6, type: :int64)
  field(:node1_policy, 7, type: Cashubrew.Lnrpc.RoutingPolicy, json_name: "node1Policy")
  field(:node2_policy, 8, type: Cashubrew.Lnrpc.RoutingPolicy, json_name: "node2Policy")

  field(:custom_records, 9,
    repeated: true,
    type: Cashubrew.Lnrpc.ChannelEdge.CustomRecordsEntry,
    json_name: "customRecords",
    map: true
  )
end

defmodule Cashubrew.Lnrpc.ChannelGraphRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:include_unannounced, 1, type: :bool, json_name: "includeUnannounced")
end

defmodule Cashubrew.Lnrpc.ChannelGraph do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:nodes, 1, repeated: true, type: Cashubrew.Lnrpc.LightningNode)
  field(:edges, 2, repeated: true, type: Cashubrew.Lnrpc.ChannelEdge)
end

defmodule Cashubrew.Lnrpc.NodeMetricsRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:types, 1, repeated: true, type: Cashubrew.Lnrpc.NodeMetricType, enum: true)
end

defmodule Cashubrew.Lnrpc.NodeMetricsResponse.BetweennessCentralityEntry do
  @moduledoc false

  use Protobuf, map: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:key, 1, type: :string)
  field(:value, 2, type: Cashubrew.Lnrpc.FloatMetric)
end

defmodule Cashubrew.Lnrpc.NodeMetricsResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:betweenness_centrality, 1,
    repeated: true,
    type: Cashubrew.Lnrpc.NodeMetricsResponse.BetweennessCentralityEntry,
    json_name: "betweennessCentrality",
    map: true
  )
end

defmodule Cashubrew.Lnrpc.FloatMetric do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:value, 1, type: :double)
  field(:normalized_value, 2, type: :double, json_name: "normalizedValue")
end

defmodule Cashubrew.Lnrpc.ChanInfoRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:chan_id, 1, type: :uint64, json_name: "chanId", deprecated: false)
  field(:chan_point, 2, type: :string, json_name: "chanPoint")
end

defmodule Cashubrew.Lnrpc.NetworkInfoRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.NetworkInfo do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:graph_diameter, 1, type: :uint32, json_name: "graphDiameter")
  field(:avg_out_degree, 2, type: :double, json_name: "avgOutDegree")
  field(:max_out_degree, 3, type: :uint32, json_name: "maxOutDegree")
  field(:num_nodes, 4, type: :uint32, json_name: "numNodes")
  field(:num_channels, 5, type: :uint32, json_name: "numChannels")
  field(:total_network_capacity, 6, type: :int64, json_name: "totalNetworkCapacity")
  field(:avg_channel_size, 7, type: :double, json_name: "avgChannelSize")
  field(:min_channel_size, 8, type: :int64, json_name: "minChannelSize")
  field(:max_channel_size, 9, type: :int64, json_name: "maxChannelSize")
  field(:median_channel_size_sat, 10, type: :int64, json_name: "medianChannelSizeSat")
  field(:num_zombie_chans, 11, type: :uint64, json_name: "numZombieChans")
end

defmodule Cashubrew.Lnrpc.StopRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.StopResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.GraphTopologySubscription do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.GraphTopologyUpdate do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:node_updates, 1,
    repeated: true,
    type: Cashubrew.Lnrpc.NodeUpdate,
    json_name: "nodeUpdates"
  )

  field(:channel_updates, 2,
    repeated: true,
    type: Cashubrew.Lnrpc.ChannelEdgeUpdate,
    json_name: "channelUpdates"
  )

  field(:closed_chans, 3,
    repeated: true,
    type: Cashubrew.Lnrpc.ClosedChannelUpdate,
    json_name: "closedChans"
  )
end

defmodule Cashubrew.Lnrpc.NodeUpdate.FeaturesEntry do
  @moduledoc false

  use Protobuf, map: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:key, 1, type: :uint32)
  field(:value, 2, type: Cashubrew.Lnrpc.Feature)
end

defmodule Cashubrew.Lnrpc.NodeUpdate do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:addresses, 1, repeated: true, type: :string, deprecated: true)
  field(:identity_key, 2, type: :string, json_name: "identityKey")
  field(:global_features, 3, type: :bytes, json_name: "globalFeatures", deprecated: true)
  field(:alias, 4, type: :string)
  field(:color, 5, type: :string)

  field(:node_addresses, 7,
    repeated: true,
    type: Cashubrew.Lnrpc.NodeAddress,
    json_name: "nodeAddresses"
  )

  field(:features, 6, repeated: true, type: Cashubrew.Lnrpc.NodeUpdate.FeaturesEntry, map: true)
end

defmodule Cashubrew.Lnrpc.ChannelEdgeUpdate do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:chan_id, 1, type: :uint64, json_name: "chanId", deprecated: false)
  field(:chan_point, 2, type: Cashubrew.Lnrpc.ChannelPoint, json_name: "chanPoint")
  field(:capacity, 3, type: :int64)
  field(:routing_policy, 4, type: Cashubrew.Lnrpc.RoutingPolicy, json_name: "routingPolicy")
  field(:advertising_node, 5, type: :string, json_name: "advertisingNode")
  field(:connecting_node, 6, type: :string, json_name: "connectingNode")
end

defmodule Cashubrew.Lnrpc.ClosedChannelUpdate do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:chan_id, 1, type: :uint64, json_name: "chanId", deprecated: false)
  field(:capacity, 2, type: :int64)
  field(:closed_height, 3, type: :uint32, json_name: "closedHeight")
  field(:chan_point, 4, type: Cashubrew.Lnrpc.ChannelPoint, json_name: "chanPoint")
end

defmodule Cashubrew.Lnrpc.HopHint do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:node_id, 1, type: :string, json_name: "nodeId")
  field(:chan_id, 2, type: :uint64, json_name: "chanId", deprecated: false)
  field(:fee_base_msat, 3, type: :uint32, json_name: "feeBaseMsat")
  field(:fee_proportional_millionths, 4, type: :uint32, json_name: "feeProportionalMillionths")
  field(:cltv_expiry_delta, 5, type: :uint32, json_name: "cltvExpiryDelta")
end

defmodule Cashubrew.Lnrpc.SetID do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:set_id, 1, type: :bytes, json_name: "setId")
end

defmodule Cashubrew.Lnrpc.RouteHint do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:hop_hints, 1, repeated: true, type: Cashubrew.Lnrpc.HopHint, json_name: "hopHints")
end

defmodule Cashubrew.Lnrpc.BlindedPaymentPath do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:blinded_path, 1, type: Cashubrew.Lnrpc.BlindedPath, json_name: "blindedPath")
  field(:base_fee_msat, 2, type: :uint64, json_name: "baseFeeMsat")
  field(:proportional_fee_rate, 3, type: :uint32, json_name: "proportionalFeeRate")
  field(:total_cltv_delta, 4, type: :uint32, json_name: "totalCltvDelta")
  field(:htlc_min_msat, 5, type: :uint64, json_name: "htlcMinMsat")
  field(:htlc_max_msat, 6, type: :uint64, json_name: "htlcMaxMsat")
  field(:features, 7, repeated: true, type: Cashubrew.Lnrpc.FeatureBit, enum: true)
end

defmodule Cashubrew.Lnrpc.BlindedPath do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:introduction_node, 1, type: :bytes, json_name: "introductionNode")
  field(:blinding_point, 2, type: :bytes, json_name: "blindingPoint")

  field(:blinded_hops, 3,
    repeated: true,
    type: Cashubrew.Lnrpc.BlindedHop,
    json_name: "blindedHops"
  )
end

defmodule Cashubrew.Lnrpc.BlindedHop do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:blinded_node, 1, type: :bytes, json_name: "blindedNode")
  field(:encrypted_data, 2, type: :bytes, json_name: "encryptedData")
end

defmodule Cashubrew.Lnrpc.AMPInvoiceState do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:state, 1, type: Cashubrew.Lnrpc.InvoiceHTLCState, enum: true)
  field(:settle_index, 2, type: :uint64, json_name: "settleIndex")
  field(:settle_time, 3, type: :int64, json_name: "settleTime")
  field(:amt_paid_msat, 5, type: :int64, json_name: "amtPaidMsat")
end

defmodule Cashubrew.Lnrpc.Invoice.FeaturesEntry do
  @moduledoc false

  use Protobuf, map: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:key, 1, type: :uint32)
  field(:value, 2, type: Cashubrew.Lnrpc.Feature)
end

defmodule Cashubrew.Lnrpc.Invoice.AmpInvoiceStateEntry do
  @moduledoc false

  use Protobuf, map: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:key, 1, type: :string)
  field(:value, 2, type: Cashubrew.Lnrpc.AMPInvoiceState)
end

defmodule Cashubrew.Lnrpc.Invoice do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:memo, 1, type: :string)
  field(:r_preimage, 3, type: :bytes, json_name: "rPreimage")
  field(:r_hash, 4, type: :bytes, json_name: "rHash")
  field(:value, 5, type: :int64)
  field(:value_msat, 23, type: :int64, json_name: "valueMsat")
  field(:settled, 6, type: :bool, deprecated: true)
  field(:creation_date, 7, type: :int64, json_name: "creationDate")
  field(:settle_date, 8, type: :int64, json_name: "settleDate")
  field(:payment_request, 9, type: :string, json_name: "paymentRequest")
  field(:description_hash, 10, type: :bytes, json_name: "descriptionHash")
  field(:expiry, 11, type: :int64)
  field(:fallback_addr, 12, type: :string, json_name: "fallbackAddr")
  field(:cltv_expiry, 13, type: :uint64, json_name: "cltvExpiry")

  field(:route_hints, 14,
    repeated: true,
    type: Cashubrew.Lnrpc.RouteHint,
    json_name: "routeHints"
  )

  field(:private, 15, type: :bool)
  field(:add_index, 16, type: :uint64, json_name: "addIndex")
  field(:settle_index, 17, type: :uint64, json_name: "settleIndex")
  field(:amt_paid, 18, type: :int64, json_name: "amtPaid", deprecated: true)
  field(:amt_paid_sat, 19, type: :int64, json_name: "amtPaidSat")
  field(:amt_paid_msat, 20, type: :int64, json_name: "amtPaidMsat")
  field(:state, 21, type: Cashubrew.Lnrpc.Invoice.InvoiceState, enum: true)
  field(:htlcs, 22, repeated: true, type: Cashubrew.Lnrpc.InvoiceHTLC)
  field(:features, 24, repeated: true, type: Cashubrew.Lnrpc.Invoice.FeaturesEntry, map: true)
  field(:is_keysend, 25, type: :bool, json_name: "isKeysend")
  field(:payment_addr, 26, type: :bytes, json_name: "paymentAddr")
  field(:is_amp, 27, type: :bool, json_name: "isAmp")

  field(:amp_invoice_state, 28,
    repeated: true,
    type: Cashubrew.Lnrpc.Invoice.AmpInvoiceStateEntry,
    json_name: "ampInvoiceState",
    map: true
  )

  field(:is_blinded, 29, type: :bool, json_name: "isBlinded")

  field(:blinded_path_config, 30,
    type: Cashubrew.Lnrpc.BlindedPathConfig,
    json_name: "blindedPathConfig"
  )
end

defmodule Cashubrew.Lnrpc.BlindedPathConfig do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:min_num_real_hops, 1, proto3_optional: true, type: :uint32, json_name: "minNumRealHops")
  field(:num_hops, 2, proto3_optional: true, type: :uint32, json_name: "numHops")
  field(:max_num_paths, 3, proto3_optional: true, type: :uint32, json_name: "maxNumPaths")
  field(:node_omission_list, 4, repeated: true, type: :bytes, json_name: "nodeOmissionList")
end

defmodule Cashubrew.Lnrpc.InvoiceHTLC.CustomRecordsEntry do
  @moduledoc false

  use Protobuf, map: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:key, 1, type: :uint64)
  field(:value, 2, type: :bytes)
end

defmodule Cashubrew.Lnrpc.InvoiceHTLC do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:chan_id, 1, type: :uint64, json_name: "chanId", deprecated: false)
  field(:htlc_index, 2, type: :uint64, json_name: "htlcIndex")
  field(:amt_msat, 3, type: :uint64, json_name: "amtMsat")
  field(:accept_height, 4, type: :int32, json_name: "acceptHeight")
  field(:accept_time, 5, type: :int64, json_name: "acceptTime")
  field(:resolve_time, 6, type: :int64, json_name: "resolveTime")
  field(:expiry_height, 7, type: :int32, json_name: "expiryHeight")
  field(:state, 8, type: Cashubrew.Lnrpc.InvoiceHTLCState, enum: true)

  field(:custom_records, 9,
    repeated: true,
    type: Cashubrew.Lnrpc.InvoiceHTLC.CustomRecordsEntry,
    json_name: "customRecords",
    map: true
  )

  field(:mpp_total_amt_msat, 10, type: :uint64, json_name: "mppTotalAmtMsat")
  field(:amp, 11, type: Cashubrew.Lnrpc.AMP)
end

defmodule Cashubrew.Lnrpc.AMP do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:root_share, 1, type: :bytes, json_name: "rootShare")
  field(:set_id, 2, type: :bytes, json_name: "setId")
  field(:child_index, 3, type: :uint32, json_name: "childIndex")
  field(:hash, 4, type: :bytes)
  field(:preimage, 5, type: :bytes)
end

defmodule Cashubrew.Lnrpc.AddInvoiceResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:r_hash, 1, type: :bytes, json_name: "rHash")
  field(:payment_request, 2, type: :string, json_name: "paymentRequest")
  field(:add_index, 16, type: :uint64, json_name: "addIndex")
  field(:payment_addr, 17, type: :bytes, json_name: "paymentAddr")
end

defmodule Cashubrew.Lnrpc.PaymentHash do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:r_hash_str, 1, type: :string, json_name: "rHashStr", deprecated: true)
  field(:r_hash, 2, type: :bytes, json_name: "rHash")
end

defmodule Cashubrew.Lnrpc.ListInvoiceRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:pending_only, 1, type: :bool, json_name: "pendingOnly")
  field(:index_offset, 4, type: :uint64, json_name: "indexOffset")
  field(:num_max_invoices, 5, type: :uint64, json_name: "numMaxInvoices")
  field(:reversed, 6, type: :bool)
  field(:creation_date_start, 7, type: :uint64, json_name: "creationDateStart")
  field(:creation_date_end, 8, type: :uint64, json_name: "creationDateEnd")
end

defmodule Cashubrew.Lnrpc.ListInvoiceResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:invoices, 1, repeated: true, type: Cashubrew.Lnrpc.Invoice)
  field(:last_index_offset, 2, type: :uint64, json_name: "lastIndexOffset")
  field(:first_index_offset, 3, type: :uint64, json_name: "firstIndexOffset")
end

defmodule Cashubrew.Lnrpc.InvoiceSubscription do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:add_index, 1, type: :uint64, json_name: "addIndex")
  field(:settle_index, 2, type: :uint64, json_name: "settleIndex")
end

defmodule Cashubrew.Lnrpc.Payment do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:payment_hash, 1, type: :string, json_name: "paymentHash")
  field(:value, 2, type: :int64, deprecated: true)
  field(:creation_date, 3, type: :int64, json_name: "creationDate", deprecated: true)
  field(:fee, 5, type: :int64, deprecated: true)
  field(:payment_preimage, 6, type: :string, json_name: "paymentPreimage")
  field(:value_sat, 7, type: :int64, json_name: "valueSat")
  field(:value_msat, 8, type: :int64, json_name: "valueMsat")
  field(:payment_request, 9, type: :string, json_name: "paymentRequest")
  field(:status, 10, type: Cashubrew.Lnrpc.Payment.PaymentStatus, enum: true)
  field(:fee_sat, 11, type: :int64, json_name: "feeSat")
  field(:fee_msat, 12, type: :int64, json_name: "feeMsat")
  field(:creation_time_ns, 13, type: :int64, json_name: "creationTimeNs")
  field(:htlcs, 14, repeated: true, type: Cashubrew.Lnrpc.HTLCAttempt)
  field(:payment_index, 15, type: :uint64, json_name: "paymentIndex")

  field(:failure_reason, 16,
    type: Cashubrew.Lnrpc.PaymentFailureReason,
    json_name: "failureReason",
    enum: true
  )
end

defmodule Cashubrew.Lnrpc.HTLCAttempt do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:attempt_id, 7, type: :uint64, json_name: "attemptId")
  field(:status, 1, type: Cashubrew.Lnrpc.HTLCAttempt.HTLCStatus, enum: true)
  field(:route, 2, type: Cashubrew.Lnrpc.Route)
  field(:attempt_time_ns, 3, type: :int64, json_name: "attemptTimeNs")
  field(:resolve_time_ns, 4, type: :int64, json_name: "resolveTimeNs")
  field(:failure, 5, type: Cashubrew.Lnrpc.Failure)
  field(:preimage, 6, type: :bytes)
end

defmodule Cashubrew.Lnrpc.ListPaymentsRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:include_incomplete, 1, type: :bool, json_name: "includeIncomplete")
  field(:index_offset, 2, type: :uint64, json_name: "indexOffset")
  field(:max_payments, 3, type: :uint64, json_name: "maxPayments")
  field(:reversed, 4, type: :bool)
  field(:count_total_payments, 5, type: :bool, json_name: "countTotalPayments")
  field(:creation_date_start, 6, type: :uint64, json_name: "creationDateStart")
  field(:creation_date_end, 7, type: :uint64, json_name: "creationDateEnd")
end

defmodule Cashubrew.Lnrpc.ListPaymentsResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:payments, 1, repeated: true, type: Cashubrew.Lnrpc.Payment)
  field(:first_index_offset, 2, type: :uint64, json_name: "firstIndexOffset")
  field(:last_index_offset, 3, type: :uint64, json_name: "lastIndexOffset")
  field(:total_num_payments, 4, type: :uint64, json_name: "totalNumPayments")
end

defmodule Cashubrew.Lnrpc.DeletePaymentRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:payment_hash, 1, type: :bytes, json_name: "paymentHash")
  field(:failed_htlcs_only, 2, type: :bool, json_name: "failedHtlcsOnly")
end

defmodule Cashubrew.Lnrpc.DeleteAllPaymentsRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:failed_payments_only, 1, type: :bool, json_name: "failedPaymentsOnly")
  field(:failed_htlcs_only, 2, type: :bool, json_name: "failedHtlcsOnly")
  field(:all_payments, 3, type: :bool, json_name: "allPayments")
end

defmodule Cashubrew.Lnrpc.DeletePaymentResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.DeleteAllPaymentsResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.AbandonChannelRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:channel_point, 1, type: Cashubrew.Lnrpc.ChannelPoint, json_name: "channelPoint")
  field(:pending_funding_shim_only, 2, type: :bool, json_name: "pendingFundingShimOnly")
  field(:i_know_what_i_am_doing, 3, type: :bool, json_name: "iKnowWhatIAmDoing")
end

defmodule Cashubrew.Lnrpc.AbandonChannelResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.DebugLevelRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:show, 1, type: :bool)
  field(:level_spec, 2, type: :string, json_name: "levelSpec")
end

defmodule Cashubrew.Lnrpc.DebugLevelResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:sub_systems, 1, type: :string, json_name: "subSystems")
end

defmodule Cashubrew.Lnrpc.PayReqString do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:pay_req, 1, type: :string, json_name: "payReq")
end

defmodule Cashubrew.Lnrpc.PayReq.FeaturesEntry do
  @moduledoc false

  use Protobuf, map: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:key, 1, type: :uint32)
  field(:value, 2, type: Cashubrew.Lnrpc.Feature)
end

defmodule Cashubrew.Lnrpc.PayReq do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:destination, 1, type: :string)
  field(:payment_hash, 2, type: :string, json_name: "paymentHash")
  field(:num_satoshis, 3, type: :int64, json_name: "numSatoshis")
  field(:timestamp, 4, type: :int64)
  field(:expiry, 5, type: :int64)
  field(:description, 6, type: :string)
  field(:description_hash, 7, type: :string, json_name: "descriptionHash")
  field(:fallback_addr, 8, type: :string, json_name: "fallbackAddr")
  field(:cltv_expiry, 9, type: :int64, json_name: "cltvExpiry")

  field(:route_hints, 10,
    repeated: true,
    type: Cashubrew.Lnrpc.RouteHint,
    json_name: "routeHints"
  )

  field(:payment_addr, 11, type: :bytes, json_name: "paymentAddr")
  field(:num_msat, 12, type: :int64, json_name: "numMsat")
  field(:features, 13, repeated: true, type: Cashubrew.Lnrpc.PayReq.FeaturesEntry, map: true)

  field(:blinded_paths, 14,
    repeated: true,
    type: Cashubrew.Lnrpc.BlindedPaymentPath,
    json_name: "blindedPaths"
  )
end

defmodule Cashubrew.Lnrpc.Feature do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:name, 2, type: :string)
  field(:is_required, 3, type: :bool, json_name: "isRequired")
  field(:is_known, 4, type: :bool, json_name: "isKnown")
end

defmodule Cashubrew.Lnrpc.FeeReportRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.ChannelFeeReport do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:chan_id, 5, type: :uint64, json_name: "chanId", deprecated: false)
  field(:channel_point, 1, type: :string, json_name: "channelPoint")
  field(:base_fee_msat, 2, type: :int64, json_name: "baseFeeMsat")
  field(:fee_per_mil, 3, type: :int64, json_name: "feePerMil")
  field(:fee_rate, 4, type: :double, json_name: "feeRate")
  field(:inbound_base_fee_msat, 6, type: :int32, json_name: "inboundBaseFeeMsat")
  field(:inbound_fee_per_mil, 7, type: :int32, json_name: "inboundFeePerMil")
end

defmodule Cashubrew.Lnrpc.FeeReportResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:channel_fees, 1,
    repeated: true,
    type: Cashubrew.Lnrpc.ChannelFeeReport,
    json_name: "channelFees"
  )

  field(:day_fee_sum, 2, type: :uint64, json_name: "dayFeeSum")
  field(:week_fee_sum, 3, type: :uint64, json_name: "weekFeeSum")
  field(:month_fee_sum, 4, type: :uint64, json_name: "monthFeeSum")
end

defmodule Cashubrew.Lnrpc.InboundFee do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:base_fee_msat, 1, type: :int32, json_name: "baseFeeMsat")
  field(:fee_rate_ppm, 2, type: :int32, json_name: "feeRatePpm")
end

defmodule Cashubrew.Lnrpc.PolicyUpdateRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  oneof(:scope, 0)

  field(:global, 1, type: :bool, oneof: 0)
  field(:chan_point, 2, type: Cashubrew.Lnrpc.ChannelPoint, json_name: "chanPoint", oneof: 0)
  field(:base_fee_msat, 3, type: :int64, json_name: "baseFeeMsat")
  field(:fee_rate, 4, type: :double, json_name: "feeRate")
  field(:fee_rate_ppm, 9, type: :uint32, json_name: "feeRatePpm")
  field(:time_lock_delta, 5, type: :uint32, json_name: "timeLockDelta")
  field(:max_htlc_msat, 6, type: :uint64, json_name: "maxHtlcMsat")
  field(:min_htlc_msat, 7, type: :uint64, json_name: "minHtlcMsat")
  field(:min_htlc_msat_specified, 8, type: :bool, json_name: "minHtlcMsatSpecified")
  field(:inbound_fee, 10, type: Cashubrew.Lnrpc.InboundFee, json_name: "inboundFee")
end

defmodule Cashubrew.Lnrpc.FailedUpdate do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:outpoint, 1, type: Cashubrew.Lnrpc.OutPoint)
  field(:reason, 2, type: Cashubrew.Lnrpc.UpdateFailure, enum: true)
  field(:update_error, 3, type: :string, json_name: "updateError")
end

defmodule Cashubrew.Lnrpc.PolicyUpdateResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:failed_updates, 1,
    repeated: true,
    type: Cashubrew.Lnrpc.FailedUpdate,
    json_name: "failedUpdates"
  )
end

defmodule Cashubrew.Lnrpc.ForwardingHistoryRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:start_time, 1, type: :uint64, json_name: "startTime")
  field(:end_time, 2, type: :uint64, json_name: "endTime")
  field(:index_offset, 3, type: :uint32, json_name: "indexOffset")
  field(:num_max_events, 4, type: :uint32, json_name: "numMaxEvents")
  field(:peer_alias_lookup, 5, type: :bool, json_name: "peerAliasLookup")
end

defmodule Cashubrew.Lnrpc.ForwardingEvent do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:timestamp, 1, type: :uint64, deprecated: true)
  field(:chan_id_in, 2, type: :uint64, json_name: "chanIdIn", deprecated: false)
  field(:chan_id_out, 4, type: :uint64, json_name: "chanIdOut", deprecated: false)
  field(:amt_in, 5, type: :uint64, json_name: "amtIn")
  field(:amt_out, 6, type: :uint64, json_name: "amtOut")
  field(:fee, 7, type: :uint64)
  field(:fee_msat, 8, type: :uint64, json_name: "feeMsat")
  field(:amt_in_msat, 9, type: :uint64, json_name: "amtInMsat")
  field(:amt_out_msat, 10, type: :uint64, json_name: "amtOutMsat")
  field(:timestamp_ns, 11, type: :uint64, json_name: "timestampNs")
  field(:peer_alias_in, 12, type: :string, json_name: "peerAliasIn")
  field(:peer_alias_out, 13, type: :string, json_name: "peerAliasOut")
end

defmodule Cashubrew.Lnrpc.ForwardingHistoryResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:forwarding_events, 1,
    repeated: true,
    type: Cashubrew.Lnrpc.ForwardingEvent,
    json_name: "forwardingEvents"
  )

  field(:last_offset_index, 2, type: :uint32, json_name: "lastOffsetIndex")
end

defmodule Cashubrew.Lnrpc.ExportChannelBackupRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:chan_point, 1, type: Cashubrew.Lnrpc.ChannelPoint, json_name: "chanPoint")
end

defmodule Cashubrew.Lnrpc.ChannelBackup do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:chan_point, 1, type: Cashubrew.Lnrpc.ChannelPoint, json_name: "chanPoint")
  field(:chan_backup, 2, type: :bytes, json_name: "chanBackup")
end

defmodule Cashubrew.Lnrpc.MultiChanBackup do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:chan_points, 1,
    repeated: true,
    type: Cashubrew.Lnrpc.ChannelPoint,
    json_name: "chanPoints"
  )

  field(:multi_chan_backup, 2, type: :bytes, json_name: "multiChanBackup")
end

defmodule Cashubrew.Lnrpc.ChanBackupExportRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.ChanBackupSnapshot do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:single_chan_backups, 1,
    type: Cashubrew.Lnrpc.ChannelBackups,
    json_name: "singleChanBackups"
  )

  field(:multi_chan_backup, 2,
    type: Cashubrew.Lnrpc.MultiChanBackup,
    json_name: "multiChanBackup"
  )
end

defmodule Cashubrew.Lnrpc.ChannelBackups do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:chan_backups, 1,
    repeated: true,
    type: Cashubrew.Lnrpc.ChannelBackup,
    json_name: "chanBackups"
  )
end

defmodule Cashubrew.Lnrpc.RestoreChanBackupRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  oneof(:backup, 0)

  field(:chan_backups, 1,
    type: Cashubrew.Lnrpc.ChannelBackups,
    json_name: "chanBackups",
    oneof: 0
  )

  field(:multi_chan_backup, 2, type: :bytes, json_name: "multiChanBackup", oneof: 0)
end

defmodule Cashubrew.Lnrpc.RestoreBackupResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.ChannelBackupSubscription do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.VerifyChanBackupResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.MacaroonPermission do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:entity, 1, type: :string)
  field(:action, 2, type: :string)
end

defmodule Cashubrew.Lnrpc.BakeMacaroonRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:permissions, 1, repeated: true, type: Cashubrew.Lnrpc.MacaroonPermission)
  field(:root_key_id, 2, type: :uint64, json_name: "rootKeyId")
  field(:allow_external_permissions, 3, type: :bool, json_name: "allowExternalPermissions")
end

defmodule Cashubrew.Lnrpc.BakeMacaroonResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:macaroon, 1, type: :string)
end

defmodule Cashubrew.Lnrpc.ListMacaroonIDsRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.ListMacaroonIDsResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:root_key_ids, 1, repeated: true, type: :uint64, json_name: "rootKeyIds")
end

defmodule Cashubrew.Lnrpc.DeleteMacaroonIDRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:root_key_id, 1, type: :uint64, json_name: "rootKeyId")
end

defmodule Cashubrew.Lnrpc.DeleteMacaroonIDResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:deleted, 1, type: :bool)
end

defmodule Cashubrew.Lnrpc.MacaroonPermissionList do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:permissions, 1, repeated: true, type: Cashubrew.Lnrpc.MacaroonPermission)
end

defmodule Cashubrew.Lnrpc.ListPermissionsRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"
end

defmodule Cashubrew.Lnrpc.ListPermissionsResponse.MethodPermissionsEntry do
  @moduledoc false

  use Protobuf, map: true, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:key, 1, type: :string)
  field(:value, 2, type: Cashubrew.Lnrpc.MacaroonPermissionList)
end

defmodule Cashubrew.Lnrpc.ListPermissionsResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:method_permissions, 1,
    repeated: true,
    type: Cashubrew.Lnrpc.ListPermissionsResponse.MethodPermissionsEntry,
    json_name: "methodPermissions",
    map: true
  )
end

defmodule Cashubrew.Lnrpc.Failure do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:code, 1, type: Cashubrew.Lnrpc.Failure.FailureCode, enum: true)
  field(:channel_update, 3, type: Cashubrew.Lnrpc.ChannelUpdate, json_name: "channelUpdate")
  field(:htlc_msat, 4, type: :uint64, json_name: "htlcMsat")
  field(:onion_sha_256, 5, type: :bytes, json_name: "onionSha256")
  field(:cltv_expiry, 6, type: :uint32, json_name: "cltvExpiry")
  field(:flags, 7, type: :uint32)
  field(:failure_source_index, 8, type: :uint32, json_name: "failureSourceIndex")
  field(:height, 9, type: :uint32)
end

defmodule Cashubrew.Lnrpc.ChannelUpdate do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:signature, 1, type: :bytes)
  field(:chain_hash, 2, type: :bytes, json_name: "chainHash")
  field(:chan_id, 3, type: :uint64, json_name: "chanId", deprecated: false)
  field(:timestamp, 4, type: :uint32)
  field(:message_flags, 10, type: :uint32, json_name: "messageFlags")
  field(:channel_flags, 5, type: :uint32, json_name: "channelFlags")
  field(:time_lock_delta, 6, type: :uint32, json_name: "timeLockDelta")
  field(:htlc_minimum_msat, 7, type: :uint64, json_name: "htlcMinimumMsat")
  field(:base_fee, 8, type: :uint32, json_name: "baseFee")
  field(:fee_rate, 9, type: :uint32, json_name: "feeRate")
  field(:htlc_maximum_msat, 11, type: :uint64, json_name: "htlcMaximumMsat")
  field(:extra_opaque_data, 12, type: :bytes, json_name: "extraOpaqueData")
end

defmodule Cashubrew.Lnrpc.MacaroonId do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:nonce, 1, type: :bytes)
  field(:storageId, 2, type: :bytes)
  field(:ops, 3, repeated: true, type: Cashubrew.Lnrpc.Op)
end

defmodule Cashubrew.Lnrpc.Op do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:entity, 1, type: :string)
  field(:actions, 2, repeated: true, type: :string)
end

defmodule Cashubrew.Lnrpc.CheckMacPermRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:macaroon, 1, type: :bytes)
  field(:permissions, 2, repeated: true, type: Cashubrew.Lnrpc.MacaroonPermission)
  field(:fullMethod, 3, type: :string)
end

defmodule Cashubrew.Lnrpc.CheckMacPermResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:valid, 1, type: :bool)
end

defmodule Cashubrew.Lnrpc.RPCMiddlewareRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  oneof(:intercept_type, 0)

  field(:request_id, 1, type: :uint64, json_name: "requestId")
  field(:raw_macaroon, 2, type: :bytes, json_name: "rawMacaroon")
  field(:custom_caveat_condition, 3, type: :string, json_name: "customCaveatCondition")
  field(:stream_auth, 4, type: Cashubrew.Lnrpc.StreamAuth, json_name: "streamAuth", oneof: 0)
  field(:request, 5, type: Cashubrew.Lnrpc.RPCMessage, oneof: 0)
  field(:response, 6, type: Cashubrew.Lnrpc.RPCMessage, oneof: 0)
  field(:reg_complete, 8, type: :bool, json_name: "regComplete", oneof: 0)
  field(:msg_id, 7, type: :uint64, json_name: "msgId")
end

defmodule Cashubrew.Lnrpc.StreamAuth do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:method_full_uri, 1, type: :string, json_name: "methodFullUri")
end

defmodule Cashubrew.Lnrpc.RPCMessage do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:method_full_uri, 1, type: :string, json_name: "methodFullUri")
  field(:stream_rpc, 2, type: :bool, json_name: "streamRpc")
  field(:type_name, 3, type: :string, json_name: "typeName")
  field(:serialized, 4, type: :bytes)
  field(:is_error, 5, type: :bool, json_name: "isError")
end

defmodule Cashubrew.Lnrpc.RPCMiddlewareResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  oneof(:middleware_message, 0)

  field(:ref_msg_id, 1, type: :uint64, json_name: "refMsgId")
  field(:register, 2, type: Cashubrew.Lnrpc.MiddlewareRegistration, oneof: 0)
  field(:feedback, 3, type: Cashubrew.Lnrpc.InterceptFeedback, oneof: 0)
end

defmodule Cashubrew.Lnrpc.MiddlewareRegistration do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:middleware_name, 1, type: :string, json_name: "middlewareName")
  field(:custom_macaroon_caveat_name, 2, type: :string, json_name: "customMacaroonCaveatName")
  field(:read_only_mode, 3, type: :bool, json_name: "readOnlyMode")
end

defmodule Cashubrew.Lnrpc.InterceptFeedback do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.13.0"

  field(:error, 1, type: :string)
  field(:replace_response, 2, type: :bool, json_name: "replaceResponse")
  field(:replacement_serialized, 3, type: :bytes, json_name: "replacementSerialized")
end

defmodule Cashubrew.Lnrpc.Lightning.Service do
  @moduledoc false

  use GRPC.Service, name: "lnrpc.Lightning", protoc_gen_elixir_version: "0.13.0"

  rpc(:WalletBalance, Cashubrew.Lnrpc.WalletBalanceRequest, Cashubrew.Lnrpc.WalletBalanceResponse)

  rpc(
    :ChannelBalance,
    Cashubrew.Lnrpc.ChannelBalanceRequest,
    Cashubrew.Lnrpc.ChannelBalanceResponse
  )

  rpc(
    :GetTransactions,
    Cashubrew.Lnrpc.GetTransactionsRequest,
    Cashubrew.Lnrpc.TransactionDetails
  )

  rpc(:EstimateFee, Cashubrew.Lnrpc.EstimateFeeRequest, Cashubrew.Lnrpc.EstimateFeeResponse)

  rpc(:SendCoins, Cashubrew.Lnrpc.SendCoinsRequest, Cashubrew.Lnrpc.SendCoinsResponse)

  rpc(:ListUnspent, Cashubrew.Lnrpc.ListUnspentRequest, Cashubrew.Lnrpc.ListUnspentResponse)

  rpc(
    :SubscribeTransactions,
    Cashubrew.Lnrpc.GetTransactionsRequest,
    stream(Cashubrew.Lnrpc.Transaction)
  )

  rpc(:SendMany, Cashubrew.Lnrpc.SendManyRequest, Cashubrew.Lnrpc.SendManyResponse)

  rpc(:NewAddress, Cashubrew.Lnrpc.NewAddressRequest, Cashubrew.Lnrpc.NewAddressResponse)

  rpc(:SignMessage, Cashubrew.Lnrpc.SignMessageRequest, Cashubrew.Lnrpc.SignMessageResponse)

  rpc(:VerifyMessage, Cashubrew.Lnrpc.VerifyMessageRequest, Cashubrew.Lnrpc.VerifyMessageResponse)

  rpc(:ConnectPeer, Cashubrew.Lnrpc.ConnectPeerRequest, Cashubrew.Lnrpc.ConnectPeerResponse)

  rpc(
    :DisconnectPeer,
    Cashubrew.Lnrpc.DisconnectPeerRequest,
    Cashubrew.Lnrpc.DisconnectPeerResponse
  )

  rpc(:ListPeers, Cashubrew.Lnrpc.ListPeersRequest, Cashubrew.Lnrpc.ListPeersResponse)

  rpc(
    :SubscribePeerEvents,
    Cashubrew.Lnrpc.PeerEventSubscription,
    stream(Cashubrew.Lnrpc.PeerEvent)
  )

  rpc(:GetInfo, Cashubrew.Lnrpc.GetInfoRequest, Cashubrew.Lnrpc.GetInfoResponse)

  rpc(:GetDebugInfo, Cashubrew.Lnrpc.GetDebugInfoRequest, Cashubrew.Lnrpc.GetDebugInfoResponse)

  rpc(
    :GetRecoveryInfo,
    Cashubrew.Lnrpc.GetRecoveryInfoRequest,
    Cashubrew.Lnrpc.GetRecoveryInfoResponse
  )

  rpc(
    :PendingChannels,
    Cashubrew.Lnrpc.PendingChannelsRequest,
    Cashubrew.Lnrpc.PendingChannelsResponse
  )

  rpc(:ListChannels, Cashubrew.Lnrpc.ListChannelsRequest, Cashubrew.Lnrpc.ListChannelsResponse)

  rpc(
    :SubscribeChannelEvents,
    Cashubrew.Lnrpc.ChannelEventSubscription,
    stream(Cashubrew.Lnrpc.ChannelEventUpdate)
  )

  rpc(
    :ClosedChannels,
    Cashubrew.Lnrpc.ClosedChannelsRequest,
    Cashubrew.Lnrpc.ClosedChannelsResponse
  )

  rpc(:OpenChannelSync, Cashubrew.Lnrpc.OpenChannelRequest, Cashubrew.Lnrpc.ChannelPoint)

  rpc(:OpenChannel, Cashubrew.Lnrpc.OpenChannelRequest, stream(Cashubrew.Lnrpc.OpenStatusUpdate))

  rpc(
    :BatchOpenChannel,
    Cashubrew.Lnrpc.BatchOpenChannelRequest,
    Cashubrew.Lnrpc.BatchOpenChannelResponse
  )

  rpc(
    :FundingStateStep,
    Cashubrew.Lnrpc.FundingTransitionMsg,
    Cashubrew.Lnrpc.FundingStateStepResp
  )

  rpc(
    :ChannelAcceptor,
    stream(Cashubrew.Lnrpc.ChannelAcceptResponse),
    stream(Cashubrew.Lnrpc.ChannelAcceptRequest)
  )

  rpc(
    :CloseChannel,
    Cashubrew.Lnrpc.CloseChannelRequest,
    stream(Cashubrew.Lnrpc.CloseStatusUpdate)
  )

  rpc(
    :AbandonChannel,
    Cashubrew.Lnrpc.AbandonChannelRequest,
    Cashubrew.Lnrpc.AbandonChannelResponse
  )

  rpc(:SendPayment, stream(Cashubrew.Lnrpc.SendRequest), stream(Cashubrew.Lnrpc.SendResponse))

  rpc(:SendPaymentSync, Cashubrew.Lnrpc.SendRequest, Cashubrew.Lnrpc.SendResponse)

  rpc(
    :SendToRoute,
    stream(Cashubrew.Lnrpc.SendToRouteRequest),
    stream(Cashubrew.Lnrpc.SendResponse)
  )

  rpc(:SendToRouteSync, Cashubrew.Lnrpc.SendToRouteRequest, Cashubrew.Lnrpc.SendResponse)

  rpc(:AddInvoice, Cashubrew.Lnrpc.Invoice, Cashubrew.Lnrpc.AddInvoiceResponse)

  rpc(:ListInvoices, Cashubrew.Lnrpc.ListInvoiceRequest, Cashubrew.Lnrpc.ListInvoiceResponse)

  rpc(:LookupInvoice, Cashubrew.Lnrpc.PaymentHash, Cashubrew.Lnrpc.Invoice)

  rpc(:SubscribeInvoices, Cashubrew.Lnrpc.InvoiceSubscription, stream(Cashubrew.Lnrpc.Invoice))

  rpc(:DecodePayReq, Cashubrew.Lnrpc.PayReqString, Cashubrew.Lnrpc.PayReq)

  rpc(:ListPayments, Cashubrew.Lnrpc.ListPaymentsRequest, Cashubrew.Lnrpc.ListPaymentsResponse)

  rpc(:DeletePayment, Cashubrew.Lnrpc.DeletePaymentRequest, Cashubrew.Lnrpc.DeletePaymentResponse)

  rpc(
    :DeleteAllPayments,
    Cashubrew.Lnrpc.DeleteAllPaymentsRequest,
    Cashubrew.Lnrpc.DeleteAllPaymentsResponse
  )

  rpc(:DescribeGraph, Cashubrew.Lnrpc.ChannelGraphRequest, Cashubrew.Lnrpc.ChannelGraph)

  rpc(:GetNodeMetrics, Cashubrew.Lnrpc.NodeMetricsRequest, Cashubrew.Lnrpc.NodeMetricsResponse)

  rpc(:GetChanInfo, Cashubrew.Lnrpc.ChanInfoRequest, Cashubrew.Lnrpc.ChannelEdge)

  rpc(:GetNodeInfo, Cashubrew.Lnrpc.NodeInfoRequest, Cashubrew.Lnrpc.NodeInfo)

  rpc(:QueryRoutes, Cashubrew.Lnrpc.QueryRoutesRequest, Cashubrew.Lnrpc.QueryRoutesResponse)

  rpc(:GetNetworkInfo, Cashubrew.Lnrpc.NetworkInfoRequest, Cashubrew.Lnrpc.NetworkInfo)

  rpc(:StopDaemon, Cashubrew.Lnrpc.StopRequest, Cashubrew.Lnrpc.StopResponse)

  rpc(
    :SubscribeChannelGraph,
    Cashubrew.Lnrpc.GraphTopologySubscription,
    stream(Cashubrew.Lnrpc.GraphTopologyUpdate)
  )

  rpc(:DebugLevel, Cashubrew.Lnrpc.DebugLevelRequest, Cashubrew.Lnrpc.DebugLevelResponse)

  rpc(:FeeReport, Cashubrew.Lnrpc.FeeReportRequest, Cashubrew.Lnrpc.FeeReportResponse)

  rpc(
    :UpdateChannelPolicy,
    Cashubrew.Lnrpc.PolicyUpdateRequest,
    Cashubrew.Lnrpc.PolicyUpdateResponse
  )

  rpc(
    :ForwardingHistory,
    Cashubrew.Lnrpc.ForwardingHistoryRequest,
    Cashubrew.Lnrpc.ForwardingHistoryResponse
  )

  rpc(
    :ExportChannelBackup,
    Cashubrew.Lnrpc.ExportChannelBackupRequest,
    Cashubrew.Lnrpc.ChannelBackup
  )

  rpc(
    :ExportAllChannelBackups,
    Cashubrew.Lnrpc.ChanBackupExportRequest,
    Cashubrew.Lnrpc.ChanBackupSnapshot
  )

  rpc(
    :VerifyChanBackup,
    Cashubrew.Lnrpc.ChanBackupSnapshot,
    Cashubrew.Lnrpc.VerifyChanBackupResponse
  )

  rpc(
    :RestoreChannelBackups,
    Cashubrew.Lnrpc.RestoreChanBackupRequest,
    Cashubrew.Lnrpc.RestoreBackupResponse
  )

  rpc(
    :SubscribeChannelBackups,
    Cashubrew.Lnrpc.ChannelBackupSubscription,
    stream(Cashubrew.Lnrpc.ChanBackupSnapshot)
  )

  rpc(:BakeMacaroon, Cashubrew.Lnrpc.BakeMacaroonRequest, Cashubrew.Lnrpc.BakeMacaroonResponse)

  rpc(
    :ListMacaroonIDs,
    Cashubrew.Lnrpc.ListMacaroonIDsRequest,
    Cashubrew.Lnrpc.ListMacaroonIDsResponse
  )

  rpc(
    :DeleteMacaroonID,
    Cashubrew.Lnrpc.DeleteMacaroonIDRequest,
    Cashubrew.Lnrpc.DeleteMacaroonIDResponse
  )

  rpc(
    :ListPermissions,
    Cashubrew.Lnrpc.ListPermissionsRequest,
    Cashubrew.Lnrpc.ListPermissionsResponse
  )

  rpc(
    :CheckMacaroonPermissions,
    Cashubrew.Lnrpc.CheckMacPermRequest,
    Cashubrew.Lnrpc.CheckMacPermResponse
  )

  rpc(
    :RegisterRPCMiddleware,
    stream(Cashubrew.Lnrpc.RPCMiddlewareResponse),
    stream(Cashubrew.Lnrpc.RPCMiddlewareRequest)
  )

  rpc(
    :SendCustomMessage,
    Cashubrew.Lnrpc.SendCustomMessageRequest,
    Cashubrew.Lnrpc.SendCustomMessageResponse
  )

  rpc(
    :SubscribeCustomMessages,
    Cashubrew.Lnrpc.SubscribeCustomMessagesRequest,
    stream(Cashubrew.Lnrpc.CustomMessage)
  )

  rpc(:ListAliases, Cashubrew.Lnrpc.ListAliasesRequest, Cashubrew.Lnrpc.ListAliasesResponse)

  rpc(
    :LookupHtlcResolution,
    Cashubrew.Lnrpc.LookupHtlcResolutionRequest,
    Cashubrew.Lnrpc.LookupHtlcResolutionResponse
  )
end

defmodule Cashubrew.Lnrpc.Lightning.Stub do
  @moduledoc false

  use GRPC.Stub, service: Cashubrew.Lnrpc.Lightning.Service
end
