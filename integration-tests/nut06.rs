extern crate integration_tests;

use assert_matches::assert_matches;
use integration_tests::init_wallet;

use cdk::nuts::{
    ContactInfo, CurrencyUnit, MeltMethodSettings, MintInfo, MintMethodSettings, MintVersion,
    NUT04Settings, Nuts, PaymentMethod, PublicKey,
};

#[tokio::test]
pub async fn info() {
    const URL: &str = "http://localhost:4000";
    let wallet = init_wallet(URL, CurrencyUnit::Sat).unwrap();
    let mint_info = wallet.get_mint_info().await.unwrap().unwrap();

    let expected_nuts = Nuts::new()
        .nut04(NUT04Settings::new(
            [MintMethodSettings {
                method: PaymentMethod::Bolt11,
                unit: CurrencyUnit::Sat,
                min_amount: None,
                max_amount: None,
            }]
            .to_vec(),
            false,
        ))
        .nut05(cdk::nuts::NUT05Settings::new(
            [MeltMethodSettings {
                method: PaymentMethod::Bolt11,
                unit: CurrencyUnit::Sat,
                min_amount: None,
                max_amount: None,
            }]
            .to_vec(),
            false,
        ));
    let expected_name = "Cashubrew Cashu Mint";
    let expected_pubkey =
        PublicKey::from_hex("0381094f72790bb014504dfc9213bd3c8450440f5d220560075dbf2f8113e9fa3e")
            .unwrap();
    let expected_version = MintVersion::new("Cashubrew".to_string(), "0.1.0".to_string());
    let expected_description = "An Elixir implementation of Cashu Mint";
    let expected_contact = [
        ContactInfo::new("twitter".to_string(), "@dimahledba".to_string()),
        ContactInfo::new(
            "nostr".to_string(),
            "npub1hr6v96g0phtxwys4x0tm3khawuuykz6s28uzwtj5j0zc7lunu99snw2e29".to_string(),
        ),
    ];
    let now = std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap()
        .as_secs();

    assert_matches!(
        mint_info,
        MintInfo {
            name: Some(name) ,
            pubkey: Some(pubkey),
            version: Some(version),
            description: Some(description),
            description_long: None,
            contact: Some(contact),
            nuts,
            icon_url: None,
            motd: None,
            time: Some(time)
        } if name == expected_name
            && pubkey == expected_pubkey
            && version == expected_version
            && description == expected_description
            && contact == expected_contact
            && nuts == expected_nuts
            && time <= now
    );
}
