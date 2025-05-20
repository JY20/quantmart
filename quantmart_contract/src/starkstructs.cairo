use starknet::ContractAddress;
use quantmart_contract::utils::{Amount, UserAddress, TokenAddress};

#[derive(Copy, Serde, Drop, starknet::Store)]
pub struct history_entry {
    pub strategy: felt252,       
    pub amount: Amount, 
    pub datetime: u64   
}