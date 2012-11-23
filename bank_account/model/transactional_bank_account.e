note
	description: "Bank accounts that record deposits/withdraws as transactions."
	author: "Paul-G. Crismer"
	license: "MIT License"
	copyright: "2012- Paul-G. Crismer & others (pgcrism@users.sf.net)"
	date: "$Date$"
	revision: "$Revision$"

class
	TRANSACTIONAL_BANK_ACCOUNT

inherit
	BANK_ACCOUNT
		redefine
			withdraw, deposit, make
		end

create
	make

feature -- Initialization

	make (a_number: like number)
		do
			Precursor (a_number)
			create transactions.make
		end

feature -- Basic operations

	withdraw (amount: INTEGER_32)
		do
			Precursor (amount)
			transactions.extend (create {BANK_ACCOUNT_TRANSACTION}.make_withdraw (amount, balance))
		ensure then
			one_more_transaction: transactions.count = old transactions.count + 1
			last_transaction: transactions.item.amount = amount and then transactions.item.is_withdraw
		end

	deposit (amount: INTEGER_32)
		do
			Precursor (amount)
			transactions.extend (create {BANK_ACCOUNT_TRANSACTION}.make_deposit (amount, balance))
		ensure then
			one_more_transaction: transactions.count = old transactions.count + 1
			last_transaction: transactions.item.amount = amount and then transactions.item.is_deposit
		end

feature -- Access

	transactions : BANK_ACCOUNT_TRANSACTIONS

end
