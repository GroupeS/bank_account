note
	description : "bank_account application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	BANK_ACCOUNT_APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			account : BANK_ACCOUNT
		do
			create account.make (create {BANK_ACCOUNT_NUMBER}.make (""))

			create compte_courant.make (create {BANK_ACCOUNT_NUMBER}.make (""))
			executer_atm
		end

feature -- Access

	compte_courant: BANK_ACCOUNT

	dernier_montant_saisi : INTEGER

	choix : CHARACTER

feature -- Status report

	session_terminee: BOOLEAN

feature -- Basic operations

	executer_atm
		do
			from

			until
				session_terminee
			loop
				saisir_choix
				inspect choix
				when 'a' then
					ajouter_montant
				when 'r' then
					retirer_montant
				when 's' then
					afficher_solde
				when 'f' then
					terminer
				else
					io.put_string ("Option invalide%N")
				end
			end
		end

	ajouter_montant
		do
			saisir_montant ("Ajouter")
			compte_courant.deposit (dernier_montant_saisi)
		end

	retirer_montant
		do
			saisir_montant ("Retirer")
			if compte_courant.may_withdraw (dernier_montant_saisi) then
				compte_courant.withdraw (dernier_montant_saisi)
			else
				io.put_string ("Solde insuffisant. Il reste: ")
				io.put_integer (compte_courant.balance)
				io.put_new_line
			end
		end

	afficher_solde
		do
			io.put_string ("Votre solde: ")
			io.put_integer (compte_courant.balance)
			io.put_new_line
		end

	terminer
		do
			session_terminee := True
		ensure
			session_terminee
		end

	saisir_montant (titre : STRING)
		do
			io.put_string (titre)
			io.put_new_line
			io.put_string ("> Montant : ")
			io.read_integer
			dernier_montant_saisi := io.last_integer
		end

	saisir_choix
		do
			io.put_string ("[
	a : Ajouter argent
	r : Retirer argent
	s : Afficher le Solde
	f : Terminer
			]")

			from
				io.put_string ("%N?")
				io.read_line
			until
				io.last_string.count > 0 and then choix_possibles.has (io.last_string[1])
			loop
				io.put_string ("?")
				io.read_line
			end
			choix := io.last_string[1]
		end

	choix_possibles : ARRAY[CHARACTER]
		once
			Result := <<'a','r','f','s'>>
		end
end
