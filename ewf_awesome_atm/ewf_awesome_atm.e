note
	description : "Application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	EWF_AWESOME_ATM

inherit
	ANY

	WSF_URI_TEMPLATE_ROUTED_SERVICE

	WSF_HANDLER_HELPER

	WSF_DEFAULT_SERVICE

create
	make

feature {NONE} -- Initialization

	make
		do
			initialize_router
			set_service_option ("port", 9090)
			make_and_launch
		end

	setup_router
		local
			bank_account_handler: BANK_ACCOUNT_HANDLER [WSF_URI_TEMPLATE_HANDLER_CONTEXT]
		do
			create account.make (create {BANK_ACCOUNT_NUMBER}.make("123-456789-10"))
			account.deposit (100)
			account.withdraw (12)
			account.deposit (22)
			--
			create account_controller.make (account)
			create bank_account_handler.make (account_controller)
			--
			router.map_with_request_methods ("/account/123", bank_account_handler, <<"GET">>)
			router.map_with_request_methods ("/account/123/transactions", bank_account_handler, <<"GET", "POST">>)
		end

feature -- Execution

	execute_default (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- I'm using this method to handle the method not allowed response
			-- in the case that the given uri does not have a corresponding http method
			-- to handle it.
		local
			h : HTTP_HEADER
			l_description : STRING
		do
			if req.content_length_value > 0 then
				req.input.read_string (req.content_length_value.as_integer_32)
			end
			create h.make
			h.put_content_type_text_plain
			l_description := req.request_method + req.request_uri + " is not allowed" + "%N" + api_doc
			h.put_content_length (l_description.count)
			h.put_current_date
			res.set_status_code ({HTTP_STATUS_CODE}.method_not_allowed)
			res.put_header_text (h.string)
			res.put_string (l_description)
		end

feature -- Access

	account : TRANSACTIONAL_BANK_ACCOUNT

	account_controller: BANK_ACCOUNT_CONTROLLER

feature -- Constants

	api_doc: STRING = "[
			Please check the API
			URI:/account/123 METHOD: GET
			URI:/account/123/transactions METHOD: GET, POST
			]"
			
end
