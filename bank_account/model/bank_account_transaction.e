note
	description: "Transactions on a bank account."
	author: "Paul-G. Crismer"
	license: "MIT License"
	copyright: "2012- Paul-G. Crismer & others (pgcrism@users.sf.net)"
	date: "$Date$"
	revision: "$Revision$"

class
	BANK_ACCOUNT_TRANSACTION

create
	make_deposit, make_withdraw

feature {NONE} -- Initialization

	make_deposit (an_amount: like amount; a_new_balance: like new_balance)
			-- Deposit `an_amount'.
		require
			an_amount_positive: an_amount >= 0
		do
			setup (an_amount, +1, a_new_balance)
		ensure
			amount_set: amount = an_amount
			new_balance_set: new_balance = a_new_balance
			deposit: is_deposit
		end

	make_withdraw (an_amount: like amount; a_new_balance: like new_balance)
			-- Deposit `an_amount'.
		require
			an_amount_positive: an_amount >= 0
		do
			setup (an_amount, -1, a_new_balance)
		ensure
			amount_set: amount = an_amount
			new_balance_set: new_balance = a_new_balance
			withdraw: is_withdraw
		end

	setup (an_amount, a_sign : INTEGER; a_new_balance: like new_balance)
		require

		do
			amount := an_amount
			new_balance:= a_new_balance
			sign := a_sign
			create timestamp.make_now_utc
		end

feature -- Status report

	is_deposit: BOOLEAN
			-- Is Current transaction a deposit?
		do Result := sign > 0 end

	is_withdraw: BOOLEAN
			-- Is Current transaction a withdraw?
		do Result := sign < 0 end

feature -- Access

	amount : INTEGER
			-- Amount.

	new_balance : INTEGER
			-- New balance.

	sign : INTEGER
			-- Sign.

	timestamp : DATE_TIME
			-- Timestamp

invariant
	amount_positive: amount >= 0
	timestamp_not_void: timestamp /= Void
	sign_domain: sign = 1 xor sign = -1

end
