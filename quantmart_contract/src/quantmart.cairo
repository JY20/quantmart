use quantmart_contract::interfaces::IQuantMart;

#[starknet::contract]
mod QuantMart {
    use quantmart_contract::erc20::IERC20DispatcherTrait;
    use core::clone::Clone;
    use quantmart_contract::interfaces::IQuantMart;
    use starknet::{get_caller_address, ContractAddress, get_contract_address, get_block_timestamp};
    use quantmart_contract::utils::{UserAddress, TokenAddress, Amount};
    use quantmart_contract::erc20::{IERC20Dispatcher};
    use starknet::contract_address_const;
    use quantmart_contract::starkstructs::{history_entry};
    
    #[storage]
    struct Storage {
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
    }

    #[abi(embed_v0)]
    impl QuantMartImpl of super::IQuantMart<ContractState> {
    }
}
