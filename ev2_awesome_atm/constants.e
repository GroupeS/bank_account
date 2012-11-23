note
	description: "[
			Objects that provide access to constants loaded from files.
			Perform and desired constant redefinitions in this class.
			Note that if you are loading constants from a file and wish to
			change the location of the file, redefine `initialize_constants' in this
			class to load from the desired location.
			]"
	author: "Paul-G. Crismer"
	license: "MIT License"
	copyright: "2012- Paul-G. Crismer & others (pgcrism@users.sf.net)"
	generator: "EiffelBuild"
	date: "$Date: 2008-12-31 09:58:34 -0800 (Wed, 31 Dec 2008) $"
	revision: "$Revision: 76495 $"

class
	CONSTANTS

inherit
	CONSTANTS_IMP
	
end
