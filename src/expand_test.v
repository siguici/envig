module envigure

fn test_expand() {
	vars := {
		'first_name': 'Kessé Emmanuel'
		'last_name':  'Sigui'
	}

	assert expand('\$first_name \$last_name', vars) == 'Kessé Emmanuel Sigui'
	assert expand('\${first_name} \${last_name}', vars) == 'Kessé Emmanuel Sigui'
}
