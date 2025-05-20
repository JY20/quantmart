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
        strategy_price: LegacyMap<felt252, u256>,
        strategy_creator: LegacyMap<felt252, UserAddress>,
        owner: UserAddress,
        history: LegacyMap<(UserAddress, u128), history_entry>,
        user_history_counts: LegacyMap<UserAddress, u128>,
        user_addresses: LegacyMap<u256, UserAddress>,
        user_addresses_len: u256,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        let creator = contract_address_const::<0x012B099F50C3CbCc82ccF7Ee557c9d60255c35C359eA6615435B761Ec3336EC8>();
        let key1 = 'averageRebalance';
        self.strategy_price.write(key1, 1_u256);
        self.strategy_creator.write(key1, creator);

        let key2 = 'momentum';
        self.strategy_price.write(key2, 1_u256);
        self.strategy_creator.write(key2, creator);

        let key3 = 'standardDeviation';
        self.strategy_price.write(key3, 1_u256);
        self.strategy_creator.write(key3, creator);

        let key4 = 'coVariance';
        self.strategy_price.write(key4, 1_u256);
        self.strategy_creator.write(key4, creator);

        let owner = contract_address_const::<0x012B099F50C3CbCc82ccF7Ee557c9d60255c35C359eA6615435B761Ec3336EC8>();
        self.owner.write(owner);
    }

    #[abi(embed_v0)]
    impl QuantMartImpl of super::IQuantMart<ContractState> {
                fn run_strategy(ref self: ContractState, strategy: felt252, amount: Amount, token_address: TokenAddress) {
            let caller = get_caller_address();
            let creator = self.strategy_creator.read(strategy);

            let fee_part = amount*20/100;
            let payout_part = amount*80/100;

            let token: IERC20Dispatcher = IERC20Dispatcher {
                contract_address: token_address,
            };

            let contract_addr = get_contract_address();
            let transfer1 = token.transferFrom(caller, contract_addr, fee_part);
            assert(transfer1, 'Contract fee transfer failed.');

            let transfer2 = token.transferFrom(caller, creator, payout_part);
            assert(transfer2, 'Creator payout transfer failed.');

            let count = self.user_history_counts.read(caller);
            let history_value = history_entry {
                strategy: strategy,
                amount: amount,
                datetime: get_block_timestamp()
            };

            if count == 0 {
                let current_user_count = self.user_addresses_len.read();
                self.user_addresses.write(current_user_count, caller);
                self.user_addresses_len.write(current_user_count + 1);
            };

            self.history.write((caller, count), history_value);
            self.user_history_counts.write(caller, count + 1);
        }

        fn get_strategy_price(self: @ContractState, strategy: felt252) -> Amount{
            self.strategy_price.read(strategy)
        }

        fn set_strategy(ref self: ContractState, strategy: felt252, amount: Amount, creator_address: UserAddress) {
            let caller = get_caller_address();
            let owner = self.owner.read();
            assert(caller == owner, 'NOT_OWNER');

            self.strategy_price.write(strategy, amount);
            self.strategy_creator.write(strategy, creator_address);
        }

        fn get_history(self: @ContractState, user: UserAddress) -> Array<history_entry> {
            let count = self.user_history_counts.read(user);
            let mut histories = ArrayTrait::new();
            let mut i = 0;

            while i < count {
                let history_value = self.history.read((user, i));
                histories.append(history_value);
                i = i + 1;
            };

            return histories;
        }

        fn get_all_histories(self: @ContractState) -> Array<history_entry> {
            let mut all_histories = ArrayTrait::new();
            let total_users = self.user_addresses_len.read();
            let mut u = 0;

            while u < total_users {
                let user = self.user_addresses.read(u);
                let count = self.user_history_counts.read(user);
                let mut i = 0;

                while i < count {
                    let history_value = self.history.read((user, i));
                    all_histories.append(history_value);
                    i = i + 1;
                };

                u = u + 1;
            };

            return all_histories;
        }

        fn get_all_user_addresses(self: @ContractState) -> Array<UserAddress> {
            let length = self.user_addresses_len.read();
            let mut addresses = ArrayTrait::new();
            let mut i = 0_u256;

            loop {
                if i == length {
                    break;
                }
                let addr = self.user_addresses.read(i);
                addresses.append(addr);
                i = i + 1;
            };

            addresses
        }
    }
}
