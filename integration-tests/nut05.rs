use assert_matches::assert_matches;
use cdk::{
    amount::Amount,
    nuts::{CurrencyUnit, MeltQuoteState},
    wallet::MeltQuote,
};
use integration_tests::init_wallet;
use uuid::Uuid;

#[tokio::test]
pub async fn melt_quote_ok() {
    const URL: &str = "http://localhost:4000";
    let wallet = init_wallet(URL, CurrencyUnit::Sat).unwrap();

    let bolt11_invoice = "lnbc100n1pnvpufspp5djn8hrq49r8cghwye9kqw752qjncwyfnrprhprpqk43mwcy4yfsqdq5g9kxy7fqd9h8vmmfvdjscqzzsxqyz5vqsp5uhpjt36rj75pl7jq2sshaukzfkt7uulj456s4mh7uy7l6vx7lvxs9qxpqysgqedwz08acmqwtk8g4vkwm2w78suwt2qyzz6jkkwcgrjm3r3hs6fskyhvud4fan3keru7emjm8ygqpcrwtlmhfjfmer3afs5hhwamgr4cqtactdq".to_string();
    let melt_quote = wallet.melt_quote(bolt11_invoice, None).await.unwrap();

    let now = std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap()
        .as_secs();

    assert_matches!(
        melt_quote,
        MeltQuote {
            id,
            unit: _,
            amount,
            request: _,
            fee_reserve,
            state,
            expiry,
            payment_preimage
        } if Uuid::try_parse(&id).is_ok()
        && amount == Amount::from(10)
        && fee_reserve == Amount::from(1)
        && state == MeltQuoteState::Unpaid
        && expiry >= now
        && payment_preimage.is_none()
    )
}
