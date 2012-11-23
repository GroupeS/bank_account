note
	description: "Containers for bank account transactions.  Stack behaviour."
	author: "Paul-G. Crismer"
	license: "MIT License"
	copyright: "2012- Paul-G. Crismer & others (pgcrism@users.sf.net)"
	date: "$Date$"
	revision: "$Revision$"

class
	BANK_ACCOUNT_TRANSACTIONS

inherit
	LINKED_STACK[BANK_ACCOUNT_TRANSACTION]

create
	make
	
end
