Bank account
============

Eiffel sample applications around the concept of bank account.

* Authors: Paul-G. Crismer, Dimitri del Marmol (for awesome-web-atm-js-client)
* License: MIT License
* Copyright: 2012- Paul-G. Crismer <pgcrism@users.sf.net> and others.
* Status: beta
* Known problems:
  - the javascript clients does not reflect the actual transactions got from the REST server
  - the Resource Handler should better/fully handle errors triggered by the controller.

Projects
--------

* bank_account:
Bank accounts, extended with transaction support

* ev2_awewome_atm:
Vision2 GUI

* ewf_awesome_atm:
EWF REST Server

* awesome-web-atm-js-client:
JavaScript client for the EWF REST Server on localhost

Analysis
--------

* REST_Bank_Account-en.pdf -- English presentation

Software requirements
---------------------

* EiffelStudio 7.2
* Firefox - Chrome

### EiffelStudio 7.1

The EWF version in EiffelStudio 7.2 has quite changed and is incompatible with the EWF version that shipped with EiffelStudio 7.1.                                                                                                                                                         
A version that works with EiffelStudio 7.1 is still available in the [ise7.1](https://github.com/GroupeS/bank_account/tree/ise7.1) tag.

Installation
------------

* Just copy/paste all directories to  "Eiffel User Files\7.2\projects"
* Launch EiffelStudio
* Open ECF projects through the "Open Project..." Dialog
* Compile and run the samples
