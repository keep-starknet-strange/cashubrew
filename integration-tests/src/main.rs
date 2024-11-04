use bitcoind::bitcoincore_rpc::RpcApi;
use lnd::Lnd;
use lnd::LndConf;
use std::sync::mpsc::channel;

#[tokio::main]
async fn main() {
    println!("Downloading bitcoind...");
    let bitcoind = bitcoind::BitcoinD::from_downloaded().unwrap();
    assert_eq!(0, bitcoind.client.get_blockchain_info().unwrap().blocks);
    println!("Done");
    println!("bitcoind is running");

    println!("Downloading lnd...");
    let lnd_conf = LndConf::default();
    let mut lnd = Lnd::with_conf(
        lnd::exe_path().unwrap(),
        &lnd_conf,
        bitcoind
            .params
            .cookie_file
            .clone()
            .into_os_string()
            .into_string()
            .unwrap(),
        bitcoind.params.rpc_socket.to_string(),
        &bitcoind,
    )
    .await
    .unwrap();
    assert!(lnd
        .client
        .lightning()
        .get_info(tonic_lnd::lnrpc::GetInfoRequest {})
        .await
        .is_ok());
    println!("Done");
    println!("lnd is running");

    let (tx, rx) = channel();

    ctrlc::set_handler(move || tx.send(()).expect("Could not send signal on channel."))
        .expect("Error setting Ctrl-C handler");

    println!("Press ctrl+c to exit");

    rx.recv().expect("Could not receive from channel.");
}
