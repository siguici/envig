module env

fn test_expand() {
	vars := {
		'NAME':  'Emmanuel'
		'EMPTY': ''
		'UNSET': ''
	}

	// Basic variable expansion
	assert expand('Hello, \$NAME!', vars) == 'Hello, Emmanuel!'
	assert expand('Hello, \${NAME}!', vars) == 'Hello, Emmanuel!'

	// Default value with ':-'
	assert expand('Hello, \${MISSING:-World}!', vars) == 'Hello, World!'

	// Default value with '-'
	assert expand('Hello, \${MISSING-World}!', vars) == 'Hello, World!'
	assert expand('Hello, \${NAME-World}!', vars) == 'Hello, Emmanuel!'

	// Alternative value with ':+'
	assert expand('Hello, \${NAME:+World}!', vars) == 'Hello, World!'
	assert expand('Hello, \${EMPTY:+World}!', vars) == 'Hello, !'

	// Alternative value with '+'
	assert expand('Hello, \${NAME+World}!', vars) == 'Hello, World!'
	assert expand('Hello, \${MISSING+World}!', vars) == 'Hello, !'

	// Mixed usage
	assert expand('User: \${USER:-guest}, Home: \${HOME:-/home/guest}', {
		'USER': 'siguici'
	}) == 'User: siguici, Home: /home/guest'
}
