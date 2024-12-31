import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";

actor Token {
    private let owner: Principal = Principal.fromText("w5nym-malzv-6y7nq-u45nc-5p23o-x5wtv-tzx5t-eoxen-bodeb-3c5rp-hae");
    private let totalSupply: Nat = 1_000_000_000;
    private let symbol: Text = "DASH";
    private stable var balanceEntries: [(Principal, Nat)] = [];
    private var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);

    // Initialize owner balance
    balances.put(owner, totalSupply);

    public query func balanceOf(who: Principal): async Nat {
    // Check the balances HashMap for the given Principal and handle null appropriately
    return switch (balances.get(who)) {
        case (?balance) { balance }; // Return the existing balance
        case null { 0 };            // If null (key not found), return 0
    };
};


    // Query function to get the symbol
    public query func getSymbol(): async Text {
        return symbol;
    };

    // Function to distribute free tokens to new users
    public shared(msg) func payOut(): async Text {
        if (balances.get(msg.caller) == null) {
            return await transfer(msg.caller, 10_000);
        } else {
            return "Tokens already claimed!";
        }
    };

    // Function to transfer tokens from the caller to another account
    public shared(msg) func transfer(to: Principal, amount: Nat): async Text {
        let senderBalance = await balanceOf(msg.caller);
        if (senderBalance < amount) {
            return "Insufficient funds";
        };

        // Deduct tokens from sender
        balances.put(msg.caller, senderBalance - amount);

        // Add tokens to the recipient
        let recipientBalance = await balanceOf(to);
        balances.put(to, recipientBalance + amount);

        return "Transfer successful";
    };

    // Store balances in a stable variable before upgrades
    system func preupgrade() {
        balanceEntries := Iter.toArray(balances.entries());
    };

    // Restore balances after upgrades
    system func postupgrade() {
        balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash);

        // Ensure owner gets tokens only if the balances are empty
        if (balances.size() < 1) {
            balances.put(owner, totalSupply);
        }
    };
}
