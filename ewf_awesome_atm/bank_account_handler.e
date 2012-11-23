note
	description: "REST Bank Account Handlers."
	author: "Paul-G. Crismer"
	license: "MIT License"
	copyright: "2012- Paul-G. Crismer & others (pgcrism@users.sf.net)"
	date: "$Date$"
	revision: "$Revision$"

class
	BANK_ACCOUNT_HANDLER [C -> WSF_HANDLER_CONTEXT]

inherit
	WSF_HANDLER [C]
	WSF_RESOURCE_HANDLER_HELPER [C]
		redefine
			do_get,
			do_post
		end

	SHARED_EJSON
	REFACTORING_HELPER

create
	make

feature -- Initialization

	make (a_controller: like controller)
		do
			controller := a_controller
			create last_invalid_post_message.make_empty

			controller.invalid_deposit_actions.extend (agent invalid_post)
			controller.invalid_withdraw_actions.extend (agent invalid_post)
			controller.transactions_changed_actions.extend (agent register_last_transaction)
		end

feature -- Access

	controller : BANK_ACCOUNT_CONTROLLER

feature -- execute

	execute (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler	
		do
			execute_methods (ctx, req, res)
		end

feature -- API DOC

	api_doc : STRING = "[
			URI:/account/123 METHOD: GET
			URI:/account/123/transactions METHOD: GET, POST
			]"


feature -- HTTP Methods

	do_get (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Using GET to retrieve resource information.
			-- If the GET request is SUCCESS, we response with
			-- 200 OK, and a representation of the order
			-- If the GET request is not SUCCESS, we response with
			-- 404 Resource not found
		local
			l_result_json: JSON_VALUE
		do
			if attached req.orig_path_info as orig_path then
				if orig_path.same_string ("/account/123")  then
					l_result_json := account_to_json (controller.account)
				else
					l_result_json := transactions_to_json (controller.account.transactions)
				end
				compute_response_get (ctx, req, res, l_result_json)
			end
		end

	compute_response_get (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE; l_value: JSON_VALUE)
		local
			h: HTTP_HEADER
			l_msg : STRING
		do
			create h.make
			h.put_content_type_application_json
			l_msg := l_value.representation
			h.put_content_length (l_msg.count)
			if attached req.request_time as time then
				h.add_header ("Date:" + time.formatted_out ("ddd,[0]dd mmm yyyy [0]hh:[0]mi:[0]ss.ff2") + " GMT")
			end
			h.add_header ("Access-Control-Allow-Origin: *")
			res.set_status_code ({HTTP_STATUS_CODE}.ok)
			res.put_header_text (h.string)
			res.put_string (l_msg)
		end

	do_post (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Here the convention is the following.
			-- POST is used for creation and the server determines the URI
			-- of the created resource.
			-- If the request post is SUCCESS, the server will create the order and will response with
			-- HTTP_RESPONSE 201 CREATED, the Location header will contains the newly created order's URI
			-- if the request post is not SUCCESS, the server will response with
			-- HTTP_RESPONSE 400 BAD REQUEST, the client send a bad request
			-- HTTP_RESPONSE 500 INTERNAL_SERVER_ERROR, when the server can deliver the request
		local
			l_response: JSON_OBJECT
		do
			is_invalid_post_arguments := False
			last_invalid_post_message := ""
			if attached {WSF_STRING} req.form_parameter ("operation") as l_operation and then
			   attached {WSF_STRING} req.form_parameter ("amount") as l_amount then
				if l_operation.value.is_case_insensitive_equal ("Deposit") then
					controller.deposit (l_amount.value)
				elseif l_operation.value.is_case_insensitive_equal ("Withdraw") then
					controller.withdraw (l_amount.value)
				else

				end
				create l_response.make
				if attached last_transaction as l_trans then
					l_response.put (transaction_to_json (l_trans), json_string (k_response))
				else
					l_response.put (create {JSON_NULL}, json_string (k_response))
				end
				l_response.put (json_string (last_invalid_post_message), json_string (k_error))
				compute_response_post (ctx, req, res, l_response)
			else
				handle_bad_request_response ("Parameters not valid", ctx, req, res)
			end
		end

	compute_response_post (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE; l_value: JSON_VALUE)
		local
			h: HTTP_HEADER
			l_msg : STRING
			l_location :  STRING
		do
			create h.make
			h.put_content_type_application_json
			l_msg := l_value.representation
			h.put_content_length (l_msg.count)
			if attached req.request_time as time then
				h.put_utc_date (time)
			end
			h.add_header ("Access-Control-Allow-Origin: *")
			res.set_status_code ({HTTP_STATUS_CODE}.created)
			res.put_header_text (h.string)
			res.put_string (l_msg)
		end

feature -- Controller Event management

	invalid_post (amount: STRING; message : STRING)
			-- Capture invalid post events
		do
			is_invalid_post_arguments := True
			last_invalid_post_message := message
		end

	register_last_transaction (a_transaction : BANK_ACCOUNT_TRANSACTION)
			-- Capture new transaction event
		do
			last_transaction := a_transaction
		end

	last_transaction: detachable BANK_ACCOUNT_TRANSACTION

	is_invalid_post_arguments: BOOLEAN
	last_invalid_post_message: STRING

feature -- Conversion

	account_to_json (an_account: BANK_ACCOUNT): JSON_VALUE
		local
			l_object: JSON_OBJECT
			l_string: JSON_STRING
			l_number: JSON_NUMBER
		do
			create l_object.make
			l_object.put (json_string (an_account.number.number), json_string (k_number))
			l_object.put (json_number (an_account.balance), json_string (k_balance))
			Result := l_object
		end

	json_string (a_string: STRING) : JSON_STRING
		do
			create Result.make_json (a_string)
		end

	json_number (a_integer: INTEGER) : JSON_NUMBER
		do
			create Result.make_integer (a_integer)
		end

	transactions_to_json (a_transactions: BANK_ACCOUNT_TRANSACTIONS) : JSON_ARRAY
		local
			l_linear: LINEAR[BANK_ACCOUNT_TRANSACTION]
			l_value : JSON_VALUE
		do
			create {JSON_ARRAY} Result.make_array
			l_linear := a_transactions.linear_representation
			from
				l_linear.start
			until
				l_linear.off
			loop
				l_value := transaction_to_json (l_linear.item)
				Result.add (l_value)
				l_linear.forth
			end
		end

	transaction_to_json (a_transaction: BANK_ACCOUNT_TRANSACTION) : JSON_OBJECT
		do
			create Result.make
			Result.put (json_date (a_transaction.timestamp.date), json_string (k_date))
			Result.put (json_time (a_transaction.timestamp.time), json_string (k_time))
			Result.put (json_op (a_transaction), json_string (k_operation))
			Result.put (json_number (a_transaction.amount), json_string (k_amount))
			Result.put (json_number (a_transaction.new_balance), json_string (k_new_balance))
		end

	json_date (a_date: DATE) : JSON_STRING
		do
			create Result.make_json (a_date.formatted_out ("[0]dd/[0]mm/yyyy"))
		end

	json_time (a_time: TIME) : JSON_STRING
		do
			create Result.make_json (a_time.formatted_out ("[0]hh:[0]mm:[0]ss"))
		end

	json_op (a_transaction: BANK_ACCOUNT_TRANSACTION) : JSON_STRING
		local
			l_op : STRING
		do
			if a_transaction.is_deposit then
				l_op := "Deposit"
			else
				l_op := "Withdraw"
			end
			create Result.make_json (l_op)
		end

feature -- Constants / JSON Conversion

	k_number: STRING = "number"
	k_balance: STRING = "balance"

	k_date: STRING = "date"
	k_time: STRING = "time"
	k_operation: STRING = "operation"
	k_new_balance: STRING = "new_balance"
	k_amount : STRING = "amount"

	k_response: STRING = "response"
	k_error: STRING = "error"

end
