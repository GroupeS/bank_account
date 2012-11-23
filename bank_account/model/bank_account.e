note
	description: "Bank Accounts."
	author: "Paul-G. Crismer"
	license: "MIT License"
	copyright: "2012- Paul-G. Crismer & others (pgcrism@users.sf.net)"
	date: "$Date$"
	revision: "$Revision$"

class
	BANK_ACCOUNT

create
	make

feature -- Initialization

	make (a_number : like number)
		require
			a_number_not_void: a_number /= Void
		do
			set_number (a_number)
		ensure
			number_set: number = a_number
		end

feature -- Access

	balance: INTEGER
		-- Balance

	number : BANK_ACCOUNT_NUMBER

feature -- Element change

	set_number (a_number: like number)
		require
			a_number_not_void: a_number /= Void
		do
			number := a_number
		ensure
			number_set: number = a_number
		end
feature -- Status report

	may_withdraw (amount : INTEGER): BOOLEAN
			-- May `amount' be withdrawn?
--		require
--			amount_strictly_positive: amount > 0
		do
			Result := amount > 0 and then (balance - amount) >= 0
		end

feature -- Basic operations

	deposit (amount : INTEGER)
			-- Deposit `amount'.
		require
			amount_positive: amount >= 0
		do
			balance := balance + amount
		ensure
			balance_set: balance = old balance + amount
		end

	withdraw (amount : INTEGER)
			-- Withdraw `amount'.
		require
			may_withdraw: may_withdraw (amount)
		do
			balance := balance - amount
		ensure
			balance_less: balance < old balance
			balance_set: balance = old balance - amount
		end

invariant

	balance_positive: balance >= 0
	number_not_void: number /= Void
end
