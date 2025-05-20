use starknet::ContractAddress;
use quantmart_contract::utils::{UserAddress, Amount, TokenAddress};
use quantmart_contract::starkstructs::{history_entry};

#[starknet::interface]
pub trait IQuantMart<TContractState> {
}