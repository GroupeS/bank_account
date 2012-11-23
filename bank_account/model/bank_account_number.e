note
	description: "Bank Account Numbers."
	author: "Paul-G. Crismer"
	license: "MIT License"
	copyright: "2012- Paul-G. Crismer & others (pgcrism@users.sf.net)"
	date: "$Date$"
	revision: "$Revision$"

class
	BANK_ACCOUNT_NUMBER

create
	make

feature -- Initialization

	make (a_number: STRING)
		do
			number := a_number
		end

feature -- Access

	number : STRING
	
end
