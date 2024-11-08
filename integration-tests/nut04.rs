use std::str::FromStr;

use assert_matches::assert_matches;
use cdk::{
    amount::Amount,
    mint_url::MintUrl,
    nuts::{CurrencyUnit, MintQuoteState},
    wallet::MintQuote,
};
use integration_tests::init_wallet;
use lightning_invoice::Bolt11Invoice;
use uuid::Uuid;

#[tokio::test]
pub async fn mint_quote_ok() {
    const CASHU_MINT_URL: &str = "http://localhost:4000";
    let wallet = init_wallet(CASHU_MINT_URL, CurrencyUnit::Sat).unwrap();
    let quote_amount = Amount::from(100);

    let quote = wallet.mint_quote(quote_amount).await.unwrap();

    let now = std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap()
        .as_secs();

    assert_matches!(
        quote,
        MintQuote {
            ref id,
            mint_url,
            amount,
            unit,
            request,
            state,
            expiry
        } if Uuid::try_parse(id).is_ok()
            && mint_url == MintUrl::from_str(CASHU_MINT_URL).unwrap()
            && amount == quote_amount
            && unit == CurrencyUnit::Sat
            && Bolt11Invoice::from_str(&request).is_ok()
            && state == MintQuoteState::Unpaid
            && expiry >= now
    );
}
