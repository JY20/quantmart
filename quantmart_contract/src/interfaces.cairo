use starknet::ContractAddress;
use quantmart_contract::utils::{UserAddress, Amount, TokenAddress};
use quantmart_contract::starkstructs::{history_entry};

#[starknet::interface]
pub trait IQuantMart<TContractState> {
    fn run_strategy(ref self: TContractState, strategy: felt252, amount: Amount, token_address: TokenAddress);
    fn get_strategy_price(self: @TContractState, strategy: felt252) -> Amount;
    fn set_strategy(ref self: TContractState, strategy: felt252, amount: Amount, creator_address: UserAddress);
    fn get_history(self: @TContractState, user: UserAddress) -> Array<history_entry>;
    fn get_all_histories(self: @TContractState) -> Array<history_entry>;
    fn get_all_user_addresses(self: @TContractState) -> Array<UserAddress>;
}