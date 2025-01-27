module sui_token_contract::basictoken {
    use sui::url::{Self, Url};
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Supply, Balance};

    const DECIMALS: u8 = 9;
    const MAX_SUPPLY: u64 = 1_000_000_000_000_000_000; // Set your fixed maximum supply here

    const E_MAXIMUM_SUPPLY_REACHED: u64 = 100;

    public struct BASICTOKEN has drop {}

    public struct BASICTOKENMetadata<phantom T> has key, store {
        id: UID,
        total_supply: Supply<T>,
    }

    fun init(witness: BASICTOKEN, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency<BASICTOKEN>(
            witness,
            DECIMALS, // decimals
            b"BTKN9", // symbol
            b"BASICTOKEN9", // name
            b"Description of the BASICTOKEN9", // description
            option::some<Url>(url::new_unsafe_from_bytes(b"https://token_url")), // icon url
            ctx
        );

        transfer::public_freeze_object(metadata);
        // Destroy treasury_cap and store it in custom Metadata object
        let supply = coin::treasury_into_supply(treasury_cap);
        transfer::share_object(BASICTOKENMetadata<BASICTOKEN> {
            id: object::new(ctx),
            total_supply: supply,
        });
    }

    public fun get_total_supply(metadata: &BASICTOKENMetadata<BASICTOKEN>): &Supply<BASICTOKEN> {
        &metadata.total_supply
    }

    public fun get_total_supply_value(metadata: &BASICTOKENMetadata<BASICTOKEN>): u64 {
        balance::supply_value(&metadata.total_supply)
    }

    public entry fun mint(
        metadata: &mut BASICTOKENMetadata<BASICTOKEN>, mint_amount: u64, ctx: &mut TxContext
    ) {
        let current_supply = balance::supply_value(&metadata.total_supply);
        assert!(current_supply + mint_amount <= MAX_SUPPLY, E_MAXIMUM_SUPPLY_REACHED);

        let minted_balance = balance::increase_supply(&mut metadata.total_supply, mint_amount);
        transfer::public_transfer(coin::from_balance(minted_balance, ctx), ctx.sender());
    }

    public entry fun mint_and_transfer(
        metadata: &mut BASICTOKENMetadata<BASICTOKEN>, mint_amount: u64, recipient: address, ctx: &mut TxContext
    ) {
        let current_supply = balance::supply_value(&metadata.total_supply);
        assert!(current_supply + mint_amount <= MAX_SUPPLY, E_MAXIMUM_SUPPLY_REACHED);

        let minted_balance = balance::increase_supply(&mut metadata.total_supply, mint_amount);
        transfer::public_transfer(coin::from_balance(minted_balance, ctx), recipient);
    }

    public entry fun transfer_token(
        coin: Coin<BASICTOKEN>,
        recipient: address,
    ){
        transfer::public_transfer(coin, recipient);
    }

    /// Burn coin
    public fun burn_coin(metadata: &mut BASICTOKENMetadata<BASICTOKEN>, coin: Coin<BASICTOKEN>): u64 {
        balance::decrease_supply(&mut metadata.total_supply, coin::into_balance(coin))
    }

    /// Burn balance instead of coin
    public fun burn_balance(metadata: &mut BASICTOKENMetadata<BASICTOKEN>, balance: Balance<BASICTOKEN>): u64 {
        balance::decrease_supply(&mut metadata.total_supply, balance)
    }
}
