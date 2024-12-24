#[starknet::contract]
mod ERC20CONTRACT {
    use openzeppelin_token::erc20::{ERC20Component, ERC20HooksEmptyImpl};
    
    #[storage]
    struct Storage {
        erc20: ERC20Component::Storage,  
        balance: u256,  
    }

    #[event]
    enum Event {
        BalanceIncreased { amount: u256 },
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        let component = ERC20Component {
            name: "HelloStarknet",
            symbol: "HSN",
            decimals: 18,
        };
        
        // Write the ERC20 component into the storage
        self.erc20.write(component);

        // Initialize balance to 0
        self.balance.write(0);
    }

    // Function to increase the balance, following the logic of the provided tests
    #[abi(embed_v0)]
    impl ERC20ContractImpl of ERC20Component<ContractState> {
        fn increase_balance(ref self: ContractState, amount: u256) {
            // Ensure the amount is non-zero
            assert(amount > 0, "Amount cannot be 0");

            // Increase the balance by the specified amount
            let current_balance = self.balance.read();
            self.balance.write(current_balance + amount);
            
            // Emit the event when balance is increased
            self.emit(Event::BalanceIncreased { amount });
        }

        // Function to get the current balance
        fn get_balance(self: @ContractState) -> u256 {
            self.balance.read()
        }
    }
}
