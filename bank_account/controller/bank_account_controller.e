note
	description: "GUI Controllers for BANK_ACCOUNT."
	author: "Paul-G. Crismer"
	license: "MIT License"
	copyright: "2012- Paul-G. Crismer & others (pgcrism@users.sf.net)"
	date: "$Date$"
	revision: "$Revision$"

class
	BANK_ACCOUNT_CONTROLLER

inherit
	ANY
		redefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make (an_account: like account)
		do
			default_create
			account := an_account
		end

	default_create
		do
			create invalid_deposit_actions
			create invalid_withdraw_actions
			create balance_changed_actions
			create transactions_changed_actions
			create last_amount_string.make_empty
			create last_amount_error.make_empty
		end

feature -- Access

	account: TRANSACTIONAL_BANK_ACCOUNT

feature -- Basic operations

	deposit (amount_text: READABLE_STRING_GENERAL)
			-- do deposit `amount_text' money.
		local
			current_amount: like last_amount_string
		do
			current_amount := amount_text.to_string_8
			check_amount (current_amount)
			if last_amount_error.is_empty then
				account.deposit (last_amount)
				balance_changed_actions.call ([account.balance])
				transactions_changed_actions.call ([account.transactions.item])
			else
				invalid_deposit_actions.call ([current_amount, last_amount_error])
			end
		end

	withdraw (amount_text: READABLE_STRING_GENERAL)
			-- do withdraw `amount_text' money
		local
			current_amount: like last_amount_string
		do
			current_amount := amount_text.to_string_8
			check_amount (current_amount)
			if last_amount_error.is_empty then
				if account.may_withdraw (last_amount) then
					account.withdraw (last_amount)
					balance_changed_actions.call ([account.balance])
					transactions_changed_actions.call ([account.transactions.item])
				else
					invalid_deposit_actions.call ([current_amount, "Amount too large"])
				end
			else
				invalid_deposit_actions.call ([current_amount, last_amount_error])
			end
		end

feature -- Event Management

	invalid_deposit_actions : ACTION_SEQUENCE[TUPLE[amount: STRING; message:STRING]]
			-- Actions fired in case of invalid deposit operation.

	invalid_withdraw_actions: ACTION_SEQUENCE[TUPLE[amount: STRING; message:STRING]]
			-- Actions fired in case of invalid withdraw operation.

	balance_changed_actions : ACTION_SEQUENCE[TUPLE[amount: INTEGER]]
			-- Actions fired when balance has changed.

	transactions_changed_actions: ACTION_SEQUENCE[TUPLE[new_transaction: BANK_ACCOUNT_TRANSACTION]]
			-- Actions fired when a new transaction has occurred.

feature -- Implementation

	is_positive_integer (a_string: STRING) : BOOLEAN
			-- is `a_string' a positive integer?
		local
			i : INTEGER
		do
			Result := True
			from
				i := 1
			until
				i > a_string.count or else not Result
			loop
				inspect a_string [i]
				when '0'..'9' then
				else
					Result := False
				end
				i := i + 1
			end
		end

	last_amount_string: STRING
	last_amount: INTEGER
	last_amount_error: STRING

	check_amount (a_string: STRING)
		do
			last_amount_string := a_string
			if is_positive_integer (a_string) then
				last_amount := a_string.to_integer
				last_amount_error := ""
			else
				last_amount := 0
				last_amount_error := "Amount must be positive"
			end
		ensure
			zero_if_error: last_amount_error.count > 0 implies last_amount = 0
			converted_if_ok: last_amount_error.is_empty implies last_amount = a_string.to_integer
		end

end
