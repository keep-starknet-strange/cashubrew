use cdk::cdk_database::WalletMemoryDatabase;
use cdk::nuts::CurrencyUnit;
use cdk::wallet::Wallet;
use rand::Rng;
use std::sync::Arc;

pub fn init_wallet(mint_url: &str, unit: CurrencyUnit) -> Result<Wallet, cdk::Error> {
    let seed = rand::thread_rng().gen::<[u8; 32]>();

    let localstore = WalletMemoryDatabase::default();
    Wallet::new(mint_url, unit, Arc::new(localstore), &seed, None)
}
